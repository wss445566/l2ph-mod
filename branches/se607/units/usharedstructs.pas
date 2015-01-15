unit usharedstructs;

interface

uses
  Classes;

const
  PCK_GS_ToServer = 4;
  PCK_GS_ToClient = 3;
  PCK_LS_ToServer = 2;
  PCK_LS_ToClient = 1;

type

  TEncDecSettings = record
    isChangeParser,
    isNoDecrypt,
    isNoProcessToClient,
    isNoProcessToServer,
    isKamael,
    isGraciaOff,
    isSavePLog,
    isNoLog,
    ShowLastPacket,
    HexViewOffset,
    isprocesspackets : boolean;

    NoFreeAfterDisconnect : boolean;
    UseSocks5Chain, Socks5NeedAuth : boolean;
    Socks5Port : cardinal;
    Socks5Host, Socks5AuthUsername, Socks5AuthPwd : string;

    isAION{,
    ignoreServerToClient,
    ignoreClientToServer} : boolean;
  end;

  {»спользуетс€ плагинами}

  PCodingClass = ^TCodingClass;

  TCodingClass = class (TObject)
  public
    GKeyS, GKeyR : array[0..15] of byte;
    procedure InitKey(const XorKey; Interlude : byte = 0); virtual; abstract;
    procedure DecryptGP(var Data; var Size : word); virtual; abstract;
    procedure EncryptGP(var Data; var Size : word); virtual; abstract;
    procedure PreDecrypt(var Data; var Size : word); virtual; abstract;
    procedure PostEncrypt(var Data; var Size : word); virtual; abstract;
  end;


  PCorrectorData = ^TCorrectorData;

  TCorrectorData = packed record
    _seed : integer;  // random generator seed for mixing id tables
    _1_byte_table : string;
    _2_byte_table : string;
    _2_byte_table_size : integer;
    _id_mix : boolean;
    temp_seed : integer;
    protocol : integer;
  end;

  TCharArray = array[0..$FFFF] of AnsiChar;
  TCharArrayEx = array[0..$1FFFE] of AnsiChar; //2х

  PPacket = ^TPacket;
  TPacket = packed record
    case integer of
      0 : (Size : word;
        Data : array[0..$FFFD] of byte);
      1 : (PacketAsByteArray : array[0..$FFFF] of byte);
      2 : (PacketAsCharArray : TCharArray);
      3 : (pckSize : word;
        pckId : byte;
        pckData : array[0..$FFFC] of byte);
  end;


  TNewPacket = procedure(var Packet : tpacket; FromServer : boolean; Caller : TObject) of object; // Caller это TencDec к примеру -> TencDec(caller).name вызывает акшин только TencDec 
  TNewAction = procedure(action : byte; Caller : TObject) of object; //Caller зависит от action
  TStringArray = array of string;


  {экземпл€р этого класса (точнее его потомок) передаетс€ в плагины.}
  TOnTimer = procedure(const param : cardinal); stdcall;

  tConnectInfo = packed record
    ConnectID : integer;
    ConnectName : string[200];
  end;

  tConnectInfoEx = packed record  //»спользуетьс€ в ASL
    ConnectInfo : tConnectInfo;
    Valid : boolean;
  end;

  PPluginStruct = ^TPluginStruct;

  TPluginStruct = class (tobject)
  private
  public
    userFormHandle : THandle;
    ConnectInfo : tConnectInfo;
    UserFuncs : tstringlist;
    function ReadC(const pck : string; const index : integer) : byte; virtual; abstract;
    function ReadH(const pck : string; const index : integer) : word; virtual; abstract;
    function ReadD(const pck : string; const index : integer) : integer; virtual; abstract;
    function ReadQ(const pck : string; const index : integer) : int64; virtual; abstract;
    function ReadF(const pck : string; const index : integer) : double; virtual; abstract;
    function ReadS(const pck : string; const index : integer) : string; virtual; abstract;

    function ReadCEx(const pck; const index : integer) : byte; virtual; abstract;
    function ReadHEx(const pck; const index : integer) : word; virtual; abstract;
    function ReadDEx(const pck; const index : integer) : integer; virtual; abstract;
    function ReadQEx(const pck; const index : integer) : int64; virtual; abstract;
    function ReadFEx(const pck; const index : integer) : double; virtual; abstract;
    function ReadSEx(const pck; const index : integer) : string; virtual; abstract;
    procedure WriteC(var pck : string; const v : byte; ind : integer = -1); virtual; abstract;
    procedure WriteH(var pck : string; const v : word; ind : integer = -1); virtual; abstract;
    procedure WriteD(var pck : string; const v : integer; ind : integer = -1); virtual; abstract;
    procedure WriteQ(var pck : string; const v : int64; ind : integer = -1); virtual; abstract;
    procedure WriteF(var pck : string; const v : double; ind : integer = -1); virtual; abstract;
    procedure WriteS(var pck : string; const v : string; ind : integer = -1); virtual; abstract;
    procedure WriteCEx(var pck; const v : byte; ind : integer = -1); virtual; abstract;
    procedure WriteHEx(var pck; const v : word; ind : integer = -1); virtual; abstract;
    procedure WriteDEx(var pck; const v : integer; ind : integer = -1); virtual; abstract;
    procedure WriteQEx(var pck; const v : int64; ind : integer = -1); virtual; abstract;
    procedure WriteFEx(var pck; const v : double; ind : integer = -1); virtual; abstract;
    procedure WriteSEx(var pck; const v : string; ind : integer = -1); virtual; abstract;

    function SetScriptVariable(scriptid : integer; varname : string; varvalue : variant) : boolean; virtual; abstract;
    function GetScriptVariable(scriptid : integer; varname : string) : variant; virtual; abstract;
    function CallScriptFunction(scriptid : integer; Name : string; Params : variant; var error : string) : variant; virtual; abstract;

    function IsScriptIdValid(scriptid : integer) : boolean; virtual; abstract;


    function CreateAndRunTimerThread(const interval, usrParam : cardinal; const OnTimerProc : TOnTimer) : Pointer; virtual; abstract;
    procedure ChangeTimerThread(const timer : Pointer; const interval : cardinal; const usrParam : cardinal = $ffffffff; const OnTimerProc : TOnTimer = nil); virtual; abstract;
    procedure DestroyTimerThread(var timer : Pointer); virtual; abstract;
    function StringToHex(str1, Separator : string) : string; virtual; abstract;
    function HexToString(Hex : string) : string; virtual; abstract;
    function DataPckToStrPck(var pck) : string; virtual; abstract;
    procedure SendPacketData(var pck; const tid : integer; const ToServer : boolean); virtual; abstract;
    procedure SendPacketStr(pck : string; const tid : integer; const ToServer : boolean); virtual; abstract;
    procedure SendPacket(Size : word; pck : string; tid : integer; ToServer : boolean); virtual; abstract;

    function getConnectionName(id : integer) : string; virtual; abstract;
    function getConnectioidByName(name : string) : integer; virtual; abstract;
    function GoFirstConnection : boolean; virtual; abstract;
    function GoNextConnection : boolean; virtual; abstract;
    procedure ShowUserForm(ActivateOnly : boolean); virtual; abstract;
    procedure HideUserForm; virtual; abstract;
  end;

implementation


end.
