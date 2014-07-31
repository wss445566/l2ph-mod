library plugin_demo2;

uses
  mmsystem,
  usharedstructs in '..\units\usharedstructs.pas';

var
  min_ver_a : array[0..3] of byte = (3, 5, 30, 160);
  min_ver : cardinal absolute min_ver_a; // минимальная поддерживаемая версия программы
  work : boolean;
  ps : TPluginStruct;


function GetPluginInfo(const ver : longword) : pchar; stdcall;
begin
  work := ver >= min_ver;
  if not work then
  begin
    Result := 'Plugin к программе l2ph добавляющий ф-ю PlaySound(FileName:string;Synch:boolean=false):boolean' + sLineBreak +
      'Для версий 3.5.31.162+' + sLineBreak +
      'У вас старая версия программы. обновитесь!!';
  end
  else
  begin
    Result := 'Plugin к программе l2ph добавляющий ф-ю PlaySound(FileName:string;Synch:boolean=false):boolean' + sLineBreak +
      'Для версий 3.5.31.162+';
  end;

end;


function SetStruct(const struct : PPluginStruct) : boolean; stdcall;
begin
  ps := struct^;
  Result := true;
end;

function OnCallMethod(const ConnectId, ScriptId : integer; const MethodName : string; // имя функции в верхнем регистре
var Params, // параметры функции
  FuncResult : variant // результат функции
  ) : boolean; stdcall; // если вернёт True то дальнейшая
                              // обработка функции прекратиться
begin
  Result := false; // передаём обработку функции программе
  if not work then
  begin
    exit;
  end;
  if MethodName = 'PLAYSOUND' then
  begin
    if boolean(Params[1]) then
    begin
      FuncResult := PlaySound(pchar(string(Params[0])), 0, SND_SYNC);
    end
    else
    begin
      FuncResult := true;
      PlaySound(pchar(string(Params[0])), 0, SND_ASYNC);
    end;
    Result := true; // запрещаем дальнейшую обработку функции в программе
    FuncResult := Pi;
  end;
end;

procedure OnRefreshPrecompile; stdcall;
begin
  if not work then
  begin
    exit;
  end;
  ps.UserFuncs.Add('function PlaySound(FileName:string;Synch:boolean=false):boolean');
end;


exports
  GetPluginInfo,
  SetStruct,
  OnRefreshPrecompile,
  OnCallMethod;

begin
end.
