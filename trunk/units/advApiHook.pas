{
  Advanced API Hook Libary.
  Coded By Ms-Rem ( Ms-Rem@yandex.ru ) ICQ 286370715
}

unit advApiHook;

{$IMAGEBASE $13140000}

interface

uses
    Windows,
    NativeAPI,
    usharedstructs;

function SizeOfCode(Code : pointer) : dword;
function SizeOfProc(Proc : pointer) : dword;
function InjectString(Process : dword; Text : pchar) : pchar;

function InjectThread(Process : dword; Thread : pointer; Info : pointer; InfoLen : dword; Results : boolean) : THandle;

function InjectDll(Process : dword; ModulePath : pchar) : boolean;
function InjectDllEx(Process : dword; Src : pointer) : boolean;
function InjectExe(Process : dword; Data : pointer) : boolean;
function InjectThisExe(Process : dword; EntryPoint : pointer) : boolean;
function InjectMemory(Process : dword; Memory : pointer; Size : dword) : pointer;
function ReleaseLibrary(Process : dword; ModulePath : pchar) : boolean;

function CreateProcessWithDll(lpApplicationName : pchar; lpCommandLine : pchar; lpProcessAttributes, lpThreadAttributes : PSecurityAttributes; bInheritHandles : boolean; dwCreationFlags : dword; lpEnvironment : pointer; lpCurrentDirectory : pchar; const lpStartupInfo : TStartupInfo; var lpProcessInformation : TProcessInformation; ModulePath : pchar) : boolean;

function CreateProcessWithDllEx(lpApplicationName : pchar; lpCommandLine : pchar; lpProcessAttributes, lpThreadAttributes : PSecurityAttributes; bInheritHandles : boolean; dwCreationFlags : dword; lpEnvironment : pointer; lpCurrentDirectory : pchar; const lpStartupInfo : TStartupInfo; var lpProcessInformation : TProcessInformation; Src : pointer) : boolean;

function HookCode(TargetProc, NewProc : pointer; var OldProc : pointer) : boolean;

function HookProc(lpModuleName, lpProcName : pchar; NewProc : pointer; var OldProc : pointer) : boolean;

function UnhookCode(OldProc : pointer) : boolean;
function DisableSFC : boolean;

function GetProcAddressEx(Process : dword; lpModuleName, lpProcName : pchar; dwProcLen : dword) : pointer;

function StopProcess(ProcessId : dword) : boolean;
function RunProcess(ProcessId : dword) : boolean;
function StopThreads() : boolean;
function RunThreads() : boolean;
function EnablePrivilegeEx(Process : dword; lpPrivilegeName : pchar) : boolean;
function EnablePrivilege(lpPrivilegeName : pchar) : boolean;
function EnableDebugPrivilegeEx(Process : dword) : boolean;
function EnableDebugPrivilege() : boolean;
function GetProcessId(pName : pchar) : dword;
function OpenProcessEx(dwProcessId : DWORD) : THandle;
function SearchProcessThread(ProcessId : dword) : dword;
function CreateZombieProcess(lpCommandLine : pchar; var lpProcessInformation : TProcessInformation; ModulePath : pchar) : boolean;
function InjectDllAlt(Process : dword; ModulePath : pchar) : boolean;
function DebugKillProcess(ProcessId : dword) : boolean;
function lstrcmpi(lpString1, lpString2 : pchar) : integer; stdcall;
{$EXTERNALSYM lstrcmpi}

implementation

const
    MAX_PATH = 260;
    IMAGE_SIZEOF_SHORT_NAME = 8;

type
    TTHREADENTRY32 = packed record
        dwSize : DWORD;
        cntUsage : DWORD;
        th32ThreadID : DWORD;
        th32OwnerProcessID : DWORD;
        tpBasePri : longint;
        tpDeltaPri : longint;
        dwFlags : DWORD;
    end;

    TPROCESSENTRY32 = packed record
        dwSize : DWORD;
        cntUsage : DWORD;
        th32ProcessID : DWORD;
        th32DefaultHeapID : DWORD;
        th32ModuleID : DWORD;
        cntThreads : DWORD;
        th32ParentProcessID : DWORD;
        pcPriClassBase : longint;
        dwFlags : DWORD;
        szExeFile : array[0..MAX_PATH - 1] of char;
    end;

    TISHMisc = packed record
        case integer of
            0 : (PhysicalAddress : DWORD);
            1 : (VirtualSize : DWORD);
    end;

    PPImageSectionHeader = ^PImageSectionHeader;
    PImageSectionHeader = ^TImageSectionHeader;

    _IMAGE_SECTION_HEADER = packed record
        Name : packed array[0..IMAGE_SIZEOF_SHORT_NAME - 1] of byte;
        Misc : TISHMisc;
        VirtualAddress : DWORD;
        SizeOfRawData : DWORD;
        PointerToRawData : DWORD;
        PointerToRelocations : DWORD;
        PointerToLinenumbers : DWORD;
        NumberOfRelocations : word;
        NumberOfLinenumbers : word;
        Characteristics : DWORD;
    end;
  {$EXTERNALSYM _IMAGE_SECTION_HEADER}
    TImageSectionHeader = _IMAGE_SECTION_HEADER;
    IMAGE_SECTION_HEADER = _IMAGE_SECTION_HEADER;
  {$EXTERNALSYM IMAGE_SECTION_HEADER}


    TModuleList = array of dword;

    PImageImportDescriptor = ^TImageImportDescriptor;

    TImageImportDescriptor = packed record
        OriginalFirstThunk : dword;
        TimeDateStamp : dword;
        ForwarderChain : dword;
        Name : dword;
        FirstThunk : dword;
    end;

    PImageBaseRelocation = ^TImageBaseRelocation;

    TImageBaseRelocation = packed record
        VirtualAddress : dword;
        SizeOfBlock : dword;
    end;


    TDllEntryProc = function(hinstDLL : HMODULE; dwReason : dword; lpvReserved : pointer) : boolean; stdcall;

    PLibInfo = ^TLibInfo;

    TLibInfo = packed record
        ImageBase : pointer;
        ImageSize : longint;
        DllProc : TDllEntryProc;
        DllProcAddress : pointer;
        LibsUsed : TStringArray;
    end;

    TSections = array [0..0] of TImageSectionHeader;

const
    IMPORTED_NAME_OFFSET = $00000002;
    IMAGE_ORDINAL_FLAG32 = $80000000;
    IMAGE_ORDINAL_MASK32 = $0000FFFF;
    THREAD_ALL_ACCESS = $001F03FF;
    THREAD_SUSPEND_RESUME = $00000002;
    TH32CS_SNAPTHREAD = $00000004;
    TH32CS_SNAPPROCESS = $00000002;

    Opcodes1 : array [0..255] of word =
        (
        $4211, $42E4, $2011, $20E4, $8401, $8C42, $0000, $0000, $4211, $42E4,
        $2011, $20E4, $8401, $8C42, $0000, $0000, $4211, $42E4, $2011, $20E4,
        $8401, $8C42, $0000, $0000, $4211, $42E4, $2011, $20E4, $8401, $8C42,
        $0000, $0000, $4211, $42E4, $2011, $20E4, $8401, $8C42, $0000, $8000,
        $4211, $42E4, $2011, $20E4, $8401, $8C42, $0000, $8000, $4211, $42E4,
        $2011, $20E4, $8401, $8C42, $0000, $8000, $0211, $02E4, $0011, $00E4,
        $0401, $0C42, $0000, $8000, $6045, $6045, $6045, $6045, $6045, $6045,
        $6045, $6045, $6045, $6045, $6045, $6045, $6045, $6045, $6045, $6045,
        $0045, $0045, $0045, $0045, $0045, $0045, $0045, $0045, $6045, $6045,
        $6045, $6045, $6045, $6045, $6045, $6045, $0000, $8000, $00E4, $421A,
        $0000, $0000, $0000, $0000, $0C00, $2CE4, $0400, $24E4, $0000, $0000,
        $0000, $0000, $1400, $1400, $1400, $1400, $1400, $1400, $1400, $1400,
        $1400, $1400, $1400, $1400, $1400, $1400, $1400, $1400, $0510, $0DA0,
        $0510, $05A0, $0211, $02E4, $A211, $A2E4, $4211, $42E4, $2011, $20E4,
        $42E3, $20E4, $00E3, $01A0, $0000, $E046, $E046, $E046, $E046, $E046,
        $E046, $E046, $8000, $0000, $0000, $0000, $0000, $0000, $0000, $8000,
        $8101, $8142, $0301, $0342, $0000, $0000, $0000, $0000, $0401, $0C42,
        $0000, $0000, $8000, $8000, $0000, $0000, $6404, $6404, $6404, $6404,
        $6404, $6404, $6404, $6404, $6C45, $6C45, $6C45, $6C45, $6C45, $6C45,
        $6C45, $6C45, $4510, $45A0, $0800, $0000, $20E4, $20E4, $4510, $4DA0,
        $0000, $0000, $0800, $0000, $0000, $0400, $0000, $0000, $4110, $41A0,
        $4110, $41A0, $8400, $8400, $0000, $8000, $0008, $0008, $0008, $0008,
        $0008, $0008, $0008, $0008, $1400, $1400, $1400, $1400, $8401, $8442,
        $0601, $0642, $1C00, $1C00, $0000, $1400, $8007, $8047, $0207, $0247,
        $0000, $0000, $0000, $0000, $0000, $0000, $0008, $0008, $0000, $0000,
        $0000, $0000, $0000, $0000, $4110, $01A0
        );

    Opcodes2 : array [0..255] of word =
        (
        $0118, $0120, $20E4, $20E4, $FFFF, $0000, $0000, $0000, $0000, $0000,
        $FFFF, $FFFF, $FFFF, $0110, $0000, $052D, $003F, $023F, $003F, $023F,
        $003F, $003F, $003F, $023F, $0110, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF,
        $FFFF, $FFFF, $4023, $4023, $0223, $0223, $FFFF, $FFFF, $FFFF, $FFFF,
        $003F, $023F, $002F, $023F, $003D, $003D, $003F, $003F, $0000, $8000,
        $8000, $8000, $0000, $0000, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF,
        $FFFF, $FFFF, $FFFF, $FFFF, $20E4, $20E4, $20E4, $20E4, $20E4, $20E4,
        $20E4, $20E4, $20E4, $20E4, $20E4, $20E4, $20E4, $20E4, $20E4, $20E4,
        $4227, $003F, $003F, $003F, $003F, $003F, $003F, $003F, $003F, $003F,
        $003F, $003F, $003F, $003F, $003F, $003F, $00ED, $00ED, $00ED, $00ED,
        $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED,
        $0065, $00ED, $04ED, $04A8, $04A8, $04A8, $00ED, $00ED, $00ED, $0000,
        $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $0265, $02ED, $1C00, $1C00,
        $1C00, $1C00, $1C00, $1C00, $1C00, $1C00, $1C00, $1C00, $1C00, $1C00,
        $1C00, $1C00, $1C00, $1C00, $4110, $4110, $4110, $4110, $4110, $4110,
        $4110, $4110, $4110, $4110, $4110, $4110, $4110, $4110, $4110, $4110,
        $0000, $0000, $8000, $02E4, $47E4, $43E4, $C211, $C2E4, $0000, $0000,
        $0000, $42E4, $47E4, $43E4, $0020, $20E4, $C211, $C2E4, $20E4, $42E4,
        $20E4, $22E4, $2154, $211C, $FFFF, $FFFF, $05A0, $42E4, $20E4, $20E4,
        $2154, $211C, $A211, $A2E4, $043F, $0224, $0465, $24AC, $043F, $8128,
        $6005, $6005, $6005, $6005, $6005, $6005, $6005, $6005, $FFFF, $00ED,
        $00ED, $00ED, $00ED, $00ED, $02ED, $20AC, $00ED, $00ED, $00ED, $00ED,
        $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED,
        $003F, $02ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED,
        $FFFF, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED, $00ED,
        $00ED, $00ED, $00ED, $00ED, $00ED, $0000
        );

    Opcodes3 : array [0..9] of array [0..15] of word =
        (
        ($0510, $FFFF, $4110, $4110, $8110, $8110, $8110, $8110, $0510, $FFFF,
        $4110, $4110, $8110, $8110, $8110, $8110),
        ($0DA0, $FFFF, $41A0, $41A0, $81A0, $81A0, $81A0, $81A0, $0DA0, $FFFF,
        $41A0, $41A0, $81A0, $81A0, $81A0, $81A0),
        ($0120, $0120, $0120, $0120, $0120, $0120, $0120, $0120, $0036, $0036,
        $0030, $0030, $0036, $0036, $0036, $0036),
        ($0120, $FFFF, $0120, $0120, $0110, $0118, $0110, $0118, $0030, $0030,
        $0000, $0030, $0000, $0000, $0000, $0000),
        ($0120, $0120, $0120, $0120, $0120, $0120, $0120, $0120, $0036, $0036,
        $0036, $0036, $FFFF, $0000, $FFFF, $FFFF),
        ($0120, $FFFF, $0120, $0120, $FFFF, $0130, $FFFF, $0130, $0036, $0036,
        $0036, $0036, $0000, $0036, $0036, $0000),
        ($0128, $0128, $0128, $0128, $0128, $0128, $0128, $0128, $0236, $0236,
        $0030, $0030, $0236, $0236, $0236, $0236),
        ($0128, $FFFF, $0128, $0128, $0110, $FFFF, $0110, $0118, $0030, $0030,
        $0030, $0030, $0030, $0030, $FFFF, $FFFF),
        ($0118, $0118, $0118, $0118, $0118, $0118, $0118, $0118, $0236, $0236,
        $0030, $0236, $0236, $0236, $0236, $0236),
        ($0118, $FFFF, $0118, $0118, $0130, $0128, $0130, $0128, $0030, $0030,
        $0030, $0030, $0000, $0036, $0036, $FFFF)
        );

function CreateToolhelp32Snapshot(dwFlags, th32ProcessID : DWORD) : dword stdcall;
    external 'kernel32.dll';
function Thread32First(hSnapshot : THandle; var lpte : TThreadEntry32) : BOOL stdcall;
    external 'kernel32.dll';
function Thread32Next(hSnapshot : THandle; var lpte : TThreadENtry32) : BOOL stdcall;
    external 'kernel32.dll';
function Process32First(hSnapshot : THandle; var lppe : TProcessEntry32) : BOOL stdcall;
    external 'kernel32.dll';
function Process32Next(hSnapshot : THandle; var lppe : TProcessEntry32) : BOOL stdcall;
    external 'kernel32.dll';
function lstrcmpi; external kernel32 name 'lstrcmpiA';

function OpenThread(dwDesiredAccess : dword; bInheritHandle : bool; dwThreadId : dword) : dword; stdcall;
    external 'kernel32.dll';

function SaveOldFunction(Proc : pointer; Old : pointer) : dword; forward;
function MapLibrary(Process : dword; Dest, Src : pointer) : TLibInfo; forward;

//**********
function StrToInt(S : string) : integer;
begin
    Val(S, Result, Result);
end;

procedure Add(Strings : TStringArray; Text : string);
begin
    SetLength(Strings, Length(Strings) + 1);
    Strings[Length(Strings) - 1] := Text;
end;

function Find(Strings : array of string; Text : string; var Index : integer) : boolean;
var
    StringLoop : integer;
begin
    Result := false;
    for StringLoop := 0 to Length(Strings) - 1 do
    begin
        if lstrcmpi(pchar(Strings[StringLoop]), pchar(Text)) = 0 then
        begin
            Index := StringLoop;
            Result := true;
        end;
    end;
end;

const
    IMAGE_SCN_MEM_NOT_CACHED = $04000000;  { Section is not cachable. }
    PAGE_NOCACHE = $200;
    IMAGE_SCN_MEM_EXECUTE = $20000000;  { Section is executable. }
    IMAGE_SCN_MEM_READ = $40000000;  { Section is readable. }
    IMAGE_SCN_MEM_WRITE = DWORD($80000000);  { Section is writeable. }
    PAGE_EXECUTE_READWRITE = $40;
    PAGE_EXECUTE_READ = $20;
    PAGE_EXECUTE_WRITECOPY = $80;
    PAGE_EXECUTE = $10;
    PAGE_READWRITE = 4;
    PAGE_READONLY = 2;
    PAGE_WRITECOPY = 8;
    PAGE_NOACCESS = 1;

function GetSectionProtection(ImageScn : dword) : dword;
begin
    Result := 0;
    if (ImageScn and IMAGE_SCN_MEM_NOT_CACHED) <> 0 then
    begin
        Result := Result or PAGE_NOCACHE;
    end;
    if (ImageScn and IMAGE_SCN_MEM_EXECUTE) <> 0 then
    begin
        if (ImageScn and IMAGE_SCN_MEM_READ) <> 0 then
        begin
            if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
            begin
                Result := Result or PAGE_EXECUTE_READWRITE;
            end
            else
            begin
                Result := Result or PAGE_EXECUTE_READ;
            end;

        end
        else
        if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
        begin
            Result := Result or PAGE_EXECUTE_WRITECOPY;
        end
        else
        begin
            Result := Result or PAGE_EXECUTE;
        end;

    end
    else
    if (ImageScn and IMAGE_SCN_MEM_READ) <> 0 then
    begin
        if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
        begin
            Result := Result or PAGE_READWRITE;
        end
        else
        begin
            Result := Result or PAGE_READONLY;
        end;

    end
    else
    if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
    begin
        Result := Result or PAGE_WRITECOPY;
    end
    else
    begin
        Result := Result or PAGE_NOACCESS;
    end;
end;

//***********


{Получение полного размера машинной комманды по указателю на нее }
function SizeOfCode(Code : pointer) : dword;
var
    Opcode : word;
    Modrm : byte;
    Fixed, AddressOveride : boolean;
    Last, OperandOveride, Flags, Rm, Size, Extend : dword;
begin
    try
        Last := dword(Code);
        if Code <> nil then
        begin
            AddressOveride := false;
            Fixed := false;
            OperandOveride := 4;
            Extend := 0;
            repeat
                Opcode := byte(Code^);
                Code := pointer(dword(Code) + 1);
                if Opcode = $66 then
                begin
                    OperandOveride := 2;
                end
                else
                if Opcode = $67 then
                begin
                    AddressOveride := true;
                end
                else
                if not ((Opcode and $E7) = $26) then
                begin
                    if not (Opcode in [$64..$65]) then
                    begin
                        Fixed := true;
                    end;
                end;
            until Fixed;
            if Opcode = $0f then
            begin
                Opcode := byte(Code^);
                Flags := Opcodes2[Opcode];
                Opcode := Opcode + $0f00;
                Code := pointer(dword(Code) + 1);
            end
            else
            begin
                Flags := Opcodes1[Opcode];
            end;

            if ((Flags and $0038) <> 0) then
            begin
                Modrm := byte(Code^);
                Rm := Modrm and $7;
                Code := pointer(dword(Code) + 1);

                case (Modrm and $c0) of
                    $40 :
                    begin
                        Size := 1;
                    end;
                    $80 :
                    begin
                        if AddressOveride then
                        begin
                            Size := 2;
                        end
                        else
                        begin
                            Size := 4;
                        end;
                    end;
                else
                begin
                    Size := 0;
                end;
                end;

                if not (((Modrm and $c0) <> $c0) and AddressOveride) then
                begin
                    if (Rm = 4) and ((Modrm and $c0) <> $c0) then
                    begin
                        Rm := byte(Code^) and $7;
                    end;
                    if ((Modrm and $c0 = 0) and (Rm = 5)) then
                    begin
                        Size := 4;
                    end;
                    Code := pointer(dword(Code) + Size);
                end;

                if ((Flags and $0038) = $0008) then
                begin
                    case Opcode of
                        $f6 :
                        begin
                            Extend := 0;
                        end;
                        $f7 :
                        begin
                            Extend := 1;
                        end;
                        $d8 :
                        begin
                            Extend := 2;
                        end;
                        $d9 :
                        begin
                            Extend := 3;
                        end;
                        $da :
                        begin
                            Extend := 4;
                        end;
                        $db :
                        begin
                            Extend := 5;
                        end;
                        $dc :
                        begin
                            Extend := 6;
                        end;
                        $dd :
                        begin
                            Extend := 7;
                        end;
                        $de :
                        begin
                            Extend := 8;
                        end;
                        $df :
                        begin
                            Extend := 9;
                        end;
                    end;
                    if ((Modrm and $c0) <> $c0) then
                    begin
                        Flags := Opcodes3[Extend][(Modrm shr 3) and $7];
                    end
                    else
                    begin
                        Flags := Opcodes3[Extend][((Modrm shr 3) and $7) + 8];
                    end;
                end;

            end;
            case (Flags and $0C00) of
                $0400 :
                begin
                    Code := pointer(dword(Code) + 1);
                end;
                $0800 :
                begin
                    Code := pointer(dword(Code) + 2);
                end;
                $0C00 :
                begin
                    Code := pointer(dword(Code) + OperandOveride);
                end;
            else
            begin
                case Opcode of
                    $9a, $ea :
                    begin
                        Code := pointer(dword(Code) + OperandOveride + 2);
                    end;
                    $c8 :
                    begin
                        Code := pointer(dword(Code) + 3);
                    end;
                    $a0..$a3 :
                    begin
                        if AddressOveride then
                        begin
                            Code := pointer(dword(Code) + 2);
                        end
                        else
                        begin
                            Code := pointer(dword(Code) + 4);
                        end;
                    end;
                end;
            end;
            end;
        end;
        Result := dword(Code) - Last;
    except
        Result := 0;
    end;
end;

{ Получение размера функции по указател на нее (размер до первой комманды RET) }
function SizeOfProc(Proc : pointer) : dword;
var
    Length : dword;
begin
    Result := 0;
    repeat
        Length := SizeOfCode(Proc);
        Inc(Result, Length);
        if ((Length = 1) and (byte(Proc^) = $C3)) then
        begin
            Break;
        end;
        Proc := pointer(dword(Proc) + Length);
    until Length = 0;
end;

{ Внедрение null terminated строки в процесс }
function InjectString(Process : dword; Text : pchar) : pchar;
var
    BytesWritten : dword;
begin
    Result := VirtualAllocEx(Process, nil, Length(Text) + 1,
        MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
    WriteProcessMemory(Process, Result, Text, Length(Text) + 1, BytesWritten);
end;

{ Внедрение участка памяти в процесс }
function InjectMemory(Process : dword; Memory : pointer; Size : dword) : pointer;
var
    BytesWritten : dword;
begin
    Result := VirtualAllocEx(Process, nil, Size, MEM_COMMIT or MEM_RESERVE,
        PAGE_EXECUTE_READWRITE);
    WriteProcessMemory(Process, Result, Memory, Size, BytesWritten);
end;


{
  Внедрение в процесс кода функции, связанных с ней данных и запуск потока.
  Process - хэндл открытого процесса,
  Thread  - адрес процедуры потока в текущем контексте,
  Info    - адрес данных передаваемых потоку
  InfoLen - размер данных передаваемых потоку
  Results - необходимость возврата результата (возврат назад переданных данных)
}
function InjectThread(Process : dword; Thread : pointer; Info : pointer; InfoLen : dword; Results : boolean) : THandle;
var
    pThread, pInfo : pointer;
    BytesRead, TID : dword;
begin
    pInfo := InjectMemory(Process, Info, InfoLen);
    pThread := InjectMemory(Process, Thread, SizeOfProc(Thread));
    Result := CreateRemoteThread(Process, nil, 0, pThread, pInfo, 0, TID);
    if Results then
    begin
        WaitForSingleObject(Result, INFINITE);
        ReadProcessMemory(Process, pInfo, Info, InfoLen, BytesRead);
    end;
end;

{ Внедрение Dll в процесс }
function InjectDll(Process : dword; ModulePath : pchar) : boolean;
var
    Memory : pointer;
    Code : dword;
    BytesWritten : dword;
    ThreadId : dword;
    hThread : dword;
    hKernel32 : dword;
    Inject : packed record
        PushCommand : byte;
        PushArgument : DWORD;
        CallCommand : word;
        CallAddr : DWORD;
        PushExitThread : byte;
        ExitThreadArg : dword;
        CallExitThread : word;
        CallExitThreadAddr : DWord;
        AddrLoadLibrary : pointer;
        AddrExitThread : pointer;
        LibraryName : array[0..MAX_PATH] of char;
    end;
begin
    Result := false;
    Memory := VirtualAllocEx(Process, nil, sizeof(Inject),
        MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    if Memory = nil then
    begin
        Exit;
    end;

    Code := dword(Memory);
  //инициализация внедряемого кода:
    Inject.PushCommand := $68;
    inject.PushArgument := code + $1E;
    inject.CallCommand := $15FF;
    inject.CallAddr := code + $16;
    inject.PushExitThread := $68;
    inject.ExitThreadArg := 0;
    inject.CallExitThread := $15FF;
    inject.CallExitThreadAddr := code + $1A;
    hKernel32 := GetModuleHandle('kernel32.dll');
    inject.AddrLoadLibrary := GetProcAddress(hKernel32, 'LoadLibraryA');
    inject.AddrExitThread := GetProcAddress(hKernel32, 'ExitThread');
    lstrcpy(@inject.LibraryName, ModulePath);
  //записать машинный код по зарезервированному адресу
    WriteProcessMemory(Process, Memory, @inject, sizeof(inject), BytesWritten);
  //выполнить машинный код
    hThread := CreateRemoteThread(Process, nil, 0, Memory, nil, 0, ThreadId);
    if hThread = 0 then
    begin
        Exit;
    end;
    CloseHandle(hThread);
    Result := true;
end;

{ Внедрение текущей Dll в процесс (если вызвано из Dll) }
function InjectThisDll(Process : dword) : boolean;
var
    Name : array [0..MAX_PATH] of char;
begin
    GetModuleFileName(hInstance, @Name, MAX_PATH);
    Result := InjectDll(Process, @Name);
end;


{
  Внедрение Dll в процесс методом инжекции кода и настройки образа Dll в памяти.
  Данный метод внедрения более скрытен, и не обнаруживается фаерволлами.
}
function InjectDllEx(Process : dword; Src : pointer) : boolean;
type
    TDllLoadInfo = packed record
        Module : pointer;
        EntryPoint : pointer;
    end;
var
    Lib : TLibInfo;
    BytesWritten : dword;
    ImageNtHeaders : PImageNtHeaders;
    pModule : pointer;
    Offset : dword;
    DllLoadInfo : TDllLoadInfo;
    hThread : dword;

 { процедура передачи управления на точку входа dll }
    procedure DllEntryPoint(lpParameter : pointer); stdcall;
    var
        LoadInfo : TDllLoadInfo;
    begin
        LoadInfo := TDllLoadInfo(lpParameter^);
        asm
            XOR EAX, EAX
            PUSH EAX
            PUSH DLL_PROCESS_ATTACH
            PUSH LoadInfo.Module
            CALL LoadInfo.EntryPoint
        end;
    end;

begin
    Result := false;
    ImageNtHeaders := pointer(dword(Src) + dword(PImageDosHeader(Src)._lfanew));
    Offset := $10000000;
    repeat
        Inc(Offset, $10000);
        pModule := VirtualAlloc(pointer(ImageNtHeaders.OptionalHeader.ImageBase + Offset),
            ImageNtHeaders.OptionalHeader.SizeOfImage,
            MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
        if pModule <> nil then
        begin
            VirtualFree(pModule, 0, MEM_RELEASE);
            pModule := VirtualAllocEx(Process, pointer(ImageNtHeaders.OptionalHeader.
                ImageBase + Offset),
                ImageNtHeaders.OptionalHeader.
                SizeOfImage,
                MEM_COMMIT or MEM_RESERVE,
                PAGE_EXECUTE_READWRITE);
        end;
    until ((pModule <> nil) or (Offset > $30000000));
    Lib := MapLibrary(Process, pModule, Src);
    if Lib.ImageBase = nil then
    begin
        Exit;
    end;
    DllLoadInfo.Module := Lib.ImageBase;
    DllLoadInfo.EntryPoint := Lib.DllProcAddress;
    WriteProcessMemory(Process, pModule, Lib.ImageBase, Lib.ImageSize, BytesWritten);
    hThread := InjectThread(Process, @DllEntryPoint, @DllLoadInfo,
        SizeOf(TDllLoadInfo), false);
    if hThread <> 0 then
    begin
        Result := true;
    end;
end;

{ Внедрение в процесс образа текущей Dll (если вызвано из Dll) }
function InjectThisDllEx(Process : dword) : boolean;
begin
    Result := InjectDllEx(Process, pointer(hInstance));
end;


{
 Внедрение образа Exe файла в чужое адресное пространство и запуск его точки входа.
 Data - адрес образа файла в текущем процессе.
}
function InjectExe(Process : dword; Data : pointer) : boolean;
var
    Module, NewModule : pointer;
    EntryPoint : pointer;
    Size, TID : dword;
    hThread : dword;
    BytesWritten : dword;
    Header : PImageOptionalHeader;
begin
    Result := false;
    Header := PImageOptionalHeader(pointer(integer(Data) +
        PImageDosHeader(Data)._lfanew + SizeOf(dword) +
        SizeOf(TImageFileHeader)));
    Size := Header^.SizeOfImage;
    Module := pointer(Header^.ImageBase);
    EntryPoint := pointer(Header^.ImageBase + Header^.AddressOfEntryPoint);

    NewModule := VirtualAllocEx(Process, Module, Size, MEM_COMMIT or
        MEM_RESERVE, PAGE_EXECUTE_READWRITE);
    if NewModule = nil then
    begin
        exit;
    end;
    WriteProcessMemory(Process, NewModule, Module, Size, BytesWritten);
    hThread := CreateRemoteThread(Process, nil, 0, EntryPoint, NewModule, 0, TID);
    if hThread <> 0 then
    begin
        Result := true;
    end;
end;

{
 Внедрение образа текущего процесса в чужое адресное пространство.
 EntryPoint - адрес точки входа внедренного кода.
}
function InjectThisExe(Process : dword; EntryPoint : pointer) : boolean;
var
    Module, NewModule : pointer;
    Size, TID : dword;
    hThread : dword;
    BytesWritten : dword;
begin
    Result := false;
    Module := pointer(GetModuleHandle(nil));
    Size := PImageOptionalHeader(pointer(integer(Module) +
        PImageDosHeader(Module)._lfanew + SizeOf(dword) +
        SizeOf(TImageFileHeader))).SizeOfImage;
    NewModule := VirtualAllocEx(Process, Module, Size, MEM_COMMIT or
        MEM_RESERVE, PAGE_EXECUTE_READWRITE);
    if NewModule = nil then
    begin
        exit;
    end;
    WriteProcessMemory(Process, NewModule, Module, Size, BytesWritten);
    hThread := CreateRemoteThread(Process, nil, 0, EntryPoint, NewModule, 0, TID);
    if hThread <> 0 then
    begin
        Result := true;
    end;
end;

{ Выгрузка Dll из чужого адресного пространства }
function ReleaseLibrary(Process : dword; ModulePath : pchar) : boolean;
type
    TReleaseLibraryInfo = packed record
        pFreeLibrary : pointer;
        pGetModuleHandle : pointer;
        lpModuleName : pointer;
        pExitThread : pointer;
    end;
var
    ReleaseLibraryInfo : TReleaseLibraryInfo;
    hThread : dword;

    procedure ReleaseLibraryThread(lpParameter : pointer); stdcall;
    var
        ReleaseLibraryInfo : TReleaseLibraryInfo;
    begin
        ReleaseLibraryInfo := TReleaseLibraryInfo(lpParameter^);
        asm
            @1:
            INC ECX
            PUSH ReleaseLibraryInfo.lpModuleName
            CALL ReleaseLibraryInfo.pGetModuleHandle
            CMP EAX, 0
            JE @2
            PUSH EAX
            CALL ReleaseLibraryInfo.pFreeLibrary
            JMP @1
            @2:
            PUSH EAX
            CALL ReleaseLibraryInfo.pExitThread
        end;
    end;

begin
    Result := false;
    ReleaseLibraryInfo.pGetModuleHandle := GetProcAddress(GetModuleHandle('kernel32.dll'),
        'GetModuleHandleA');
    ReleaseLibraryInfo.pFreeLibrary := GetProcAddress(GetModuleHandle('kernel32.dll'),
        'FreeLibrary');
    ReleaseLibraryInfo.pExitThread := GetProcAddress(GetModuleHandle('kernel32.dll'),
        'ExitThread');
    ReleaseLibraryInfo.lpModuleName := InjectString(Process, ModulePath);
    if ReleaseLibraryInfo.lpModuleName = nil then
    begin
        Exit;
    end;
    hThread := InjectThread(Process, @ReleaseLibraryThread, @ReleaseLibraryInfo,
        SizeOf(TReleaseLibraryInfo), false);
    if hThread = 0 then
    begin
        Exit;
    end;
    CloseHandle(hThread);
    Result := true;
end;

{ Запуск процесса с загрузкой в него Dll }
function CreateProcessWithDll(lpApplicationName : pchar; lpCommandLine : pchar; lpProcessAttributes, lpThreadAttributes : PSecurityAttributes; bInheritHandles : boolean; dwCreationFlags : dword; lpEnvironment : pointer; lpCurrentDirectory : pchar; const lpStartupInfo : TStartupInfo; var lpProcessInformation : TProcessInformation; ModulePath : pchar) : boolean;
begin
    Result := false;
    if not CreateProcess(lpApplicationName,
        lpCommandLine,
        lpProcessAttributes,
        lpThreadAttributes,
        bInheritHandles,
        dwCreationFlags or CREATE_SUSPENDED,
        lpEnvironment,
        lpCurrentDirectory,
        lpStartupInfo, lpProcessInformation) then
    begin
        Exit;
    end;

    Result := InjectDll(lpProcessInformation.hProcess, ModulePath);
    if (dwCreationFlags and CREATE_SUSPENDED) = 0 then
    begin
        ResumeThread(lpProcessInformation.hThread);
    end;
end;


{
 Запуск процесса с загрузкой в него Dll альтернативным методом.
 Обеспечивается высокая скрытность загрузки Dll.
}
function CreateProcessWithDllEx(lpApplicationName : pchar; lpCommandLine : pchar; lpProcessAttributes, lpThreadAttributes : PSecurityAttributes; bInheritHandles : boolean; dwCreationFlags : dword; lpEnvironment : pointer; lpCurrentDirectory : pchar; const lpStartupInfo : TStartupInfo; var lpProcessInformation : TProcessInformation; Src : pointer) : boolean;
begin
    Result := false;
    if not CreateProcess(lpApplicationName,
        lpCommandLine,
        lpProcessAttributes,
        lpThreadAttributes,
        bInheritHandles,
        dwCreationFlags or CREATE_SUSPENDED,
        lpEnvironment,
        lpCurrentDirectory,
        lpStartupInfo,
        lpProcessInformation) then
    begin
        Exit;
    end;

    Result := InjectDllEx(lpProcessInformation.hProcess, Src);
    if (dwCreationFlags and CREATE_SUSPENDED) = 0 then
    begin
        ResumeThread(lpProcessInformation.hThread);
    end;
end;

{
  Установка перехвата функции.
  TargetProc - адрес перехватываемой функции,
  NewProc    - адрес функции замены,
  OldProc    - здесь будет сохранен адрес моста к старой функции.
}
function HookCode(TargetProc, NewProc : pointer; var OldProc : pointer) : boolean;
var
    Address : dword;
    OldProtect : dword;
    OldFunction : pointer;
    Proc : pointer;
begin
    Result := false;
    try
        Proc := TargetProc;
    //вычисляем адрес относительного (jmp near) перехода на новую функцию   
        Address := dword(NewProc) - dword(Proc) - 5;
        VirtualProtect(Proc, 5, PAGE_EXECUTE_READWRITE, OldProtect);
    //создаем буффер для true функции 
        GetMem(OldFunction, 255);
    //копируем первые 4 байта функции 
        dword(OldFunction^) := dword(Proc);
        byte(pointer(dword(OldFunction) + 4)^) := SaveOldFunction(Proc, pointer(dword(OldFunction) + 5));
    //byte(pointer(dword(OldFunction) + 4)^) - длина сохраненного участка
        byte(Proc^) := $e9; //устанавливаем переход 
        dword(pointer(dword(Proc) + 1)^) := Address;
        VirtualProtect(Proc, 5, OldProtect, OldProtect);
        OldProc := pointer(dword(OldFunction) + 5);
    except
        Exit;
    end;
    Result := true;
end;


{
 Установка перехвата функции из Dll в текущем процессе.
 lpModuleName - имя модуля,
 lpProcName   - имя функции,
 NewProc    - адрес функции замены,
 OldProc    - здесь будет сохранен адрес моста к старой функции.
 В случае отсутствия модуля в текущем АП, будет сделана попытка его загрузить.
}
function HookProc(lpModuleName, lpProcName : pchar; NewProc : pointer; var OldProc : pointer) : boolean;
var
    hModule : dword;
    fnAdr : pointer;
begin
    Result := false;
    hModule := GetModuleHandle(lpModuleName);
    if hModule = 0 then
    begin
        hModule := LoadLibrary(lpModuleName);
    end;
    if hModule = 0 then
    begin
        Exit;
    end;
    fnAdr := GetProcAddress(hModule, lpProcName);
    if fnAdr = nil then
    begin
        Exit;
    end;
    Result := HookCode(fnAdr, NewProc, OldProc);
end;


{
 Снятие перехвата установленного по HookCode,
 OldProc - адрес моста возвращенный функцией HookCode.
}
function UnhookCode(OldProc : pointer) : boolean;
var
    OldProtect : dword;
    Proc : pointer;
    SaveSize : dword;
begin
    Result := true;
    try
        Proc := pointer(dword(pointer(dword(OldProc) - 5)^));
        SaveSize := byte(pointer(dword(OldProc) - 1)^);
        VirtualProtect(Proc, 5, PAGE_EXECUTE_READWRITE, OldProtect);
        CopyMemory(Proc, OldProc, SaveSize);
        VirtualProtect(Proc, 5, OldProtect, OldProtect);
        FreeMem(pointer(dword(OldProc) - 5));
    except
        Result := false;
    end;
end;


{
 Отключение System Fle Protection на лету.
 Необходимо для незаметной модификации системных файлов.
}
function DisableSFC : boolean;
var
    Process, SFC, PID, Thread, ThreadID : dword;
begin
    Result := false;
    SFC := LoadLibrary('sfc.dll');
    GetWindowThreadProcessID(FindWindow('NDDEAgnt', nil), @PID);
    Process := OpenProcess(PROCESS_ALL_ACCESS, false, PID);
    Thread := CreateRemoteThread(Process, nil, 0,
        GetProcAddress(SFC, pchar(2 and $ffff)),
        nil, 0, ThreadId);
    if Thread = 0 then
    begin
        Exit;
    end;
    CloseHandle(Thread);
    CloseHandle(Process);
    FreeLibrary(SFC);
    Result := true;
end;

{ Создание моста к старой функции }
function SaveOldFunction(Proc : pointer; Old : pointer) : dword;
var
    SaveSize, Size : dword;
    Next : pointer;
begin
    SaveSize := 0;
    Next := Proc;
  //сохраняем следующие несколько коротких, либо одну длинную инструкцию
    while SaveSize < 5 do
    begin
        Size := SizeOfCode(Next);
        Next := pointer(dword(Next) + Size);
        Inc(SaveSize, Size);
    end;
    CopyMemory(Old, Proc, SaveSize);
  //генерируем переход на следующую инструкцию после сохраненного участка
    byte(pointer(dword(Old) + SaveSize)^) := $e9;
    dword(pointer(dword(Old) + SaveSize + 1)^) := dword(Next) - dword(Old) - SaveSize - 5;
    Result := SaveSize;
end;

{ Получение адреса API в чужом адресном пространстве }
function GetProcAddressEx(Process : dword; lpModuleName, lpProcName : pchar; dwProcLen : dword) : pointer;
type
    TGetProcAddrExInfo = record
        pExitThread : pointer;
        pGetProcAddress : pointer;
        pGetModuleHandle : pointer;
        lpModuleName : pointer;
        lpProcName : pointer;
    end;
var
    GetProcAddrExInfo : TGetProcAddrExInfo;
    ExitCode : dword;
    hThread : dword;

    procedure GetProcAddrExThread(lpParameter : pointer); stdcall;
    var
        GetProcAddrExInfo : TGetProcAddrExInfo;
    begin
        GetProcAddrExInfo := TGetProcAddrExInfo(lpParameter^);
        asm
            PUSH GetProcAddrExInfo.lpModuleName
            CALL GetProcAddrExInfo.pGetModuleHandle
            PUSH GetProcAddrExInfo.lpProcName
            PUSH EAX
            CALL GetProcAddrExInfo.pGetProcAddress
            PUSH EAX
            CALL GetProcAddrExInfo.pExitThread
        end;
    end;

begin
    Result := nil;
    GetProcAddrExInfo.pGetModuleHandle := GetProcAddress(GetModuleHandle('kernel32.dll'),
        'GetModuleHandleA');
    GetProcAddrExInfo.pGetProcAddress := GetProcAddress(GetModuleHandle('kernel32.dll'),
        'GetProcAddress');
    GetProcAddrExInfo.pExitThread := GetProcAddress(GetModuleHandle('kernel32.dll'),
        'ExitThread');
    if dwProcLen = 4 then
    begin
        GetProcAddrExInfo.lpProcName := lpProcName;
    end
    else
    begin
        GetProcAddrExInfo.lpProcName := InjectMemory(Process, lpProcName, dwProcLen);
    end;

    GetProcAddrExInfo.lpModuleName := InjectString(Process, lpModuleName);
    hThread := InjectThread(Process, @GetProcAddrExThread, @GetProcAddrExInfo,
        SizeOf(GetProcAddrExInfo), false);

    if hThread <> 0 then
    begin
        WaitForSingleObject(hThread, INFINITE);
        GetExitCodeThread(hThread, ExitCode);
        Result := pointer(ExitCode);
    end;
end;

{
 Отображение Dll на чужое адресное пространство, настройка импорта и релоков.
 Process - хэндл процесса для отображения,
 Dest    - адрес отображения в процессе Process,
 Src     - адрес образа Dll в текущем процессе. 
}
function MapLibrary(Process : dword; Dest, Src : pointer) : TLibInfo;
var
    ImageBase : pointer;
    ImageBaseDelta : integer;
    ImageNtHeaders : PImageNtHeaders;
    PSections : ^TSections;
    SectionLoop : integer;
    SectionBase : pointer;
    VirtualSectionSize, RawSectionSize : dword;
    OldProtect : dword;
    NewLibInfo : TLibInfo;

  { Настройка релоков }
    procedure ProcessRelocs(PRelocs : PImageBaseRelocation);
    var
        PReloc : PImageBaseRelocation;
        RelocsSize : dword;
        Reloc : PWord;
        ModCount : dword;
        RelocLoop : dword;
    begin
        PReloc := PRelocs;
        RelocsSize := ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].Size;
        while dword(PReloc) - dword(PRelocs) < RelocsSize do
        begin
            ModCount := (PReloc.SizeOfBlock - Sizeof(PReloc^)) div 2;
            Reloc := pointer(dword(PReloc) + sizeof(PReloc^));
            for RelocLoop := 0 to ModCount - 1 do
            begin
                if Reloc^ and $f000 <> 0 then
                begin
                    Inc(pdword(dword(ImageBase) +
                        PReloc.VirtualAddress +
                        (Reloc^ and $0fff))^, ImageBaseDelta);
                end;
                Inc(Reloc);
            end;
            PReloc := pointer(Reloc);
        end;
    end;

  { Настройка импорта Dll в чужом процессе}
    procedure ProcessImports(PImports : PImageImportDescriptor);
    var
        PImport : PImageImportDescriptor;
        Import : pdword;
        PImportedName : pchar;
        ProcAddress : pointer;
        PLibName : pchar;
        ImportLoop : integer;

        function IsImportByOrdinal(ImportDescriptor : dword) : boolean;
        begin
            Result := (ImportDescriptor and IMAGE_ORDINAL_FLAG32) <> 0;
        end;

    begin
        PImport := PImports;
        while PImport.Name <> 0 do
        begin
            PLibName := pchar(dword(PImport.Name) + dword(ImageBase));
            if not Find(NewLibInfo.LibsUsed, PLibName, ImportLoop) then
            begin
                InjectDll(Process, PLibName);
                Add(NewLibInfo.LibsUsed, PLibName);
            end;
            if PImport.TimeDateStamp = 0 then
            begin
                Import := pdword(pImport.FirstThunk + dword(ImageBase));
            end
            else
            begin
                Import := pdword(pImport.OriginalFirstThunk + dword(ImageBase));
            end;

            while Import^ <> 0 do
            begin
                if IsImportByOrdinal(Import^) then
                begin
                    ProcAddress := GetProcAddressEx(Process, PLibName, pchar(Import^ and $ffff), 4);
                end
                else
                begin
                    PImportedName := pchar(Import^ + dword(ImageBase) + IMPORTED_NAME_OFFSET);
                    ProcAddress := GetProcAddressEx(Process, PLibName, PImportedName, Length(PImportedName));
                end;
                Ppointer(Import)^ := ProcAddress;
                Inc(Import);
            end;
            Inc(PImport);
        end;
    end;

begin
    ImageNtHeaders := pointer(dword(Src) + dword(PImageDosHeader(Src)._lfanew));
    ImageBase := VirtualAlloc(Dest, ImageNtHeaders.OptionalHeader.SizeOfImage,
        MEM_RESERVE, PAGE_NOACCESS);

    ImageBaseDelta := dword(ImageBase) - ImageNtHeaders.OptionalHeader.ImageBase;
    SectionBase := VirtualAlloc(ImageBase, ImageNtHeaders.OptionalHeader.SizeOfHeaders,
        MEM_COMMIT, PAGE_READWRITE);
    Move(Src^, SectionBase^, ImageNtHeaders.OptionalHeader.SizeOfHeaders);
    VirtualProtect(SectionBase, ImageNtHeaders.OptionalHeader.SizeOfHeaders,
        PAGE_READONLY, OldProtect);
    PSections := pointer(pchar(@(ImageNtHeaders.OptionalHeader)) +
        ImageNtHeaders.FileHeader.SizeOfOptionalHeader);

    for SectionLoop := 0 to ImageNtHeaders.FileHeader.NumberOfSections - 1 do
    begin
        VirtualSectionSize := PSections[SectionLoop].Misc.VirtualSize;
        RawSectionSize := PSections[SectionLoop].SizeOfRawData;
        if VirtualSectionSize < RawSectionSize then
        begin
            VirtualSectionSize := VirtualSectionSize xor RawSectionSize;
            RawSectionSize := VirtualSectionSize xor RawSectionSize;
            VirtualSectionSize := VirtualSectionSize xor RawSectionSize;
        end;
        SectionBase := VirtualAlloc(PSections[SectionLoop].VirtualAddress +
            pchar(ImageBase), VirtualSectionSize,
            MEM_COMMIT, PAGE_READWRITE);
        FillChar(SectionBase^, VirtualSectionSize, 0);
        Move((pchar(src) + PSections[SectionLoop].pointerToRawData)^,
            SectionBase^, RawSectionSize);
    end;
    NewLibInfo.DllProcAddress := pointer(ImageNtHeaders.OptionalHeader.AddressOfEntryPoint +
        dword(ImageBase));
    NewLibInfo.DllProc := TDllEntryProc(NewLibInfo.DllProcAddress);

    NewLibInfo.ImageBase := ImageBase;
    NewLibInfo.ImageSize := ImageNtHeaders.OptionalHeader.SizeOfImage;
    SetLength(NewLibInfo.LibsUsed, 0);
    if ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress <> 0 then
    begin
        ProcessRelocs(pointer(ImageNtHeaders.OptionalHeader.
            DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].
            VirtualAddress + dword(ImageBase)));
    end;

    if ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress <> 0 then
    begin
        ProcessImports(pointer(ImageNtHeaders.OptionalHeader.
            DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].
            VirtualAddress + dword(ImageBase)));
    end;

    for SectionLoop := 0 to ImageNtHeaders.FileHeader.NumberOfSections - 1 do
    begin
        VirtualProtect(PSections[SectionLoop].VirtualAddress + pchar(ImageBase),
            PSections[SectionLoop].Misc.VirtualSize,
            GetSectionProtection(PSections[SectionLoop].Characteristics),
            OldProtect);
    end;
    Result := NewLibInfo;
end;


{
 Остановка всех нитей процесса.
 Если останавливается текущий процесс, то вызывающая нить не останавливается.
}
function StopProcess(ProcessId : dword) : boolean;
var
    Snap : dword;
    CurrTh : dword;
    ThrHandle : dword;
    Thread : TThreadEntry32;
begin
    Result := false;
    CurrTh := GetCurrentThreadId;
    Snap := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
    if Snap <> INVALID_HANDLE_VALUE then
    begin
        Thread.dwSize := SizeOf(TThreadEntry32);
        if Thread32First(Snap, Thread) then
        begin
            repeat
                if (Thread.th32ThreadID <> CurrTh) and (Thread.th32OwnerProcessID = ProcessId) then
                begin
                    ThrHandle := OpenThread(THREAD_SUSPEND_RESUME, false, Thread.th32ThreadID);
                    if ThrHandle = 0 then
                    begin
                        Exit;
                    end;
                    SuspendThread(ThrHandle);
                    CloseHandle(ThrHandle);
                end;
            until not Thread32Next(Snap, Thread);
        end;
        CloseHandle(Snap);
        Result := true;
    end;
end;

{ Запуск процесса остановленного StopProcess }
function RunProcess(ProcessId : dword) : boolean;
var
    Snap : dword;
    CurrTh : dword;
    ThrHandle : dword;
    Thread : TThreadEntry32;
begin
    Result := false;
    CurrTh := GetCurrentThreadId;
    Snap := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
    if Snap <> INVALID_HANDLE_VALUE then
    begin
        Thread.dwSize := SizeOf(TThreadEntry32);
        if Thread32First(Snap, Thread) then
        begin
            repeat
                if (Thread.th32ThreadID <> CurrTh) and (Thread.th32OwnerProcessID = ProcessId) then
                begin
                    ThrHandle := OpenThread(THREAD_SUSPEND_RESUME, false, Thread.th32ThreadID);
                    if ThrHandle = 0 then
                    begin
                        Exit;
                    end;
                    ResumeThread(ThrHandle);
                    CloseHandle(ThrHandle);
                end;
            until not Thread32Next(Snap, Thread);
        end;
        CloseHandle(Snap);
        Result := true;
    end;
end;

{ поиск первой попавшейся нити заданного процесса }
function SearchProcessThread(ProcessId : dword) : dword;
var
    Snap : dword;
    Thread : TThreadEntry32;
begin
    Result := 0;
    Snap := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
    if Snap <> INVALID_HANDLE_VALUE then
    begin
        Thread.dwSize := SizeOf(TThreadEntry32);
        if Thread32First(Snap, Thread) then
        begin
            repeat
                if Thread.th32OwnerProcessID = ProcessId then
                begin
                    Result := Thread.th32ThreadID;
                    CloseHandle(Snap);
                    Exit;
                end;
            until not Thread32Next(Snap, Thread);
        end;
        CloseHandle(Snap);
    end;
end;

{ Остановка всех нитей текущего процесса кроме вызывающей }
function StopThreads() : boolean;
begin
    Result := StopProcess(GetCurrentProcessId());
end;

{ Запуск нитей остановленных StopThreads}
function RunThreads() : boolean;
begin
    Result := RunProcess(GetCurrentProcessId());
end;

{ Включение заданой привилегии для процесса }
function EnablePrivilegeEx(Process : dword; lpPrivilegeName : pchar) : boolean;
var
    hToken : dword;
    NameValue : int64;
    tkp : TOKEN_PRIVILEGES;
    ReturnLength : dword;
begin
    Result := false;
  //Получаем токен нашего процесса
    OpenProcessToken(Process, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken);
  //Получаем LUID привилегии
    if not LookupPrivilegeValue(nil, lpPrivilegeName, NameValue) then
    begin
        CloseHandle(hToken);
        exit;
    end;
    tkp.PrivilegeCount := 1;
    tkp.Privileges[0].Luid := NameValue;
    tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
  //Добавляем привилегию к процессу
    AdjustTokenPrivileges(hToken, false, tkp, SizeOf(TOKEN_PRIVILEGES), tkp, ReturnLength);
    if GetLastError() <> ERROR_SUCCESS then
    begin
        CloseHandle(hToken);
        exit;
    end;
    Result := true;
    CloseHandle(hToken);
end;

{ включение заданной привилегии для текущего процесса }
function EnablePrivilege(lpPrivilegeName : pchar) : boolean;
begin
    Result := EnablePrivilegeEx(INVALID_HANDLE_VALUE, lpPrivilegeName);
end;


{ Включение привилегии SeDebugPrivilege для процесса }
function EnableDebugPrivilegeEx(Process : dword) : boolean;
begin
    Result := EnablePrivilegeEx(Process, 'SeDebugPrivilege');
end;

{ Включение привилегии SeDebugPrivilege для текущего процесса }
function EnableDebugPrivilege() : boolean;
begin
    Result := EnablePrivilegeEx(INVALID_HANDLE_VALUE, 'SeDebugPrivilege');
end;

{ Получение Id процесса по его имени }
function GetProcessId(pName : pchar) : dword;
var
    Snap : dword;
    Process : TPROCESSENTRY32;
begin
    Result := 0;
    Snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if Snap <> INVALID_HANDLE_VALUE then
    begin
        Process.dwSize := SizeOf(TPROCESSENTRY32);
        if Process32First(Snap, Process) then
        begin
            repeat
                if lstrcmpi(Process.szExeFile, pName) = 0 then
                begin
                    Result := Process.th32ProcessID;
                    CloseHandle(Snap);
                    Exit;
                end;
            until not Process32Next(Snap, Process);
        end;
        Result := 0;
        CloseHandle(Snap);
    end;
end;


{ получение хэндла процесса альтернативным методом }
function OpenProcessEx(dwProcessId : DWORD) : THandle;
var
    HandlesInfo : PSYSTEM_HANDLE_INFORMATION_EX;
    ProcessInfo : _PROCESS_BASIC_INFORMATION;
    idCSRSS : dword;
    hCSRSS : dword;
    tHandle : dword;
    r : dword;
begin
    Result := 0;
 //открываем процесс csrss.exe 
    idCSRSS := GetProcessId('csrss.exe');
    hCSRSS := OpenProcess(PROCESS_DUP_HANDLE, false, idCSRSS);
    if hCSRSS = 0 then
    begin
        Exit;
    end;
    HandlesInfo := GetInfoTable(SystemHandleInformation);
    if HandlesInfo <> nil then
    begin
        for r := 0 to HandlesInfo^.NumberOfHandles do
        begin
            if (HandlesInfo^.Information[r].ObjectTypeNumber = $5) and  //тип хэндла - процесс
                (HandlesInfo^.Information[r].ProcessId = idCSRSS) then   //владелец - CSRSS
            begin
          //копируем хэндл себе
                if DuplicateHandle(hCSRSS, HandlesInfo^.Information[r].Handle,
                    INVALID_HANDLE_VALUE, @tHandle, 0, false,
                    DUPLICATE_SAME_ACCESS) then
                begin
                    ZwQueryInformationProcess(tHandle, ProcessBasicInformation, @ProcessInfo,
                        SizeOf(_PROCESS_BASIC_INFORMATION), nil);
                    if ProcessInfo.UniqueProcessId = dwProcessId then
                    begin
                        VirtualFree(HandlesInfo, 0, MEM_RELEASE);
                        CloseHandle(hCSRSS);
                        Result := tHandle;
                        Exit;
                    end
                    else
                    begin
                        CloseHandle(tHandle);
                    end;
                end;
            end;
        end;
    end;
    VirtualFree(HandlesInfo, 0, MEM_RELEASE);
    CloseHandle(hCSRSS);
end;


{ создание процесса "зомби", в контексте которого будет выполняться наша DLL }
function CreateZombieProcess(lpCommandLine : pchar; var lpProcessInformation : TProcessInformation; ModulePath : pchar) : boolean;
var
    Memory : pointer;
    Code : dword;
    BytesWritten : dword;
    Context : _CONTEXT;
    lpStartupInfo : TStartupInfo;
    hKernel32 : dword;
    Inject : packed record
        PushCommand : byte;
        PushArgument : DWORD;
        CallCommand : word;
        CallAddr : DWORD;
        PushExitThread : byte;
        ExitThreadArg : dword;
        CallExitThread : word;
        CallExitThreadAddr : DWord;
        AddrLoadLibrary : pointer;
        AddrExitThread : pointer;
        LibraryName : array[0..MAX_PATH] of char;
    end;
begin
    Result := false;
  //запускаем процесс
    ZeroMemory(@lpStartupInfo, SizeOf(TStartupInfo));
    lpStartupInfo.cb := SizeOf(TStartupInfo);
    if not CreateProcess(nil, lpCommandLine, nil, nil,
        false, CREATE_SUSPENDED, nil, nil,
        lpStartupInfo, lpProcessInformation) then
    begin
        Exit;
    end;
  //выделяем память для внедряемого кода
    Memory := VirtualAllocEx(lpProcessInformation.hProcess, nil, SizeOf(Inject),
        MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    if Memory = nil then
    begin
        TerminateProcess(lpProcessInformation.hProcess, 0);
        Exit;
    end;
    Code := dword(Memory);
  //инициализация внедряемого кода:
    Inject.PushCommand := $68;
    inject.PushArgument := code + $1E;
    inject.CallCommand := $15FF;
    inject.CallAddr := code + $16;
    inject.PushExitThread := $68;
    inject.ExitThreadArg := 0;
    inject.CallExitThread := $15FF;
    inject.CallExitThreadAddr := code + $1A;
    hKernel32 := GetModuleHandle('kernel32.dll');
    inject.AddrLoadLibrary := GetProcAddress(hKernel32, 'LoadLibraryA');
    inject.AddrExitThread := GetProcAddress(hKernel32, 'ExitThread');
    lstrcpy(@inject.LibraryName, ModulePath);
  //записать машинный код по зарезервированному адресу
    WriteProcessMemory(lpProcessInformation.hProcess, Memory, @inject, sizeof(inject), BytesWritten);

  //получаем текущий контекст первичной нити процесса
    Context.ContextFlags := CONTEXT_FULL;
    GetThreadContext(lpProcessInformation.hThread, Context);
  //изменяем контекст так, чтобы выполнялся наш код
    Context.Eip := code;
    SetThreadContext(lpProcessInformation.hThread, Context);
  //запускаем нить
    ResumeThread(lpProcessInformation.hThread);
end;

{ Внедрение DLL альтернативным способом (без CreateRemoteThread) }
function InjectDllAlt(Process : dword; ModulePath : pchar) : boolean;
var
    Context : _CONTEXT;
    hThread : dword;
    ProcessInfo : _PROCESS_BASIC_INFORMATION;
    InjData : packed record
        OldEip : dword;
        OldEsi : dword;
        AdrLoadLibrary : pointer;
        AdrLibName : pointer;
    end;

    procedure Injector();
    asm
        PUSHAD
        DB $E8              // опкод call short 0
        DD 0
        POP EAX             // eax - адрес текущей инструкции
        ADD EAX, $12
        MOV [EAX], ESI      // модифицируем операнд dd $00000000
        PUSH [ESI + $0C]    // кладем в стек имя DLL
        CALL [ESI + $08]    // call LoadLibraryA
        POPAD
        MOV ESI, [ESI + $4] // восстанавливаем esi из старого контекста
        DW $25FF            // опкод Jmp dword ptr [00000000h]
        DD $00000000        // модифицируемый операнд
        RET
    end;
begin
    Result := false;
  //получаем id процесса
    ZwQueryInformationProcess(Process, ProcessBasicInformation, @ProcessInfo,
        SizeOf(_PROCESS_BASIC_INFORMATION), nil);
  //открываем первую попавшуюся нить
    hThread := OpenThread(THREAD_ALL_ACCESS, false,
        SearchProcessThread(ProcessInfo.UniqueProcessId));
    if hThread = 0 then
    begin
        Exit;
    end;
    SuspendThread(hThread);
  //сохраняем старый контекст
    Context.ContextFlags := CONTEXT_FULL;
    GetThreadContext(hThread, Context);
  //подготавливаем данные для внедряемого кода
    InjData.OldEip := Context.Eip;
    InjData.OldEsi := Context.Esi;
    InjData.AdrLoadLibrary := GetProcAddress(GetModuleHandle('kernel32.dll'),
        'LoadLibraryA');
    InjData.AdrLibName := InjectString(Process, ModulePath);
    if InjData.AdrLibName = nil then
    begin
        Exit;
    end;
  //внедряем данные и устанавливаем ebp контекста 
    Context.Esi := dword(InjectMemory(Process, @InjData, SizeOf(InjData)));
  //внедряем код
    Context.Eip := dword(InjectMemory(Process, @Injector, SizeOfProc(@Injector)));
  //устанавливаем новый контекст 
    SetThreadContext(hThread, Context);
    ResumeThread(hThread);
    Result := true;
end;


{ убивание процесса отладочным методом }
function DebugKillProcess(ProcessId : dword) : boolean;
var
    pHandle : dword;
    myPID : dword;
    HandlesInfo : PSYSTEM_HANDLE_INFORMATION_EX;
    r : dword;
begin
    Result := false;
    myPID := GetCurrentProcessId();
    if not EnableDebugPrivilege() then
    begin
        Exit;
    end;
 //подключаемся к системе отладки и получаем DebugObject
    if DbgUiConnectToDbg() <> STATUS_SUCCESS then
    begin
        Exit;
    end;
    pHandle := OpenProcessEx(ProcessId);
 //включаем отладку процесса
    if DbgUiDebugActiveProcess(pHandle) <> STATUS_SUCCESS then
    begin
        Exit;
    end;
 //надо найти полученный DebugObject
    HandlesInfo := GetInfoTable(SystemHandleInformation);
    if HandlesInfo = nil then
    begin
        Exit;
    end;
    for r := 0 to HandlesInfo^.NumberOfHandles do
    begin
        if (HandlesInfo^.Information[r].ProcessId = myPID) and
            (HandlesInfo^.Information[r].ObjectTypeNumber = $8)  //DebugObject
        then
        begin
       //закрываем DebugObject, что приводит к уничтожению отлаживаемого процесса
            CloseHandle(HandlesInfo^.Information[r].Handle);
            Result := true;
            break;
        end;
    end;
    VirtualFree(HandlesInfo, 0, MEM_RELEASE);
end;

end.
