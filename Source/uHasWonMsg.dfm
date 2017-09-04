object fmHasWon: TfmHasWon
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 676
  ClientWidth = 929
  Color = clBtnFace
  ParentFont = True
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 910
    Height = 57
    Shape = bsFrame
  end
  object lblMsg: TLabel
    Left = 384
    Top = 24
    Width = 208
    Height = 23
    Caption = #1057#1074#1086#1076#1085#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 590
    Top = 510
    Width = 205
    Height = 13
    Caption = #1058#1077#1082#1091#1097#1072#1103' '#1076#1083#1080#1090'-'#1090#1100' '#1094#1077#1083#1077#1074#1086#1075#1086' '#1089#1090#1080#1084#1091#1083#1072', '#1084#1089':'
  end
  object chrtCommonCriteria: TChart
    Left = 8
    Top = 64
    Width = 846
    Height = 313
    Legend.Visible = False
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    View3D = False
    TabOrder = 1
    object srsCurCommonCriteria: TBarSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      SeriesColor = clGreen
      BarWidthPercent = 100
      Gradient.Direction = gdTopBottom
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object btnOk: TButton
    Left = 388
    Top = 626
    Width = 129
    Height = 40
    Caption = 'Ok'
    TabOrder = 0
    OnClick = btnOkClick
  end
  object redtInstruction: TRichEdit
    Left = 8
    Top = 64
    Width = 910
    Height = 361
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      
        '   '#1057' '#1087#1088#1072#1074#1086#1081' '#1089#1090#1086#1088#1086#1085#1099' '#1073#1091#1076#1077#1090' '#1087#1086#1103#1074#1083#1103#1090#1100#1089#1103' '#1096#1072#1088#1080#1082', '#1082#1086#1090#1086#1088#1099#1081' '#1073#1091#1076#1077#1090' '#1073#1099#1089#1090#1088#1086 +
        ' '#1087#1088#1086#1083#1077#1090#1072#1090#1100' '#1087#1086' '#1101#1082#1088#1072#1085#1091', '#1080#1089#1095#1077#1079#1072#1103' '#1089#1083#1077#1074#1072'. '#1042#1072#1096#1072' '#1079#1072#1076#1072#1095#1072' '
      
        #1087#1086#1076#1085#1103#1090#1100' '#1087#1072#1083#1077#1094' '#1090#1086#1095#1085#1086' '#1074' '#1090#1086#1090' '#1084#1086#1084#1077#1085#1090', '#1082#1086#1075#1076#1072' '#1096#1072#1088#1080#1082' '#1086#1082#1072#1078#1077#1090#1089#1103' '#1085#1072' '#1087#1077#1088#1077#1089#1077 +
        #1095#1077#1085#1080#1080' '#1074#1077#1088#1090#1080#1082#1072#1083#1100#1085#1086#1081' '#1087#1086#1083#1086#1089#1099'. '#1055#1086#1089#1090#1072#1088#1072#1081#1090#1077#1089#1100' '#1091#1083#1086#1074#1080#1090#1100' '
      #1085#1091#1078#1085#1099#1081' '#1084#1086#1084#1077#1085#1090' '#1089#1086#1074#1077#1088#1096#1077#1085#1080#1103' '#1076#1077#1081#1089#1090#1074#1080#1103'. ')
    ParentFont = False
    TabOrder = 2
  end
  object rgrpsAnswer: TGroupBox
    Left = 8
    Top = 423
    Width = 910
    Height = 74
    Caption = #1041#1072#1083#1083' '#1086#1097#1091#1097#1077#1085#1080#1103' '#1072#1074#1090#1086#1088#1089#1090#1074#1072' '#1076#1074#1080#1078#1077#1085#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Label2: TLabel
      Left = 91
      Top = 50
      Width = 9
      Height = 21
      Caption = '0'
    end
    object Label4: TLabel
      Left = 255
      Top = 50
      Width = 9
      Height = 21
      Caption = '2'
    end
    object Label5: TLabel
      Left = 337
      Top = 50
      Width = 9
      Height = 21
      Caption = '3'
    end
    object Label6: TLabel
      Left = 419
      Top = 50
      Width = 9
      Height = 21
      Caption = '4'
    end
    object Label7: TLabel
      Left = 500
      Top = 50
      Width = 9
      Height = 21
      Caption = '5'
    end
    object Label8: TLabel
      Left = 582
      Top = 50
      Width = 9
      Height = 21
      Caption = '6'
    end
    object Label9: TLabel
      Left = 664
      Top = 50
      Width = 9
      Height = 21
      Caption = '7'
    end
    object Label10: TLabel
      Left = 746
      Top = 50
      Width = 9
      Height = 21
      Caption = '8'
    end
    object Label3: TLabel
      Left = 173
      Top = 50
      Width = 9
      Height = 21
      Caption = '1'
    end
    object Label11: TLabel
      Left = 3
      Top = 50
      Width = 29
      Height = 21
      Caption = 'N/A'
    end
    object Label12: TLabel
      Left = 828
      Top = 50
      Width = 9
      Height = 21
      Caption = '9'
    end
    object SldrAgencyVal: TJvxSlider
      Left = 3
      Top = 20
      Width = 840
      Height = 30
      Increment = 1
      MaxValue = 10
      TabOrder = 0
      OnChange = SldrAgencyValChange
    end
    object edtAgencyVal: TEdit
      Left = 849
      Top = 32
      Width = 54
      Height = 37
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = 'N/A'
    end
  end
  object btn_7: TButton
    Tag = 7
    Left = 412
    Top = 503
    Width = 30
    Height = 30
    Caption = '7'
    TabOrder = 4
    OnClick = btnDigitalBtnsClick
  end
  object btn_8: TButton
    Tag = 8
    Left = 441
    Top = 503
    Width = 30
    Height = 30
    Caption = '8'
    TabOrder = 5
    OnClick = btnDigitalBtnsClick
  end
  object btn_9: TButton
    Tag = 9
    Left = 470
    Top = 503
    Width = 30
    Height = 30
    Caption = '9'
    TabOrder = 6
    OnClick = btnDigitalBtnsClick
  end
  object btn_4: TButton
    Tag = 4
    Left = 412
    Top = 532
    Width = 30
    Height = 30
    Caption = '4'
    TabOrder = 7
    OnClick = btnDigitalBtnsClick
  end
  object btn_5: TButton
    Tag = 5
    Left = 441
    Top = 532
    Width = 30
    Height = 30
    Caption = '5'
    TabOrder = 8
    OnClick = btnDigitalBtnsClick
  end
  object btn_6: TButton
    Tag = 6
    Left = 470
    Top = 532
    Width = 30
    Height = 30
    Caption = '6'
    TabOrder = 9
    OnClick = btnDigitalBtnsClick
  end
  object btn_1: TButton
    Tag = 1
    Left = 412
    Top = 561
    Width = 30
    Height = 30
    Caption = '1'
    TabOrder = 10
    OnClick = btnDigitalBtnsClick
  end
  object btn_2: TButton
    Tag = 2
    Left = 441
    Top = 561
    Width = 30
    Height = 30
    Caption = '2'
    TabOrder = 11
    OnClick = btnDigitalBtnsClick
  end
  object btn_3: TButton
    Tag = 3
    Left = 470
    Top = 561
    Width = 30
    Height = 30
    Caption = '3'
    TabOrder = 12
    OnClick = btnDigitalBtnsClick
  end
  object btn_0: TButton
    Left = 412
    Top = 590
    Width = 59
    Height = 30
    Caption = '0'
    TabOrder = 13
    OnClick = btnDigitalBtnsClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 503
    Width = 182
    Height = 66
    Caption = #1057#1091#1073#1098#1077#1082#1090#1080#1074#1085#1086#1077' '#1074#1088#1077#1084#1103' '#1089#1080#1075#1085#1072#1083#1072' '#1054#1057
    TabOrder = 14
    object SpnEdFeedbackSignalDelay: TJvSpinEdit
      Left = 16
      Top = 23
      Width = 97
      Height = 37
      MaxValue = 999.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = SpnEdFeedbackSignalDelayChange
    end
  end
  object edtAlertDurationTime: TEdit
    Left = 801
    Top = 507
    Width = 51
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 15
    Text = '0'
  end
  object btn_C: TButton
    Tag = 3
    Left = 470
    Top = 590
    Width = 30
    Height = 30
    Caption = 'C'
    TabOrder = 16
    OnClick = btn_CClick
  end
  object tmrAutoCloseWnd: TJvTimer
    EventTime = tetPost
    Enabled = False
    OnTimer = tmrAutoCloseWndTimer
    Left = 760
    Top = 8
  end
  object tmrDraw: TJvTimer
    EventTime = tetPost
    Enabled = False
    Interval = 20
    Threaded = False
    OnTimer = tmrDrawTimer
    Left = 672
    Top = 16
  end
end
