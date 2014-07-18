unit uVisualContainer;

interface

uses
    uGlobalFuncs,
    math,
    uSharedStructs,
    StrUtils,
    uREsourceStrings,
    LSPControl,
    uScriptEditor,
    uPacketView,
    Windows,
    Messages,
    SysUtils,
    Variants,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    ImgList,
    JvExControls,
    JvEditorCommon,
    JvEditor,
    JvHLEditor,
    StdCtrls,
    ComCtrls,
    ToolWin,
    JvExStdCtrls,
    JvRichEdit,
    ExtCtrls,
    Menus,
    JvExExtCtrls,
    Mask,
    JvExMask,
    JvSpin,
    JvLabel,
    siComp,
    PerlRegEx,
    Buttons;

type

    TfVisual = class (TFrame)
        PageControl1 : TPageControl;
        TabSheet1 : TTabSheet;
        GroupBox12 : TGroupBox;
        ListView5 : TListView;
        TabSheet2 : TTabSheet;
        TabSheet3 : TTabSheet;
        GroupBox8 : TGroupBox;
        imgBT : TImageList;
        ImageList2 : TImageList;
        PopupMenu1 : TPopupMenu;
        N1 : TMenuItem;
        N2 : TMenuItem;
        dlgSaveLog : TSaveDialog;
        Panel4 : TPanel;
        ToolBar1 : TToolBar;
        tbtnSave : TToolButton;
        tbtnClear : TToolButton;
        ToolButton1 : TToolButton;
        tbtnFilterDel : TToolButton;
        tbtnDelete : TToolButton;
        ToolButton15 : TToolButton;
        tbtnToSend : TToolButton;
        ToolButton4 : TToolButton;
        ToolButton3 : TToolButton;
        ToolButton5 : TToolButton;
        BtnAutoSavePckts : TToolButton;
        ToolButton9 : TToolButton;
        ToolButton6 : TToolButton;
        ToolButton17 : TToolButton;
        Panel5 : TPanel;
        Panel7 : TPanel;
        ToolBar3 : TToolBar;
        ToolButton37 : TToolButton;
        ToolButton38 : TToolButton;
        timerSend : TTimer;
        Panel8 : TPanel;
        Panel9 : TPanel;
        Panel11 : TPanel;
        ToolBar5 : TToolBar;
        ToolButton30 : TToolButton;
        ToolButton31 : TToolButton;
        ToolBar2 : TToolBar;
        SaveBnt : TToolButton;
        OpenBtn : TToolButton;
        ToolButton14 : TToolButton;
        ToServer : TToolButton;
        ToClient : TToolButton;
        ToolButton19 : TToolButton;
        EachLinePacket : TToolButton;
        ToolButton13 : TToolButton;
        SendBtn : TToolButton;
        ToolButton26 : TToolButton;
        SendByTimer : TToolButton;
        JvSpinEdit2 : TJvSpinEdit;
        Panel12 : TPanel;
        Panel13 : TPanel;
        ToolBar6 : TToolBar;
        ToolButton25 : TToolButton;
        ToolButton27 : TToolButton;
        ToolButton28 : TToolButton;
        btnExecute : TToolButton;
        btnTerminate : TToolButton;
        ToolButton8 : TToolButton;
        btnSaveRaw : TToolButton;
        dlgSaveLogRaw : TSaveDialog;
        DlgSavePacket : TSaveDialog;
        DlgOpenPacket : TOpenDialog;
        Panel14 : TPanel;
        DlgOpenScript : TOpenDialog;
        dlgSaveScript : TSaveDialog;
        waitbar : TPanel;
        ProgressBar1 : TProgressBar;
        Label3 : TLabel;
        lang : TsiLang;
        ReloadThis : TToolButton;
        packetVievPanel : TPanel;
        Splitter3 : TSplitter;
        GroupBox7 : TGroupBox;
        Memo4 : TJvRichEdit;
        btnProcessPackets : TToolButton;
        splashpnl : TPanel;
        Splash : TJvLabel;
        JvSpinEdit1 : TJvSpinEdit;
        Label1 : TLabel;
        PerlRegEx : TPerlRegEx;
        Panel1 : TPanel;
        edtRegRule : TEdit;
        btnRegRuleUpdate : TSpeedButton;
        chkRegRule : TCheckBox;
        ToolButton2 : TToolButton;
        procedure ListView5Click(Sender : TObject);
        procedure ListView5KeyUp(Sender : TObject; var Key : word; Shift : TShiftState);
        procedure tbtnToSendClick(Sender : TObject);
        procedure ToolButton17Click(Sender : TObject);
        procedure ToolButton6Click(Sender : TObject);
        procedure tbtnSaveClick(Sender : TObject);
        procedure CloseConnectionClick(Sender : TObject);
        procedure tbtnClearClick(Sender : TObject);
        procedure tbtnFilterDelClick(Sender : TObject);
        procedure tbtnDeleteClick(Sender : TObject);
        procedure ToolButton4Click(Sender : TObject);
        procedure Memo4Change(Sender : TObject);
        procedure ToServerClick(Sender : TObject);
        procedure ToClientClick(Sender : TObject);
        procedure Memo4KeyUp(Sender : TObject; var Key : word; Shift : TShiftState);
        procedure Memo4MouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : integer);
        procedure SaveBntClick(Sender : TObject);
        procedure SendByTimerClick(Sender : TObject);
        procedure SendBtnClick(Sender : TObject);
        procedure ToolButton30Click(Sender : TObject);
        procedure btnExecuteClick(Sender : TObject);
        procedure btnTerminateClick(Sender : TObject);
        procedure ToolButton8Click(Sender : TObject);
        procedure PopupMenu1Popup(Sender : TObject);
        procedure ToolButton27Click(Sender : TObject);
        procedure ToolButton25Click(Sender : TObject);
        procedure btnSaveRawClick(Sender : TObject);
        procedure FrameResize(Sender : TObject);
        procedure ReloadThisClick(Sender : TObject);
        procedure TabSheet1Show(Sender : TObject);
        procedure TabSheet3Show(Sender : TObject);
        procedure OpenBtnClick(Sender : TObject);
        procedure timerSendTimer(Sender : TObject);
        procedure JvSpinEdit1Change(Sender : TObject);
        procedure btnRegRuleUpdateClick(Sender : TObject);
        procedure chkRegRuleClick(Sender : TObject);
        procedure ListView5CustomDrawItem(Sender : TCustomListView; Item : TListItem; State : TCustomDrawState; var DefaultDraw : boolean);
    private
    { Private declarations }
        hScriptThread, idScriptThread : cardinal;
        Edit : tfscripteditor;
    public
        PacketView : tfPacketView;
        dump, dumpacumulator, dumpRegBuf : TStringList;
        hexvalue : string; //дл€ вывода HEX в расшифровке пакетов
        currenttunel, currentLSP, CurrentTpacketLog : Tobject;
        procedure ProcessPacket(newpacket : tpacket; FromServer : boolean; Caller : TObject; PacketNumber : integer);
        procedure processpacketfromacum();
        procedure AddPacketToAcum(newpacket : tpacket; FromServer : boolean; Caller : TObject);
        procedure init();
        procedure Translate();
        procedure deinit();

    { Public declarations }
        procedure sendThis(str : string);

        procedure SavePacketLog;                      //сохран€ет Dump в файл
        procedure PacketListRefresh(NeedLoadPackets : boolean);
        procedure DisableBtns;
        procedure EnableBtns;
        procedure disableControls;
        procedure enableControls;
        procedure IDontknowHowToNameThis;
        procedure setNofreeBtns(down : boolean);
        procedure ThisOneDisconnected;
    end;

implementation

uses
    uencdec,
    uMain,
    uSocketEngine,
    uFilterForm,
    uData,
    uScripts;

{$R *.dfm}

{ TFrame1 }

procedure TfVisual.init;
begin
    translate();
    Panel7.Width := 73;
    PacketView := TfPacketView.Create(self);
    PacketView.Parent := packetVievPanel;
    ToolButton17.Down := GlobalSettings.HexViewOffset;
    PacketView.HexViewOffset := GlobalSettings.HexViewOffset;
    ToolButton5.Down := GlobalSettings.ShowLastPacket;
    btnProcessPackets.Down := GlobalSettings.isprocesspackets;


    if Assigned(currenttunel) then
    begin
        btnSaveRaw.Visible := Ttunel(currenttunel).isRawAllowed;
    end;

    if Assigned(currentLSP) then
    begin
        btnSaveRaw.Visible := TlspConnection(currentLSP).isRawAllowed;
    end;

    edit := TfScriptEditor.Create(GroupBox8);
    Edit.init;
    Edit.Parent := GroupBox8;
    edit.Source.Lines.SetText(
        'begin'#10#13 +
        'buf:=#$4A;'#10#13 +
        'WriteD(0);'#10#13 +
        'WriteD(10);'#10#13 +
        'WriteS('''');'#10#13 +
        'WriteS(''Hello!!!'');'#10#13 +
        'SendToClient;'#10#13 +
        'end.');
    dmData.UpdateAutoCompleate(edit.AutoComplete);

    Dump := TStringList.Create;
    dumpacumulator := TStringList.Create;
    dumpRegBuf := TStringList.Create;
    BtnAutoSavePckts.Down := GlobalSettings.isSavePLog;
    if CurrentTpacketLog <> nil then //просмотр логов, просто скрываем все ненужное
    begin
        TabSheet2.TabVisible := false;
        TabSheet2.Hide;
        TabSheet3.TabVisible := false;
        TabSheet3.Hide;
        TabSheet1.TabVisible := false;
        N2.Visible := false;
        ToolButton2.Visible := false;
        tbtnToSend.Hide;
        ToolButton37.Hide;
        ToolButton37.Hide;
        ToolButton38.Hide;
        btnProcessPackets.hide;
        ToolButton8.Show;
        dump.LoadFromFile(TpacketLogWiev(CurrentTpacketLog).sFileName);
        PacketListRefresh(false);
      //в этом экземпл€ре нет соединени€!
    end;

    TabSheet1.Show;
    if assigned(currenttunel) then
    begin
        if assigned(sockEngine) then
        begin
            if sockEngine.donotdecryptnextconnection then
            begin
                Panel5.Parent := Self;
                PageControl1.Visible := false;
                packetVievPanel.Visible := false;
                ToolBar1.Visible := false;
                btnProcessPackets.Visible := false;
                toolbutton37.Down := false;
                toolbutton37.Visible := false;
                Splitter3.Visible := false;
                panel7.Width := 25;
                ToolButton38.Left := 1;
                splashpnl.Align := alClient;
                splashpnl.Show;
                splashpnl.BringToFront;
            end;
        end;
    end;
end;

procedure TfVisual.deinit;
begin
    if not isDestroying then
    begin
        SavePacketLog;
    end;
    if assigned(Dump) then
    begin
        Dump.Destroy;
    end;
    dump := nil;
    dumpRegBuf.Free;
    if assigned(dumpacumulator) then
    begin
        dumpacumulator.Destroy;
    end;
    dumpacumulator := nil;
    if assigned(Edit) then
    begin
        Edit.deinit;
        edit.Destroy;
        dump := nil;
    end;
    if assigned(PacketView) then
    begin
        PacketView.Destroy;
    end;
    currenttunel := nil;
    currentLSP := nil;
    PacketView := nil;
end;

procedure TfVisual.Processpacket;
  //=========================================
  // локальные процедуры
  //=========================================
    procedure AddToListView5(ItemImageIndex : byte; ItemCaption : string; ItemPacketNumber : longword; ItemId : byte; ItemSubId, ItemSub2Id : word; Visible : boolean; hexid : string; pksize : integer);
    var
        str : string;
    begin
        with ListView5.Items.Add do
        begin
      //им€ пакета
            Caption := IntToStr(ItemPacketNumber);
      //код иконки
            ImageIndex := ItemImageIndex;
      //номер
            SubItems.Add(inttostr(pksize));
            SubItems.Add(hexid);
//            SubItemImages[SubItems.Add(ItemCaption)] := ItemImageIndex;
            SubItems.Add(ItemCaption);
            if not Visible then
            begin
                MakeVisible(false);
            end;
        end;
    end;

    procedure AddToPacketFilterUnknown(ItemFromServer : boolean; ItemId : byte; ItemSubId, ItemSub2Id : word; ItemChecked : boolean; hexid : string);
    var
        CurrentList : TListView;
        currentpackedfrom : TStringList;
        str : string;
    begin
        GetPFandPL(currentpackedfrom, CurrentList, ItemFromServer);
        with CurrentList.Items.Add do
        begin
            str := hexid;
            Caption := str;
            Checked := ItemChecked;
            SubItems.Add('Unknown' + str);
            if length(str) = 2 then
            begin
                currentpackedfrom.Append(str + '=Unknown:');
            end
            else
            begin
                currentpackedfrom.Append(str + '=Unknown:h(SubId)');
            end;
        end;
    end;
//=========================================
var
    id : byte;
    subid, sub2id : word;
    pname : string;
    isknown : boolean;
    IsShow : boolean;
    hexid : string;
begin
  //а нужна ли она?!
    if GlobalSettings.isNoLog then
    begin
        exit;
    end; //не ведем лог пакетов

    if PacketNumber < 0 then
    begin
        exit;
    end; //или -1 0_о
    if PacketNumber >= Dump.Count then
    begin
        exit;
    end; //или индекс оф боундс -)
    if newpacket.Size = 0 then
    begin
        exit;
    end; // если пустой пакет выходим
    if (FromServer and not ToolButton4.Down) or (not FromServer and not ToolButton3.Down) then
    begin
        exit;
    end;

    id := newpacket.Data[0];
    if newpacket.size >= 3 then
    begin
        subid := word(newpacket.data[1] + newpacket.data[2] shl 8);
    end
    else
    begin
        subid := 0;
    end;
    if newpacket.size >= 5 then
    begin
        sub2id := word(newpacket.data[3] + newpacket.data[4] shl 8);
    end
    else
    begin
        sub2id := 0;
    end;

    isknown := GetPacketName(id, subid, sub2id, FromServer, pname, IsShow, hexid);
    if not isknown then
    begin
        AddToPacketFilterUnknown(FromServer, id, subid, sub2id, true, hexid);
    end;
    if IsShow then
    begin
        AddToListView5(math.ifthen(FromServer, 0, 1), Pname, PacketNumber, Id, subid, sub2id, not ToolButton5.Down, hexid, newpacket.size - 2);
    end;
end;

procedure TfVisual.ListView5Click(Sender : TObject);
var
    sid : integer;
begin
    if ListView5.SelCount = 1 then
    begin
        EnableBtns;
        sid := StrToIntDef(ListView5.Selected.SubItems.strings[0], 0);
        if GlobalSettings.isChangeParser then
        //java
        begin
            PacketView.InterpretatorJava(ListView5.Selected.Caption, Dump.Strings[sid]);
        end
        else
        begin
            PacketView.ParsePacket(ListView5.Selected.Caption, Dump.Strings[sid]);
        end;
    end;
end;

procedure TfVisual.ListView5CustomDrawItem(Sender : TCustomListView; Item : TListItem; State : TCustomDrawState; var DefaultDraw : boolean);
begin
    if item.ImageIndex = 0 then
    begin
        listview5.Canvas.Brush.Color := $ffeeee;
    end
    else
    begin
        listview5.Canvas.Brush.Color := $eeeeff;
    end;
end;

procedure TfVisual.ListView5KeyUp(Sender : TObject; var Key : word; Shift : TShiftState);
begin
    ListView5Click(Sender);
end;

procedure TfVisual.tbtnToSendClick(Sender : TObject);
begin
    if Memo4.Text <> '' then
    begin
        EachLinePacket.Down := true;
    end;

    Memo4.Lines.Add(PacketView.currentpacket);
end;

procedure TfVisual.ToolButton17Click(Sender : TObject);
begin
    PacketView.HexViewOffset := ToolButton17.Down;
    ListView5Click(self);
end;

// показать/спр€тать фильтр
procedure TfVisual.ToolButton6Click(Sender : TObject);
begin
    if fPacketFilter.Visible then
    begin
        fPacketFilter.Hide;
    end
    else
    begin
        fPacketFilter.Show;
    end;
end;

procedure TfVisual.tbtnSaveClick(Sender : TObject);
begin
  //ChDir(AppPath+'logs\');
    dlgSaveLog.InitialDir := AppPath + 'logs\';
    if dlgSaveLog.Execute then
    begin
        Dump.SaveToFile(dlgSaveLog.FileName);
    end;
  //ChDir(AppPath+'settings\');
end;

procedure TfVisual.SavePacketLog;
var
    SaveThis : TStringList;
    charname : string;
    i : integer;
begin
    try
        if not assigned(dump) then
        begin
            exit;
        end;

        if assigned(currenttunel) then
        begin
            if Ttunel(currenttunel).EncDec.Settings.isNoDecrypt then
            begin
                exit;
            end;
        end;

        if assigned(currentLSP) then
        begin
            if TlspConnection(currentLSP).EncDec.Settings.isNoDecrypt then
            begin
                exit;
            end;
        end;


        if BtnAutoSavePckts.Down then
        begin
            AddToLog(rsSavingPacketLog);
            SaveThis := TStringList.Create;
            SaveThis.Assign(dump);
        end;
        Dump.Clear;
        ListView5.Items.BeginUpdate;
        ListView5.Items.Clear;
        ListView5.Items.EndUpdate;

        if BtnAutoSavePckts.Down then
        begin
            if assigned(currenttunel) then
            begin
                charname := Ttunel(currenttunel).EncDec.CharName + ' ';
            end;

            if assigned(currentLSP) then
            begin
                charname := TlspConnection(currentLSP).EncDec.CharName + ' ';
            end;

            i := 1;
            while i <= Length(charname) do
            begin
                if pos(lowercase(charname[i]), 'qwertyuiopasdfghjklzxcvbnm1234567890.') > 0 then
                begin
                    inc(i);
                end
                else
                begin
                    delete(charname, i, 1);
                end;
            end;

            SaveThis.SaveToFile(pchar(ExtractFilePath(ParamStr(0))) + 'logs\' + charname + '[' + AddDateTime + '].pLog');
            SaveThis.Free;
        end;
    except
    end;
end;

{$warnings on}
procedure TfVisual.CloseConnectionClick(Sender : TObject);
begin
    if MessageDlg(lang.GetTextOrDefault('reallywant' (* 'Ёто действие закроет данный диалог и прервет текущее соединение' *)) + #10#13 + lang.GetTextOrDefault('reallywant2' (* 'если оно существует. ¬ы уверены ?' *)), mtWarning, [mbYes, mbNo], 0) = mrNo then
    begin
        exit;
    end;
    if assigned(currenttunel) then
    begin
        Ttunel(currenttunel).MustBeDestroyed := true;
    end;
    if Assigned(currentLSP) then
    begin
        TlspConnection(currentLSP).DisconnectAfterDestroy := true;
        TlspConnection(currentLSP).mustbedestroyed := true;
    end;
end;

procedure TfVisual.tbtnClearClick(Sender : TObject);
begin
    dump.Clear;
    ListView5.Clear;
end;

procedure TfVisual.tbtnFilterDelClick(Sender : TObject);
var
    PktStr : string;
    i, indx : integer;
    tmpItm : TListItem;
    from, id : byte;
    subid : word;
begin
    DisableBtns;
    tmpItm := ListView5.Selected;
    for i := 0 to ListView5.SelCount - 1 do
    begin
        PktStr := HexToString(Dump.Strings[StrToInt(tmpItm.SubItems.Strings[0])]);
        if Length(PktStr) < 12 then
        begin
            Exit;
        end;
        from := byte(PktStr[1]);   //клиент=4, сервер=3
        id := byte(PktStr[12]);   //фактическое начало пакета, ID
        SubId := word(id shl 8 + byte(PktStr[13])); //считываем SubId
        if from = 4 then
        begin
      //от клиента
            if ((GlobalProtocolVersion < CHRONICLE4)) then // дл€ јйон
            begin
                indx := PacketsFromC.IndexOfName(IntToHex(id, 2));
                if indx > -1 then
                begin
                    fPacketFilter.ListView2.Items.Item[indx].Checked := false;
                end;
            end
            else
            if (id in [$39, $D0]) then
            begin
          //находим индекс пакета
                indx := PacketsFromC.IndexOfName(IntToHex(subid, 4));
                if indx > -1 then
                begin
                    fPacketFilter.ListView2.Items.Item[indx].Checked := false;
                end;
            end
            else
            begin
                indx := PacketsFromC.IndexOfName(IntToHex(id, 2));
                if indx > -1 then
                begin
                    fPacketFilter.ListView2.Items.Item[indx].Checked := false;
                end;
            end;
        end
        else
        begin
      //от сервера
            if ((GlobalProtocolVersion < CHRONICLE4)) then // дл€ јйон
            begin
                indx := PacketsFromS.IndexOfName(IntToHex(id, 2));
                if indx > -1 then
                begin
                    fPacketFilter.ListView1.Items.Item[indx].Checked := false;
                end;
            end
            else
            if id = $FE then
            begin
          //находим индекс пакета
                indx := PacketsFromS.IndexOfName(IntToHex(subid, 4));
                if indx > -1 then
                begin
                    fPacketFilter.ListView1.Items.Item[indx].Checked := false;
                end;
            end
            else
            begin
                indx := PacketsFromS.IndexOfName(IntToHex(id, 2));
                if indx > -1 then
                begin
                    fPacketFilter.ListView1.Items.Item[indx].Checked := false;
                end;
            end;
        end;
        tmpItm := ListView5.GetNextItem(tmpItm, sdAll, [isSelected]);
    end;
    fPacketFilter.UpdateBtn.Click;
end;

procedure TfVisual.PacketListRefresh;
var
    i : integer;
    FromServer : boolean;
    Currentpacket : TPacket;
    str : string;
    pm : integer;
begin
    waitbar.Show;
  //расшифровываем лог пакетов
    DisableBtns;
    ListView5.Items.BeginUpdate;
    try
        if NeedLoadPackets then
        begin
            fPacketFilter.LoadPacketsIni;
        end;  //перечитываем packets.ini
        ListView5.Items.Clear;
        PacketView.rvDescryption.Clear;
        PacketView.rvHEX.Clear;
        ProgressBar1.Max := dump.Count;
        pm := 0;
        for i := 0 to Dump.Count - 1 do
        begin
            if pm < 50 then
            begin
                pm := 30;
                ProgressBar1.Position := i;
                Application.ProcessMessages;
            end;
            dec(pm);
      //смотрим второй байт в каждом пакете
            str := dump.Strings[i];
            if length(str) > 18 then
            begin
                FromServer := (str[2] = '3');
                Delete(str, 1, 18);
                HexToBin(@str[1], Currentpacket.PacketAsCharArray, round(Length(str) / 2));
                ProcessPacket(Currentpacket, FromServer, nil, i);
            end;
        end;
    finally
        ListView5.Items.EndUpdate;
        waitbar.Hide;
    end;
end;

procedure TfVisual.DisableBtns;
begin
    tbtnToSend.Enabled := false;
    tbtnFilterDel.Enabled := false;
    tbtnDelete.Enabled := false;
    n1.Enabled := false;
    N2.Enabled := false;
end;

procedure TfVisual.EnableBtns;
begin
    tbtnToSend.Enabled := true;
    tbtnFilterDel.Enabled := true;
    tbtnDelete.Enabled := true;
    n1.Enabled := true;
    N2.Enabled := true;
end;

procedure TfVisual.tbtnDeleteClick(Sender : TObject);
var
    i, k : integer;
    tmpItm : TListItem;
begin
    tmpItm := ListView5.Selected;
    for i := 1 to ListView5.SelCount do
    begin
        k := StrToInt(tmpItm.SubItems.Strings[0]) - i + 1;
        Dump.Delete(k);
        tmpItm := ListView5.GetNextItem(tmpItm, sdAll, [isSelected]);
    end;
    PacketListRefresh(false);
end;

procedure TfVisual.ToolButton4Click(Sender : TObject);
begin
    PacketListRefresh(false);
end;

procedure TfVisual.Memo4Change(Sender : TObject);
var
    i, k : integer;
    temp : string;
    p : TPoint;
    b : boolean;
begin
    p := Memo4.CaretPos;
    b := false;
    for k := 0 to Memo4.Lines.Count - 1 do
    begin
        temp := Memo4.Lines[k];
        for i := 1 to Length(temp) do
        begin
            if not (temp[i] in ['0'..'9', 'a'..'f', 'A'..'F', ' ']) then
            begin
                temp[i] := ' ';
                b := true;
            end;
        end;
        if b then
        begin
            Memo4.Lines[k] := temp;
        end;
    end;
    Memo4.CaretPos := p;
end;

procedure TfVisual.disableControls;
begin
    OpenBtn.Enabled := false;
    ToServer.Enabled := false;
    ToClient.Enabled := false;
end;

procedure TfVisual.enableControls;
begin
    OpenBtn.Enabled := true;
    ToServer.Enabled := true;
    ToClient.Enabled := true;
end;

procedure TfVisual.ToServerClick(Sender : TObject);
begin
    ToServer.Down := true;
    ToClient.Down := false;
    IDontknowHowToNameThis;
end;

procedure TfVisual.ToClientClick(Sender : TObject);
begin
    ToServer.Down := false;
    ToClient.Down := true;
    IDontknowHowToNameThis;
end;

procedure TfVisual.IDontknowHowToNameThis;
var
    PktStr : string;
    size : integer;
begin
    PktStr := Memo4.Lines[Memo4.CaretPos.Y];
    if PktStr = '' then
    begin
        exit;
    end;
    size := length(HexToString(PktStr)) + 2;
    if size = 2 then
    begin
        exit;
    end;
    if ToServer.Down then
    begin
        PktStr := '0400000000000000000000' + PktStr;
    end
    else
    begin
        PktStr := '0300000000000000000000' + PktStr;
    end;
    if GlobalSettings.isChangeParser then
    //java
    begin
        PacketView.InterpretatorJava('', PktStr, size);
    end
    else
    begin
        PacketView.ParsePacket('', PktStr, size);
    end;
end;

procedure TfVisual.Memo4KeyUp(Sender : TObject; var Key : word; Shift : TShiftState);
begin
    IDontknowHowToNameThis;
end;

procedure TfVisual.Memo4MouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : integer);
begin
    IDontknowHowToNameThis;
end;

procedure TfVisual.OpenBtnClick(Sender : TObject);
begin
  //ChDir(AppPath+'logs\');
    DlgOpenPacket.InitialDir := AppPath + 'logs\';
    if DlgOpenPacket.Execute then
    begin
        Memo4.Lines.LoadFromFile(DlgOpenPacket.FileName);
    end;
  //ChDir(AppPath+'settings\');
end;

procedure TfVisual.SaveBntClick(Sender : TObject);
begin
  //ChDir(AppPath+'logs\');
    DlgSavePacket.InitialDir := AppPath + 'logs\';
    if DlgSavePacket.Execute then
    begin
        Memo4.Lines.SaveToFile(DlgSavePacket.FileName);
    end;
  //ChDir(AppPath+'settings\');
end;

procedure TfVisual.SendByTimerClick(Sender : TObject);
begin
    timerSend.Enabled := SendByTimer.Down;
end;

procedure TfVisual.SendBtnClick(Sender : TObject);
var
    i : integer;
begin
    if not EachLinePacket.Down then
    begin
        sendThis(HexToString(Memo4.Lines.Text));
    end
    else
    begin
        i := 0;
        while i < Memo4.Lines.Count do
        begin
            sendThis(HexToString(Memo4.Lines.Strings[i]));
            inc(i);
        end;
    end;
end;

procedure TfVisual.sendThis(str : string);
var
    Packet : TPacket;
begin
    if Length(str) >= 1 then
    begin
        FillChar(Packet.PacketAsCharArray, $ffff, #0);
        Packet.Size := length(str) + 2;
        move(str[1], Packet.Data, Packet.Size - 2);

        if Assigned(currenttunel) then
        begin
            Ttunel(currenttunel).EncryptAndSend(Packet, ToServer.Down);
        end;
        if Assigned(currentLSP) then
        begin
            TlspConnection(currentLSP).encryptAndSend(Packet, ToServer.Down);
        end;
    end;
end;

procedure TfVisual.ToolButton30Click(Sender : TObject);
begin
    setNofreeBtns(ToolButton37.Down);

    if Assigned(currenttunel) then
    begin
        Ttunel(currenttunel).noFreeAfterDisconnect := ToolButton37.Down;
    end;
    if Assigned(currentLSP) then
    begin
        TlspConnection(currentLSP).noFreeAfterDisconnect := ToolButton37.Down;
    end;
end;

procedure TfVisual.setNofreeBtns(down : boolean);
begin
    ToolButton37.Down := down;
    ToolButton30.Down := down;
end;

procedure TfVisual.ThisOneDisconnected;
begin
    timerSend.Enabled := false;
    ToServer.Enabled := false;
    ToClient.Enabled := false;
    SendBtn.Enabled := false;
    timerSend.Enabled := false;
    JvSpinEdit2.Enabled := false;
    SendByTimer.Enabled := false;
    SendByTimer.Down := false;
    ToolButton37.Enabled := false;
    ToolButton30.Enabled := false;
    btnExecute.Enabled := false;
    btnTerminate.Click;
end;

procedure TfVisual.btnExecuteClick(Sender : TObject);
    procedure RunScript(Visual : TfVisual);
    begin
        try
            Visual.Edit.fsScript.Execute;
        finally
            Visual.btnTerminate.Enabled := false;
            Visual.btnExecute.Enabled := true;
        end;
    end;

begin
    dmData.RefreshPrecompile(Edit.fsScript);
    Edit.fsScript.Lines.Assign(Edit.Source.Lines);
    if dmData.Compile(Edit, fMain.StatusBar1) then
    begin
      //ƒелаем зелененькие пол€.
        Edit.Editor.LineStateDisplay.UnchangedColor := clLime;
        Edit.Editor.LineStateDisplay.NewColor := clLime;
        Edit.Editor.LineStateDisplay.SavedColor := clLime;
        Edit.Editor.Invalidate;

        if assigned(currenttunel) then
        begin
            Edit.fsScript.Variables['ConnectID'] := Ttunel(currenttunel).initserversocket;
            Edit.fsScript.Variables['ConnectName'] := Ttunel(currenttunel).EncDec.CharName;
        end
        else
        if assigned(currentLSP) then
        begin
            Edit.fsScript.Variables['ConnectID'] := TlspConnection(currentLSP).SocketNum;
            Edit.fsScript.Variables['ConnectName'] := TlspConnection(currentLSP).EncDec.CharName;
        end;

        btnExecute.Enabled := false;
        btnTerminate.Enabled := true;
        hScriptThread := BeginThread(nil, 0, @RunScript, Self, 0, idScriptThread);
    end;
end;

procedure TfVisual.btnRegRuleUpdateClick(Sender : TObject);
var
    i : integer;
    s : string;
begin
    PerlRegEx.RegEx := StringReplace(edtRegRule.Text, ' ', '', [rfReplaceAll]);
    waitbar.Visible := true;
    ProgressBar1.Max := dumpRegBuf.Count;
    dump.BeginUpdate;
    try
        dump.Clear;
        for i := 0 to dumpRegBuf.Count - 1 do
        begin
            s := dumpRegBuf[i];
            PerlRegEx.Subject := Copy(s, 23, Length(s));
            if PerlRegEx.Match then
            begin
                dump.Add(s);
            end;
            if (i mod 50 = 0) then
            begin
                ProgressBar1.Position := i;
            end;
        end;
    finally
        dump.EndUpdate;
        waitbar.Visible := false;
    end;
    PacketListRefresh(false);
end;

procedure TfVisual.btnTerminateClick(Sender : TObject);
begin
    Edit.fsScript.Terminate;
    TerminateThread(hScriptThread, 0);
    btnTerminate.Enabled := false;
    btnExecute.Enabled := true;
end;

procedure TfVisual.chkRegRuleClick(Sender : TObject);
begin
    btnRegRuleUpdate.Enabled := chkRegRule.Checked;
    if chkRegRule.Checked then
    begin
        dumpRegBuf.Assign(dump);
        PerlRegEx.RegEx := StringReplace(edtRegRule.Text, ' ', '', [rfReplaceAll]);
    end
    else
    begin
        dump.Assign(dumpRegBuf);
        PacketListRefresh(false);
    end;
end;

procedure TfVisual.ToolButton8Click(Sender : TObject);
begin
    TpacketLogWiev(CurrentTpacketLog).MustBeDestroyed := true;
end;

procedure TfVisual.PopupMenu1Popup(Sender : TObject);
begin
    if ListView5.SelCount = 1 then
    begin
    end;
end;

procedure TfVisual.ToolButton27Click(Sender : TObject);
begin
  //ChDir(AppPath+'scripts\');
    dlgOpenScript.InitialDir := AppPath + 'scripts\';
    if DlgOpenScript.Execute then
    begin
        Edit.Source.Lines.LoadFromFile(DlgOpenScript.FileName);
    end;
  //ChDir(AppPath+'settings\');
end;

procedure TfVisual.ToolButton25Click(Sender : TObject);
begin
  //ChDir(AppPath+'scripts\');
    DlgSaveScript.InitialDir := AppPath + 'scripts\';
    if dlgSaveScript.Execute then
    begin
        Edit.Source.Lines.SaveToFile(dlgSaveScript.FileName);
    end;
  //ChDir(AppPath+'settings\');
end;

procedure TfVisual.btnSaveRawClick(Sender : TObject);
var
    ms : TFileStream;
begin
  //ChDir(AppPath+'logs\');
    dlgSaveLogRaw.InitialDir := AppPath + 'logs\';
    if dlgSaveLogRaw.Execute then
    begin
        deletefile(dlgSaveLogRaw.FileName);
        ms := TFileStream.Create(dlgSaveLogRaw.FileName, fmOpenWrite or fmCreate);
        try
            ms.Position := 0;
            if assigned(currenttunel) then
            begin
                Ttunel(currenttunel).RawLog.Position := 0;
                ms.CopyFrom(Ttunel(currenttunel).RawLog, Ttunel(currenttunel).RawLog.Size);
                Ttunel(currenttunel).RawLog.Position := Ttunel(currenttunel).RawLog.Size;
            end
            else
            if Assigned(currentLSP) then
            begin
                TlspConnection(currentLSP).RawLog.Position := 0;
                ms.CopyFrom(TlspConnection(currentLSP).RawLog, TlspConnection(currentLSP).RawLog.Size);
                TlspConnection(currentLSP).RawLog.Position := TlspConnection(currentLSP).RawLog.Size;
            end;
        finally
            ms.Destroy;
        end;
    end;
  //ChDir(AppPath+'settings\');
end;

procedure TfVisual.FrameResize(Sender : TObject);
begin
    waitbar.Left := round((Self.Width - waitbar.Width) / 2);
    waitbar.Top := round((Self.Height - waitbar.Height) / 2);
end;

procedure TfVisual.AddPacketToAcum;
var
    TimeStep : TDateTime;
    TimeStepB : array [0..7] of byte;
    apendix : string;
    sLastPacket : string;
begin
    if newpacket.Size = 0 then
    begin
        exit;
    end;
  //на серве - апендикс 04, на клиент = 03
    if FromServer then
    begin
        apendix := '03';
    end
    else
    begin
        apendix := '04';
    end;

    TimeStep := now;
    Move(TimeStep, TimeStepB, 8);

    sLastPacket :=
        Apendix +
        ByteArrayToHex(TimeStepB, 8) +
        ByteArrayToHex(newpacket.PacketAsByteArray, newpacket.Size);

    dumpacumulator.Add(sLastPacket);
//  sendAction(TencDec_Action_LOG);
end;

procedure TfVisual.processpacketfromacum;
var
    packetnumber : integer;
    str : string;
    FromServer : boolean;
    Currentpacket : TPacket;
begin
    if not assigned(dumpacumulator) or not assigned(Dump) then
    begin
        exit;
    end;
    if not btnProcessPackets.Down then
    begin
        dumpacumulator.Clear;
        exit;
    end;

    while dumpacumulator.Count > 0 do
    begin
        if Dump.Count >= MaxLinesInPktLog then
        begin
            SavePacketLog;
        end;
        if dumpacumulator.Count = 0 then
        begin
            exit;
        end;

        PacketNumber := Dump.Count;
        str := dumpacumulator.Strings[0];
        dumpacumulator.Delete(0);

    // регул€рные выражени€
        if chkRegRule.Checked then
        begin
            dumpRegBuf.Add(str);
            PerlRegEx.Subject := Copy(str, 23, Length(str));
            if not PerlRegEx.Match then
            begin
                str := '';
            end;
        end;

        if length(str) >= 18 then
        begin
            dump.Add(str);
      //смотрим второй байт в каждом пакете
            FromServer := (str[2] = '3');
            Delete(str, 1, 18);
            HexToBin(@str[1], Currentpacket.PacketAsCharArray, round(Length(str) / 2));
            ProcessPacket(Currentpacket, FromServer, nil, packetnumber);
        end;
    end;
end;

procedure TfVisual.Translate;
begin
    Lang.Language := fMain.lang.Language;
    if assigned(PacketView) then
    begin
        PacketView.lang.Language := fMain.lang.Language;
    end;
end;

procedure TfVisual.ReloadThisClick(Sender : TObject);
begin
    Reload;
    PacketListRefresh(true);
end;

procedure TfVisual.TabSheet1Show(Sender : TObject);
begin
    if Splitter3 <> nil then
    begin
        Splitter3.Show;
    end;
    if packetVievPanel <> nil then
    begin
        packetVievPanel.Show;
    end;
    Splitter3.Left := 1;
end;

procedure TfVisual.TabSheet3Show(Sender : TObject);
begin
    packetVievPanel.Hide;
    Splitter3.Hide;
end;

procedure TfVisual.timerSendTimer(Sender : TObject);
begin
    if JvSpinEdit2.Value > 0 then
    begin
        timerSend.Interval := round((JvSpinEdit1.Value - JvSpinEdit2.Value) * 1000 + random(round(JvSpinEdit2.Value * 2000)));
    end;
    if timerSend.Interval <= 0 then
    begin
        timerSend.Interval := 100;
    end;

    SendBtnClick(self);
end;

procedure TfVisual.JvSpinEdit1Change(Sender : TObject);
begin
    timerSend.Interval := round(JvSpinEdit1.Value * 1000);
    JvSpinEdit2.MaxValue := timerSend.Interval - 0.1;
    if timerSend.Interval <= 0 then
    begin
        timerSend.Interval := 100;
    end;
end;

end.
