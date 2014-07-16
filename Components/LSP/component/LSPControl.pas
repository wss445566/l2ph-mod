unit LSPControl;

interface

uses
    LSPInstalation,
    LSPStructures,
    windows,
    messages,
    sysutils,
    Classes,
    SyncObjs;

const
    LSP_Install_success = 1;
    LSP_Already_installed = 2;
    LSP_Uninstall_success = 3;
    LSP_Not_installed = 4;
    LSP_Install_error = 5;
    LSP_UnInstall_error = 6;
    LSP_Install_error_badspipath = 7;


type
    tOnSendOrRecv = procedure(const inStruct : TSendRecvStruct; var OutStruct : TSendRecvStruct) of object;
    tOnConnect = procedure(var Struct : TConnectStruct; var hook : boolean) of object;
    tOnDisconnect = procedure(var Struct : TDisconnectStruct) of object;
    tLspModuleState = procedure(state : byte) of object;

    TLSPModuleControl = class (TComponent)
    private
        fOnRecv, fOnSend : tOnSendOrRecv;
        fOnConnect : tOnConnect;
        fOnDisconnect : tOnDisconnect;
        fPathToLspModule : string;
        fLookFor : string;
        fonLspModuleState : tLspModuleState;
        fWasStarted : boolean; //true - Было стартовано успешно, можно освобождать.
        ShareClient : array[0..255] of TConnectStruct;
        ClientCount : integer;
        ShareMain : TshareMain;

        ReciverMEssageProcessThreadId : DWORD;
        ReciverMEssageProcessThreadHandle : THandle;
        ReciverWndClass : TWndClassEx; //окошко, через которое основное приложение нас будет уведомлять о новых данных... точнее класс окна.
        MutexHandle : THandle;

        function FindIndexBySocketNum(SocketNum : integer) : integer;
        function CreateReciverWnd : Thandle;
        procedure addclient(Wparam : integer);
        procedure deleteclient(Wparam : integer);
        procedure clientsend(Wparam : integer);
        procedure clientrecv(Wparam : integer);
        procedure setlookfor(newLookFor : string);
        function isLspinstalled : boolean;
    public
        function SendToServer(Struct : TSendRecvStruct) : boolean;
        function SendToClient(Struct : TSendRecvStruct) : boolean;
        procedure CloseSocket(SockNum : integer);
        procedure setlspstate(state : boolean);

    published
        property WasStarted : boolean read fWasStarted;
        property PathToLspModule : string read fPathToLspModule write fPathToLspModule;
        property isLspModuleInstalled : boolean read islspinstalled;

        property LookFor : string read fLookFor write setlookfor;
        property onLspModuleState : tLspModuleState read fonLspModuleState write fonLspModuleState;
        property onConnect : tOnConnect read fOnConnect write fOnConnect;
        property onDisconnect : tOnDisconnect read fOnDisconnect write fOnDisconnect;
        property onRecv : tOnSendOrRecv read fOnRecv write fOnRecv;
        property onSend : tOnSendOrRecv read fOnSend write fOnSend;
        constructor Create(AOwner : TComponent); override;
        destructor Destroy; override;
    end;


var
    this_component : TLSPModuleControl;
    cs : RTL_CRITICAL_SECTION;
    Mmsg : MSG;  //сообщение

procedure Register;

implementation


procedure Register;
begin
    RegisterComponents('LSP', [TLSPModuleControl]);
end;


// Процедура обработки сообщений
function WindowProc(wnd : HWND; msg : integer; wparam : WPARAM; lparam : LPARAM) : LRESULT; stdcall;
begin

    result := 0;
    case msg of
        WM_action :
        begin
            case lparam of
                Action_client_connect :
                begin
                    this_component.addclient(wparam);
                end;
                Action_client_disconnect :
                begin
                    this_component.deleteclient(wparam);
                end;
                Action_client_send :
                begin
                    this_component.clientsend(wparam);
                end;
                Action_client_recv :
                begin
                    this_component.clientrecv(wparam);
                end;
            end;

        end;
    else
    begin
        Result := DefWindowProc(wnd, msg, wparam, lparam);
    end;
    end;
end;


procedure pReciverMessageProcess;
begin
  // Цикл обработки сообщений}
    while GetMessage(Mmsg, 0, 0, 0) do
    begin
        TranslateMessage(Mmsg);
        DispatchMessage(Mmsg);
    end;
end;

function TLSPModuleControl.CreateReciverWnd;
begin
 //Вот тут мы создаем окошко.
    ReciverWndClass.cbSize := sizeof(ReciverWndClass);
    with ReciverWndClass do
    begin
        lpfnWndProc := @WindowProc;
        cbClsExtra := 0;
        cbWndExtra := 0;
        hInstance := HInstance;
        lpszMenuName := nil;
        lpszClassName := Apendix;
    end;
    RegisterClassEx(ReciverWndClass);
  // Создание окна на основе созданного класса
    result := CreateWindowEx(0, Apendix, Apendix, WS_OVERLAPPEDWINDOW, 0, 0, 0, 0, 0, 0, Hinstance, nil);
end;

constructor TLSPModuleControl.create;
begin
    inherited Create(AOwner);
    fWasStarted := false; //мы еще не стартовали.
    if csDesigning in self.ComponentState then
    begin
        exit;
    end;
    InitializeCriticalSection(cs);
    EnterCriticalSection(cs);
  //создаем мютекс говорящий всем нашим клиентам что основное приложение - работает.
    MutexHandle := CreateMutex(nil, false, Mutexname);

    if (GetLastError = ERROR_ALREADY_EXISTS) then
    begin
      //Мы уже существуем....
        LeaveCriticalSection(cs);
        MessageBox(0, 'Другой экземпляр TLSPModuleControl уже существует.'#10#13 +
            'новый экземляр не может быть создан.', 'TLSPModuleControl', MB_OK);
        exit;
    end;

    ClientCount := 0;//изначально считается что у нас ноль клиентов

  //Создаем мапфайл.
    ShareMain.MapHandle := CreateFileMapping(INVALID_HANDLE_VALUE, nil,
        PAGE_READWRITE, 0, SizeOf(TShareMapMain), Apendix);
    if ShareMain.MapHandle = 0 then
    begin
        ShareMain.MapHandle := OpenFileMapping(PAGE_READWRITE, false, Apendix);
    end;
    ShareMain.MapData := MapViewOfFile(ShareMain.MapHandle, FILE_MAP_ALL_ACCESS,
        0, 0, SizeOf(TShareMapMain));

    if ShareMain.MapHandle = 0 then
    begin
        setlspstate(false);
        MessageBox(0, 'Невозможно получить доступ к общему участку памяти.'#10#13 +
            'Регистрация LSP провайдера автоматически снята'#10#13 +
            'Перезагрузите машину.', 'TLSPModuleControl', MB_OK);
        exit;
    end;
  //Создаем приемник.
    ShareMain.MapData^.ReciverHandle := CreateReciverWnd;

  //Создаем Поток, который будет обрабатывать сообщения от приемника
    ReciverMessageProcessThreadHandle := CreateThread(nil, 0, @pReciverMessageProcess, nil, 0, ReciverMEssageProcessThreadId);
    ResumeThread(ReciverMEssageProcessThreadHandle);

  //Указываем в каких приложениях стоит перехватывать
    ShareMain.MapData^.ProcessesForHook := flookfor;
    fWasStarted := true; //Мы стартовали успешно.
    LeaveCriticalSection(cs);
    this_component := self;
end;

destructor TLSPModuleControl.destroy;
begin
    if WasStarted then
    begin
        ReleaseMutex(MutexHandle); //жгем напалмом. (мы уже не работаем).
        CloseHandle(MutexHandle);
        TerminateThread(ReciverMEssageProcessThreadHandle, 0); //Рубаем нить с обработкой сообщений
        DestroyWindow(ShareMain.MapData^.ReciverHandle); //убиваем окно рецивера
        ShareMain.MapData^.ReciverHandle := 0;
        windows.UnregisterClass(apendix, HInstance);
    end;
    inherited destroy;
end;


procedure TLSPModuleControl.addclient;
var
    Membuf : PTMemoryBuffer;
    MemHandle : thandle;
begin
    memHandle := CreateFileMapping(INVALID_HANDLE_VALUE, nil,
        PAGE_READWRITE, 0, SizeOf(TMemoryBuffer), pchar(Apendix + inttostr(wparam))); { TODO : ТУТ МОЖЕТ БЫТЬ РАНДОМНОЕ НАЗВАНИЕ }
    Membuf := MapViewOfFile(memHandle, FILE_MAP_ALL_ACCESS,
        0, 0, SizeOf(TMemoryBuffer));
    CloseHandle(memHandle);


    Membuf^.ConnectStruct.HookIt := true;
    if assigned(onConnect) then
    begin
        onConnect(Membuf^.ConnectStruct, Membuf^.ConnectStruct.HookIt);
    end;
  //надо ловить этот конект ?
    if Membuf^.ConnectStruct.HookIt then
    begin
    //если да - заполняем и увеличиваем кол--во юзверей на 1.
    //Идентификатор
        ShareClient[ClientCount].HookIt := true; //непонятно зачем -) но пусть будет
        ShareClient[ClientCount].ReciverHandle := Membuf^.ConnectStruct.ReciverHandle;
        ShareClient[ClientCount].SockNum := Membuf^.ConnectStruct.SockNum;
        ShareClient[ClientCount].ip := Membuf^.ConnectStruct.ip;
        ShareClient[ClientCount].port := Membuf^.ConnectStruct.port;
        ShareClient[ClientCount].application := Membuf^.ConnectStruct.application;
        ShareClient[ClientCount].pid := Membuf^.ConnectStruct.pid;    //увеличиваем кол-во юзверей на 1.
        ShareClient[ClientCount].MemBuf := Membuf;
        ShareClient[ClientCount].MemBufHandle := MemHandle;
        Inc(ClientCount);
    end
    else //не надо ? затираем ссылку на мапфайл. хендл и сокетнум.
    begin
        ShareClient[ClientCount].SockNum := 0;
    end;
end;

procedure TLSPModuleControl.deleteclient;
var
    i : integer;
begin
    i := 0;
  //бежим пока не находим наш sockid; или не находим -)
    while (i < ClientCount) and (ShareClient[i].SockNum <> Wparam) do
    begin
        inc(i);
    end;

    if i = ClientCount then //не нашли -)... чертовщина какаято.. -)
    begin
        exit;
    end;

    if assigned(onDisconnect) then
    begin
        onDisconnect(ShareClient[i].MemBuf^.DisconnectStruct);
    end;

  //Ставим позицию чуть чуть дальше
    inc(i);

  //и затираем наш отключившийся клиент.
    while i < ClientCount do
    begin
        ShareClient[i - 1] := ShareClient[i];
        inc(i);
    end;


  // -1 пользователь
    Dec(ClientCount);
end;

function TLSPModuleControl.FindIndexBySocketNum;
begin
    result := 0;
  //бежим пока не находим наш sockid; или не находим -)
    while (result < ClientCount) and (ShareClient[result].SockNum <> SocketNum) do
    begin
        inc(result);
    end;

    if Result = ClientCount then
    begin
        Result := -1;
    end;

end;

procedure TLSPModuleControl.clientrecv;
var
    index : integer;
begin
    index := FindIndexBySocketNum(Wparam);
    if Assigned(onRecv) and (index >= 0) then
    begin
        onRecv(ShareClient[index].MemBuf^.RecvStruct, ShareClient[index].MemBuf^.RecvProcessed);
    end
    else
    begin
        ShareClient[index].MemBuf^.RecvProcessed := ShareClient[index].MemBuf^.RecvStruct;
    end;
    ShareClient[index].MemBuf^.RecvStruct.CurrentSize := 0;
    fillchar(ShareClient[index].MemBuf^.RecvStruct.CurrentBuff[0], $ffff, #0);
end;

procedure TLSPModuleControl.clientsend;
var
    index : integer;
begin
    index := FindIndexBySocketNum(wparam);
    if Assigned(onSend) and (index >= 0) then
    begin
        onSend(ShareClient[index].MemBuf^.SendStruct, ShareClient[index].MemBuf^.SendProcessed);
    end
    else
    begin
        ShareClient[index].MemBuf^.SendProcessed := ShareClient[index].MemBuf^.SendStruct;
    end;

    ShareClient[index].MemBuf^.SendStruct.CurrentSize := 0;
    fillchar(ShareClient[index].MemBuf^.SendStruct.CurrentBuff[0], $ffff, #0);
end;

//Отправляем данные от имени клиента использующего указаный номер сокета
function TLSPModuleControl.SendToServer;
var
    index : integer;
begin
    index := FindIndexBySocketNum(Struct.SockNum);
    Result := (index >= 0);
    if not Result then
    begin
        exit;
    end;
    ShareClient[index].MemBuf^.SendRecv := Struct;
    SendMessage(ShareClient[index].ReciverHandle, WM_action, Struct.SockNum, Action_sendtoserver);
end;

//Отправляем данные клиенту использующему указаный номер сокета
function TLSPModuleControl.SendToClient;
var
    index : integer;
begin
    index := FindIndexBySocketNum(Struct.SockNum);
    Result := (index >= 0);
    if not Result then
    begin
        exit;
    end;
    ShareClient[index].MemBuf^.SendRecv := Struct;
    SendMessage(ShareClient[index].ReciverHandle, WM_action, Struct.SockNum, Action_sendtoClient);
end;

procedure TLSPModuleControl.setlookfor(newLookFor : string);
begin
    fLookFor := newLookFor;
    if ShareMain.MapData <> nil then
    begin
        ShareMain.MapData^.ProcessesForHook := flookfor;
    end;
end;

function TLSPModuleControl.islspinstalled : boolean;
begin
    result := isinstalled;
end;

procedure TLSPModuleControl.setlspstate(state : boolean);
var
    result : byte;
begin
    if state then
    begin
        result := InstallProvider(fPathToLspModule);
    end
    else
    begin
        result := RemoveProvider;
    end;

    if assigned(onLspModuleState) then
    begin
        onLspModuleState(result);
    end;

end;

procedure TLSPModuleControl.CloseSocket;
var
    index : integer;
begin
    index := FindIndexBySocketNum(SockNum);
    if index = -1 then
    begin
        exit;
    end;
    SendMessage(ShareClient[index].ReciverHandle, WM_action, SockNum, Action_closesocket);
end;

end.
