library WinAmp;

{$define RELEASE} // для совместимости с релизом пакетхака, при дебуге можно закоментировать

uses
  FastMM4 in '..\fastmm\FastMM4.pas',
  FastMM4Messages in '..\fastmm\FastMM4Messages.pas',
  windows,
  messages,
  sysutils,
  usharedstructs in '..\units\usharedstructs.pas';

var                                {version} {revision}
  min_ver_a : array[0..3] of byte = (3, 5, 23, 141);
  min_ver : longword absolute min_ver_a; // минимальная поддерживаемая версия программы
  ps : TPluginStruct; // структура передаваемая в плагин

function GetPluginInfo(const ver : longword) : pchar; stdcall;
begin
  Result := 'Плагин управления Winamp к программе l2ph' + sLineBreak +
    'Для версий 3.5.23.141+';
end;


function SetStruct(const struct : PPluginStruct) : boolean; stdcall;
begin
  ps := struct^;
  Result := true;
end;

procedure WinampCommand(Command : integer);
var
  WinampHWND : cardinal;
begin
  WinampHWND := findwindow('Winamp v1.x', nil);
  if (WinampHWND <> 0) then
  begin
    SendMessage(WinampHWND, WM_COMMAND, Command, 0);
  end;
end;


// Вызывается при вызове скриптовой функции обьявленной в RefreshPrecompile
function OnCallMethod(const ConnectId, ScriptId : integer; const MethodName : string; // имя функции в верхнем регистре
var Params, // параметры функции
  FuncResult : variant // результат функции
  ) : boolean; stdcall; // если вернёт True то дальнейшая
                              // обработка функции прекратиться
begin
  Result := false; // передаём обработку функции программе
  if lowercase(MethodName) = 'winampcommand' then
  begin
    WinampCommand(integer(Params[0]));
    Result := true; // запрещаем дальнейшую обработку функции в программе
  end;
end;


// Вызывается после иницализации плагина, позволяет добавлять свои функции в редактор / скриптовый движек
procedure OnRefreshPrecompile; stdcall;
begin
  ps.UserFuncs.Add('procedure WinampCommand(Command:Integer)');
end;


// экспортируем используемые программой функции
exports
  GetPluginInfo,
  SetStruct,
  OnCallMethod,
  OnRefreshPrecompile;

begin
end.
