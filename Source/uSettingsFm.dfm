object fmSettings: TfmSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Game settings'
  ClientHeight = 526
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label30: TLabel
    Left = 22
    Top = 462
    Width = 145
    Height = 13
    Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1089#1077#1089#1089#1080#1080':'
  end
  object Button1: TButton
    Left = 191
    Top = 493
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 0
  end
  object GroupBox7: TGroupBox
    Left = 8
    Top = 8
    Width = 265
    Height = 97
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1101#1082#1088#1072#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label24: TLabel
      Left = 14
      Top = 21
      Width = 84
      Height = 13
      Caption = #1060#1086#1088#1084#1072#1090' '#1074#1099#1074#1086#1076#1072':'
    end
    object CmbBxScrAdj: TComboBox
      Left = 14
      Top = 39
      Width = 119
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '1024'#1093'768,32'
      Items.Strings = (
        '1024'#1093'768,32'
        '1280'#1093'1050,32'
        '1680'#1093'1050,32')
    end
    object ChBxFullScr: TCheckBox
      Left = 14
      Top = 66
      Width = 139
      Height = 17
      Caption = #1055#1086#1083#1085#1086#1101#1082#1088#1072#1085#1085#1099#1081' '#1088#1077#1078#1080#1084
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 1
    end
  end
  object Button2: TButton
    Left = 279
    Top = 493
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 279
    Top = 8
    Width = 270
    Height = 97
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1080#1075#1088#1099
    TabOrder = 3
    Visible = False
    object Label2: TLabel
      Left = 16
      Top = 21
      Width = 72
      Height = 13
      Caption = #1056#1072#1079#1084#1077#1088' '#1076#1086#1089#1082#1080':'
      Visible = False
    end
    object Label3: TLabel
      Left = 150
      Top = 21
      Width = 61
      Height = 13
      Caption = #1059#1088#1086#1074#1077#1085#1100' AI:'
      Visible = False
    end
    object Label4: TLabel
      Left = 16
      Top = 48
      Width = 70
      Height = 13
      Caption = #1062#1077#1083#1077#1074#1086#1081' '#1088#1103#1076':'
      Visible = False
    end
    object SEdBoardSize: TJvSpinEdit
      Left = 94
      Top = 18
      Width = 50
      Height = 21
      MaxValue = 20.000000000000000000
      MinValue = 5.000000000000000000
      Value = 10.000000000000000000
      TabOrder = 0
      Visible = False
    end
    object SEdAIPower: TJvSpinEdit
      Left = 217
      Top = 18
      Width = 50
      Height = 21
      MaxValue = 8.000000000000000000
      MinValue = 1.000000000000000000
      Value = 2.000000000000000000
      TabOrder = 1
      Visible = False
    end
    object SEdGoalLineCnt: TJvSpinEdit
      Left = 92
      Top = 45
      Width = 50
      Height = 21
      MaxValue = 10.000000000000000000
      MinValue = 3.000000000000000000
      Value = 5.000000000000000000
      TabOrder = 2
      Visible = False
    end
    object ChkBxDialogAutoHideTimer: TCheckBox
      Left = 16
      Top = 72
      Width = 251
      Height = 17
      Caption = #1040#1074#1090#1086#1079#1072#1082#1088#1099#1090#1080#1077' '#1076#1080#1072#1083#1086#1075#1086#1074#1086#1075#1086' '#1086#1082#1085#1072' '#1087#1086' '#1090#1072#1081#1084#1077#1088#1091
      TabOrder = 3
    end
  end
  object tpSessionDuration: TDateTimePicker
    Left = 173
    Top = 459
    Width = 74
    Height = 21
    Date = 42321.000000000000000000
    Time = 42321.000000000000000000
    DateMode = dmUpDown
    DoubleBuffered = True
    Kind = dtkTime
    ParentDoubleBuffered = False
    TabOrder = 4
    OnChange = tpSessionDurationChange
  end
  object rgrpExpVariants: TRadioGroup
    Left = 8
    Top = 103
    Width = 541
    Height = 338
    Caption = #1042#1072#1088#1080#1072#1085#1090#1099' '#1101#1082#1089#1087#1077#1088#1080#1084#1077#1085#1090#1072
    ItemIndex = 0
    Items.Strings = (
      '1 '#1074#1072#1088#1080#1072#1085#1090' '#1101#1082#1089#1087#1077#1088#1080#1084#1077#1085#1090#1072' ('#1085#1086#1088#1084'.'#1088#1077#1072#1075#1080#1088#1086#1074#1072#1085#1080#1077' '#1073#1077#1079' FAct, Dec TLit)'
      
        '2 '#1074#1072#1088#1080#1072#1085#1090' '#1101#1082#1089#1087#1077#1088#1080#1084#1077#1085#1090#1072' ('#1087#1072#1089#1089#1080#1074#1085#1086'-'#1072#1082#1090#1080#1074#1085#1099#1077' '#1076#1074#1080#1078'. FAct delay=AvrgR' +
        'T)'
      '3 '#1074#1072#1088#1080#1072#1085#1090' '#1101#1082#1089#1087#1077#1088#1080#1084#1077#1085#1090#1072' ('#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1076#1074#1080#1078'.  FAct delay=Rand)'
      '4 '#1074#1072#1088#1080#1072#1085#1090' '#1101#1082#1089#1087#1077#1088#1080#1084#1077#1085#1090#1072' ('#1087#1072#1089#1089#1080#1074#1085#1099#1077' '#1076#1074#1080#1078'. FAct delay=AvrgRT)'
      '5 '#1074#1072#1088#1080#1072#1085#1090' '#1101#1082#1089#1087#1077#1088#1080#1084#1077#1085#1090#1072' ('#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1076#1074#1080#1078'. FAct delay=0ms)'
      '6 '#1074#1072#1088#1080#1072#1085#1090' '#1101#1082#1089#1087#1077#1088#1080#1084#1077#1085#1090#1072' ()'
      '7 '#1074#1072#1088#1080#1072#1085#1090' '#1101#1082#1089#1087#1077#1088#1080#1084#1077#1085#1090#1072' ('#1090#1077#1089#1090' '#1090#1086#1095#1085#1086#1089#1090#1080' '#1088#1077#1072#1082#1094#1080#1080')'
      '8 '#1074#1072#1088#1080#1072#1085#1090' '#1101#1082#1089#1087#1077#1088#1080#1084#1077#1085#1090#1072' ('#1090#1077#1089#1090' '#1090#1086#1095#1085#1086#1089#1090#1080' '#1088#1077#1072#1082#1094#1080#1080', '#1073#1077#1079' '#1054#1057')'
      
        '9 '#1074#1072#1088#1080#1072#1085#1090' '#1101#1082#1089#1087#1077#1088#1080#1084#1077#1085#1090#1072' ('#1087#1072#1089#1089#1080#1074#1085#1086'-'#1072#1082#1090'.'#1076#1074#1080#1078'-'#1103' '#1089' 30% '#1085#1077#1072#1075#1077#1085#1090'.'#1089#1086#1073#1099#1090#1080 +
        #1081')'
      '10 '#1074#1072#1088#1080#1072#1085#1090' '#1101#1082#1089#1087#1077#1088#1080#1084#1077#1085#1090#1072' ('#1087#1086#1080#1089#1082' '#1087#1086#1088#1086#1075#1072' '#1087#1086' '#1087#1072#1089#1089#1080#1074#1085#1099#1084' '#1076#1074#1080#1078#1077#1085#1080#1103#1084')'
      '11 '#1074#1072#1088#1080#1072#1085#1090' '#1101#1082#1089#1087#1077#1088#1080#1084#1077#1085#1090#1072' ('#1087#1086#1080#1089#1082' '#1087#1086#1088#1086#1075#1072' '#1087#1086' '#1072#1082#1090#1080#1074#1085#1099#1084' '#1076#1074#1080#1078#1077#1085#1080#1103#1084')')
    TabOrder = 5
    OnClick = rgrpExpVariantsClick
  end
end
