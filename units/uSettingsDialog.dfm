object fSettings: TfSettings
  Left = 209
  Top = 157
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #205#224#241#242#240#238#233#234#232
  ClientHeight = 525
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl3: TPageControl
    Left = 0
    Top = 0
    Width = 371
    Height = 498
    ActivePage = TabSheet8
    Align = alClient
    TabOrder = 0
    object TabSheet8: TTabSheet
      Caption = #206#225#249#232#229' '#237#224#241#242#240#238#233#234#232
      object rgProtocolVersion: TRadioGroup
        Left = 0
        Top = 157
        Width = 363
        Height = 128
        Align = alTop
        Caption = #194#229#240#241#232#255' '#239#240#238#242#238#234#238#235#224' ('#244#224#233#235' packets.ini):'
        Columns = 2
        ItemIndex = 13
        Items.Strings = (
          'AION 2.1-2.6'
          'AION 2.7'
          'C4 - Chronicle 4'
          'C5 - Chronicle 5'
          'T0 - Interlude'
          'T1 - Kamael/Hellbound/Gracia'
          'Gracia Final'
          'Gracia Epilogue'
          'Freya'
          'High Five'
          'GoD'
          'Ertheia'
          'Infinite Odyssey'
          'Classic')
        TabOrder = 1
        OnClick = rgProtocolVersionClick
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 363
        Height = 157
        Hint = #205#229' '#225#243#228#229#242' '#226#235#232#255#242#252' '#237#224' '#243#230#229' '#241#243#249#229#241#242#226#243#254#249#232#229
        Align = alTop
        Caption = #205#224#241#242#240#238#233#234#232' '#228#235#255' '#237#238#226#238#227#238' '#239#229#240#229#245#226#224#247#229#237#237#238#227#238' '#241#238#229#228#232#237#229#237#232#255':'
        TabOrder = 0
        object btnNewXor: TSpeedButton
          Left = 323
          Top = 130
          Width = 23
          Height = 22
          Glyph.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            08000000000000010000420B0000420B0000000100000001000000730800087B
            080008841000088C100008A51800108C2100109C210018AD290031C64A0042D6
            6B0052D67B005AE78C0018A5C60018ADD60021ADD60029ADD60031B5DE0052BD
            E7004AC6E7004AC6EF009CDEEF00ADDEEF006BDEF70073DEF700A5EFF700FF00
            FF0084EFFF008CEFFF0094EFFF008CF7FF0094F7FF00A5F7FF0094FFFF009CFF
            FF00ADFFFF00C6FFFF00D6FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00191919191919
            19191919191919191919190F100E191919191919191919191919190F141A120E
            0C0C0C19191919191919190F11212017171717120E0C19191919190F11221D1B
            1B1B171717130E191919190F0F151E1E1B1B1B1B171713191919190F170F211D
            1D1D1B1B1B17170C1919190F1E0F1518181F1B1B1B17000C1919190F21170F0C
            0C0C151D1A000B000C19190F211E171717160F15000A09080019190F211E1E1E
            1E17170F0C0508060C19190F23202124241B1C17170207021919190E14232314
            0D0C0C0C0C03041919191919100F0C0C19191919030402191919191919191919
            1900010303011919191919191919191919191919191919191919}
          OnClick = btnNewXorClick
        end
        object ChkNoDecrypt: TCheckBox
          Left = 5
          Top = 18
          Width = 340
          Height = 17
          Hint = #207#238#234#224#231#251#226#224#229#242' '#242#240#224#244#232#234' '#234#224#234' '#238#237' '#239#240#232#245#238#228#232#242
          Caption = #205#229' '#228#229#248#232#244#240#238#226#251#226#224#242#252' '#242#240#224#244#232#234
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = ChkAionClick
        end
        object ChkAion: TCheckBox
          Left = 5
          Top = 34
          Width = 340
          Height = 17
          Hint = #211#241#242#224#237#238#226#232#242#252' '#228#235#255' '#241#229#240#226#229#240#238#226' '#242#232#239#224' Aion'
          Caption = 'Aion'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = ChkAionClick
        end
        object ChkKamael: TCheckBox
          Left = 5
          Top = 50
          Width = 340
          Height = 17
          Hint = #211#241#242#224#237#238#226#232#242#252' '#228#235#255' '#241#229#240#226#229#240#238#226' '#242#232#239#224' Kamael - Hellbound - Gracia'
          Caption = 'Kamael-Hellbound-Gracia'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 2
          OnClick = ChkKamaelClick
        end
        object ChkGraciaOff: TCheckBox
          Left = 5
          Top = 66
          Width = 340
          Height = 17
          Hint = #211#241#242#224#237#238#226#232#242#252' '#242#238#235#252#234#238' '#228#235#255' '#240#243#241#241#234#238#227#238' '#238#244#232#246#232#224#235#252#237#238#227#238' '#241#229#240#226#229#240#224' L2.RU'
          Caption = 'Gracia ('#241#242#224#226#232#242#252' '#228#235#255' Official-like Server)'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 3
          Visible = False
          OnClick = ChkGraciaOffClick
        end
        object isNewXor: TLabeledEdit
          Left = 24
          Top = 130
          Width = 293
          Height = 21
          Hint = #193#232#225#235#232#238#242#229#234#224' '#228#235#255' '#241#229#240#226#229#240#238#226' '#241' '#237#229#241#242#224#237#228#224#240#242#237#238#233' '#248#232#244#240#224#246#232#229#233
          EditLabel.Width = 85
          EditLabel.Height = 13
          EditLabel.Caption = #207#241#229#226#228#238#237#232#236' Newxor:'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          Text = 'newxor.dll'
        end
        object iNewxor: TCheckBox
          Left = 5
          Top = 133
          Width = 15
          Height = 17
          Hint = #199#224#227#240#243#230#224#229#242' '#243#234#224#231#224#237#243#254' '#225#232#225#235#232#238#242#229#234#243
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnClick = iNewxorClick
        end
        object chkIgnoseClientToServer: TCheckBox
          Left = 5
          Top = 99
          Width = 340
          Height = 17
          Hint = #205#229' '#225#243#228#229#242' '#238#225#240#224#225#224#242#251#226#224#242#252' '#242#240#224#244#232#234' '#232#228#243#249#232#233' '#238#242' '#234#235#232#229#237#242#224' '#237#224' '#241#229#240#226#229#240
          Caption = #205#229' '#238#225#240#224#225#224#242#251#226#224#242#252' '#237#224#239#240#224#226#235#229#237#232#229' Client -> Server'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnClick = ChkAionClick
        end
        object chkIgnoseServerToClient: TCheckBox
          Left = 5
          Top = 83
          Width = 340
          Height = 17
          Hint = #205#229' '#225#243#228#229#242' '#238#225#240#224#225#224#242#251#226#224#242#252' '#242#240#224#244#232#234' '#232#228#243#249#232#233' '#238#242' '#241#229#240#226#229#240#224' '#237#224' '#234#235#232#229#237#242
          Caption = #205#229' '#238#225#240#224#225#224#242#251#226#224#242#252' '#237#224#239#240#224#226#235#229#237#232#229' Server -> Client'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = ChkAionClick
        end
      end
      object PnlSocks5Chain: TGroupBox
        Left = 0
        Top = 285
        Width = 363
        Height = 173
        Align = alTop
        Caption = #209#238#234#246#232#244#232#246#232#240#238#226#224#242#252' '#239#240#232#235#238#230#229#237#232#229' '#247#229#240#229#231' SOCKS5 '#241#229#240#226#229#240':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object Label4: TLabel
          Left = 8
          Top = 37
          Width = 69
          Height = 13
          Caption = 'IP/Host name:'
        end
        object Label5: TLabel
          Left = 241
          Top = 37
          Width = 22
          Height = 13
          Caption = 'Port:'
        end
        object Label6: TLabel
          Left = 8
          Top = 96
          Width = 51
          Height = 13
          Caption = 'Username:'
        end
        object Label7: TLabel
          Left = 176
          Top = 96
          Width = 49
          Height = 13
          Caption = 'Password:'
        end
        object ChkUseSocks5Chain: TCheckBox
          Left = 8
          Top = 18
          Width = 329
          Height = 17
          Caption = #200#241#239#238#235#252#231#238#226#224#242#252' SOCKS5 '#241#229#240#226#229#240
          Enabled = False
          TabOrder = 0
        end
        object edSocks5Host: TEdit
          Left = 8
          Top = 52
          Width = 225
          Height = 21
          TabOrder = 1
        end
        object edSocks5Port: TEdit
          Left = 239
          Top = 52
          Width = 97
          Height = 21
          TabOrder = 2
          Text = '1080'
          OnExit = edSocks5PortExit
          OnKeyPress = edSocks5PortKeyPress
        end
        object chkSocks5NeedAuth: TCheckBox
          Left = 8
          Top = 80
          Width = 185
          Height = 17
          Caption = #210#240#229#225#243#229#242#241#255' '#224#226#242#238#240#232#231#224#246#232#255
          Enabled = False
          TabOrder = 3
        end
        object edSocks5AuthUsername: TEdit
          Left = 8
          Top = 112
          Width = 161
          Height = 21
          TabOrder = 4
        end
        object edSocks5AuthPwd: TEdit
          Left = 176
          Top = 112
          Width = 161
          Height = 21
          PasswordChar = '*'
          TabOrder = 5
          OnEnter = edSocks5AuthPwdEnter
          OnExit = edSocks5AuthPwdExit
        end
        object btnTestSocks5Chain: TButton
          Left = 8
          Top = 140
          Width = 329
          Height = 23
          Caption = 'Test (connect microsoft.com:80)'
          ParentShowHint = False
          ShowHint = False
          TabOrder = 6
          OnClick = btnTestSocks5ChainClick
        end
      end
    end
    object TabSheet9: TTabSheet
      Caption = #205#224#241#242#240#238#233#234#232' '#239#229#240#229#245#226#224#242#224
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Bevel1: TBevel
        Left = 5
        Top = 90
        Width = 350
        Height = 118
        Shape = bsFrame
      end
      object Bevel2: TBevel
        Left = 5
        Top = 350
        Width = 350
        Height = 34
        Shape = bsFrame
      end
      object Bevel3: TBevel
        Left = 5
        Top = 214
        Width = 350
        Height = 131
        Shape = bsFrame
      end
      object Bevel4: TBevel
        Left = 5
        Top = 390
        Width = 350
        Height = 63
        Shape = bsFrame
      end
      object Label1: TLabel
        Left = 12
        Top = 394
        Width = 101
        Height = 13
        Caption = #207#240#238#241#235#243#248#232#226#224#229#236#251#233' '#239#238#240#242':'
      end
      object Label2: TLabel
        Left = 59
        Top = 435
        Width = 292
        Height = 13
        Alignment = taRightJustify
        Caption = '*'#228#235#255' '#239#240#232#236#229#237#229#237#232#255' '#253#242#238#233' '#237#224#241#242#240#238#233#234#232' '#242#240#229#225#243#229#242#241#255' '#239#229#240#229#231#224#239#243#241#234' L2ph'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object BtnInject: TSpeedButton
        Left = 326
        Top = 177
        Width = 23
        Height = 22
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          08000000000000010000420B0000420B0000000100000001000000730800087B
          080008841000088C100008A51800108C2100109C210018AD290031C64A0042D6
          6B0052D67B005AE78C0018A5C60018ADD60021ADD60029ADD60031B5DE0052BD
          E7004AC6E7004AC6EF009CDEEF00ADDEEF006BDEF70073DEF700A5EFF700FF00
          FF0084EFFF008CEFFF0094EFFF008CF7FF0094F7FF00A5F7FF0094FFFF009CFF
          FF00ADFFFF00C6FFFF00D6FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00191919191919
          19191919191919191919190F100E191919191919191919191919190F141A120E
          0C0C0C19191919191919190F11212017171717120E0C19191919190F11221D1B
          1B1B171717130E191919190F0F151E1E1B1B1B1B171713191919190F170F211D
          1D1D1B1B1B17170C1919190F1E0F1518181F1B1B1B17000C1919190F21170F0C
          0C0C151D1A000B000C19190F211E171717160F15000A09080019190F211E1E1E
          1E17170F0C0508060C19190F23202124241B1C17170207021919190E14232314
          0D0C0C0C0C03041919191919100F0C0C19191919030402191919191919191919
          1900010303011919191919191919191919191919191919191919}
        OnClick = BtnInjectClick
      end
      object BtnLsp: TSpeedButton
        Left = 326
        Top = 313
        Width = 23
        Height = 22
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          08000000000000010000420B0000420B0000000100000001000000730800087B
          080008841000088C100008A51800108C2100109C210018AD290031C64A0042D6
          6B0052D67B005AE78C0018A5C60018ADD60021ADD60029ADD60031B5DE0052BD
          E7004AC6E7004AC6EF009CDEEF00ADDEEF006BDEF70073DEF700A5EFF700FF00
          FF0084EFFF008CEFFF0094EFFF008CF7FF0094F7FF00A5F7FF0094FFFF009CFF
          FF00ADFFFF00C6FFFF00D6FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00191919191919
          19191919191919191919190F100E191919191919191919191919190F141A120E
          0C0C0C19191919191919190F11212017171717120E0C19191919190F11221D1B
          1B1B171717130E191919190F0F151E1E1B1B1B1B171713191919190F170F211D
          1D1D1B1B1B17170C1919190F1E0F1518181F1B1B1B17000C1919190F21170F0C
          0C0C151D1A000B000C19190F211E171717160F15000A09080019190F211E1E1E
          1E17170F0C0508060C19190F23202124241B1C17170207021919190E14232314
          0D0C0C0C0C03041919191919100F0C0C19191919030402191919191919191919
          1900010303011919191919191919191919191919191919191919}
        OnClick = BtnLspClick
      end
      object isInject: TLabeledEdit
        Left = 30
        Top = 178
        Width = 293
        Height = 21
        Hint = #193#232#225#235#232#238#242#229#234#224' '#238#225#229#241#239#229#247#232#226#224#254#249#224#255' '#239#229#240#229#245#226#224#242' '#241#238#229#228#232#237#229#237#232#255
        EditLabel.Width = 225
        EditLabel.Height = 13
        EditLabel.Caption = #200#236#255' '#225#232#225#235#232#238#242#229#234#232' '#239#229#240#229#245#226#224#242#251#226#224#254#249#229#233' '#241#238#229#228#232#237#229#237#232#255':'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
      end
      object HookMethod: TRadioGroup
        Left = 12
        Top = 125
        Width = 336
        Height = 34
        Caption = #209#239#238#241#238#225' '#226#237#229#228#240#229#237#232#255' '#226' '#234#235#232#229#237#242'/'#225#238#242':'
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          #205#224#228#229#230#237#251#233
          #209#234#240#251#242#237#251#233
          #192#235#252#242#229#240#237#224#242#232#226#237#251#233)
        ParentShowHint = False
        ShowHint = False
        TabOrder = 4
      end
      object ChkIntercept: TCheckBox
        Left = 12
        Top = 99
        Width = 309
        Height = 17
        Hint = #208#224#231#240#229#248#224#229#242' '#239#238#232#241#234' '#237#238#226#251#245' '#234#235#232#229#237#242#238#226', '#232' '#239#229#240#229#245#226#224#242' '#232#245' '#241#238#229#228#232#237#229#237#232#233
        Caption = #207#229#240#229#245#226#224#242';  '#200#241#234#224#242#252' '#234#235#232#229#237#242'                    '#241#229#234'.'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = ChkInterceptClick
      end
      object JvSpinEdit1: TJvSpinEdit
        Left = 166
        Top = 97
        Width = 52
        Height = 21
        Hint = #202#224#234' '#247#224#241#242#238' '#232#241#234#224#242#252' '#239#240#238#227#240#224#236#236#251' '#228#235#255' '#239#229#240#229#245#226#224#242#224
        Increment = 0.500000000000000000
        MaxValue = 10.000000000000000000
        MinValue = 0.100000000000000000
        ValueType = vtFloat
        Value = 5.000000000000000000
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnChange = rgProtocolVersionClick
        BevelInner = bvNone
        BevelOuter = bvNone
      end
      object ChkSocks5Mode: TCheckBox
        Left = 12
        Top = 359
        Width = 309
        Height = 17
        Hint = #207#224#234#229#242#245#224#234' '#240#224#225#238#242#224#229#242' '#234#224#234' '#239#240#238#234#241#232'-'#241#229#240#226#229#240
        Caption = #208#224#225#238#242#224#242#252' '#234#224#234' Socks5 '#241#229#240#226#229#240
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        OnClick = ChkSocks5ModeClick
      end
      object iInject: TCheckBox
        Left = 12
        Top = 179
        Width = 13
        Height = 17
        Hint = #199#224#227#240#243#230#224#229#242' '#243#234#224#231#224#237#243#254' '#225#232#225#235#232#238#242#229#234#243
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = iInjectClick
      end
      object ChkLSPIntercept: TCheckBox
        Left = 12
        Top = 220
        Width = 317
        Height = 17
        Hint = #200#241#239#238#235#252#231#243#229#242' LSP '#228#235#255' '#239#229#240#229#245#226#224#242#224' '#242#240#224#244#244#232#234#224
        Caption = #200#241#239#238#235#252#231#238#226#224#242#252' LSP '#239#229#240#229#245#226#224#242
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = ChkLSPInterceptClick
      end
      object isLSP: TLabeledEdit
        Left = 14
        Top = 313
        Width = 308
        Height = 21
        Hint = 'LSP '#193#232#225#235#232#238#242#229#234#224' ('#192#225#241#238#235#254#242#237#251#233' '#239#243#242#252', '#235#232#225#238' '#240#224#231#236#229#241#242#232#242#252' '#226' SYSTEM32)'
        EditLabel.Width = 122
        EditLabel.Height = 13
        EditLabel.Caption = #207#238#235#237#251#233' '#239#243#242#252' '#234' LSP '#236#238#228#243#235#254':'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        Text = 'lsp.dll'
        OnChange = isLSPChange
      end
      object JvSpinEdit2: TJvSpinEdit
        Left = 14
        Top = 408
        Width = 115
        Height = 21
        Hint = #207#238#240#242
        Decimal = 0
        MaxValue = 60000.000000000000000000
        MinValue = 1024.000000000000000000
        ValueType = vtFloat
        Value = 1024.000000000000000000
        ParentShowHint = False
        ShowHint = True
        TabOrder = 12
        OnChange = rgProtocolVersionClick
        BevelInner = bvNone
        BevelOuter = bvNone
      end
      object isIgnorePorts: TLabeledEdit
        Left = 5
        Top = 59
        Width = 350
        Height = 21
        Hint = #207#238#240#242#251', '#234#238#237#237#229#234#242#251' '#237#224' '#234#238#242#238#240#251#229' '#237#224#228#238' '#239#229#240#229#245#226#224#242#251#226#224#242#252
        EditLabel.Width = 197
        EditLabel.Height = 13
        EditLabel.Caption = #207#238#240#242#251' '#227#229#233#236#241#229#240#226#229#240#224' ('#225#243#228#243#242' '#239#229#240#229#245#226#224#247#229#237#251'):'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object isClientsList: TLabeledEdit
        Left = 5
        Top = 20
        Width = 350
        Height = 21
        Hint = #207#240#238#227#240#224#236#236#251' '#243' '#234#238#242#238#240#251#245' '#225#243#228#229#236' '#239#229#240#229#245#226#224#242#251#226#224#242#252' '#242#240#224#244#232#234
        EditLabel.Width = 178
        EditLabel.Height = 13
        EditLabel.Caption = #209#247#232#242#224#242#252' '#234#235#232#229#237#242#224#236#232'/'#225#238#242#224#236#232' '#239#240#238#227#240#224#236#236#251':'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object ChkLSPDeinstallonclose: TCheckBox
        Left = 12
        Top = 239
        Width = 317
        Height = 17
        Hint = #209#237#232#236#224#229#242' '#240#229#227#232#241#242#240#224#246#232#254' LSP '#236#238#228#243#235#255' '#239#240#232' '#231#224#226#229#240#248#229#237#232#232' '#240#224#225#238#242#251' l2ph'
        Caption = #196#229#232#237#241#242#224#235#232#240#238#226#224#242#252' '#239#240#232' '#226#251#245#238#228#229' '#232#231' PH'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
      end
      object lspInterceptMethod: TRadioGroup
        Left = 12
        Top = 258
        Width = 338
        Height = 38
        Caption = #204#229#242#238#228' '#226#237#229#228#240#229#237#232#255':'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          #207#229#240#229#245#226#224#242#251#226#224#242#252' '#241#238#229#228#232#237#229#237#232#229
          #207#229#240#229#245#226#224#242#251#226#224#242#252' '#228#224#237#237#251#229)
        ParentShowHint = False
        ShowHint = False
        TabOrder = 9
        OnClick = lspInterceptMethodClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = #196#238#239#238#235#237#232#242#229#235#252#237#238
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ChkAllowExit: TCheckBox
        Left = 10
        Top = 215
        Width = 340
        Height = 17
        Hint = #208#224#231#240#229#248#224#229#242' '#226#251#245#238#228#232#242#252' '#232#231' '#239#240#238#227#240#224#236#236#251' '#225#229#231' '#237#224#228#238#229#228#235#232#226#238#227#238' "'#226#251' '#243#226#229#240#229#237#237#251'"'
        Caption = #208#224#231#240#229#248#232#242#252' '#226#251#245#238#228' '#232#231' '#239#240#238#227#240#224#236#236#251' '#225#229#231' '#231#224#239#240#238#241#224
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = ChkAionClick
      end
      object ChkShowLogWinOnStart: TCheckBox
        Left = 10
        Top = 238
        Width = 340
        Height = 17
        Hint = #192' '#247#242#238' '#242#243#242' '#237#229#239#238#237#255#242#237#238#227#238' ? =0)'
        Caption = #192#226#242#238#236#224#242#232#247#229#241#234#232' '#239#238#234#224#231#251#226#224#242#252' '#238#234#237#238' '#235#238#227#224' '#239#240#232' '#231#224#239#243#241#234#229
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = ChkAionClick
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 3
        Width = 350
        Height = 206
        Caption = #211#236#238#235#247#224#237#232#255' '#228#235#255' '#244#240#229#233#236#238#226' '#241#238#229#228#232#237#229#237#232#233':'
        TabOrder = 5
        object LabelkNpcID: TLabel
          Left = 3
          Top = 137
          Width = 194
          Height = 13
          Caption = #202#238#253#244#244#232#246#232#229#237#242' '#226#251#247#232#242#224#229#236#251#233' '#232#231' NpcTypeID'
        end
        object Labelwlimit: TLabel
          Left = 11
          Top = 156
          Width = 56
          Height = 13
          Caption = 'w string limit'
        end
        object Labellooplimit: TLabel
          Left = 27
          Top = 183
          Width = 40
          Height = 13
          Caption = 'loop limit'
        end
        object chkAutoSavePlog: TCheckBox
          Left = 5
          Top = 28
          Width = 311
          Height = 17
          Hint = #208#224#231#240#229#248#232#242' '#224#226#242#238#236#224#242#232#247#229#241#234#232' '#241#238#245#240#224#237#255#242#252' '#235#238#227' '#239#224#234#229#242#238#226
          Caption = #192#226#242#238#236#224#242#232#247#229#241#234#232' '#241#238#245#240#224#237#255#242#252' '#235#238#227' '#239#224#234#229#242#238#226
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = ChkAionClick
        end
        object ChkHexViewOffset: TCheckBox
          Left = 5
          Top = 43
          Width = 311
          Height = 17
          Caption = #207#238#234#224#231#251#226#224#242#252' '#241#236#229#249#229#237#232#229' '#226' Hex'
          TabOrder = 1
          OnClick = ChkAionClick
        end
        object ChkShowLastPacket: TCheckBox
          Left = 5
          Top = 57
          Width = 313
          Height = 17
          Caption = #209#235#229#228#232#242#252' '#231#224' '#239#238#241#235#229#228#237#232#236' '#239#224#234#229#242#238#236
          TabOrder = 2
          OnClick = ChkAionClick
        end
        object chkRaw: TCheckBox
          Left = 5
          Top = 71
          Width = 311
          Height = 17
          Hint = 
            #208#224#231#240#229#248#232#242' '#245#240#224#237#232#242#252' '#226#238' '#226#240#229#236#229#237#237#238#236' '#244#224#233#235#229' '#242#238' '#247#242#238' '#239#240#238#232#241#245#238#228#232#242' '#237#224' '#243#240#238#226#237#229' ' +
            #241#229#242#229#226#238#227#238' '#239#240#238#242#238#234#238#235#224'.'
          Caption = #196#224#242#252' '#226#238#231#236#238#230#237#238#241#242#252' '#241#238#245#240#224#237#255#242#252' RAW '#235#238#227#232' '#242#240#224#244#232#234#224
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = ChkAionClick
        end
        object chkNoFree: TCheckBox
          Left = 5
          Top = 86
          Width = 313
          Height = 17
          Hint = 
            #211#241#242#224#237#238#226#232#242' '#224#237#224#235#238#227#232#247#237#243#254' '#238#239#246#232#254' '#228#235#255' '#234#224#230#228#238#227#238' '#244#240#229#233#236#224' '#239#240#232#226#255#231#251#226#224#254#249#229#227#238#241#255' ' +
            #234' '#241#238#229#228#232#237#229#237#232#254'.'
          Caption = #205#229' '#231#224#234#240#251#226#224#242#252' "'#238#234#237#238'" '#241#238#229#228#232#237#229#237#232#255' '#239#238#241#235#229' '#196#232#241#234#238#237#237#229#234#242#224
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = ChkAionClick
        end
        object chkProcessPackets: TCheckBox
          Left = 5
          Top = 101
          Width = 340
          Height = 17
          Hint = 
            #211#241#242#224#237#238#226#232#242' '#224#237#224#235#238#227#232#247#237#243#254' '#238#239#246#232#254' '#228#235#255' '#234#224#230#228#238#227#238' '#244#240#229#233#236#224' '#239#240#232#226#255#231#251#226#224#254#249#229#227#238#241#255' ' +
            #234' '#241#238#229#228#232#237#229#237#232#254'.'
          Caption = #206#225#240#224#225#224#242#251#226#224#242#252' '#239#224#234#229#242#251
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnClick = ChkAionClick
        end
        object EditkNpcID: TEdit
          Left = 217
          Top = 135
          Width = 99
          Height = 21
          Hint = #209#242#224#237#228#224#240#242#237#238#229' '#231#237#224#247#229#237#232#229' 1000000'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          Text = '1000000'
        end
        object ChkChangeParser: TCheckBox
          Left = 5
          Top = 116
          Width = 340
          Height = 17
          Hint = #194#234#235#254#247#232#242#252' '#240#224#231#225#238#240' '#239#224#234#229#242#238#226' '#239#238' java '#232#241#245#238#228#237#232#234#224#236
          Caption = #192#235#252#242#229#240#237#224#242#232#226#237#251#233' '#240#224#231#225#238#240' '#239#224#234#229#242#238#226
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          OnClick = ChkAionClick
        end
        object chkNoLog: TCheckBox
          Left = 5
          Top = 14
          Width = 313
          Height = 17
          Hint = #203#238#227#232' '#237#229' '#237#243#230#237#251
          Caption = #203#238#227#232' '#237#229' '#237#243#230#237#251
          ParentShowHint = False
          ShowHint = True
          TabOrder = 8
          OnClick = ChkAionClick
        end
        object Editwlimit: TEdit
          Left = 73
          Top = 156
          Width = 121
          Height = 21
          TabOrder = 9
          Text = '20'
        end
        object Editlooplimit: TEdit
          Left = 73
          Top = 182
          Width = 121
          Height = 21
          TabOrder = 10
          Text = '500'
        end
      end
      object GroupBox3: TGroupBox
        Left = 3
        Top = 262
        Width = 350
        Height = 45
        Caption = #199#224#227#238#235#238#226#238#234' '#227#235#224#226#237#238#233' '#244#238#240#236#251':'
        TabOrder = 0
        object isMainFormCaption: TEdit
          Left = 3
          Top = 15
          Width = 329
          Height = 21
          TabOrder = 0
          Text = 'L2PacketHack v%s by CoderX.ru'
          OnChange = isMainFormCaptionChange
        end
      end
      object GroupBox4: TGroupBox
        Left = 5
        Top = 313
        Width = 350
        Height = 74
        Caption = 'WinClassName '#227#235#224#226#237#238#233' '#244#238#240#236#251':'
        TabOrder = 1
        object Label3: TLabel
          Left = 44
          Top = 50
          Width = 292
          Height = 13
          Alignment = taRightJustify
          Caption = '*'#228#235#255' '#239#240#232#236#229#237#229#237#232#255' '#253#242#238#233' '#237#224#241#242#240#238#233#234#232' '#242#240#229#225#243#229#242#241#255' '#239#229#240#229#231#224#239#243#241#234' L2ph'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object edWinClassName: TEdit
          Left = 9
          Top = 23
          Width = 329
          Height = 21
          Hint = 
            #207#229#240#229#232#236#229#237#238#226#251#226#224#229#236' WinClassName '#227#235#224#226#237#238#233' '#244#238#240#236#251'. '#210#240#229#225#243#229#242#241#255' '#239#229#240#229#231#224#239#243#241#234 +
            ' '#239#240#238#227#240#224#236#236#251'!'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Text = 'TfMainRep'
          OnChange = isMainFormCaptionChange
        end
      end
      object GroupBox5: TGroupBox
        Left = 3
        Top = 393
        Width = 350
        Height = 74
        Caption = #204#252#254#242#229#234#241' '#227#235#224#226#237#238#233' '#244#238#240#236#251':'
        TabOrder = 2
        object Label8: TLabel
          Left = 46
          Top = 50
          Width = 292
          Height = 13
          Alignment = taRightJustify
          Caption = '*'#228#235#255' '#239#240#232#236#229#237#229#237#232#255' '#253#242#238#233' '#237#224#241#242#240#238#233#234#232' '#242#240#229#225#243#229#242#241#255' '#239#229#240#229#231#224#239#243#241#234' L2ph'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object edMainMutex: TEdit
          Left = 9
          Top = 23
          Width = 329
          Height = 21
          Hint = 
            #207#229#240#229#232#236#229#237#238#226#251#226#224#229#236' '#204#252#254#242#229#234#241' '#227#235#224#226#237#238#233' '#244#238#240#236#251'. '#210#240#229#225#243#229#242#241#255' '#239#229#240#229#231#224#239#243#241#234' '#239#240#238#227 +
            #240#224#236#236#251'!'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Text = 'mainMutex'
          OnChange = isMainFormCaptionChange
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 498
    Width = 371
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object Panel3: TPanel
      Left = 196
      Top = 0
      Width = 175
      Height = 27
      Align = alRight
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      object Button1: TButton
        Left = 11
        Top = 2
        Width = 75
        Height = 23
        Caption = #209#238#245#240#224#237#232#242#252
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 92
        Top = 2
        Width = 75
        Height = 23
        Caption = #206#242#236#229#237#224
        ParentShowHint = False
        ShowHint = False
        TabOrder = 1
        OnClick = Button2Click
      end
    end
  end
  object lang: TsiLang
    Version = '6.1.0.1'
    IsInheritedOwner = True
    StringsTypes.Strings = (
      'TIB_STRINGLIST'
      'TSTRINGLIST')
    SmartExcludeProps.Strings = (
      'Action4.Caption'
      'Action5.Caption'
      'Action6.Caption'
      'Action7.Caption'
      'Action8.Caption'
      'Action9.Caption'
      'Action10.Caption'
      'TL2PacketHackMain.Caption'
      'rgProtocolVersion.Items'
      'isNewxor.Text'
      'isInject.Text'
      'isNewXor.Text'
      'isMainFormCaption.Hint'
      'GroupBox4.Hint'
      'GroupBox5.Hint')
    UseInheritedData = True
    AutoSkipEmpties = True
    NumOfLanguages = 2
    LangDispatcher = fMain.lang
    LangDelim = 1
    DoNotTranslate.Strings = (
      'Action2'
      'Action3')
    LangNames.Strings = (
      'Rus'
      'Eng')
    Language = 'Rus'
    ExcludedProperties.Strings = (
      'Category'
      'SecondaryShortCuts'
      'HelpKeyword'
      'InitialDir'
      'HelpKeyword'
      'ActivePage'
      'ImeName'
      'DefaultExt'
      'FileName'
      'FieldName'
      'PickList'
      'DisplayFormat'
      'EditMask'
      'KeyList'
      'LookupDisplayFields'
      'DropDownSpecRow'
      'TableName'
      'DatabaseName'
      'IndexName'
      'MasterFields')
    ExtendedTranslations = <
      item
        Identifier = 'isLSP.EditLabel.Caption'
        PropertyType = tkLString
        ValuesEx = {
          CFEEEBEDFBE920EFF3F2FC20EA204C535020ECEEE4F3EBFE3A01446972726563
          74207061746820746F204C5350206D6F64756C653A01}
      end
      item
        Identifier = 'isInject.EditLabel.Caption'
        PropertyType = tkLString
        ValuesEx = {
          C8ECFF20E1E8E1EBE8EEF2E5EAE820EFE5F0E5F5E2E0F2FBE2E0FEF9E5E920F1
          EEE5E4E8EDE5EDE8FF3A014E616D65206F6620746865206C6962726172793A01}
      end
      item
        Identifier = 'isNewXor.EditLabel.Caption'
        PropertyType = tkLString
        ValuesEx = {
          CFF1E5E2E4EEEDE8EC204E6577786F723A015061746820746F204E6577586F72
          3A01}
      end
      item
        Identifier = 'isIgnorePorts.EditLabel.Caption'
        PropertyType = tkLString
        ValuesEx = {
          CFEEF0F2FB20E3E5E9ECF1E5F0E2E5F0E02028E1F3E4F3F220EFE5F0E5F5E2E0
          F7E5EDFB293A01475320706F7274732028696E74657263657074293A01}
      end
      item
        Identifier = 'isClientsList.EditLabel.Caption'
        PropertyType = tkLString
        ValuesEx = {
          D1F7E8F2E0F2FC20EAEBE8E5EDF2E0ECE82FE1EEF2E0ECE820EFF0EEE3F0E0EC
          ECFB3A01496E7465726365707420636F6E6E656374696F6E7320696E3A01}
      end
      item
        Identifier = 'lspInterceptMethod.Items'
        PropertyType = tkClass
        ValuesEx = {
          22CFE5F0E5F5E2E0F2FBE2E0F2FC20F1EEE5E4E8EDE5EDE8E5222C22CFE5F0E5
          F5E2E0F2FBE2E0F2FC20E4E0EDEDFBE5220122496E7465726365707420636F6E
          6E656374696F6E222C22496E7465726365707420646174612201}
      end>
    Left = 320
    Top = 32
    TranslationData = {
      737443617074696F6E730D0A546653657474696E677301CDE0F1F2F0EEE9EAE8
      0153657474696E6773010D0A62746E54657374536F636B7335436861696E0154
      6573742028636F6E6E656374206D6963726F736F66742E636F6D3A3830290154
      6573742028636F6E6E656374206D6963726F736F66742E636F6D3A383029010D
      0A427574746F6E3101D1EEF5F0E0EDE8F2FC0153617665010D0A427574746F6E
      3201CEF2ECE5EDE00143616E63656C010D0A43686B416C6C6F774578697401D0
      E0E7F0E5F8E8F2FC20E2FBF5EEE420E8E720EFF0EEE3F0E0ECECFB20E1E5E720
      E7E0EFF0EEF1E001416C6C6F7720746F20657869742066726F6D206C32706820
      776974686F7574207175657374696F6E73010D0A63686B4175746F5361766550
      6C6F6701C0E2F2EEECE0F2E8F7E5F1EAE820F1EEF5F0E0EDFFF2FC20EBEEE320
      EFE0EAE5F2EEE201416C6C6F7720736176696E67207061636B6574206C6F6773
      206175746F6D61746963616C6C79010D0A43686B41696F6E0141696F6E014169
      6F6E010D0A43686B4772616369614F6666014772616369612028F1F2E0E2E8F2
      FC20E4EBFF204F6666696369616C2D6C696B6520536572766572290147726163
      69612028436865636B206F6E204F6666696369616C2D6C696B65205365727665
      7229010D0A43686B486578566965774F666673657401CFEEEAE0E7FBE2E0F2FC
      20F1ECE5F9E5EDE8E520E2204865780153686F77206F666673657420696E2048
      4558010D0A63686B49676E6F7365436C69656E74546F53657276657201CDE520
      EEE1F0E0E1E0F2FBE2E0F2FC20EDE0EFF0E0E2EBE5EDE8E520436C69656E7420
      2D3E205365727665720149676E6F726520646972656374696F6E20436C69656E
      74202D3E20536572766572010D0A63686B49676E6F7365536572766572546F43
      6C69656E7401CDE520EEE1F0E0E1E0F2FBE2E0F2FC20EDE0EFF0E0E2EBE5EDE8
      E520536572766572202D3E20436C69656E740149676E6F726520646972656374
      696F6E20536572766572202D3E20436C69656E74010D0A43686B496E74657263
      65707401CFE5F0E5F5E2E0F23B2020C8F1EAE0F2FC20EAEBE8E5EDF220202020
      20202020202020202020202020202020F1E5EA2E01496E746572636570743B20
      2065616368202020202020202020202020202020202020202020202020202020
      202020202020202020202020207365632E010D0A43686B4B616D61656C014B61
      6D61656C2D48656C6C626F756E642D477261636961014B616D61656C2D48656C
      6C626F756E642D477261636961010D0A43686B4C53504465696E7374616C6C6F
      6E636C6F736501C4E5E8EDF1F2E0EBE8F0EEE2E0F2FC20EFF0E820E2FBF5EEE4
      E520E8E7205048014465696E7374616C6C206C7370206D6F64756C65206F6E20
      706820636C6F73696E67010D0A43686B4C5350496E7465726365707401C8F1EF
      EEEBFCE7EEE2E0F2FC204C535020EFE5F0E5F5E2E0F201557365204C53502064
      7269766572010D0A43686B4E6F4465637279707401CDE520E4E5F8E8F4F0EEE2
      FBE2E0F2FC20F2F0E0F4E8EA01446F206E6F7420646563727970742074726166
      666963010D0A63686B4E6F4672656501CDE520E7E0EAF0FBE2E0F2FC2022EEEA
      EDEE2220F1EEE5E4E8EDE5EDE8FF20EFEEF1EBE520C4E8F1EAEEEDEDE5EAF2E0
      01446F206E6F7420636C6F736520636F6E6E656374696F6E206672616D657301
      0D0A63686B50726F636573735061636B65747301CEE1F0E0E1E0F2FBE2E0F2FC
      20EFE0EAE5F2FB0150726F63657373207061636B657473010D0A63686B526177
      01C4E0F2FC20E2EEE7ECEEE6EDEEF1F2FC20F1EEF5F0E0EDFFF2FC2052415720
      EBEEE3E820F2F0E0F4E8EAE001416C6C6F7720746F207361766520726177206C
      6F6773010D0A43686B53686F774C6173745061636B657401D1EBE5E4E8F2FC20
      E7E020EFEEF1EBE5E4EDE8EC20EFE0EAE5F2EEEC014175746F207363726F6F6C
      20646F776E010D0A43686B53686F774C6F6757696E4F6E537461727401C0E2F2
      EEECE0F2E8F7E5F1EAE820EFEEEAE0E7FBE2E0F2FC20EEEAEDEE20EBEEE3E020
      EFF0E820E7E0EFF3F1EAE50153686F77206C6F672077696E646F77206F6E2073
      746172747570010D0A43686B536F636B73354D6F646501D0E0E1EEF2E0F2FC20
      EAE0EA20536F636B733520F1E5F0E2E5F001576F726B20617320736F636B3520
      736572766572010D0A63686B536F636B73354E6565644175746801D2F0E5E1F3
      E5F2F1FF20E0E2F2EEF0E8E7E0F6E8FF01417574686F72697A6174696F6E2069
      73206E6563657373617279010D0A43686B557365536F636B7335436861696E01
      C8F1EFEEEBFCE7EEE2E0F2FC20534F434B533520F1E5F0E2E5F0015573652073
      706563696669656420736F636B733520736572766572010D0A47726F7570426F
      783101CDE0F1F2F0EEE9EAE820E4EBFF20EDEEE2EEE3EE20EFE5F0E5F5E2E0F7
      E5EDEDEEE3EE20F1EEE5E4E8EDE5EDE8FF3A0153657474696E677320666F7220
      6E657720696E74657263657074656420636F6E6E656374696F6E733A010D0A47
      726F7570426F783201D3ECEEEBF7E0EDE8FF20E4EBFF20F4F0E5E9ECEEE220F1
      EEE5E4E8EDE5EDE8E93A0144656661756C747320666F72206E657720636F6E6E
      656374696F6E206672616D65733A010D0A486F6F6B4D6574686F6401D1EFEEF1
      EEE120E2EDE5E4F0E5EDE8FF20E220EAEBE8E5EDF22FE1EEF23A01496E6A6563
      74207761793A010D0A4C6162656C3101CFF0EEF1EBF3F8E8E2E0E5ECFBE920EF
      EEF0F23A014C697374656E206F6E20706F72743A010D0A4C6162656C32012AE4
      EBFF20EFF0E8ECE5EDE5EDE8FF20FDF2EEE920EDE0F1F2F0EEE9EAE820F2F0E5
      E1F3E5F2F1FF20EFE5F0E5E7E0EFF3F1EA204C327068012A6C327068206D7573
      742062652072657374617274656420746F206170706C79206E657720706F7274
      010D0A4C6162656C340149502F486F7374206E616D653A0149502F486F737420
      6E616D653A010D0A4C6162656C3501506F72743A01506F72743A010D0A4C6162
      656C3601557365726E616D653A01557365726E616D653A010D0A4C6162656C37
      0150617373776F72643A0150617373776F72643A010D0A6C7370496E74657263
      6570744D6574686F6401CCE5F2EEE420E2EDE5E4F0E5EDE8FF3A01496E746572
      63657074206D6574686F643A010D0A506E6C536F636B7335436861696E01D1EE
      EAF6E8F4E8F6E8F0EEE2E0F2FC20EFF0E8EBEEE6E5EDE8E520F7E5F0E5E72053
      4F434B533520F1E5F0E2E5F03A0155736520534F434B5335207365727665723A
      010D0A726750726F746F636F6C56657273696F6E01C2E5F0F1E8FF20EFF0EEF2
      EEEAEEEBE02028F4E0E9EB207061636B6574732E696E69293A0150726F746F63
      6F6C2076657273696F6E20287061636B6574732E696E69293A010D0A54616253
      686565743101C4EEEFEEEBEDE8F2E5EBFCEDEE014164646974696F6E616C010D
      0A54616253686565743801CEE1F9E8E520EDE0F1F2F0EEE9EAE8015072696D61
      72792073657474696E6773010D0A54616253686565743901CDE0F1F2F0EEE9EA
      E820EFE5F0E5F5E2E0F2E001496E746572636570742073657474696E6773010D
      0A4C6162656C6B4E7063494401CAEEFDF4F4E8F6E8E5EDF220E2FBF7E8F2E0E5
      ECFBE920E8E7204E706354797065494401466163746F72207375627472616374
      65642066726F6D204E7063547970654944010D0A47726F7570426F783301C7E0
      E3EEEBEEE2EEEA20E3EBE0E2EDEEE920F4EEF0ECFB3A0143617074696F6D206D
      61696E20666F726D3A010D0A63686B4E6F4C6F6701CBEEE3E820EDE520EDF3E6
      EDFB014C6F677320617265206E6F74206E6565646564010D0A47726F7570426F
      78340157696E436C6173734E616D6520E3EBE0E2EDEEE920F4EEF0ECFB3A0157
      696E436C6173734E616D6520746865206D61696E20666F726D3A010D0A47726F
      7570426F783501CCFCFEF2E5EAF120E3EBE0E2EDEEE920F4EEF0ECFB3A014D75
      746578206D61696E20666F726D3A010D0A4C6162656C33012AE4EBFF20EFF0E8
      ECE5EDE5EDE8FF20FDF2EEE920EDE0F1F2F0EEE9EAE820F2F0E5E1F3E5F2F1FF
      20EFE5F0E5E7E0EFF3F1EA204C327068012A20666F7220757365206F66207468
      69732073657474696E6720726571756972657320612072657374617274204C32
      7068010D0A4C6162656C38012AE4EBFF20EFF0E8ECE5EDE5EDE8FF20FDF2EEE9
      20EDE0F1F2F0EEE9EAE820F2F0E5E1F3E5F2F1FF20EFE5F0E5E7E0EFF3F1EA20
      4C327068012A20666F7220757365206F6620746869732073657474696E672072
      6571756972657320612072657374617274204C327068010D0A43686B4368616E
      676550617273657201C0EBFCF2E5F0EDE0F2E8E2EDFBE920F0E0E7E1EEF020EF
      E0EAE5F2EEE201416E20616C7465726E617469766520616E616C797369732070
      61636B616765010D0A737448696E74730D0A69734C5350014C535020C1E8E1EB
      E8EEF2E5EAE02028C0E1F1EEEBFEF2EDFBE920EFF3F2FC2C20EBE8E1EE20F0E0
      E7ECE5F1F2E8F2FC20E22053595354454D333229014C5350206C696272617279
      2028444952524543542050415448212121212129010D0A43686B53686F774C6F
      6757696E4F6E537461727401C020F7F2EE20F2F3F220EDE5EFEEEDFFF2EDEEE3
      EE203F203D302901736F6D657468696E672077726F6E67203F010D0A69734E65
      77786F7201C1E8E1EBE8EEF2E5EAE020E4EBFF20F1E5F0E2E5F0EEE220F120ED
      E5F1F2E0EDE4E0F0F2EDEEE920F8E8F4F0E0F6E8E5E9014C6962726172792066
      6F7220736572766572732077697468206E6F6E2D7374616E6461726420656E63
      72797074696F6E010D0A6973496E6A65637401C1E8E1EBE8EEF2E5EAE020EEE1
      E5F1EFE5F7E8E2E0FEF9E0FF20EFE5F0E5F5E2E0F220F1EEE5E4E8EDE5EDE8FF
      01496E74657263657074206C696272617279010D0A694E6577786F7201C7E0E3
      F0F3E6E0E5F220F3EAE0E7E0EDF3FE20E1E8E1EBE8EEF2E5EAF3014C6F616420
      7468697320646C6C010D0A69496E6A65637401C7E0E3F0F3E6E0E5F220F3EAE0
      E7E0EDF3FE20E1E8E1EBE8EEF2E5EAF3014C6F6164207468697320646C6C010D
      0A63686B4E6F4C6F6701CBEEE3E820EDE520EDF3E6EDFB014E6F206C6F677301
      0D0A43686B4C5350496E7465726365707401C8F1EFEEEBFCE7F3E5F2204C5350
      20E4EBFF20EFE5F0E5F5E2E0F2E020F2F0E0F4F4E8EAE0014C53502070726F76
      696465722077696C6C206265207573656420666F72207472616666696320696E
      74657263657074010D0A4A765370696E456469743101CAE0EA20F7E0F1F2EE20
      E8F1EAE0F2FC20EFF0EEE3F0E0ECECFB20E4EBFF20EFE5F0E5F5E2E0F2E00148
      6F77206F6674656E206C3270682077696C6C2073656172636820666F72206E65
      77206C3220636C69656E7473010D0A47726F7570426F783101CDE520E1F3E4E5
      F220E2EBE8FFF2FC20EDE020F3E6E520F1F3F9E5F1F2E2F3FEF9E8E50157696C
      6C206E6F742061666665637420746865206578697374696E6720636F6E6E6563
      74696F6E73010D0A63686B49676E6F7365436C69656E74546F53657276657201
      CDE520E1F3E4E5F220EEE1F0E0E1E0F2FBE2E0F2FC20F2F0E0F4E8EA20E8E4F3
      F9E8E920EEF220EAEBE8E5EDF2E020EDE020F1E5F0E2E5F001576F6E74207072
      6F63657373207472616669636B20696E20636C69656E743E7365727665722064
      697272656374696F6E010D0A63686B49676E6F7365536572766572546F436C69
      656E7401CDE520E1F3E4E5F220EEE1F0E0E1E0F2FBE2E0F2FC20F2F0E0F4E8EA
      20E8E4F3F9E8E920EEF220F1E5F0E2E5F0E020EDE020EAEBE8E5EDF201576F6E
      742070726F63657373207472616669636B20696E207365727665723E636C6965
      6E742064697272656374696F6E010D0A43686B41696F6E01D3F1F2E0EDEEE2E8
      F2FC20E4EBFF20F1E5F0E2E5F0EEE220F2E8EFE02041696F6E014D7573742062
      6520636B65636B656420666F7220746861742074797065206F66207365727665
      7273010D0A43686B536F636B73354D6F646501CFE0EAE5F2F5E0EA20F0E0E1EE
      F2E0E5F220EAE0EA20EFF0EEEAF1E82DF1E5F0E2E5F0016C3270682077696C6C
      20626520737769746368656420746F20776F726B20617320736F636B73207365
      72766572010D0A656457696E436C6173734E616D6501CFE5F0E5E8ECE5EDEEE2
      FBE2E0E5EC2057696E436C6173734E616D6520E3EBE0E2EDEEE920F4EEF0ECFB
      2E20D2F0E5E1F3E5F2F1FF20EFE5F0E5E7E0EFF3F1EA20EFF0EEE3F0E0ECECFB
      210152656E616D652057696E436C6173734E616D6520746865206D61696E2066
      6F726D2E20526571756972657320612072657374617274206F66207468652070
      726F6772616D21010D0A65644D61696E4D7574657801CFE5F0E5E8ECE5EDEEE2
      FBE2E0E5EC20CCFCFEF2E5EAF120E3EBE0E2EDEEE920F4EEF0ECFB2E20D2F0E5
      E1F3E5F2F1FF20EFE5F0E5E7E0EFF3F1EA20EFF0EEE3F0E0ECECFB210152656E
      616D6520746865206D7574657820746865206D61696E20666F726D2E20526571
      756972657320612072657374617274206F66207468652070726F6772616D2101
      0D0A43686B4E6F4465637279707401CFEEEAE0E7FBE2E0E5F220F2F0E0F4E8EA
      20EAE0EA20EEED20EFF0E8F5EEE4E8F20157696C6C2073686F77207472616666
      69632061736973010D0A4A765370696E456469743201CFEEF0F201506F727401
      0D0A697349676E6F7265506F72747301CFEEF0F2FB2C20EAEEEDEDE5EAF2FB20
      EDE020EAEEF2EEF0FBE520EDE0E4EE20EFE5F0E5F5E2E0F2FBE2E0F2FC01446F
      20696E7465726365707420636F6E6E656374696F6E73206F6E20706F72747301
      0D0A6973436C69656E74734C69737401CFF0EEE3F0E0ECECFB20F320EAEEF2EE
      F0FBF520E1F3E4E5EC20EFE5F0E5F5E2E0F2FBE2E0F2FC20F2F0E0F4E8EA0141
      70706C69636174696F6E7320776869636820636F6E6E656374696F6E73206D75
      737420626520696E746572636570746564010D0A43686B416C6C6F7745786974
      01D0E0E7F0E5F8E0E5F220E2FBF5EEE4E8F2FC20E8E720EFF0EEE3F0E0ECECFB
      20E1E5E720EDE0E4EEE5E4EBE8E2EEE3EE2022E2FB20F3E2E5F0E5EDEDFB2201
      416C6C6F772065786974696E6720776974686F757420616E6F79696E67202261
      726520796F7520737572653F22010D0A43686B496E7465726365707401D0E0E7
      F0E5F8E0E5F220EFEEE8F1EA20EDEEE2FBF520EAEBE8E5EDF2EEE22C20E820EF
      E5F0E5F5E2E0F220E8F520F1EEE5E4E8EDE5EDE8E901416C6C6F7720666F2075
      736520696E6A6563742E646C6C20666F7220636F6E6E656374696F6E7320696E
      74657263657074010D0A63686B4175746F53617665506C6F6701D0E0E7F0E5F8
      E8F220E0E2F2EEECE0F2E8F7E5F1EAE820F1EEF5F0E0EDFFF2FC20EBEEE320EF
      E0EAE5F2EEE201416C6C6F7720746F206175746F6D61746963616C6C79207361
      766520746865206C6F67207061636B616765010D0A63686B52617701D0E0E7F0
      E5F8E8F220F5F0E0EDE8F2FC20E2EE20E2F0E5ECE5EDEDEEEC20F4E0E9EBE520
      F2EE20F7F2EE20EFF0EEE8F1F5EEE4E8F220EDE020F3F0EEE2EDE520F1E5F2E5
      E2EEE3EE20EFF0EEF2EEEAEEEBE02E01416C6C6F777320746F2073746F726520
      7261776C6F6720696E2074656D702066696C6520616E64207361766520697420
      7768656E206E6565646564010D0A43686B4C53504465696E7374616C6C6F6E63
      6C6F736501D1EDE8ECE0E5F220F0E5E3E8F1F2F0E0F6E8FE204C535020ECEEE4
      F3EBFF20EFF0E820E7E0E2E5F0F8E5EDE8E820F0E0E1EEF2FB206C3270680157
      696C6C2075696E7374616C6C206C7370206D6F64756C65206F6E20706820636C
      6F73696E67010D0A63686B50726F636573735061636B65747301D3F1F2E0EDEE
      E2E8F220E0EDE0EBEEE3E8F7EDF3FE20EEEFF6E8FE20E4EBFF20EAE0E6E4EEE3
      EE20F4F0E5E9ECE020EFF0E8E2FFE7FBE2E0FEF9E5E3EEF1FF20EA20F1EEE5E4
      E8EDE5EDE8FE2E0144656661756C747320666F7220636F6E6E656374696F6E20
      6672616D65010D0A63686B4E6F4672656501D3F1F2E0EDEEE2E8F220E0EDE0EB
      EEE3E8F7EDF3FE20EEEFF6E8FE20E4EBFF20EAE0E6E4EEE3EE20F4F0E5E9ECE0
      20EFF0E8E2FFE7FBE2E0FEF9E5E3EEF1FF20EA20F1EEE5E4E8EDE5EDE8FE2E01
      57696C6C207365742073616D65206F7074696F6E20666F722065616368206E65
      7720636F6E6E656374696F6E206672616D65010D0A43686B4B616D61656C01D3
      F1F2E0EDEEE2E8F2FC20E4EBFF20F1E5F0E2E5F0EEE220F2E8EFE0204B616D61
      656C202D2048656C6C626F756E64202D20477261636961014D75737420626520
      636B65636B656420666F7220746861742074797065206F662073657276657273
      010D0A43686B4772616369614F666601D3F1F2E0EDEEE2E8F2FC20F2EEEBFCEA
      EE20E4EBFF20F0F3F1F1EAEEE3EE20EEF4E8F6E8E0EBFCEDEEE3EE20F1E5F0E2
      E5F0E0204C322E5255014F6E6C7920666F72206C322E7275010D0A456469746B
      4E7063494401D1F2E0EDE4E0F0F2EDEEE520E7EDE0F7E5EDE8E5203130303030
      3030015468652064656661756C742076616C75652031303030303030010D0A43
      686B4368616E676550617273657201C2EAEBFEF7E8F2FC20F0E0E7E1EEF020EF
      E0EAE5F2EEE220EFEE206A61766120E8F1F5EEE4EDE8EAE0EC01456E61626C65
      20616E616C79736973206F6620736F7572636520636F6465207061636B616765
      206F6E206A617661010D0A7374446973706C61794C6162656C730D0A7374466F
      6E74730D0A546653657474696E6773014D532053616E7320536572696601010D
      0A4C6162656C32014D532053616E7320536572696601010D0A506E6C536F636B
      7335436861696E014D532053616E7320536572696601010D0A4C6162656C3301
      4D532053616E7320536572696601010D0A4C6162656C38014D532053616E7320
      536572696601010D0A73744D756C74694C696E65730D0A486F6F6B4D6574686F
      642E4974656D7301CDE0E4E5E6EDFBE92CD1EAF0FBF2EDFBE92CC0EBFCF2E5F0
      EDE0F2E8E2EDFBE90152656C6961626C652C436C616D2C416C7465726E617469
      7665010D0A6C7370496E746572636570744D6574686F642E4974656D730122CF
      E5F0E5F5E2E0F2FBE2E0F2FC20F1EEE5E4E8EDE5EDE8E5222C22CFE5F0E5F5E2
      E0F2FBE2E0F2FC20E4E0EDEDFBE5220122496E7465726365707420636F6E6E65
      6374222C22496E74657263657074206461746122010D0A7374446C6773436170
      74696F6E730D0A5761726E696E67015761726E696E67015761726E696E67010D
      0A4572726F72014572726F72014572726F72010D0A496E666F726D6174696F6E
      01496E666F726D6174696F6E01496E666F726D6174696F6E010D0A436F6E6669
      726D01436F6E6669726D01436F6E6669726D010D0A5965730126596573012659
      6573010D0A4E6F01264E6F01264E6F010D0A4F4B014F4B014F4B010D0A43616E
      63656C0143616E63656C0143616E63656C010D0A41626F7274012641626F7274
      012641626F7274010D0A52657472790126526574727901265265747279010D0A
      49676E6F7265012649676E6F7265012649676E6F7265010D0A416C6C0126416C
      6C0126416C6C010D0A4E6F20546F20416C6C014E266F20746F20416C6C014E26
      6F20746F20416C6C010D0A59657320546F20416C6C0159657320746F2026416C
      6C0159657320746F2026416C6C010D0A48656C70012648656C70012648656C70
      010D0A7374537472696E67730D0A4944535F313801C2FB20F3E2E5F0E5EDFB20
      F7F2EE20F5EEF2E8F2E520E2FBE9F2E820E8E720EFF0EEE3F0E0ECECFB3F0141
      726520796F752073757265203F010D0A4944535F313901C2F1E520F1EEE5E4E8
      EDE5EDE8FF20EFF0E5F0E2F3F2F1FF2101416C6C20636F6E6E656374696F6E73
      2077696C6C20626520636C6F73656421010D0A4944535F3601D0E0E7F0E0E1EE
      F2F7E8EAE8203A0144657627733A010D0A4944535F3901D1F2E0F0F2F3E5F220
      4C32706820760153746172747570206F66204C3270682076010D0A73744F7468
      6572537472696E67730D0A646C674F70656E446C6C2E46696C74657201446C6C
      20F4E0E9EB20282A2E446C6C297C2A2E446C6C7CC2F1E520F4E0E9EBFB20282A
      2E2A297C2A2E2A01446C6C2066696C6520282A2E446C6C297C2A2E446C6C7C41
      6C6C2046696C6573282A2E2A297C2A2E2A010D0A6564536F636B7335506F7274
      2E54657874013130383001010D0A456469746B4E706349442E54657874013130
      303030303001010D0A69734D61696E466F726D43617074696F6E2E5465787401
      4C325061636B65744861636B2076257320627920436F646572582E727501010D
      0A656457696E436C6173734E616D652E546578740154664D61696E5265700101
      0D0A65644D61696E4D757465782E54657874016D61696E4D7574657801010D0A
      69734C53502E54657874016C73702E646C6C01010D0A73744C6F63616C65730D
      0A7374436F6C6C656374696F6E730D0A737443686172536574730D0A54665365
      7474696E67730144454641554C545F434841525345540144454641554C545F43
      484152534554010D0A4C6162656C3201414E53495F4348415253455401444546
      41554C545F43484152534554010D0A506E6C536F636B7335436861696E014445
      4641554C545F434841525345540144454641554C545F43484152534554010D0A
      4C6162656C3301414E53495F434841525345540144454641554C545F43484152
      534554010D0A4C6162656C3801414E53495F434841525345540144454641554C
      545F43484152534554010D0A}
  end
  object dlgOpenDll: TOpenDialog
    DefaultExt = '*.Dll'
    Filter = 'Dll '#244#224#233#235' (*.Dll)|*.Dll|'#194#241#229' '#244#224#233#235#251' (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 287
    Top = 33
  end
end
