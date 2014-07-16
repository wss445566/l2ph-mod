library plugin_demo;

{$define RELEASE} // для совместимости с релизом пакетхака, при дебуге можно закоментировать

uses
    FastMM4 in '..\fastmm\FastMM4.pas',
    FastMM4Messages in '..\fastmm\FastMM4Messages.pas',
    SysUtils,
    Windows,
    dialogs,
    Classes,
    usharedstructs in '..\units\usharedstructs.pas';

var
    min_ver_a : array[0..3] of byte = (3, 5, 23, 141);
    min_ver : longword absolute min_ver_a; // минимальная поддерживаемая версия программы
    ps : TPluginStruct;
    ppck : string;
const
pause = 15000;

var
    ColvoHP, CharObjID, ItemObjHP : integer;
    CurHP, MaxHP : integer;
    lastHP, cntHP : cardinal;
    TimerHP : boolean;
    StatusHP : boolean;

function GetPluginInfo(const ver : longword) : pchar; stdcall;
begin
    if ver < min_ver then
    begin
        Result := 'Демонстрационный Plugin к программе l2phx' + sLineBreak +
            'Для версий 3.5.23.141+' + sLineBreak +
            'У вас старая версия программы! Плагин не сможет корректно с ней работать!';
    end
    else
    begin
        Result := 'Демонстрационный Plugin к программе l2phx' + sLineBreak +
            'Для версий 3.5.23.141+' + sLineBreak +
            'Автовыпивалка НР бутылок';
    end;
end;


procedure Say(msg : string);
var
    buf : string;
begin
    with ps do
    begin
        buf := HexToString('4A 00 00 00 00');
        WriteD(buf, 2);
        WriteS(buf, 'AutoHP');
        WriteS(buf, msg);
        SendPacketStr(buf, cntHP, false);
    end;
end;


function SetStruct(const struct : PPluginStruct) : boolean; stdcall;
begin
    ps := struct^;
    Result := true;
    cntHP := 0;
end;


procedure StatsUpdate;
var
    i : integer;
begin
    for i := 0 to ps.ReadDEx(ppck, 7) - 1 do
    begin
        case ppck[i * 8 + 8] of
            #$09 :
            begin
                CurHP := ps.ReadDEx(ppck, i * 8 + 15);
            end;
            #$0A :
            begin
                MaxHP := ps.ReadDEx(ppck, i * 8 + 15);
            end;
        end;
    end;
    say('CurHP/MaxHP = ' + inttostr(curhp) + '/' + inttostr(maxhp));
    if (CurHP <= MaxHP - 50) then
    begin
        TimerHP := true;
    end
    else
    begin
        TimerHP := false;
    end;
end;

procedure OnLoad; stdcall;
begin
    statusHP := false;
    CharObjID := 0;
    ItemObjHP := 0;
    TimerHP := false;
    lastHP := 0;
    cntHP := 0;
    with ps do
    begin

        if GoFirstConnection then
        begin
            repeat
                cntHP := ConnectInfo.ConnectID;
                Say('Для выбора нужного соединения наберите в чате слово set и отправьте');
            until GoNextConnection;
        end;

    end;
end;

procedure OnPacket(const cnt : integer; const fromServer : boolean; const connectionname : string; var pck : string); stdcall;
var
    buf : string;
begin
    if length(pck) < 3 then
    begin
        exit;
    end;
    ppck := pck;

    if not FromServer and (pck[1] = #$38) and (cntHP = 0) then
    begin
        if (ps.ReadSEx(pck, 3) = 'set') then
        begin
            pck := ''; // не пропускаем пакет
            cntHP := cnt;
            Say('Выбрано это соединение.');
            Say('Для начала работы скрипта бросаем, подбираем или выпиваем Heal Potion!');
        end;
    end;

    if FromServer and (cnt = cntHP) then
    begin
    //InventoryUpdate
        if (pck[1] = #$27) and ((ps.ReadDEx(pck, 13) = 1060) or (ps.ReadDEx(pck, 13) = 1061)) then
        begin //Healing Potion, Lesser Healing Potion
            ItemObjHP := ps.ReadDEx(pck, 9);
            ColvoHP := ps.ReadDEx(pck, 17); //количество хилок
            if statusHP then
            begin
                exit;
            end;
            Say('Автоматическое использование Нeal Рotion готово к работе!');
            Say('Хилок=' + IntToStr(ColvoHP));
            statusHP := true;
        end;

    //UserInfo
        if (pck[1] = #$04) then
        begin
            CharObjID := ps.ReadDEx(ppck, 19);
            MaxHP := ps.ReadDEx(ppck, 83);
        end;

    //StatusUpdate
        if ((pck[1] = #$0E) and (ps.ReadDEx(pck, 3) = CharObjID) and (pck[4] = #$04)) then
        begin
            StatsUpdate;
        end;

        if TimerHP and (GetTickCount - lastHP > pause) then
        begin
            lastHP := GetTickCount;
            buf := #$14;
            ps.WriteD(buf, ItemObjHP);
            ps.WriteD(buf, 0);
            ps.SendPacketStr(buf, cnt, true);
            if ColvoHP < 5 then
            begin
                Say('Кончаются хилки! Закупите Heal Potion!');
            end;
            if ColvoHP = 1 then
            begin
                Say('Хилок=' + inttostr(ColvoHP - 1));
                Say('Кончились хилки! Закупите Heal Potion!');
                TimerHP := false;
            end;
        end;
    end;

end;

exports
    GetPluginInfo,
    OnPacket,
    OnLoad,
    SetStruct;

begin
end.
