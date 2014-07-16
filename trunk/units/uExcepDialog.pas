{****************************************************************************}

{ Project JEDI Code Library (JCL)                                            }

{ The contents of this file are subject to the Mozilla Public License        }
{ Version 1.1 (the "License"); you may not use this file except in           }
{ compliance with the License. You may obtain a copy of the License at       }
{ http://www.mozilla.org/MPL/                                                }

{ Software distributed under the License is distributed on an "AS IS" basis, }
{ WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   }
{ for the specific language governing rights and limitations under the       }
{ License.                                                                   }

{ The Original Code is ExceptDlg.pas.                                        }

{ The Initial Developer of the Original Code is Petr Vones.                  }
{ Portions created by Petr Vones are Copyright (C) of Petr Vones.            }

{****************************************************************************}

{ Last modified: $Date: 2006-05-18 18:04:47 +0200 (jeu., 18 mai 2006) $      }

{****************************************************************************}

unit uExcepDialog;

interface

uses
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    StdCtrls,
    ExtCtrls,
    AppEvnts,
    JclSysUtils,
    JclDebug;

const
    UM_CREATEDETAILS = WM_USER + $100;
    AnsiCrLf = ansistring(#13#10);

type
    TExceptionDialog = class (TForm)

        TextLabel : TMemo;
        OkBtn : TButton;
        DetailsBtn : TButton;
        BevelDetails : TBevel;
        DetailsMemo : TMemo;

        procedure FormPaint(Sender : TObject);
        procedure FormCreate(Sender : TObject);
        procedure FormShow(Sender : TObject);
        procedure DetailsBtnClick(Sender : TObject);
        procedure FormKeyDown(Sender : TObject; var Key : word; Shift : TShiftState);
        procedure FormDestroy(Sender : TObject);
        procedure FormResize(Sender : TObject);
        procedure FormDeactivate(Sender : TObject);
    private
    private
        FDetailsVisible : boolean;
        FThreadID : DWORD;
        FLastActiveControl : TWinControl;
        FNonDetailsHeight : integer;
        FFullHeight : integer;
        FSimpleLog : TJclSimpleLog;
        procedure ReportToLog;
        function GetReportAsText : string;
        procedure SetDetailsVisible(const Value : boolean);
        procedure UMCreateDetails(var Message : TMessage); message UM_CREATEDETAILS;
    protected
        procedure AfterCreateDetails; dynamic;
        procedure BeforeCreateDetails; dynamic;
        procedure CreateDetails; dynamic;
        procedure CreateReport;
        function ReportMaxColumns : integer; virtual;
        function ReportNewBlockDelimiterChar : char; virtual;
        procedure NextDetailBlock;
        procedure UpdateTextLabelScrollbars;
    public
        procedure CopyReportToClipboard;
        class procedure ExceptionHandler(Sender : TObject; E : Exception);
        class procedure ExceptionThreadHandler(Thread : TJclDebugThread);
        class procedure ShowException(E : TObject; Thread : TJclDebugThread);
        property DetailsVisible : boolean read FDetailsVisible write SetDetailsVisible;
        property ReportAsText : string read GetReportAsText;
        property SimpleLog : TJclSimpleLog read FSimpleLog;
    end;

    TExceptionDialogClass = class of TExceptionDialog;

var
    ExceptionDialogClass : TExceptionDialogClass = TExceptionDialog;

implementation

{$R *.dfm}

uses
    ClipBrd,
    Math,
    JclBase,
    JclFileUtils,
    JclHookExcept,
    JclPeImage,
    JclStrings,
    JclSysInfo,
    JclWin32;

resourcestring
    RsAppError = '%s - application error';
    RsExceptionClass = 'Exception class: %s';
    RsExceptionMessage = 'Exception message: %s';
    RsExceptionAddr = 'Exception address: %p';
    RsStackList = 'Stack list, generated %s';
    RsModulesList = 'List of loaded modules:';
    RsOSVersion = 'System   : %s %s, Version: %d.%d, Build: %x, "%s"';
    RsProcessor = 'Processor: %s, %s, %d MHz';
    RsMemory = 'Memory: %d; free %d';
    RsScreenRes = 'Display  : %dx%d pixels, %d bpp';
    RsActiveControl = 'Active Controls hierarchy:';
    RsThread = 'Thread: %s';
    RsMissingVersionInfo = '(no version info)';
    RsMainThreadCallStack = 'Call stack for main thread';
    RsThreadCallStack = 'Call stack for thread %s';

var
    ExceptionDialog : TExceptionDialog;

//============================================================================
// Helper routines
//============================================================================

// SortModulesListByAddressCompare
// sorts module by address
function SortModulesListByAddressCompare(List : TStringList; Index1, Index2 : integer) : integer;
var
    Addr1, Addr2 : cardinal;
begin
    Addr1 := cardinal(List.Objects[Index1]);
    Addr2 := cardinal(List.Objects[Index2]);
    if Addr1 > Addr2 then
    begin
        Result := 1;
    end
    else
    if Addr1 < Addr2 then
    begin
        Result := -1;
    end
    else
    begin
        Result := 0;
    end;
end;

//============================================================================
// TApplication.HandleException method code hooking for exceptions from DLLs
//============================================================================

// We need to catch the last line of TApplication.HandleException method:
// [...]
//   end else
//    SysUtils.ShowException(ExceptObject, ExceptAddr);
// end;

procedure HookShowException(ExceptObject : TObject; ExceptAddr : Pointer);
begin
    if JclValidateModuleAddress(ExceptAddr) and (ExceptObject.InstanceSize >= Exception.InstanceSize) then
    begin
        TExceptionDialog.ExceptionHandler(nil, Exception(ExceptObject));
    end
    else
    begin
        SysUtils.ShowException(ExceptObject, ExceptAddr);
    end;
end;

//----------------------------------------------------------------------------

function HookTApplicationHandleException : boolean;
const
    CallOffset = $86;
    CallOffsetDebug = $94;
type
    PCALLInstruction = ^TCALLInstruction;

    TCALLInstruction = packed record
        Call : byte;
        Address : integer;
    end;
var
    TApplicationHandleExceptionAddr, SysUtilsShowExceptionAddr : Pointer;
    CALLInstruction : TCALLInstruction;
    CallAddress : Pointer;
    WrittenBytes : cardinal;

    function CheckAddressForOffset(Offset : cardinal) : boolean;
    begin
        try
            CallAddress := Pointer(cardinal(TApplicationHandleExceptionAddr) + Offset);
            CALLInstruction.Call := $E8;
            Result := PCALLInstruction(CallAddress)^.Call = CALLInstruction.Call;
            if Result then
            begin
                if IsCompiledWithPackages then
                begin
                    Result := PeMapImgResolvePackageThunk(Pointer(integer(CallAddress) + integer(PCALLInstruction(CallAddress)^.Address) + SizeOf(CALLInstruction))) = SysUtilsShowExceptionAddr;
                end
                else
                begin
                    Result := PCALLInstruction(CallAddress)^.Address = integer(SysUtilsShowExceptionAddr) - integer(CallAddress) - SizeOf(CALLInstruction);
                end;
            end;
        except
            Result := false;
        end;
    end;

begin
    TApplicationHandleExceptionAddr := PeMapImgResolvePackageThunk(@TApplication.HandleException);
    SysUtilsShowExceptionAddr := PeMapImgResolvePackageThunk(@SysUtils.ShowException);
    if Assigned(TApplicationHandleExceptionAddr) and Assigned(SysUtilsShowExceptionAddr) then
    begin
        Result := CheckAddressForOffset(CallOffset) or CheckAddressForOffset(CallOffsetDebug);
        if Result then
        begin
            CALLInstruction.Address := integer(@HookShowException) - integer(CallAddress) - SizeOf(CALLInstruction);
            Result := WriteProtectedMemory(CallAddress, @CallInstruction, SizeOf(CallInstruction), WrittenBytes);
        end;
    end
    else
    begin
        Result := false;
    end;
end;

//============================================================================
// Exception dialog with Send
//============================================================================

var
    ExceptionShowing : boolean;

//=== { TExceptionDialog } ===============================================

procedure TExceptionDialog.AfterCreateDetails;
begin

end;

//----------------------------------------------------------------------------

procedure TExceptionDialog.BeforeCreateDetails;
begin

end;

//----------------------------------------------------------------------------

function TExceptionDialog.ReportMaxColumns : integer;
begin
    Result := 78;
end;


//----------------------------------------------------------------------------

procedure TExceptionDialog.CopyReportToClipboard;
begin
    ClipBoard.AsText := ReportAsText;
end;

//----------------------------------------------------------------------------

procedure TExceptionDialog.CreateDetails;
begin
    Screen.Cursor := crHourGlass;
    DetailsMemo.Lines.BeginUpdate;
    try
        CreateReport;
        ReportToLog;
        DetailsMemo.SelStart := 0;
        SendMessage(DetailsMemo.Handle, EM_SCROLLCARET, 0, 0);
        AfterCreateDetails;
    finally
        DetailsMemo.Lines.EndUpdate;
        OkBtn.Enabled := true;
        DetailsBtn.Enabled := true;
        OkBtn.SetFocus;
        Screen.Cursor := crDefault;
    end;
end;

//----------------------------------------------------------------------------

procedure TExceptionDialog.CreateReport;
var
    SL : TStringList;
    I : integer;
    ModuleName : TFileName;
    NtHeaders32 : PImageNtHeaders32;
    NtHeaders64 : PImageNtHeaders64;
    ModuleBase : cardinal;
    ImageBaseStr : string;
    C : TWinControl;
    CpuInfo : TCpuInfo;
    ProcessorDetails : string;
    StackList : TJclStackInfoList;
    ThreadList : TJclDebugThreadList;
    AThreadID : DWORD;
    PETarget : TJclPeTarget;
begin
    SL := TStringList.Create;
    try
    // Stack list
        StackList := JclGetExceptStackList(FThreadID);
        if Assigned(StackList) then
        begin
            DetailsMemo.Lines.Add(Format(RsStackList, [DateTimeToStr(StackList.TimeStamp)]));
            StackList.AddToStrings(DetailsMemo.Lines, true, true, true, true);
            NextDetailBlock;
        end;
    // Main thread
        if FThreadID <> MainThreadID then
        begin
            StackList := JclCreateThreadStackTraceFromID(true, MainThreadID);
            if Assigned(StackList) then
            begin
                DetailsMemo.Lines.Add(RsMainThreadCallStack);
                DetailsMemo.Lines.Add(Format(RsStackList, [DateTimeToStr(StackList.TimeStamp)]));
                StackList.AddToStrings(DetailsMemo.Lines, true, true, true, true);
                NextDetailBlock;
            end;
        end;
    // All threads
        ThreadList := JclDebugThreadList;
        ThreadList.Lock.Enter; // avoid modifications
        try
            for I := 0 to ThreadList.ThreadIDCount - 1 do
            begin
                AThreadID := ThreadList.ThreadIDs[I];
                if (AThreadID <> FThreadID) then
                begin
                    StackList := JclCreateThreadStackTrace(true, ThreadList.ThreadHandles[I]);
                    if Assigned(StackList) then
                    begin
                        DetailsMemo.Lines.Add(Format(RsThreadCallStack, [ThreadList.ThreadInfos[AThreadID]]));
                        DetailsMemo.Lines.Add(Format(RsStackList, [DateTimeToStr(StackList.TimeStamp)]));
                        StackList.AddToStrings(DetailsMemo.Lines, true, true, true, true);
                        NextDetailBlock;
                    end;
                end;
            end;
        finally
            ThreadList.Lock.Leave;
        end;


    // System and OS information
        DetailsMemo.Lines.Add(Format(RsOSVersion, [GetWindowsVersionString, NtProductTypeString,
            Win32MajorVersion, Win32MinorVersion, Win32BuildNumber, Win32CSDVersion]));
        GetCpuInfo(CpuInfo);
        with CpuInfo do
        begin
            ProcessorDetails := Format(RsProcessor, [Manufacturer, CpuName,
                RoundFrequency(FrequencyInfo.NormFreq)]);
            if not IsFDIVOK then
            begin
                ProcessorDetails := ProcessorDetails + ' [FDIV Bug]';
            end;
            if ExMMX then
            begin
                ProcessorDetails := ProcessorDetails + ' MMXex';
            end
            else
            if MMX then
            begin
                ProcessorDetails := ProcessorDetails + ' MMX';
            end;
//      if SSE > 0 then
//        ProcessorDetails := Format('%s SSE%d', [ProcessorDetails, SSE]);
            if Ex3DNow then
            begin
                ProcessorDetails := ProcessorDetails + ' 3DNow!ex';
            end
            else
            if _3DNow then
            begin
                ProcessorDetails := ProcessorDetails + ' 3DNow!';
            end;
            if Is64Bits then
            begin
                ProcessorDetails := ProcessorDetails + ' 64 bits';
            end;
            if DEPCapable then
            begin
                ProcessorDetails := ProcessorDetails + ' DEP';
            end;
        end;
        DetailsMemo.Lines.Add(ProcessorDetails);
        DetailsMemo.Lines.Add(Format(RsMemory, [GetTotalPhysicalMemory div 1024 div 1024,
            GetFreePhysicalMemory div 1024 div 1024]));
        DetailsMemo.Lines.Add(Format(RsScreenRes, [Screen.Width, Screen.Height, GetBPP]));
        NextDetailBlock;


    // Modules list
        if LoadedModulesList(SL, GetCurrentProcessId) then
        begin
            DetailsMemo.Lines.Add(RsModulesList);
            SL.CustomSort(SortModulesListByAddressCompare);
            for I := 0 to SL.Count - 1 do
            begin
                ModuleName := SL[I];
                ModuleBase := cardinal(SL.Objects[I]);
                DetailsMemo.Lines.Add(Format('[%.8x] %s', [ModuleBase, ModuleName]));
                PETarget := PeMapImgTarget(Pointer(ModuleBase));
                NtHeaders32 := nil;
                NtHeaders64 := nil;
                if PETarget = taWin32 then
                begin
                    NtHeaders32 := PeMapImgNtHeaders32(Pointer(ModuleBase));
                end
                else
                if PETarget = taWin64 then
                begin
                    NtHeaders64 := PeMapImgNtHeaders64(Pointer(ModuleBase));
                end;
                if (NtHeaders32 <> nil) and (NtHeaders32^.OptionalHeader.ImageBase <> ModuleBase) then
                begin
                    ImageBaseStr := Format('<%.8x> ', [NtHeaders32^.OptionalHeader.ImageBase]);
                end
                else
                if (NtHeaders64 <> nil) and (NtHeaders64^.OptionalHeader.ImageBase <> ModuleBase) then
                begin
                    ImageBaseStr := Format('<%.8x> ', [NtHeaders64^.OptionalHeader.ImageBase]);
                end
                else
                begin
                    ImageBaseStr := StrRepeat(' ', 11);
                end;
                if VersionResourceAvailable(ModuleName) then
                begin
                    with TJclFileVersionInfo.Create(ModuleName) do
                    begin
                        try
                            DetailsMemo.Lines.Add(ImageBaseStr + BinFileVersion + ' - ' + FileVersion);
                            if FileDescription <> '' then
                            begin
                                DetailsMemo.Lines.Add(StrRepeat(' ', 11) + FileDescription);
                            end;
                        finally
                            Free;
                        end;
                    end;
                end
                else
                begin
                    DetailsMemo.Lines.Add(ImageBaseStr + RsMissingVersionInfo);
                end;
            end;
            NextDetailBlock;
        end;


    // Active controls
        if (FLastActiveControl <> nil) then
        begin
            DetailsMemo.Lines.Add(RsActiveControl);
            C := FLastActiveControl;
            while C <> nil do
            begin
                DetailsMemo.Lines.Add(Format('%s "%s"', [C.ClassName, C.Name]));
                C := C.Parent;
            end;
            NextDetailBlock;
        end;

    finally
        SL.Free;
    end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.DetailsBtnClick(Sender : TObject);
begin
    DetailsVisible := not DetailsVisible;
end;

//--------------------------------------------------------------------------------------------------

class procedure TExceptionDialog.ExceptionHandler(Sender : TObject; E : Exception);
begin
    if Assigned(E) then
    begin
        if ExceptionShowing then
        begin
            Application.ShowException(E);
        end
        else
        begin
            ExceptionShowing := true;
            try
                if IsIgnoredException(E.ClassType) then
                begin
                    Application.ShowException(E);
                end
                else
                begin
                    ShowException(E, nil);
                end;
            finally
                ExceptionShowing := false;
            end;
        end;
    end;
end;

//--------------------------------------------------------------------------------------------------

class procedure TExceptionDialog.ExceptionThreadHandler(Thread : TJclDebugThread);
var
    E : Exception;
begin
    E := Exception(Thread.SyncException);
    if Assigned(E) then
    begin
        if ExceptionShowing then
        begin
            Application.ShowException(E);
        end
        else
        begin
            ExceptionShowing := true;
            try
                if IsIgnoredException(E.ClassType) then
                begin
                    Application.ShowException(E);
                end
                else
                begin
                    ShowException(E, Thread);
                end;
            finally
                ExceptionShowing := false;
            end;
        end;
    end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormCreate(Sender : TObject);
begin
    FSimpleLog := TJclSimpleLog.Create('errors.log');
    FFullHeight := ClientHeight;
    DetailsVisible := false;
    Caption := Format(RsAppError, [Application.Title]);
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormDestroy(Sender : TObject);
begin
    FreeAndNil(FSimpleLog);
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormKeyDown(Sender : TObject; var Key : word; Shift : TShiftState);
begin
    if (Key = Ord('C')) and (ssCtrl in Shift) then
    begin
        CopyReportToClipboard;
        MessageBeep(MB_OK);
    end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormPaint(Sender : TObject);
begin
    DrawIcon(Canvas.Handle, TextLabel.Left - GetSystemMetrics(SM_CXICON) - 15,
        TextLabel.Top, LoadIcon(0, IDI_ERROR));
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormResize(Sender : TObject);
begin
    UpdateTextLabelScrollbars;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormShow(Sender : TObject);
begin
    BeforeCreateDetails;
    MessageBeep(MB_ICONERROR);
    if (GetCurrentThreadId = MainThreadID) and (GetWindowThreadProcessId(Handle, nil) = MainThreadID) then
    begin
        PostMessage(Handle, UM_CREATEDETAILS, 0, 0);
    end
    else
    begin
        CreateReport;
    end;
end;

//--------------------------------------------------------------------------------------------------

function TExceptionDialog.GetReportAsText : string;
begin
    Result := StrEnsureSuffix(AnsiCrLf, TextLabel.Text) + AnsiCrLf + DetailsMemo.Text;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.NextDetailBlock;
begin
    DetailsMemo.Lines.Add(StrRepeat(ReportNewBlockDelimiterChar, ReportMaxColumns));
end;

//--------------------------------------------------------------------------------------------------

function TExceptionDialog.ReportNewBlockDelimiterChar : char;
begin
    Result := '-';
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.ReportToLog;
begin
    FSimpleLog.WriteStamp(ReportMaxColumns);
    try
        FSimpleLog.Write(ReportAsText);
    finally
        FSimpleLog.CloseLog;
    end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.SetDetailsVisible(const Value : boolean);
var
    DetailsCaption : string;
begin
    FDetailsVisible := Value;
    DetailsCaption := Trim(StrRemoveChars(DetailsBtn.Caption, ['<', '>']));
    if Value then
    begin
        Constraints.MinHeight := FNonDetailsHeight + 100;
        Constraints.MaxHeight := Screen.Height;
        DetailsCaption := '<< ' + DetailsCaption;
        ClientHeight := FFullHeight;
        DetailsMemo.Height := FFullHeight - DetailsMemo.Top - 3;
    end
    else
    begin
        FFullHeight := ClientHeight;
        DetailsCaption := DetailsCaption + ' >>';
        if FNonDetailsHeight = 0 then
        begin
            ClientHeight := BevelDetails.Top;
            FNonDetailsHeight := Height;
        end
        else
        begin
            Height := FNonDetailsHeight;
        end;
        Constraints.MinHeight := FNonDetailsHeight;
        Constraints.MaxHeight := FNonDetailsHeight;
    end;
    DetailsBtn.Caption := DetailsCaption;
    DetailsMemo.Enabled := Value;
end;

//--------------------------------------------------------------------------------------------------

class procedure TExceptionDialog.ShowException(E : TObject; Thread : TJclDebugThread);
begin
    if ExceptionDialog = nil then
    begin
        ExceptionDialog := ExceptionDialogClass.Create(Application);
    end;
    try
        with ExceptionDialog do
        begin
            if Assigned(Thread) then
            begin
                FThreadID := Thread.ThreadID;
            end
            else
            begin
                FThreadID := MainThreadID;
            end;
            FLastActiveControl := Screen.ActiveControl;
            if E is Exception then
            begin
                TextLabel.Text := AdjustLineBreaks(StrEnsureSuffix('.', Exception(E).Message));
            end
            else
            begin
                TextLabel.Text := AdjustLineBreaks(StrEnsureSuffix('.', E.ClassName));
            end;
            UpdateTextLabelScrollbars;
            DetailsMemo.Lines.Add(Format(RsExceptionClass, [E.ClassName]));
            if E is Exception then
            begin
                DetailsMemo.Lines.Add(Format(RsExceptionMessage, [StrEnsureSuffix('.', Exception(E).Message)]));
            end;
            if Thread = nil then
            begin
                DetailsMemo.Lines.Add(Format(RsExceptionAddr, [ExceptAddr]));
            end
            else
            begin
                DetailsMemo.Lines.Add(Format(RsThread, [Thread.ThreadInfo]));
            end;
            NextDetailBlock;
            ShowModal;
        end;
    finally
        FreeAndNil(ExceptionDialog);
    end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.UMCreateDetails(var Message : TMessage);
begin
    Update;
    CreateDetails;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.UpdateTextLabelScrollbars;
begin
    Canvas.Font := TextLabel.Font;
    if TextLabel.Lines.Count * Canvas.TextHeight('Wg') > TextLabel.ClientHeight then
    begin
        TextLabel.ScrollBars := ssVertical;
    end
    else
    begin
        TextLabel.ScrollBars := ssNone;
    end;
end;

//==================================================================================================
// Exception handler initialization code
//==================================================================================================

var
    AppEvents : TApplicationEvents = nil;

procedure InitializeHandler;
begin
    if AppEvents = nil then
    begin
        AppEvents := TApplicationEvents.Create(nil);
        AppEvents.OnException := TExceptionDialog.ExceptionHandler;


        JclStackTrackingOptions := JclStackTrackingOptions + [stRawMode];
        JclStackTrackingOptions := JclStackTrackingOptions + [stStaticModuleList];
        JclStackTrackingOptions := JclStackTrackingOptions + [stDelayedTrace];
        JclDebugThreadList.OnSyncException := TExceptionDialog.ExceptionThreadHandler;
        JclStartExceptionTracking;
        if HookTApplicationHandleException then
        begin
            JclTrackExceptionsFromLibraries;
        end;
    end;
end;

//--------------------------------------------------------------------------------------------------

procedure UnInitializeHandler;
begin
    if AppEvents <> nil then
    begin
        FreeAndNil(AppEvents);
        JclDebugThreadList.OnSyncException := nil;
        JclUnhookExceptions;
        JclStopExceptionTracking;
    end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormDeactivate(Sender : TObject);
begin
    SetWindowPos(handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
end;

initialization
    InitializeHandler;

finalization
    UnInitializeHandler;

end.
