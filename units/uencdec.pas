unit uencdec;

interface

uses
    uResourceStrings,
    usharedstructs,
    Classes,
    windows,
    forms,
    sysutils;

const
    KeyConst2 : array[0..63] of char = 'nKO/WctQ0AVLbpzfBkS6NevDYT8ourG5CRlmdjyJ72aswx4EPq1UgZhFMXH?3iI9';

type
    L2Xor = class (TCodingClass)
    private
        keyLen : byte;
    public
        isAion : boolean;
        constructor Create;
        procedure InitKey(const XorKey; Interlude : byte = 0); override;
        procedure DecryptGP(var Data; var Size : word); override;
        procedure EncryptGP(var Data; var Size : word); override;
        procedure PreDecrypt(var Data; var Size : word); override;
        procedure PostEncrypt(var Data; var Size : word); override;
    end;


    TencDec = class (TObject)
        fonNewPacket : TNewPacket;
        fonNewAction : TNewAction;
        xorC, xorS : TCodingClass;         //ксор
        LastPacket : Tpacket;
    private
        isInterlude : boolean;
        SetInitXORAfterEncode : boolean; //Установить SetInitXOR в True после вызова EncodePacket

        pckCount : integer;                //счетчик пакетов
        MaxLinesInPktLog : integer;
    //////////////////////////////////////////////////////////////////////////////////////////////
        CorrectXorData : TPacket;
        CorrectorData : PCorrectorData;

    //корректор для старого руофа
        procedure Corrector(var data; const enc : boolean = false; const FromServer : boolean = false);

    //Детект нового ключа
    //Procedure CorrectXor(Packet:Tpacket);
    //////////////////////////////////////////////////////////////////////////////////////////////

    //опять стандартное
        procedure sendAction(act : integer);
        procedure ProcessRecivedPacket(var packet : tpacket); //обрабатываем пакет (вытягиваем имя соединения, etc)
    public
        ParentTtunel, ParentLSP : Tobject;
        Ident : cardinal;
//    Packet: TPacket; //Содержит пакет над которым в данный момент производятся действия

        CharName : string;                     //имя пользователя
        sLastPacket : string;
        sLastMessage : string;

    //настройки
        InitXOR : boolean;

        Settings : TEncDecSettings;
        innerXor : boolean;

        procedure DecodePacket(var Packet : Tpacket; Dirrection : byte); //Старый PacketProcesor
        procedure EncodePacket(var Packet : Tpacket; Dirrection : byte); //старый сендпакет

        constructor create;
        procedure INIT; //инициализация, вызывать после креейта
        destructor Destroy; override;

    published
    //Разнообразные реакции
        property onNewPacket : TNewPacket read fonNewPacket write fonNewPacket;
        property onNewAction : TNewAction read fonNewAction write fonNewAction;
    end;

implementation

uses
    Math,
    uData,
    uSocketEngine,
    uglobalfuncs;

{ TencDec }


constructor TencDec.create;
begin
    MaxLinesInPktLog := 10000;
    innerXor := false;
    pckCount := 0;
    SetInitXORAfterEncode := false;
    isInterlude := false;
    InitXOR := false;
    New(CorrectorData);
    CorrectorData._id_mix := false;
end;

procedure TencDec.DecodePacket;
var
    InitXOR_copy : boolean;
    temp : word;
begin
    InitXOR_copy := InitXOR;  //надо так.
    if (Packet.Size > 2) then
    begin
        Inc(pckCount);

  //корректор.
//  if Settings.isAionTwoId then
//    CorrectXor(Packet);

        case Dirrection of
            PCK_GS_ToClient, PCK_LS_ToClient :
            begin                       //от ГС
        //запоминание 3го пакета (на сервер)
        //Обход смены XOR ключа. в 4м пакете (на клиент)
        //может изменить флаг InitXOR поэтому у нас есть InitXOR_copy.
//        if Settings.isAionTwoId then CorrectXor(packet);

        //собственно декрипт, если есть ключ и не стоит галочка "не декриптовать".
                if (InitXOR_copy and (not Settings.isNoDecrypt)) then
                begin
                    temp := Packet.Size - 2;
                    xorS.DecryptGP(packet.data, temp);
                    Packet.Size := temp + 2;
                end;
                if (Packet.Size <= 2) then
                begin
                    FillChar(Packet.PacketAsCharArray, $FFFF, #0);
                end //авдруг!
                else
          //вытягиваем имя соединения и прочее
                if (not Settings.isNoDecrypt) then
                begin
                    if (Settings.isAION and (not InitXOR)) then
                    begin
                        packet.Data[0] := (packet.Data[0] xor $EE) - $AE;
                    end; //obfuscate packet id
                    ProcessRecivedPacket(packet);
                end;

                LastPacket := Packet;
                if (Assigned(onNewPacket)) then
                begin
                    if Packet.Size > 2 then //не отправляем скриптам пакеты длинной 2 байта (физически)
                    begin
                        onNewPacket(Packet, true, self);
                    end;
                end;

                if (Packet.Size <= 2) then
                begin
                    FillChar(Packet.PacketAsCharArray, $FFFF, #0);
                end; //авдруг!
            end;

            PCK_GS_ToServer, PCK_LS_ToServer :
            begin
                if Packet.Size = 29754 then
                begin
                    Packet.Size := 267;
                end;
        //Декодирование
                if (InitXOR and (not Settings.isNoDecrypt)) then
                begin
                    temp := Packet.Size - 2;
                    xorC.DecryptGP(Packet.Data, temp);
                    Packet.Size := temp + 2;
                end;
        //корректор для грации
//                if (Settings.isGraciaOff and (not Settings.isNoDecrypt)) then
                if (not Settings.isNoDecrypt) then
                begin
                    Corrector(Packet.Size);
                end;
        //отправка скриптам
                if Assigned(onNewPacket) then
                begin
                    onNewPacket(packet, false, self);
                end;
                if Packet.Size = 0 then
                begin
                    FillChar(Packet.PacketAsCharArray, $FFFF, #0);
                end;
            end;
        end;
    end;
end;

destructor TencDec.destroy;
begin
    try
        if not innerxor then
        begin
            xorS.Destroy;
            xorC.Destroy;
        end;
    except
  //м.б. ошибка. ничего страшного - игнор.
    end;

    Dispose(CorrectorData);
    inherited destroy;
end;


procedure TencDec.Corrector(var data; const enc, FromServer : boolean);
var
    buff : array[1..400] of char absolute data;

    procedure _pseudo_srand(seed : integer);
    begin
        CorrectorData._seed := seed;
    end;

    function _pseudo_rand : integer;
    var
        a : integer;
    begin
        with CorrectorData^ do
        begin
            a := (int64(_seed) * $343fd + $269EC3) and $FFFFFFFF;
            _seed := a;
            result := (_seed shr $10) and $7FFF;
        end;
    end;

    procedure swap(var a, b : byte);
    var
        tmp : byte;
    begin
        tmp := a;
        a := b;
        b := tmp;
    end;


    procedure _init_tables(seed : integer; _2_byte_size : integer);
    var
        i : integer;
        x : char;
        x2 : word;
        rand_pos : integer;
        cur_pos : integer;
    begin
        with CorrectorData^ do
        begin
            _1_byte_table := '';
            _2_byte_table := '';

            _2_byte_table_size := _2_byte_size;

            for i := 0 to $D0 do
            begin
                _1_byte_table := _1_byte_table + chr(i);
            end;
            for i := 0 to _2_byte_size do
            begin
                _2_byte_table := _2_byte_table + chr(i) + #$0;
            end;
            _pseudo_srand(seed);
            for i := 2 to $D1 do
            begin
                rand_pos := (_pseudo_rand mod i) + 1;
                x := _1_byte_table[rand_pos];
                _1_byte_table[rand_pos] := _1_byte_table[i];
                _1_byte_table[i] := x;
            end;

            cur_pos := 3;
            for i := 2 to _2_byte_size + 1 do
            begin
                rand_pos := _pseudo_rand mod i;
                x2 := PWord(@_2_byte_table[rand_pos * 2 + 1])^;
                PWord(@_2_byte_table[rand_pos * 2 + 1])^ := PWord(@_2_byte_table[cur_pos])^;
                PWord(@_2_byte_table[cur_pos])^ := x2;
                cur_pos := cur_pos + 2;
            end;
      // nlobp по подсказке alexteam
            if GlobalProtocolVersion < FREYA then  //ниже Фрейи
            begin
                cur_pos := Pos(#$12, _1_byte_table);
                x := _1_byte_table[$13];
                _1_byte_table[$13] := #$12;
                _1_byte_table[cur_pos] := x;

                cur_pos := Pos(#$B1, _1_byte_table);
                x := _1_byte_table[$B2];
                _1_byte_table[$B2] := #$B1;
                _1_byte_table[cur_pos] := x;
            end
            else
            if GlobalProtocolVersion < GOD then  //Фрейя и HighFive
            begin
                cur_pos := Pos(#$11, _1_byte_table);
                x := _1_byte_table[$12];
                _1_byte_table[$12] := #$11;
                _1_byte_table[cur_pos] := x;

                cur_pos := Pos(#$D0, _1_byte_table);
                x := _1_byte_table[$D1];
                _1_byte_table[$D1] := #$D0;
                _1_byte_table[cur_pos] := x;
            end
            else
            if GlobalProtocolVersion = GOD then  //GoD
            begin
                cur_pos := Pos(#$73, _1_byte_table);
                x := _1_byte_table[$74];
                _1_byte_table[$74] := #$73;
                _1_byte_table[cur_pos] := x;

                cur_pos := Pos(#$74, _1_byte_table);
                x := _1_byte_table[$75];
                _1_byte_table[$75] := #$74;
                _1_byte_table[cur_pos] := x;
            end
            else
            begin
                swap(pbyte(@_1_byte_table[$11 + 1])^, pbyte(@_1_byte_table[pos(#$11, _1_byte_table)])^);
                swap(pbyte(@_1_byte_table[$12 + 1])^, pbyte(@_1_byte_table[pos(#$12, _1_byte_table)])^);
                swap(pbyte(@_1_byte_table[$B1 + 1])^, pbyte(@_1_byte_table[pos(#$B1, _1_byte_table)])^);
                swap(pbyte(@_1_byte_table[$D0 + 1])^, pbyte(@_1_byte_table[pos(#$D0, _1_byte_table)])^);
            end;
            if seed = 0 then
            begin
                _id_mix := false;
            end
            else
            begin
                _id_mix := true;
            end;
        end;
    end;

    procedure _decode_ID;
    begin
        with CorrectorData^ do
        begin
            buff[3] := _1_byte_table[byte(buff[3]) + 1];
            if buff[3] = #$D0 then
            begin
                if byte(buff[4]) > _2_byte_table_size then
                begin
          // error!
                end;
                buff[4] := _2_byte_table[byte(buff[4]) * 2 + 1];
            end;
        end;
    end;

    procedure _encode_ID;
    var
        p : integer;
    begin
        with CorrectorData^ do
        begin
            if buff[3] = #$D0 then
            begin
                p := pos(buff[4], _2_byte_table);
                buff[4] := char(((p + 1) shr 1) - 1);
            end;
            p := pos(buff[3], _1_byte_table);
            buff[3] := char(p - 1);
        end;
    end;

begin
    with CorrectorData^ do
    begin
        if FromServer then
        begin
            if _id_mix and (buff[3] = #$0b) then
            begin
                temp_seed := PInteger(@buff[PWord(@buff[1])^ - 3])^;
                _init_tables(temp_seed, _2_byte_table_size);
            end;
            if (buff[3] = #$2e) then
            begin
      // nlobp по подсказке alexteam
                if GlobalProtocolVersion < FREYA then
                begin
                    _init_tables(PInteger(@buff[$16])^, $80);
                end //ниже Фрейи
                else
                if GlobalProtocolVersion < GOD then
                begin
                    _init_tables(PInteger(@buff[$16])^, $86);
                end //Фрейя, HighFive
                else
                if GlobalProtocolVersion = GOD then
                begin //GoD
                    _init_tables(PInteger(@buff[$16])^, $C5);
                end
                else
                begin
                    _init_tables(PInteger(@buff[$16])^, $FF);
                end;
            end;
        end
        else
        begin
            if not _id_mix and (buff[3] = #$0e) then
            begin
                Protocol := PInteger(@buff[4])^;
            end;
            if _id_mix and not enc then
            begin
                _decode_ID;
            end;
            if _id_mix and enc then
            begin
                _encode_ID;
            end;
        end;
    end;
end;

procedure TencDec.INIT;
begin
  //newxor
    if @CreateXorOut = nil then
    begin
        CreateXorOut := CreateXorIn;
    end;
  //xorS, xorC - init
    if Assigned(CreateXorIn) then
    begin
        CreateXorIn(@xorS);
        innerXor := true;
    end
    else
    begin
        xorS := L2Xor.Create;
    end;
    if Assigned(CreateXorOut) then
    begin
        CreateXorOut(@xorC);
        innerXor := true;
    end
    else
    begin
        xorC := L2Xor.Create;
    end;
end;

procedure TencDec.EncodePacket;
var
    isToServer : boolean;
    CurrentCoddingClass : TCodingClass;
    NeedEncrypt : boolean;
    temp : word;
begin
    isToServer := (Dirrection = PCK_GS_ToServer) or (Dirrection = PCK_LS_ToServer); //пакет идет на сервер ?
    if (isToServer) then //в зависимости от направления выбираем кодирующий класс
    begin
        NeedEncrypt := (not Settings.isNoDecrypt) and InitXOR;
        CurrentCoddingClass := xorC;
    end
    else
    begin
        NeedEncrypt := (not Settings.isNoDecrypt) and InitXOR;
        if (Settings.isAION and not InitXOR and not Settings.isNoDecrypt) then
        begin
            packet.Data[0] := (packet.Data[0] + $AE) xor $EE;
        end; //obfuscate packet id
        CurrentCoddingClass := xorS;
    end;
    if (NeedEncrypt) then
    begin
//        if (isToServer and Settings.isGraciaOff) then
        if isToServer then
        begin
            Corrector(Packet.Size, true);
        end;
        temp := Packet.Size - 2;
        CurrentCoddingClass.EncryptGP(Packet.data, temp); //кодируем
        Packet.Size := temp + 2;
    end;
    if SetInitXORAfterEncode then
    begin
        InitXOR := true;
        SetInitXORAfterEncode := false;
    end;
    LastPacket := Packet;
end;

//procedure TencDec.CorrectXor;
//var
////  tmp: string;
//  Offset: Word;
//  TempPacket : Tpacket;
//  temp : word;
//begin
////Обход смены XOR ключа.
//case pckCount of
//3:  CorrectXorData := Packet;
//4:  begin
//      TempPacket := Packet;
////      SetLength(tmp, TempPacket.Size);
////      Move(TempPacket, tmp[1], TempPacket.Size);
//      temp := TempPacket.Size-2;
//      xorS.DecryptGP(TempPacket.Data, temp);
//      TempPacket.Size := temp + 2;
//      Offset := $13 or ((TempPacket.size-7) div 295) shl 8;
//      PInteger(@TempPacket.Data[0])^:=PInteger(@TempPacket.Data[0])^ xor Offset xor PInteger(@(xorS.GKeyS[0]))^;
//      xorS.InitKey(TempPacket.Data[0],Byte(isInterlude));
//      xorC.InitKey(TempPacket.Data[0],Byte(isInterlude));
//      if (not Settings.isNoDecrypt) then
//        begin
//          temp := CorrectXorData.Size - 2;
//          xorC.DecryptGP(CorrectXorData.Data, temp);
//          CorrectXorData.Size := temp + 2;
//        end;
//      if (not Settings.isNoDecrypt) then
//        begin
//          temp := CorrectXorData.Size - 2;
//          xorC.EncryptGP(CorrectXorData.Data, temp);
//          CorrectXorData.Size := temp + 2;
//        end;
//      InitXOR:=True;
//    end;
//end;
//end;

procedure TencDec.ProcessRecivedPacket;
var
    Offset : word;
    WStr : widestring;
begin
    if (not Settings.isAION) then
    begin  //LineageII
        case Packet.Data[0] of
      //KeyInit до Интерлюда включительно
            $00 :
            begin
                if ((not InitXOR) and (not Settings.isKamael)) then
                begin
                    isInterlude := (Packet.Size > 19);
                    xorC.InitKey(Packet.Data[2], byte(isInterlude));
                    xorS.InitKey(Packet.Data[2], byte(isInterlude));
                    SetInitXORAfterEncode := true;
                end;
            end;
      //CharSelected начиная с Камаеля по ГоД
            $0B :
            begin
                if (Settings.isKamael) then
                begin
                    Offset := 1;
                    while not ((Packet.Data[Offset] = 0) and (Packet.Data[Offset + 1] = 0)) do
                    begin
                        Inc(Offset, 2);
                    end;
                    SetLength(WStr, round((Offset + 0.5) / 2));
                    Move(Packet.Data[1], WStr[1], Offset);
                    CharName := WideStringToString(WStr, 1251);
//                    if (Settings.isGraciaOff) then
//                    begin
                    Corrector(Packet.Size, false, true);
//                    end; // инициализация корректора
          //Получено имя соединения
                    sendAction(TencDec_Action_GotName);
                end;
            end;
      //CharSelected до Интерлюда включительно
            $15 :
            begin
                if (not Settings.isKamael) then
                begin //and (pckCount=7)
                    Offset := 1;
                    while not ((Packet.Data[Offset] = 0) and (Packet.Data[Offset + 1] = 0)) do
                    begin
                        Inc(Offset);
                    end;
                    SetLength(WStr, round((Offset + 0.5) / 2));
                    Move(Packet.Data[1], WStr[1], Offset);

                    CharName := WideStringToString(WStr, 1251);
        //Получено имя соединения
                    sendAction(TencDec_Action_GotName);
                end;
            end;
      //KeyInit начиная с Камаеля по ГоД
            $2e :
            begin
                if ((not InitXOR) and Settings.isKamael) then
                begin
                    isInterlude := true;
                    xorC.InitKey(Packet.Data[2], byte(isInterlude));
                    xorS.InitKey(Packet.Data[2], byte(isInterlude));
//                    if Settings.isGraciaOff then
//                    begin
                    Corrector(Packet.Size, false, true);
//                    end; // инициализация корректора
                    SetInitXORAfterEncode := true;
                    exit;
                end;
            end;
        end;
    end
    else
    begin  //Aion
        case Packet.Data[0] of
      // $0166=SM_KEY AION 2.7
            $66 :
            begin
                if not InitXOR then
                begin
                    xorC.InitKey(Packet.Data[5], 2);
                    xorS.InitKey(Packet.Data[5], 2);
                    SetInitXORAfterEncode := true;
                end;
            end;
      // $67=SM_KEY AION 2.1
            $67 :
            begin
                if not InitXOR then
                begin
                    xorC.InitKey(Packet.Data[3], 2);
                    xorS.InitKey(Packet.Data[3], 2);
                    SetInitXORAfterEncode := true;
                end;
            end;
      // E4=sm_l2auth_login_check Aion 2.1
            $E4 :
            begin
                if (GlobalProtocolVersion = AION) then
                begin
                    CharName := WideStringToString(PWideChar(@Packet.Data[7]), 1251);
        //Получено имя соединения
                    sendAction(TencDec_Action_GotName);
                end;
            end;
      // 01E7=sm_l2auth_login_check Aion 2.7
            $E7 :
            begin
                if (GlobalProtocolVersion = AION27) then
                begin
                    CharName := WideStringToString(PWideChar(@Packet.Data[9]), 1251);
        //Получено имя соединения
                    sendAction(TencDec_Action_GotName);
                end;
            end;
    //если нет подходящих пакетов
        else
        begin
            if (not InitXOR) then
            begin
                xorC.InitKey(Packet.Data[3], 2);
                xorS.InitKey(Packet.Data[3], 2);
                SetInitXORAfterEncode := true;
            end;
        end;
        end;
    end;
end;

procedure TencDec.sendAction(act : integer);
begin
    if assigned(onNewAction) then
    begin
        onNewAction(act, Self);
    end;
end;

{ L2Xor }
constructor L2Xor.Create;
begin
    FillChar(GKeyS[0], SizeOf(GKeyS), 0);
    FillChar(GKeyR[0], SizeOf(GKeyR), 0);
    keyLen := 0;
    isAion := false;
end;

procedure L2Xor.DecryptGP(var Data; var Size : word);
var
    k : integer;
    i, t : byte;
    pck : array[0..$FFFD] of byte absolute Data;
begin
    i := 0;
    for k := 0 to size - 1 do
    begin
        t := pck[k];
        pck[k] := t xor GKeyR[k and keyLen] xor i xor IfThen(isAion and (k > 0), byte(KeyConst2[k and 63]));
        i := t;
    end;
    Inc(PCardinal(@GKeyR[keyLen - 7])^, size);
    if (isAion and (Size > 0)) then
    begin
        pck[0] := (pck[0] xor $EE) - $AE;
    end; //obfuscate packet id
end;

procedure L2Xor.EncryptGP(var Data; var Size : word);
var
    i : integer;
    k : byte;
    pck : array[0..$FFFD] of byte absolute Data;
begin
    if (isAion and (Size > 0)) then
    begin
        pck[0] := (pck[0] + $AE) xor $EE;
    end; //obfuscate packet id
    k := 0;
    for i := 0 to size - 1 do
    begin
        pck[i] := pck[i] xor GKeyS[i and keyLen] xor k xor IfThen(isAion and (i > 0), byte(KeyConst2[i and 63]));
        k := pck[i];
    end;
    Inc(PCardinal(@GKeyS[keyLen - 7])^, size);
end;

procedure L2Xor.InitKey(const XorKey; Interlude : byte);
const
    KeyConst : array[0..3] of byte = ($A1, $6C, $54, $87);
    KeyConstInterlude : array[0..7] of byte = ($C8, $27, $93, $01, $A1, $6C, $31, $97);
var
    key2 : array[0..15] of byte;
begin
    case Interlude of
        0 :
        begin   //C4
            keyLen := 7;
            Move(XorKey, key2, 4);
            Move(KeyConst, key2[4], 4);
        end;
        1 :
        begin   //Interlude - Gracia - GoD
            keyLen := 15;
            Move(XorKey, key2, 8);
            Move(KeyConstInterlude, key2[8], 8);
        end;
        2 :
        begin   //Aion
            keyLen := 7;
            Move(XorKey, key2, 4);
            Move(KeyConst, key2[4], 4);
            PCardinal(@key2[0])^ := PCardinal(@key2[0])^ - $3ff2cc87 xor $cd92e451;
            isAion := true;
        end;
    end;
    Move(key2, GKeyS, 16);
    Move(key2, GKeyR, 16);
    inherited;
end;

procedure L2Xor.PostEncrypt(var Data; var Size : word);
begin
//Ничего не делаем, ибо ничего делать и не надо.
end;

procedure L2Xor.PreDecrypt(var Data; var Size : word);
begin
//Ничего не делаем, ибо ничего делать и не надо.
end;

end.
