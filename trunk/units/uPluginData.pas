unit uPluginData;

interface

uses
    windows,
    classes,
    SysUtils,
    strutils,
    usharedstructs;

type
    TEnableFunc = (efOnPacket, efOnConnect, efOnDisconnect, efOnLoad, efOnFree,
        efOnCallMethod, efOnRefreshPrecompile);
    TEnableFuncs = set of TEnableFunc;

    TGetPluginInfo = function(const ver : longword) : pchar; stdcall;
  //TGetEnableFuncs = function: TEnableFuncs; stdcall;
    TSetStruct = function(const struct : PPluginStruct) : boolean; stdcall;
    TOnPacket = procedure(const ConnectId : integer; const fromServer : boolean; const connectionname : string; var packet : string); stdcall;
    TOnConnect = procedure(const ConnectId : integer; const withServer : boolean); stdcall;
    TOnDisconnect = TOnConnect;
    TOnLoad = procedure; stdcall;
    TOnFree = TOnLoad;
    TOnCallMethod = function(const ConnectId, ScriptId : integer; const MethodName : string; var Params, FuncResult : variant) : boolean; stdcall;
    TOnRefreshPrecompile = procedure; stdcall;

    TConnectInfo = class (tobject)
        ConnectionId : integer;
        ConnectionName : string;
    end;

    TPluginStructClass = class (TPluginStruct)
    private
        conNum : integer;
        function getconnectionscount : integer;
    public
        function ReadC(const pck : string; const index : integer) : byte; override;
        function ReadH(const pck : string; const index : integer) : word; override;
        function ReadD(const pck : string; const index : integer) : integer; override;
        function ReadQ(const pck : string; const index : integer) : int64; override;
        function ReadF(const pck : string; const index : integer) : double; override;
        function ReadS(const pck : string; const index : integer) : string; override;
        function ReadCEx(const pck; const index : integer) : byte; override;
        function ReadHEx(const pck; const index : integer) : word; override;
        function ReadDEx(const pck; const index : integer) : integer; override;
        function ReadQEx(const pck; const index : integer) : int64; override;
        function ReadFEx(const pck; const index : integer) : double; override;
        function ReadSEx(const pck; const index : integer) : string; override;
        procedure WriteC(var pck : string; const v : byte; ind : integer = -1); override;
        procedure WriteH(var pck : string; const v : word; ind : integer = -1); override;
        procedure WriteD(var pck : string; const v : integer; ind : integer = -1); override;
        procedure WriteQ(var pck : string; const v : int64; ind : integer = -1); override;
        procedure WriteF(var pck : string; const v : double; ind : integer = -1); override;
        procedure WriteS(var pck : string; const v : string; ind : integer = -1); override;
        procedure WriteCEx(var pck; const v : byte; ind : integer = -1); override;
        procedure WriteHEx(var pck; const v : word; ind : integer = -1); override;
        procedure WriteDEx(var pck; const v : integer; ind : integer = -1); override;
        procedure WriteQEx(var pck; const v : int64; ind : integer = -1); override;
        procedure WriteFEx(var pck; const v : double; ind : integer = -1); override;
        procedure WriteSEx(var pck; const v : string; ind : integer = -1); override;

        function SetScriptVariable(scriptid : integer; varname : string; varvalue : variant) : boolean; override;
        function GetScriptVariable(scriptid : integer; varname : string) : variant; override;
        function IsScriptIdValid(scriptid : integer) : boolean; override;
        function CallScriptFunction(scriptid : integer; Name : string; Params : variant; var error : string) : variant; override;


        function CreateAndRunTimerThread(const interval, usrParam : cardinal; const OnTimerProc : TOnTimer) : Pointer; override;
        procedure ChangeTimerThread(const timer : Pointer; const interval : cardinal; const usrParam : cardinal = $ffffffff; const OnTimerProc : TOnTimer = nil); override;
        procedure DestroyTimerThread(var timer : Pointer); override;
        function StringToHex(str1, Separator : string) : string; override;
        function HexToString(Hex : string) : string; override;
        function DataPckToStrPck(var pck) : string; override;
        procedure SendPacketData(var pck; const tid : integer; const ToServer : boolean); override;
        procedure SendPacketStr(pck : string; const tid : integer; const ToServer : boolean); override;
        procedure SendPacket(Size : word; pck : string; tid : integer; ToServer : boolean); override;


        function getConnectionName(id : integer) : string; override;
        function getConnectioidByName(name : string) : integer; override;

        function GoFirstConnection : boolean; override;
        function GoNextConnection : boolean; override;
        procedure ShowUserForm(ActivateOnly : boolean); override;
        procedure HideUserForm; override;
        constructor create;
        destructor Destroy; override;
    end;

    TPlugin = class (TObject)
    public
        FileName, Info : string;
        Loaded : boolean;
        hLib : cardinal;
        EnableFuncs : TEnableFuncs;
        GetPluginInfo : TGetPluginInfo;
    //GetEnableFuncs: TGetEnableFuncs;
        SetStruct : TSetStruct;
        OnPacket : TOnPacket;
        OnConnect : TOnConnect;
        OnDisconnect : TOnDisconnect;
        OnLoad : TOnLoad;
        OnFree : TOnFree;
        OnCallMethod : TOnCallMethod;
        OnRefreshPrecompile : TOnRefreshPrecompile;
        constructor Create;
        destructor Destroy; override;
        function LoadPlugin : boolean;
        function LoadInfo : boolean;
        procedure FreePlugin;
    end;

    TPlugThread = class (TThread)
    public
        OnTimer : TOnTimer;
        TimerInterval, UserParam : cardinal;
    protected
        procedure Execute; override;
    end;

var
    PluginStruct : TPluginStruct;
    Plugins : tlist;

implementation

uses
    fs_iinterpreter,
    uscripts,
    uglobalFuncs,
    uMain,
    uUserForm,
    udata,
    usocketengine,
    uencdec,
    Controls,
    Variants;

{ TPluginDataClass }


function TPluginStructClass.CallScriptFunction(scriptid : integer; Name : string; Params : variant; var error : string) : variant;
begin
    if IsScriptIdValid(scriptid) then
    begin
        try
            Result := TfsScript(scriptid).CallFunction(name, params);
        except
        end;
    end;
end;

procedure TPluginStructClass.ChangeTimerThread(const timer : Pointer; const interval, usrParam : cardinal; const OnTimerProc : TOnTimer);
begin
    with TPlugThread(timer) do
    begin
        TimerInterval := interval;
        if @OnTimerProc <> nil then
        begin
            OnTimer := OnTimerProc;
        end;
        if usrParam <> $ffffffff then
        begin
            UserParam := usrParam;
        end;
    end;
end;

constructor TPluginStructClass.create;
begin
    inherited;
    conNum := 0;
    userFormHandle := UserForm.Handle;
    UserFuncs := TStringList.Create;
end;

function TPluginStructClass.CreateAndRunTimerThread(const interval, usrParam : cardinal; const OnTimerProc : TOnTimer) : Pointer;
begin
    Result := TPlugThread.Create(true);
    with TPlugThread(Result) do
    begin
        FreeOnTerminate := true;
        Priority := tpLower;
        TimerInterval := interval;
        OnTimer := OnTimerProc;
        UserParam := usrParam;
        Resume;
    end;
end;

function TPluginStructClass.DataPckToStrPck(var pck) : string;
var
    tpck : packed record
        size : word;
        id : byte;
    end
    absolute pck;
begin
    SetLength(Result, tpck.size - 2);
    Move(tpck.id, Result[1], Length(Result));
end;

destructor TPluginStructClass.Destroy;
begin
    UserFuncs.Destroy;
    inherited;
end;

procedure TPluginStructClass.DestroyTimerThread(var timer : Pointer);
begin
    FreeAndNil(TPlugThread(timer));
end;

function TPluginStructClass.getConnectioidByName(name : string) : integer;
begin
    result := dmData.ConnectIdByName(name);
end;

function TPluginStructClass.getConnectionName(id : integer) : string;
begin
    result := dmData.ConnectNameById(id);
end;

function SymbolEntersCount(s : string) : string;
var
    i : integer;
begin
    Result := '';
    for i := 1 to Length(s) do
    begin
        if not (s[i] in [' ', #10, #13]) then
        begin
            Result := Result + s[i];
        end;
    end;
end;


function TPluginStructClass.getconnectionscount : integer;
var
    i : integer;
begin
    result := 0;
    i := 0;
    while i < LSPConnections.Count do
    begin
        if TlspConnection(LSPConnections.Items[i]).active then
        begin
            inc(result);
        end;
        inc(i);
    end;

    i := 0;
    while i < sockEngine.tunels.Count do
    begin
        if Ttunel(sockEngine.tunels.Items[i]).active then
        begin
            inc(result);
        end;
        inc(i);
    end;

end;

function TPluginStructClass.GetScriptVariable(scriptid : integer; varname : string) : variant;
begin
    try
        result := TfsScript(scriptid).Variables[varname];
    except
        result := Null;
    end;
end;

function TPluginStructClass.GoFirstConnection : boolean;
var
    i : integer;
begin
    if getconnectionscount = 0 then
    begin
        Result := false;
        Exit;
    end;
    Result := true;
    conNum := 0;
    i := 0;
    while i < LSPConnections.Count do
    begin
        if TlspConnection(LSPConnections.Items[i]).active then
        begin
            ConnectInfo.ConnectID := TlspConnection(LSPConnections.Items[i]).SocketNum;
            ConnectInfo.ConnectName := TlspConnection(LSPConnections.Items[i]).EncDec.CharName;
            exit;
        end;
        inc(i);
    end;


    i := 0;
    while i < sockEngine.tunels.Count do
    begin
        if Ttunel(sockEngine.tunels.Items[i]).active then
        begin
            ConnectInfo.ConnectID := Ttunel(sockEngine.tunels.Items[i]).initserversocket;
            ConnectInfo.ConnectName := Ttunel(sockEngine.tunels.Items[i]).EncDec.CharName;
            exit;
        end;
        inc(i);
    end;
end;

function TPluginStructClass.GoNextConnection : boolean;
var
    i : integer;
    index : integer;
begin
    Inc(conNum);
    if getconnectionscount <= conNum then
    begin
        Result := false;
        Exit;
    end;
    Result := true;
    index := 0;
    i := 0;
    while i < LSPConnections.Count do
    begin
        if (index = conNum) and TlspConnection(LSPConnections.Items[i]).active then
        begin
            ConnectInfo.ConnectID := TlspConnection(LSPConnections.Items[i]).SocketNum;
            ConnectInfo.ConnectName := TlspConnection(LSPConnections.Items[i]).EncDec.CharName;
            exit;
        end;
        if TlspConnection(LSPConnections.Items[i]).active then
        begin
            inc(index);
        end;
        inc(i);
    end;


    i := 0;
    while i < sockEngine.tunels.Count do
    begin
        if (index = conNum) and Ttunel(sockEngine.tunels.Items[i]).active then
        begin
            ConnectInfo.ConnectID := Ttunel(sockEngine.tunels.Items[i]).initserversocket;
            ConnectInfo.ConnectName := Ttunel(sockEngine.tunels.Items[i]).EncDec.CharName;
            exit;
        end;
        if Ttunel(sockEngine.tunels.Items[i]).active then
        begin
            inc(index);
        end;
        inc(i);
    end;
end;

function TPluginStructClass.HexToString(Hex : string) : string;
var
    buf : string;
    bt : byte;
    i : integer;
begin
    buf := '';
    Hex := SymbolEntersCount(UpperCase(Hex));
    for i := 0 to (Length(Hex) div 2) - 1 do
    begin
        bt := 0;
        if (byte(hex[i * 2 + 1]) > $2F) and (byte(hex[i * 2 + 1]) < $3A) then
        begin
            bt := byte(hex[i * 2 + 1]) - $30;
        end;
        if (byte(hex[i * 2 + 1]) > $40) and (byte(hex[i * 2 + 1]) < $47) then
        begin
            bt := byte(hex[i * 2 + 1]) - $37;
        end;
        if (byte(hex[i * 2 + 2]) > $2F) and (byte(hex[i * 2 + 2]) < $3A) then
        begin
            bt := bt * 16 + byte(hex[i * 2 + 2]) - $30;
        end;
        if (byte(hex[i * 2 + 2]) > $40) and (byte(hex[i * 2 + 2]) < $47) then
        begin
            bt := bt * 16 + byte(hex[i * 2 + 2]) - $37;
        end;
        buf := buf + char(bt);
    end;
    Result := buf;
end;

procedure TPluginStructClass.HideUserForm;
begin
    UserForm.Hide;
    fMain.nUserFormShow.Enabled := false;
end;

function TPluginStructClass.IsScriptIdValid(scriptid : integer) : boolean;
begin
    try
        Result := TfScript(scriptid).ClassName = 'TfsScript'
    except
        result := false;
    end;
end;

function TPluginStructClass.ReadC;
begin
    Result := 0;
    if index > Length(pck) then
    begin
        Exit;
    end;
    Result := byte(pck[index]);
end;

function TPluginStructClass.ReadCEx;
begin
    Result := 0;
    if index >= PWord(@pck)^ then
    begin
        Exit;
    end;
    Result := PByteArray(@pck)^[index];
end;

function TPluginStructClass.ReadD(const pck : string; const index : integer) : integer;
begin
    Result := 0;
    if index + 3 > Length(pck) then
    begin
        Exit;
    end;
    Move(pck[index], Result, 4);
end;

function TPluginStructClass.ReadDEx;
begin
    Result := 0;
    if index + 3 >= PWord(@pck)^ then
    begin
        Exit;
    end;
    Move(PByteArray(@pck)^[index], Result, 4);
end;

function TPluginStructClass.ReadF(const pck : string; const index : integer) : double;
begin
    Result := 0;
    if index + 7 > Length(pck) then
    begin
        Exit;
    end;
    Move(pck[index], Result, 8);
end;

function TPluginStructClass.ReadFEx;
begin
    Result := 0;
    if index + 7 >= PWord(@pck)^ then
    begin
        Exit;
    end;
    Move(PByteArray(@pck)^[index], Result, 8);
end;

function TPluginStructClass.ReadH;
begin
    Result := 0;
    if index + 1 > Length(pck) then
    begin
        Exit;
    end;
    Move(pck[index], Result, 2);
end;

function TPluginStructClass.ReadHEx;
begin
    Result := 0;
    if index + 1 >= PWord(@pck)^ then
    begin
        Exit;
    end;
    Move(PByteArray(@pck)^[index], Result, 2);
end;

function TPluginStructClass.ReadQ;
begin
    Result := 0;
    if index + 7 > Length(pck) then
    begin
        Exit;
    end;
    Move(pck[index], Result, 8);
end;

function TPluginStructClass.ReadQEx;
begin
    Result := 0;
    if index + 7 >= PWord(@pck)^ then
    begin
        Exit;
    end;
    Move(PByteArray(@pck)^[index], Result, 8);
end;

function TPluginStructClass.ReadS;
var
    temp : widestring;
    d : integer;
begin
    d := PosEx(#0#0, pck, index) - index;
    if (d mod 2) = 1 then
    begin
        Inc(d);
    end;
    SetLength(temp, d div 2);
    if d >= 2 then
    begin
        Move(pck[index], temp[1], d);
    end;
    Result := temp;
end;

function TPluginStructClass.ReadSEx;
var
    temp : widestring;
    i, d : integer;
begin
    i := index;
    while not ((PByteArray(@pck)^[i] = 0) and (PByteArray(@pck)^[i + 1] = 0)) and (PWord(@pck)^ > i + 1) do
    begin
        Inc(i, 2);
    end;
    d := i - index;
    SetLength(temp, d div 2);
    if d >= 2 then
    begin
        Move(PByteArray(@pck)^[index], temp[1], d);
    end;
    Result := temp;
end;

procedure TPluginStructClass.SendPacket(Size : word; pck : string; tid : integer; ToServer : boolean);
var
    packet : TPacket;
begin
    FillChar(packet.PacketAsCharArray, $ffff, #0);
    packet.Size := size;
    Move(pck[1], packet.data[0], length(pck));
    dmData.SendPacket(packet, tid, ToServer);
end;

procedure TPluginStructClass.SendPacketData(var pck; const tid : integer; const ToServer : boolean);
var
    tpck : packed record
        size : word;
        id : byte;
    end
    absolute pck;
    spck : string;
begin
    SetLength(spck, tpck.size - 2);
    Move(tpck.id, spck[1], Length(spck));
    SendPacket(tpck.size, spck, tid, ToServer);
end;

procedure TPluginStructClass.SendPacketStr(pck : string; const tid : integer; const ToServer : boolean);
begin
    SendPacket(Length(pck) + 2, pck, tid, ToServer);
end;

function TPluginStructClass.SetScriptVariable(scriptid : integer; varname : string; varvalue : variant) : boolean;
begin
    try
        TfsScript(scriptid).Variables[varname] := varvalue;
        result := true;
    except
        result := false;
    end;
end;

procedure TPluginStructClass.ShowUserForm(ActivateOnly : boolean);
begin
    if not ActivateOnly then
    begin
        UserForm.show;
    end;
    fMain.nUserFormShow.Enabled := true;
end;

function TPluginStructClass.StringToHex(str1, Separator : string) : string;
var
    buf : string;
    i : integer;
begin
    buf := '';
    for i := 1 to Length(str1) do
    begin
        buf := buf + IntToHex(byte(str1[i]), 2) + Separator;
    end;
    Result := buf;
end;

procedure TPluginStructClass.WriteC(var pck : string; const v : byte; ind : integer);
const
    dt_size = 1;
begin
    if ind = -1 then
    begin
        ind := Length(pck) + 1;
    end;
    if ind + dt_size - 1 > Length(pck) then
    begin
        SetLength(pck, ind + dt_size - 1);
    end;
    Move(v, pck[ind], dt_size);
end;

procedure TPluginStructClass.WriteCEx(var pck; const v : byte; ind : integer);
const
    dt_size = 1;
begin
    if ind = -1 then
    begin
        ind := PWord(@pck)^;
    end;
    if ind + dt_size > PWord(@pck)^ then
    begin
        PWord(@pck)^ := ind + dt_size;
    end;
    Move(v, PByteArray(@pck)^[ind], dt_size);
end;

procedure TPluginStructClass.WriteD(var pck : string; const v : integer; ind : integer);
const
    dt_size = 4;
begin
    if ind = -1 then
    begin
        ind := Length(pck) + 1;
    end;
    if ind + dt_size - 1 > Length(pck) then
    begin
        SetLength(pck, ind + dt_size - 1);
    end;
    Move(v, pck[ind], dt_size);
end;

procedure TPluginStructClass.WriteDEx(var pck; const v : integer; ind : integer);
const
    dt_size = 4;
begin
    if ind = -1 then
    begin
        ind := PWord(@pck)^;
    end;
    if ind + dt_size > PWord(@pck)^ then
    begin
        PWord(@pck)^ := ind + dt_size;
    end;
    Move(v, PByteArray(@pck)^[ind], dt_size);
end;

procedure TPluginStructClass.WriteF(var pck : string; const v : double; ind : integer);
const
    dt_size = 8;
begin
    if ind = -1 then
    begin
        ind := Length(pck) + 1;
    end;
    if ind + dt_size - 1 > Length(pck) then
    begin
        SetLength(pck, ind + dt_size - 1);
    end;
    Move(v, pck[ind], dt_size);
end;

procedure TPluginStructClass.WriteFEx(var pck; const v : double; ind : integer);
const
    dt_size = 8;
begin
    if ind = -1 then
    begin
        ind := PWord(@pck)^;
    end;
    if ind + dt_size > PWord(@pck)^ then
    begin
        PWord(@pck)^ := ind + dt_size;
    end;
    Move(v, PByteArray(@pck)^[ind], dt_size);
end;

procedure TPluginStructClass.WriteH(var pck : string; const v : word; ind : integer);
const
    dt_size = 2;
begin
    if ind = -1 then
    begin
        ind := Length(pck) + 1;
    end;
    if ind + dt_size - 1 > Length(pck) then
    begin
        SetLength(pck, ind + dt_size - 1);
    end;
    Move(v, pck[ind], dt_size);
end;

procedure TPluginStructClass.WriteHEx(var pck; const v : word; ind : integer);
const
    dt_size = 2;
begin
    if ind = -1 then
    begin
        ind := PWord(@pck)^;
    end;
    if ind + dt_size > PWord(@pck)^ then
    begin
        PWord(@pck)^ := ind + dt_size;
    end;
    Move(v, PByteArray(@pck)^[ind], dt_size);
end;

procedure TPluginStructClass.WriteQ(var pck : string; const v : int64; ind : integer);
const
    dt_size = 8;
begin
    if ind = -1 then
    begin
        ind := Length(pck) + 1;
    end;
    if ind + dt_size - 1 > Length(pck) then
    begin
        SetLength(pck, ind + dt_size - 1);
    end;
    Move(v, pck[ind], dt_size);
end;

procedure TPluginStructClass.WriteQEx(var pck; const v : int64; ind : integer);
const
    dt_size = 8;
begin
    if ind = -1 then
    begin
        ind := PWord(@pck)^;
    end;
    if ind + dt_size > PWord(@pck)^ then
    begin
        PWord(@pck)^ := ind + dt_size;
    end;
    Move(v, PByteArray(@pck)^[ind], dt_size);
end;

procedure TPluginStructClass.WriteS(var pck : string; const v : string; ind : integer);
var
    temp : widestring;
    dt_size : word;
begin
    dt_size := Length(v) * 2 + 2;
    temp := v + #0;
    if ind = -1 then
    begin
        ind := Length(pck) + 1;
    end;
    if ind + dt_size - 1 > Length(pck) then
    begin
        SetLength(pck, ind + dt_size - 1);
    end;
    Move(temp[1], pck[ind], dt_size);
end;

procedure TPluginStructClass.WriteSEx(var pck; const v : string; ind : integer);
var
    temp : widestring;
    dt_size : word;
begin
    dt_size := Length(v) * 2 + 2;
    temp := v + #0;
    if ind = -1 then
    begin
        ind := PWord(@pck)^;
    end;
    if ind + dt_size > PWord(@pck)^ then
    begin
        PWord(@pck)^ := ind + dt_size;
    end;
    Move(temp[1], PByteArray(@pck)^[ind], dt_size);
end;


{ TPlugin }


constructor TPlugin.Create;
begin
    plugins.Add(self);
    Loaded := false;
    EnableFuncs := [];
end;

destructor TPlugin.Destroy;
var
    i : integer;
begin
    i := 0;
    while i < Plugins.Count do
    begin
        if TPlugin(Plugins.Items[i]) = self then
        begin
            Plugins.Delete(i);
            break;
        end;

        inc(i);
    end;


    if Loaded then
    begin
        if Assigned(OnFree) then
        begin
            OnFree;
        end;
        FreeLibrary(hLib);
    end;
    inherited;
end;

procedure TPlugin.FreePlugin;
begin
    if Loaded then
    begin
        if Assigned(OnFree) then
        begin
            OnFree;
        end;
        FreeLibrary(hLib);
    end;
    EnableFuncs := [];
    Loaded := false;
end;

function TPlugin.LoadInfo : boolean;
begin
    Result := false;
    hLib := LoadLibrary(pchar(FileName));
    if hLib = 0 then
    begin
        exit;
    end;
    @GetPluginInfo := GetProcAddress(hLib, 'GetPluginInfo');

    if (not Assigned(@GetPluginInfo)) then
    begin
        Exit;
    end;

    Info := string(GetPluginInfo(l2pxversion));
    @OnPacket := GetProcAddress(hLib, 'OnPacket');
    @OnConnect := GetProcAddress(hLib, 'OnConnect');
    @OnDisconnect := GetProcAddress(hLib, 'OnDisconnect');
    @OnLoad := GetProcAddress(hLib, 'OnLoad');
    @OnFree := GetProcAddress(hLib, 'OnFree');
    @OnCallMethod := GetProcAddress(hLib, 'OnCallMethod');
    @OnRefreshPrecompile := GetProcAddress(hLib, 'OnRefreshPrecompile');

    EnableFuncs := [];
    if Assigned(@OnPacket) then
    begin
        EnableFuncs := EnableFuncs + [efOnPacket];
    end;
    if Assigned(@OnConnect) then
    begin
        EnableFuncs := EnableFuncs + [efOnConnect];
    end;
    if Assigned(@OnDisconnect) then
    begin
        EnableFuncs := EnableFuncs + [efOnDisconnect];
    end;
    if Assigned(@OnLoad) then
    begin
        EnableFuncs := EnableFuncs + [efOnLoad];
    end;
    if Assigned(@OnFree) then
    begin
        EnableFuncs := EnableFuncs + [efOnFree];
    end;
    if Assigned(@OnCallMethod) then
    begin
        EnableFuncs := EnableFuncs + [efOnCallMethod];
    end;
    if Assigned(@OnRefreshPrecompile) then
    begin
        EnableFuncs := EnableFuncs + [efOnRefreshPrecompile];
    end;

    FreeLibrary(hLib);

    Result := true;
end;

function TPlugin.LoadPlugin : boolean;
begin
    hLib := LoadLibrary(pchar(FileName));
    Loaded := hLib <> 0;
    Result := false;
    try
        if not Loaded then
        begin
            exit;
        end;
        @GetPluginInfo := GetProcAddress(hLib, 'GetPluginInfo');
        @SetStruct := GetProcAddress(hLib, 'SetStruct');

        if (not Assigned(GetPluginInfo)) or (not Assigned(SetStruct)) or (not SetStruct(@PluginStruct)) then
        begin
            FreePlugin;
            Exit;
        end;

        Info := string(GetPluginInfo(l2pxversion));
        EnableFuncs := [];
        @OnPacket := GetProcAddress(hLib, 'OnPacket');
        @OnConnect := GetProcAddress(hLib, 'OnConnect');
        @OnDisconnect := GetProcAddress(hLib, 'OnDisconnect');
        @OnLoad := GetProcAddress(hLib, 'OnLoad');
        @OnFree := GetProcAddress(hLib, 'OnFree');
        @OnCallMethod := GetProcAddress(hLib, 'OnCallMethod');
        @OnRefreshPrecompile := GetProcAddress(hLib, 'OnRefreshPrecompile');

        if Assigned(@OnPacket) then
        begin
            EnableFuncs := EnableFuncs + [efOnPacket];
        end;
        if Assigned(@OnConnect) then
        begin
            EnableFuncs := EnableFuncs + [efOnConnect];
        end;
        if Assigned(@OnDisconnect) then
        begin
            EnableFuncs := EnableFuncs + [efOnDisconnect];
        end;
        if Assigned(@OnLoad) then
        begin
            EnableFuncs := EnableFuncs + [efOnLoad];
            OnLoad;
        end;
        if Assigned(@OnFree) then
        begin
            EnableFuncs := EnableFuncs + [efOnFree];
        end;
        if Assigned(@OnCallMethod) then
        begin
            EnableFuncs := EnableFuncs + [efOnCallMethod];
        end;
        if Assigned(@OnRefreshPrecompile) then
        begin
            EnableFuncs := EnableFuncs + [efOnRefreshPrecompile];
        end;

        Result := true;
    finally
        Loaded := Result;
    end;
end;

{ TPlugThread }

procedure TPlugThread.Execute;
begin
    repeat
        Sleep(TimerInterval);
        OnTimer(UserParam);
    until TimerInterval = 0;
end;

end.
