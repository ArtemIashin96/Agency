object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'AgencyExpServoFinfer'
  ClientHeight = 869
  ClientWidth = 1574
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1574
    Height = 869
    ActivePage = TabSheet3
    Align = alClient
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'JoyParams'
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 81
        Height = 704
        Caption = 'Limb one'
        TabOrder = 0
        object lblLPPos1: TLabel
          Left = 4
          Top = 20
          Width = 38
          Height = 13
          Caption = 'LPPos1:'
        end
        object Label4: TLabel
          Left = 4
          Top = 58
          Width = 38
          Height = 13
          Caption = 'LPPos2:'
        end
        object Label3: TLabel
          Left = 4
          Top = 100
          Width = 45
          Height = 13
          Caption = 'LPDifPos:'
        end
        object Label5: TLabel
          Left = 3
          Top = 142
          Width = 57
          Height = 13
          Caption = 'LPMaxTime:'
        end
        object Label6: TLabel
          Left = 3
          Top = 225
          Width = 52
          Height = 13
          Caption = 'ValuesLen:'
        end
        object Label7: TLabel
          Left = 3
          Top = 273
          Width = 52
          Height = 13
          Caption = 'UpCriteria:'
        end
        object Label8: TLabel
          Left = 3
          Top = 182
          Width = 53
          Height = 13
          Caption = 'LPMinTime:'
        end
        object Label16: TLabel
          Left = 3
          Top = 313
          Width = 66
          Height = 13
          Caption = 'DownCriteria:'
        end
        object Label18: TLabel
          Left = 8
          Top = 361
          Width = 55
          Height = 13
          Caption = 'FullCriteria:'
        end
        object TrckBarLP: TTrackBar
          Left = 29
          Top = 416
          Width = 45
          Height = 278
          Max = 1023
          Orientation = trVertical
          Position = 1023
          TabOrder = 0
          TickStyle = tsNone
        end
        object edtLPPos1: TEdit
          Left = 3
          Top = 34
          Width = 71
          Height = 21
          TabOrder = 1
          Text = '0'
        end
        object edtLPPos2: TEdit
          Left = 3
          Top = 72
          Width = 71
          Height = 21
          TabOrder = 2
          Text = '0'
        end
        object edtLPDifPos: TEdit
          Left = 3
          Top = 115
          Width = 71
          Height = 21
          TabOrder = 3
          Text = '0'
        end
        object edtLPMaxTime: TEdit
          Left = 3
          Top = 158
          Width = 71
          Height = 21
          TabOrder = 4
          Text = '0'
        end
        object edtLPValuesLen: TEdit
          Left = 3
          Top = 244
          Width = 71
          Height = 21
          TabOrder = 5
          Text = '0'
        end
        object edtLPCritUpValue: TEdit
          Left = 3
          Top = 290
          Width = 71
          Height = 21
          TabOrder = 6
          Text = '0'
        end
        object edtLPMinTime: TEdit
          Left = 3
          Top = 198
          Width = 71
          Height = 21
          TabOrder = 7
          Text = '0'
        end
        object edtLPCritDownValue: TEdit
          Left = 3
          Top = 330
          Width = 71
          Height = 21
          TabOrder = 8
          Text = '0'
        end
        object edtLPFullCritValue: TEdit
          Left = 7
          Top = 378
          Width = 71
          Height = 21
          TabOrder = 9
          Text = '0'
        end
      end
      object GroupBox2: TGroupBox
        Left = 269
        Top = 8
        Width = 228
        Height = 374
        Caption = 'Common parameters'
        TabOrder = 1
        object Label9: TLabel
          Left = 11
          Top = 17
          Width = 72
          Height = 13
          Caption = 'Pedal time diff:'
          Visible = False
        end
        object Label15: TLabel
          Left = 11
          Top = 61
          Width = 72
          Height = 13
          Caption = 'Pedal time diff:'
          Visible = False
        end
        object Label20: TLabel
          Left = 11
          Top = 291
          Width = 81
          Height = 13
          Caption = 'Common criteria:'
        end
        object Label21: TLabel
          Left = 11
          Top = 251
          Width = 79
          Height = 13
          Caption = 'Synchro criteria:'
          Visible = False
        end
        object Label31: TLabel
          Left = 11
          Top = 111
          Width = 69
          Height = 13
          Caption = 'Yoke time diff:'
          Visible = False
        end
        object Label32: TLabel
          Left = 11
          Top = 155
          Width = 69
          Height = 13
          Caption = 'Yoke time diff:'
          Visible = False
        end
        object edtDifPedalsMaxTimeNotifictn: TEdit
          Left = 11
          Top = 36
          Width = 206
          Height = 21
          TabOrder = 0
          Visible = False
        end
        object edtDifPedalsMinTimeNotifictn: TEdit
          Left = 11
          Top = 80
          Width = 206
          Height = 21
          TabOrder = 1
          Visible = False
        end
        object edtCommonCrit: TEdit
          Left = 11
          Top = 310
          Width = 206
          Height = 21
          TabOrder = 2
        end
        object edtSynchroCriteria: TEdit
          Left = 11
          Top = 270
          Width = 206
          Height = 21
          TabOrder = 3
          Visible = False
        end
        object edtDifYokeMaxTimeNotifictn: TEdit
          Left = 11
          Top = 130
          Width = 206
          Height = 21
          TabOrder = 4
          Visible = False
        end
        object edtDifYokeMinTimeNotifictn: TEdit
          Left = 11
          Top = 174
          Width = 206
          Height = 21
          TabOrder = 5
          Visible = False
        end
      end
      object GroupBox3: TGroupBox
        Left = 95
        Top = 8
        Width = 81
        Height = 704
        Caption = 'Limb Two'
        TabOrder = 2
        object Label10: TLabel
          Left = 4
          Top = 20
          Width = 40
          Height = 13
          Caption = 'RPPos1:'
        end
        object Label11: TLabel
          Left = 4
          Top = 58
          Width = 40
          Height = 13
          Caption = 'RPPos2:'
        end
        object Label12: TLabel
          Left = 4
          Top = 100
          Width = 47
          Height = 13
          Caption = 'RPDifPos:'
        end
        object Label13: TLabel
          Left = 3
          Top = 142
          Width = 59
          Height = 13
          Caption = 'RPMaxTime:'
        end
        object Label14: TLabel
          Left = 3
          Top = 225
          Width = 52
          Height = 13
          Caption = 'ValuesLen:'
        end
        object Label17: TLabel
          Left = 3
          Top = 273
          Width = 52
          Height = 13
          Caption = 'UpCriteria:'
        end
        object Label19: TLabel
          Left = 3
          Top = 182
          Width = 55
          Height = 13
          Caption = 'RPMinTime:'
        end
        object Label22: TLabel
          Left = 4
          Top = 313
          Width = 66
          Height = 13
          Caption = 'DownCriteria:'
        end
        object Label23: TLabel
          Left = 5
          Top = 361
          Width = 55
          Height = 13
          Caption = 'FullCriteria:'
        end
        object TrckBarRP: TTrackBar
          Left = 27
          Top = 416
          Width = 45
          Height = 278
          Max = 65535
          Orientation = trVertical
          Position = 1023
          TabOrder = 0
        end
        object edtRPPos1: TEdit
          Left = 3
          Top = 34
          Width = 71
          Height = 21
          TabOrder = 1
          Text = '0'
        end
        object edtRPPos2: TEdit
          Left = 3
          Top = 72
          Width = 71
          Height = 21
          TabOrder = 2
          Text = '0'
        end
        object edtRPDifPos: TEdit
          Left = 3
          Top = 115
          Width = 71
          Height = 21
          TabOrder = 3
          Text = '0'
        end
        object edtRPMaxTime: TEdit
          Left = 3
          Top = 158
          Width = 71
          Height = 21
          TabOrder = 4
          Text = '0'
        end
        object edtRPValuesLen: TEdit
          Left = 3
          Top = 244
          Width = 71
          Height = 21
          TabOrder = 5
          Text = '0'
        end
        object edtRPCritUpValue: TEdit
          Left = 3
          Top = 290
          Width = 71
          Height = 21
          TabOrder = 6
          Text = '0'
        end
        object edtRPMinTime: TEdit
          Left = 3
          Top = 198
          Width = 71
          Height = 21
          TabOrder = 7
          Text = '0'
        end
        object edtRPCritDownValue: TEdit
          Left = 3
          Top = 330
          Width = 71
          Height = 21
          TabOrder = 8
          Text = '0'
        end
        object edtRPFullCritValue: TEdit
          Left = 3
          Top = 378
          Width = 71
          Height = 21
          TabOrder = 9
          Text = '0'
        end
      end
      object TrackBar1: TTrackBar
        Left = 282
        Top = 424
        Width = 45
        Height = 278
        Max = 300
        Orientation = trVertical
        TabOrder = 3
        Visible = False
      end
      object Edit3: TEdit
        Left = 284
        Top = 397
        Width = 43
        Height = 21
        TabOrder = 4
        Text = '0'
        Visible = False
      end
      object GroupBox4: TGroupBox
        Left = 182
        Top = 8
        Width = 81
        Height = 704
        Caption = 'Yoke'
        TabOrder = 5
        Visible = False
        object Label24: TLabel
          Left = 4
          Top = 20
          Width = 50
          Height = 13
          Caption = 'YokePos1:'
        end
        object Label25: TLabel
          Left = 4
          Top = 58
          Width = 50
          Height = 13
          Caption = 'YokePos2:'
        end
        object Label26: TLabel
          Left = 4
          Top = 100
          Width = 57
          Height = 13
          Caption = 'YokeDifPos:'
        end
        object Label27: TLabel
          Left = 3
          Top = 142
          Width = 69
          Height = 13
          Caption = 'YokeMaxTime:'
        end
        object Label28: TLabel
          Left = 3
          Top = 225
          Width = 52
          Height = 13
          Caption = 'ValuesLen:'
        end
        object Label29: TLabel
          Left = 3
          Top = 273
          Width = 52
          Height = 13
          Caption = 'UpCriteria:'
        end
        object Label30: TLabel
          Left = 3
          Top = 182
          Width = 65
          Height = 13
          Caption = 'YokeMinTime:'
        end
        object Label33: TLabel
          Left = 4
          Top = 313
          Width = 66
          Height = 13
          Caption = 'DownCriteria:'
        end
        object Label34: TLabel
          Left = 5
          Top = 361
          Width = 55
          Height = 13
          Caption = 'FullCriteria:'
        end
        object TrckBarYoke: TTrackBar
          Left = 27
          Top = 416
          Width = 45
          Height = 278
          Max = 65535
          Orientation = trVertical
          Position = 32767
          TabOrder = 0
        end
        object edtYokePos1: TEdit
          Left = 3
          Top = 34
          Width = 71
          Height = 21
          TabOrder = 1
          Text = '0'
        end
        object edtYokePos2: TEdit
          Left = 3
          Top = 72
          Width = 71
          Height = 21
          TabOrder = 2
          Text = '0'
        end
        object edtYokeDifPos: TEdit
          Left = 3
          Top = 115
          Width = 71
          Height = 21
          TabOrder = 3
          Text = '0'
        end
        object edtYokeMaxTime: TEdit
          Left = 3
          Top = 158
          Width = 71
          Height = 21
          TabOrder = 4
          Text = '0'
        end
        object edtYokeValuesLen: TEdit
          Left = 3
          Top = 244
          Width = 71
          Height = 21
          TabOrder = 5
          Text = '0'
        end
        object edtYokeCritUpValue: TEdit
          Left = 3
          Top = 290
          Width = 71
          Height = 21
          TabOrder = 6
          Text = '0'
        end
        object edtYokeMinTime: TEdit
          Left = 3
          Top = 198
          Width = 71
          Height = 21
          TabOrder = 7
          Text = '0'
        end
        object edtYokeCritDownValue: TEdit
          Left = 3
          Top = 330
          Width = 71
          Height = 21
          TabOrder = 8
          Text = '0'
        end
        object edtYokeFullCritValue: TEdit
          Left = 3
          Top = 378
          Width = 71
          Height = 21
          TabOrder = 9
          Text = '0'
        end
      end
      object btnStartEmul: TButton
        Left = 238
        Top = 727
        Width = 75
        Height = 25
        Caption = 'Start emul'
        TabOrder = 6
        Visible = False
        OnClick = btnStartEmulClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Aggregates'
      ImageIndex = 1
      object Label35: TLabel
        Left = 805
        Top = 245
        Width = 73
        Height = 13
        Caption = '5 '#1087#1088#1086#1094#1077#1085#1090#1080#1083#1100':'
      end
      object Label36: TLabel
        Left = 799
        Top = 272
        Width = 79
        Height = 13
        Caption = '50 '#1087#1088#1086#1094#1077#1085#1090#1080#1083#1100':'
      end
      object Label37: TLabel
        Left = 799
        Top = 299
        Width = 79
        Height = 13
        Caption = '95 '#1087#1088#1086#1094#1077#1085#1090#1080#1083#1100':'
      end
      object Label38: TLabel
        Left = 805
        Top = 380
        Width = 73
        Height = 13
        Caption = '5 '#1087#1088#1086#1094#1077#1085#1090#1080#1083#1100':'
      end
      object Label39: TLabel
        Left = 799
        Top = 407
        Width = 79
        Height = 13
        Caption = '50 '#1087#1088#1086#1094#1077#1085#1090#1080#1083#1100':'
      end
      object Label40: TLabel
        Left = 799
        Top = 434
        Width = 79
        Height = 13
        Caption = '95 '#1087#1088#1086#1094#1077#1085#1090#1080#1083#1100':'
      end
      object Label41: TLabel
        Left = 805
        Top = 515
        Width = 73
        Height = 13
        Caption = '5 '#1087#1088#1086#1094#1077#1085#1090#1080#1083#1100':'
      end
      object Label42: TLabel
        Left = 799
        Top = 542
        Width = 79
        Height = 13
        Caption = '50 '#1087#1088#1086#1094#1077#1085#1090#1080#1083#1100':'
      end
      object Label43: TLabel
        Left = 799
        Top = 569
        Width = 79
        Height = 13
        Caption = '95 '#1087#1088#1086#1094#1077#1085#1090#1080#1083#1100':'
      end
      object Label44: TLabel
        Left = 805
        Top = 215
        Width = 84
        Height = 13
        Caption = #1054#1073#1097#1072#1103' '#1089#1082#1086#1088#1086#1089#1090#1100
      end
      object Label45: TLabel
        Left = 805
        Top = 350
        Width = 127
        Height = 13
        Caption = #1054#1073#1097#1072#1103' '#1076#1077#1089#1080#1085#1093#1088#1086#1085#1080#1079#1072#1094#1080#1103
      end
      object Label46: TLabel
        Left = 805
        Top = 485
        Width = 86
        Height = 13
        Caption = #1054#1073#1097#1080#1081' '#1082#1088#1080#1090#1077#1088#1080#1081
      end
      object Label47: TLabel
        Left = 805
        Top = 3
        Width = 86
        Height = 13
        Caption = #1054#1073#1097#1080#1081' '#1082#1088#1080#1090#1077#1088#1080#1081
      end
      object Label48: TLabel
        Left = 805
        Top = 26
        Width = 86
        Height = 13
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1087#1099#1090#1086#1082':'
      end
      object chrtCommonCriteria: TChart
        Left = 3
        Top = 3
        Width = 785
        Height = 206
        Legend.Visible = False
        Title.Text.Strings = (
          'TChart')
        Title.Visible = False
        View3D = False
        TabOrder = 0
        object srsCurCommonCriteria: TBarSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = True
          SeriesColor = 4227072
          BarWidthPercent = 100
          Gradient.Direction = gdTopBottom
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
      end
      object chrtHistCommonRltvVelocity: TChart
        Left = 3
        Top = 215
        Width = 785
        Height = 129
        Legend.Visible = False
        Title.Text.Strings = (
          'TChart')
        Title.Visible = False
        View3D = False
        TabOrder = 1
        object BarSrsCommonRltvVelocity: TBarSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          SeriesColor = 4227072
          BarWidthPercent = 100
          Gradient.Direction = gdTopBottom
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
      end
      object edt5PercentileCommonRltvVelocity: TEdit
        Left = 884
        Top = 241
        Width = 121
        Height = 21
        TabOrder = 2
        Text = '0'
      end
      object edt50PercentileCommonRltvVelocity: TEdit
        Left = 884
        Top = 268
        Width = 121
        Height = 21
        TabOrder = 3
        Text = '0'
      end
      object edt95PercentileCommonRltvVelocity: TEdit
        Left = 884
        Top = 295
        Width = 121
        Height = 21
        TabOrder = 4
        Text = '0'
      end
      object chrtHistCommonDeSynch: TChart
        Left = 3
        Top = 350
        Width = 785
        Height = 129
        Legend.Visible = False
        Title.Text.Strings = (
          'TChart')
        Title.Visible = False
        View3D = False
        TabOrder = 5
        object BarSrsCommonDeSynch: TBarSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          SeriesColor = 4227072
          BarWidthPercent = 100
          Gradient.Direction = gdTopBottom
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
      end
      object edt5PercentileCommonDeSync: TEdit
        Left = 884
        Top = 376
        Width = 121
        Height = 21
        TabOrder = 6
        Text = '0'
      end
      object edt50PercentileCommonDeSync: TEdit
        Left = 884
        Top = 403
        Width = 121
        Height = 21
        TabOrder = 7
        Text = '0'
      end
      object edt95PercentileCommonDeSync: TEdit
        Left = 884
        Top = 430
        Width = 121
        Height = 21
        TabOrder = 8
        Text = '0'
      end
      object chrtHistCommonCriteria: TChart
        Left = 3
        Top = 485
        Width = 785
        Height = 129
        Legend.Visible = False
        Title.Text.Strings = (
          'TChart')
        Title.Visible = False
        View3D = False
        TabOrder = 9
        object BarSrsCommonCriteria: TBarSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          SeriesColor = 4227072
          BarWidthPercent = 100
          Gradient.Direction = gdTopBottom
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
      end
      object edt5PercentileCommonCriteria: TEdit
        Left = 884
        Top = 511
        Width = 121
        Height = 21
        TabOrder = 10
        Text = '0'
      end
      object edt50PercentileCommonCriteria: TEdit
        Left = 884
        Top = 538
        Width = 121
        Height = 21
        TabOrder = 11
        Text = '0'
      end
      object edt95PercentileCommonCriteria: TEdit
        Left = 884
        Top = 565
        Width = 121
        Height = 21
        TabOrder = 12
        Text = '0'
      end
      object btnClearArrays: TButton
        Left = 256
        Top = 640
        Width = 75
        Height = 25
        Caption = 'Clear'
        TabOrder = 13
        OnClick = btnClearArraysClick
      end
      object edtTrialsCount: TEdit
        Left = 897
        Top = 22
        Width = 121
        Height = 21
        TabOrder = 14
        Text = '0'
      end
      object btnUseIt: TButton
        Left = 368
        Top = 640
        Width = 75
        Height = 25
        Caption = 'UseIt'
        TabOrder = 15
        OnClick = btnUseItClick
      end
      object btnRestoreDefault: TButton
        Left = 472
        Top = 640
        Width = 75
        Height = 25
        Caption = 'Default'
        TabOrder = 16
        OnClick = btnRestoreDefaultClick
      end
      object btn2StartEmul: TButton
        Left = 150
        Top = 640
        Width = 75
        Height = 25
        Caption = 'Start emul'
        TabOrder = 17
        OnClick = btnStartEmulClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Visualisation'
      DoubleBuffered = False
      ImageIndex = 2
      ParentDoubleBuffered = False
      object BoardPnl: TPntPanel
        Left = 169
        Top = 0
        Width = 1397
        Height = 841
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        OnMouseDown = BoardPnlMouseDown
        OnPaint = BoardPnlPaint
      end
      object DebugPnl: TPanel
        Left = 0
        Top = 0
        Width = 169
        Height = 841
        Align = alLeft
        TabOrder = 1
        object Label1: TLabel
          Left = 4
          Top = 35
          Width = 47
          Height = 13
          Caption = 'Fov, deg:'
        end
        object LedDevOnAir: TJvLED
          Left = 112
          Top = 36
          Height = 15
          Hint = #1053#1077#1090' '#1089#1074#1103#1079#1080' '#1089' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1086#1084
          ColorOff = clBlack
          Interval = 200
          ParentShowHint = False
          ShowHint = True
          Status = False
        end
        object Label2: TLabel
          Left = 3
          Top = 59
          Width = 27
          Height = 13
          Caption = 'COM:'
        end
        object Label58: TLabel
          Left = 3
          Top = 83
          Width = 28
          Height = 13
          Caption = 'Baud:'
        end
        object Label59: TLabel
          Left = 2
          Top = 176
          Width = 44
          Height = 13
          Caption = 'ReoPos='
        end
        object Label60: TLabel
          Left = 2
          Top = 203
          Width = 42
          Height = 13
          Caption = 'SnsPos='
        end
        object Label61: TLabel
          Left = 2
          Top = 230
          Width = 41
          Height = 13
          Caption = 'SrvPos='
        end
        object Label62: TLabel
          Left = 2
          Top = 257
          Width = 21
          Height = 13
          Caption = 'RT='
        end
        object Label63: TLabel
          Left = 2
          Top = 284
          Width = 44
          Height = 13
          Caption = 'AvrgRT='
        end
        object Label65: TLabel
          Left = 2
          Top = 403
          Width = 71
          Height = 13
          Caption = 'FActnTShft='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label66: TLabel
          Left = 2
          Top = 343
          Width = 52
          Height = 13
          Caption = 'RTValCnt='
        end
        object Label68: TLabel
          Left = 2
          Top = 376
          Width = 62
          Height = 13
          Caption = 'AlrtDrtnT='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label69: TLabel
          Left = 2
          Top = 460
          Width = 55
          Height = 13
          Caption = 'AvrgRAcc='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label70: TLabel
          Left = 2
          Top = 433
          Width = 67
          Height = 13
          Caption = 'RctnAccur='
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label81: TLabel
          Left = 2
          Top = 311
          Width = 37
          Height = 13
          Caption = 'MinRT='
        end
        object SldrFovY: TJvxSlider
          Left = -4
          Top = 0
          Width = 169
          Height = 30
          Increment = 1
          MinValue = 1
          MaxValue = 150
          TabOrder = 0
          Value = 1
          OnChange = SldrFovYChange
        end
        object Edit1: TEdit
          Left = 52
          Top = 32
          Width = 40
          Height = 21
          TabOrder = 1
          Text = '0'
        end
        object Memo1: TMemo
          Left = 2
          Top = 711
          Width = 43
          Height = 16
          Lines.Strings = (
            'M'
            'e'
            'm'
            'o'
            '1')
          ScrollBars = ssVertical
          TabOrder = 2
        end
        object JvxSlider1: TJvxSlider
          Left = -1
          Top = 741
          Width = 105
          Height = 30
          Increment = 1
          MinValue = -60
          MaxValue = 60
          TabOrder = 3
          OnChange = JvxSlider1Change
        end
        object JvxSlider2: TJvxSlider
          Left = -1
          Top = 777
          Width = 105
          Height = 30
          Increment = 1
          MinValue = -5
          MaxValue = 5
          TabOrder = 4
          OnChange = JvxSlider2Change
        end
        object edtX_: TEdit
          Left = 110
          Top = 750
          Width = 55
          Height = 21
          TabOrder = 5
          Text = '0'
        end
        object edtY_: TEdit
          Left = 110
          Top = 785
          Width = 55
          Height = 21
          TabOrder = 6
          Text = '0'
        end
        object btnShowGL: TButton
          Left = 82
          Top = 812
          Width = 75
          Height = 22
          Caption = 'ShowGL'
          TabOrder = 7
          OnClick = btnShowGLClick
        end
        object btn3StartEmul: TButton
          Left = 4
          Top = 812
          Width = 75
          Height = 22
          Caption = 'Start emul'
          TabOrder = 8
          OnClick = btnStartEmulClick
        end
        object btnDoAlertSubjAction: TButton
          Left = 98
          Top = 138
          Width = 59
          Height = 22
          Caption = 'DoAlert'
          TabOrder = 9
          OnClick = btnDoAlertSubjActionClick
        end
        object cbxComNum: TComboBox
          Left = 36
          Top = 56
          Width = 121
          Height = 21
          TabOrder = 10
          Text = 'cbxComNum'
          OnChange = cbxComNumChange
        end
        object edtComSpeed: TEdit
          Left = 37
          Top = 83
          Width = 121
          Height = 21
          TabOrder = 11
          Text = '57600'
          OnChange = edtComSpeedChange
        end
        object btnStartWorkWithComPort: TButton
          Left = 98
          Top = 110
          Width = 59
          Height = 22
          Caption = 'Open Port'
          TabOrder = 12
        end
        object Button4: TButton
          Left = 6
          Top = 110
          Width = 80
          Height = 22
          Caption = 'ScanComPorts'
          TabOrder = 13
          OnClick = Button4Click
        end
        object btnServoUpDown: TButton
          Left = 6
          Top = 138
          Width = 80
          Height = 22
          Caption = 'ServoUpDown'
          TabOrder = 14
          OnClick = btnServoUpDownClick
        end
        object edtReoPos: TEdit
          Left = 94
          Top = 173
          Width = 63
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 15
          Text = '0'
        end
        object edtSnsPos: TEdit
          Left = 94
          Top = 200
          Width = 63
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 16
          Text = '0'
        end
        object edtSrvPos: TEdit
          Left = 94
          Top = 227
          Width = 63
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 17
          Text = '0'
        end
        object edtRT: TEdit
          Left = 94
          Top = 254
          Width = 63
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 18
          Text = '0'
        end
        object edtAvrgRT: TEdit
          Left = 94
          Top = 281
          Width = 63
          Height = 21
          TabOrder = 19
          Text = '0'
          OnChange = edtAvrgRTChange
        end
        object edtFrcActnTShift: TEdit
          Left = 94
          Top = 400
          Width = 63
          Height = 21
          TabOrder = 20
          Text = '0'
          OnChange = edtFrcActnTShiftChange
        end
        object edtRTValCnt: TEdit
          Left = 94
          Top = 340
          Width = 63
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 21
          Text = '0'
        end
        object edtAlrtDrtnT: TEdit
          Left = 94
          Top = 373
          Width = 63
          Height = 21
          Color = clWhite
          TabOrder = 22
          Text = '0'
          OnChange = edtAlrtDrtnTChange
        end
        object btnSuspendDecTShift: TButton
          Left = 3
          Top = 688
          Width = 75
          Height = 25
          Caption = 'SuspDecTShft'
          TabOrder = 23
          OnClick = btnSuspendDecTShiftClick
        end
        object btnResumeDecTShift: TButton
          Left = 82
          Top = 688
          Width = 75
          Height = 25
          Caption = 'ResmDecTShft'
          TabOrder = 24
          OnClick = btnResumeDecTShiftClick
        end
        object edtAvrgReactionAccuracy: TEdit
          Left = 94
          Top = 457
          Width = 63
          Height = 21
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 25
          Text = '0'
        end
        object edtReactionAccuracy: TEdit
          Left = 94
          Top = 430
          Width = 63
          Height = 21
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 26
          Text = '0'
        end
        object GroupBox5: TGroupBox
          Left = -1
          Top = 483
          Width = 164
          Height = 199
          TabOrder = 27
          object Label64: TLabel
            Left = 6
            Top = 19
            Width = 60
            Height = 13
            Caption = 'RVlctyTime='
          end
          object Label67: TLabel
            Left = 6
            Top = 46
            Width = 67
            Height = 13
            Caption = 'AvrgRVlctyT='
          end
          object Label56: TLabel
            Left = 6
            Top = 72
            Width = 75
            Height = 13
            Caption = 'AmpLimbToUp='
          end
          object Label71: TLabel
            Left = 6
            Top = 127
            Width = 65
            Height = 13
            Caption = 'Limb1UpCnt='
          end
          object Label72: TLabel
            Left = 6
            Top = 99
            Width = 98
            Height = 13
            Caption = 'AvrgAmpLimbToUp='
          end
          object Label73: TLabel
            Left = 6
            Top = 154
            Width = 81
            Height = 13
            Caption = 'GoalRVlctyTime='
          end
          object Label74: TLabel
            Left = 6
            Top = 177
            Width = 96
            Height = 13
            Caption = 'GoalAmpLimbToUp='
          end
          object edtRVlctyTime: TEdit
            Left = 91
            Top = 15
            Width = 63
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 0
            Text = '0'
          end
          object edtAvrgRVlctyT: TEdit
            Left = 91
            Top = 42
            Width = 63
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 1
            Text = '0'
          end
          object edtAmpLimbToUp: TEdit
            Left = 91
            Top = 69
            Width = 63
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 2
            Text = '0'
          end
          object edtLimb1UpCnt: TEdit
            Left = 91
            Top = 123
            Width = 63
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 3
            Text = '0'
          end
          object edtAvrgAmpLimbToUp: TEdit
            Left = 91
            Top = 96
            Width = 63
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 4
            Text = '0'
          end
          object edtGoalRVlctyTime: TEdit
            Left = 91
            Top = 150
            Width = 63
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 5
            Text = '0'
          end
          object edtGoalAmpLimbToUp: TEdit
            Left = 91
            Top = 173
            Width = 63
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 6
            Text = '0'
          end
        end
        object JvxSlider3: TJvxSlider
          Left = -1
          Top = 719
          Width = 105
          Height = 30
          Increment = 1
          MinValue = -30
          MaxValue = 30
          TabOrder = 28
          OnChange = JvxSlider3Change
        end
        object Edit2: TEdit
          Left = 110
          Top = 719
          Width = 55
          Height = 21
          TabOrder = 29
          Text = '0'
        end
        object edtMinRT: TEdit
          Left = 94
          Top = 308
          Width = 63
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 30
          Text = '0'
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'SendTriggers'
      DoubleBuffered = False
      ImageIndex = 3
      ParentDoubleBuffered = False
      object Label49: TLabel
        Left = 159
        Top = 10
        Width = 41
        Height = 13
        Caption = #1040#1076#1088#1077#1089'1:'
      end
      object Label50: TLabel
        Left = 159
        Top = 56
        Width = 41
        Height = 13
        Caption = #1040#1076#1088#1077#1089'2:'
      end
      object Label51: TLabel
        Left = 17
        Top = 10
        Width = 98
        Height = 13
        Caption = 'Mrk evt action code:'
      end
      object Label52: TLabel
        Left = 159
        Top = 104
        Width = 43
        Height = 13
        Caption = 'Ctrl Reg:'
      end
      object Label53: TLabel
        Left = 17
        Top = 56
        Width = 103
        Height = 13
        Caption = 'Mrk begin intrvl code:'
      end
      object Label54: TLabel
        Left = 17
        Top = 104
        Width = 95
        Height = 13
        Caption = 'Mrk end intrvl code:'
      end
      object Label55: TLabel
        Left = 17
        Top = 331
        Width = 75
        Height = 13
        Caption = 'LPT_IO_Result:'
      end
      object Label57: TLabel
        Left = 17
        Top = 152
        Width = 124
        Height = 13
        Caption = 'Mrk AlertSubjAction code:'
      end
      object btnSendData: TButton
        Left = 7
        Top = 211
        Width = 123
        Height = 25
        Caption = 'SendData'
        TabOrder = 0
        OnClick = btnSendDataClick
      end
      object btnReceiveData: TButton
        Left = 149
        Top = 211
        Width = 123
        Height = 25
        Caption = 'ReceiveData'
        TabOrder = 1
        OnClick = btnReceiveDataClick
      end
      object edtrMrkEvtActionCode: TEdit
        Left = 17
        Top = 29
        Width = 121
        Height = 21
        TabOrder = 2
        Text = '10'
        OnChange = edtrMrkEvtActionCodeChange
      end
      object btnReceiveInit: TButton
        Left = 149
        Top = 273
        Width = 123
        Height = 25
        Caption = 'ReceiveInit'
        TabOrder = 3
        OnClick = btnReceiveInitClick
      end
      object btnPortReset: TButton
        Left = 7
        Top = 273
        Width = 123
        Height = 25
        Caption = 'PortReset'
        TabOrder = 4
        OnClick = btnPortResetClick
      end
      object edLPTAdress: TEdit
        Left = 159
        Top = 29
        Width = 121
        Height = 21
        TabOrder = 5
        Text = '127'
      end
      object edLPTAdress2: TEdit
        Left = 159
        Top = 75
        Width = 121
        Height = 21
        TabOrder = 6
        Text = '127'
      end
      object Edit5: TEdit
        Left = 159
        Top = 123
        Width = 121
        Height = 21
        TabOrder = 7
        Text = '0'
      end
      object btnSendDataToControlReg: TButton
        Left = 9
        Top = 242
        Width = 121
        Height = 25
        Caption = 'SendDataToControlReg'
        TabOrder = 8
        OnClick = btnSendDataToControlRegClick
      end
      object Button8: TButton
        Left = 752
        Top = 73
        Width = 83
        Height = 26
        Caption = 'Start'
        TabOrder = 9
        Visible = False
      end
      object edtrMrkBgnIntrvlCode: TEdit
        Left = 17
        Top = 75
        Width = 121
        Height = 21
        TabOrder = 10
        Text = '12'
        OnChange = edtrMrkBgnIntrvlCodeChange
      end
      object edtrMrkEndIntrvlCode: TEdit
        Left = 17
        Top = 123
        Width = 121
        Height = 21
        TabOrder = 11
        Text = '13'
        OnChange = edtrMrkEndIntrvlCodeChange
      end
      object edtLPT_IO_Result: TEdit
        Left = 133
        Top = 328
        Width = 121
        Height = 21
        TabOrder = 12
        Text = '0'
      end
      object Button7: TButton
        Left = 3
        Top = 515
        Width = 272
        Height = 162
        Caption = 'SendEvent on KeyUp'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        Style = bsCommandLink
        TabOrder = 14
        Visible = False
      end
      object edtMrkAlertSubjAction: TEdit
        Left = 17
        Top = 171
        Width = 121
        Height = 21
        TabOrder = 13
        Text = '13'
        OnChange = edtMrkAlertSubjActionChange
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'TabSheet5'
      ImageIndex = 4
      object Label75: TLabel
        Left = 5
        Top = 592
        Width = 174
        Height = 13
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' *.log '#1092#1072#1081#1083#1072':'
      end
      object Label76: TLabel
        Left = 3
        Top = 640
        Width = 145
        Height = 13
        Caption = #1041#1072#1083#1083#1099'  '#1096#1082#1072#1083#1099' '#1072#1075#1077#1085#1090#1080#1074#1085#1086#1089#1090#1080
      end
      object Label77: TLabel
        Left = 96
        Top = 795
        Width = 67
        Height = 13
        Caption = #1053#1086#1084#1077#1088' '#1090#1077#1089#1090#1072':'
      end
      object Label78: TLabel
        Left = 185
        Top = 640
        Width = 209
        Height = 13
        Caption = 't '#1089#1077#1088#1074#1086' '#1086#1090#1085#1086#1089#1080#1090#1077#1083#1100#1085#1086' '#1085#1072#1095#1072#1083#1072' '#1080#1085#1090#1077#1088#1074#1072#1083#1072' '
      end
      object Label79: TLabel
        Left = 96
        Top = 820
        Width = 61
        Height = 13
        Caption = #1042#1093#1086#1078#1076#1077#1085#1080#1077':'
      end
      object Button1: TButton
        Left = 312
        Top = 559
        Width = 75
        Height = 25
        Caption = 'Generate'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Chart1: TChart
        Left = 3
        Top = 3
        Width = 1054
        Height = 550
        Title.Text.Strings = (
          'TChart')
        View3D = False
        TabOrder = 1
        object Series1: TBarSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = True
          SeriesColor = 8421440
          BarWidthPercent = 100
          Gradient.Direction = gdTopBottom
          Shadow.Color = 8553090
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
        object Series2: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
      end
      object btnGetTstData: TButton
        Left = 5
        Top = 790
        Width = 75
        Height = 25
        Caption = 'GetTstData'
        TabOrder = 2
        OnClick = btnGetTstDataClick
      end
      object BitBtnOpenLogFile: TBitBtn
        Left = 185
        Top = 587
        Width = 25
        Height = 25
        DoubleBuffered = True
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00A7D0DE004B99B2007CACBC00B8D1DA00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF006FC7E40076CFF0003FB5DE0037A5CB003994B4004496B20081AFC000B1CD
          D700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF0067C5E900ADECFF007BE4FF0082E6FF0075E2FF0069D8FB0057C6E9003EAE
          D300419FBE00529EB800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF0043BAE700ACE7F60085EBFE0080E7FC0084EAFE0086EBFF0088EEFF008AF0
          FF0086F0FF005CD5F7004B9FBA00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF0045BAEC0091D7F100A4FAFF0088F2FD008EF4FE008EF4FE008DF3FE008BF2
          FD008DF3FB0090F1FF0047AFCC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF004EC1F10074CAF500BDFEFE0091FEFF0095FCFF0093FCFE0097FCFE0096FB
          FF0095FCFD0097F2FE0090E2F0004D96B100FF00FF00FF00FF00FF00FF00FF00
          FF0062C9F40060CAF900A6E2F200C2F7FA00BBFBFB00C1FFFF00ACFFFF00A8FD
          FE00ABFEFE0096ECFD00D6FEFF004CA4C000FF00FF00FF00FF00FF00FF00FF00
          FF0068D0F2007EE2FE0061D0F50076D2F1007FD6F2009EDDF400DEFCFC00DCFF
          FF00DBFFFF00ADECFE00FFFFFF00ADDEEB004B92AB00FF00FF00FF00FF00FF00
          FF006EDEF10093F7FF008AF4FF0088F4FF007EF0FE0071E9F90084DDF000A7E0
          F000B5E9F400BAE8F800C6E8F200C5ECF7003F97B400B5CCD500FF00FF00AED6
          EB0083E7F300A0FFFE0094FBFD0097FEFE00B0FFFF00B3FFFF009CFFFF0093FC
          FE0098FCFE0050C7E400DEF1F800A1DAED00AAD3E100FF00FF00FF00FF00FF00
          FF006FD2E800B6FFFF00A3FFFF00B8FCFE007BCDE60066C3E2006BD1E8009AE8
          F40095E9F40064CAE500FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00A7DCEE007CCEE70075CFE7006FC7E400FF00FF00FF00FF00FF00FF00AEDC
          EE00AEDBED00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
        ParentDoubleBuffered = False
        TabOrder = 3
        OnClick = BitBtnOpenLogFileClick
      end
      object EdtLoadLogFileName: TEdit
        Left = 216
        Top = 589
        Width = 841
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 4
      end
      object Memo2: TMemo
        Left = 3
        Top = 659
        Width = 176
        Height = 117
        ScrollBars = ssVertical
        TabOrder = 5
      end
      object edtTstNum: TEdit
        Left = 169
        Top = 792
        Width = 32
        Height = 21
        TabOrder = 6
        Text = '6'
      end
      object mmDelayServoFromBgnIntrvl: TMemo
        Left = 195
        Top = 659
        Width = 176
        Height = 117
        ScrollBars = ssVertical
        TabOrder = 7
      end
      object edtTstNumPos: TEdit
        Left = 169
        Top = 817
        Width = 32
        Height = 21
        TabOrder = 8
        Text = '1'
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Servo curve'
      ImageIndex = 5
      object ch: TChart
        Left = 0
        Top = 0
        Width = 825
        Height = 713
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Legend.Visible = False
        Title.Text.Strings = (
          'Servo curves')
        OnClickSeries = chClickSeries
        BottomAxis.Axis.Color = clSilver
        BottomAxis.Axis.Width = 1
        BottomAxis.AxisValuesFormat = '####.###'
        BottomAxis.LabelsFont.Color = clWhite
        LeftAxis.Axis.Color = clSilver
        LeftAxis.Axis.Width = 1
        LeftAxis.LabelsAngle = 90
        LeftAxis.LabelsFont.Color = clWhite
        LeftAxis.TickLength = 0
        LeftAxis.Ticks.Width = 2
        LeftAxis.TicksInner.Width = 2
        LeftAxis.Title.Font.Color = clWhite
        View3D = False
        OnAfterDraw = chAfterDraw
        Color = clBlack
        TabOrder = 0
        OnMouseMove = chMouseMove
        OnMouseUp = chMouseUp
        object LineSeries1: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          LinePen.Color = clRed
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = True
          TreatNulls = tnIgnore
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
        object LineSeries2: TLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
      end
      object btnResetCurves: TButton
        Left = 21
        Top = 736
        Width = 75
        Height = 25
        Caption = 'Reset'
        TabOrder = 1
        OnClick = btnResetCurvesClick
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'TabSheet7'
      ImageIndex = 6
      object Label80: TLabel
        Left = 144
        Top = 479
        Width = 103
        Height = 13
        Caption = 'Channel num [1..69]:'
      end
      object lblAmplThreshold: TLabel
        Left = 144
        Top = 519
        Width = 95
        Height = 13
        Caption = 'ChnlAmplThreshold:'
      end
      object Chart2: TChart
        Left = 0
        Top = 3
        Width = 1569
        Height = 465
        Legend.Visible = False
        Title.Text.Strings = (
          'TChart')
        Title.Visible = False
        BottomAxis.Automatic = False
        BottomAxis.AutomaticMaximum = False
        BottomAxis.Maximum = 5000.000000000000000000
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 15000.000000000000000000
        LeftAxis.Minimum = -15000.000000000000000000
        View3D = False
        View3DOptions.Orthogonal = False
        TabOrder = 0
        object FastLineSeries1: TFastLineSeries
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Visible = False
          LinePen.Color = clRed
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
        end
      end
      object btnStart: TButton
        Left = 0
        Top = 474
        Width = 126
        Height = 25
        Caption = 'Start receive EEG Data'
        TabOrder = 1
        OnClick = btnStartClick
      end
      object edtChnlNum: TEdit
        Left = 253
        Top = 476
        Width = 33
        Height = 21
        TabOrder = 2
        Text = '65'
        OnChange = edtChnlNumChange
      end
      object chkBxNotchFilter50: TCheckBox
        Left = 416
        Top = 478
        Width = 177
        Height = 17
        Caption = 'Notch filter 50Hz + HPF 5-500Hz'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = chkBxNotchFilter50Click
      end
      object edtAmplThreshold: TEdit
        Left = 253
        Top = 516
        Width = 44
        Height = 21
        TabOrder = 4
        Text = '12000'
        OnChange = edtAmplThresholdChange
      end
    end
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 1016
    Top = 504
    object mnuBackdropstart: TMenuItem
      Caption = 'Backdrop start'
      OnClick = mnuBackdropstartClick
    end
    object mnuNewGame: TMenuItem
      Caption = 'Start experiment'
      ShortCut = 49230
      OnClick = mnuNewGameClick
    end
    object mnuSettings: TMenuItem
      Caption = 'Settings'
      ShortCut = 49235
      OnClick = mnuSettingsClick
    end
    object mnuDebugPnlVisible: TMenuItem
      Caption = 'Debug panel visible\unvisible'
      OnClick = mnuDebugPnlVisibleClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuQuit: TMenuItem
      Caption = 'Quit'
      OnClick = mnuQuitClick
    end
  end
  object JvInitTmr: TJvTimer
    EventTime = tetPost
    Interval = 10
    OnTimer = JvInitTmrTimer
    Left = 976
    Top = 152
  end
  object tmrTrckBarJoyPosEmul: TJvTimer
    Enabled = False
    Interval = 1
    OnTimer = tmrTrckBarJoyPosEmulTimer
    Left = 936
    Top = 184
  end
  object TmrSessionDuration: TJvTimer
    EventTime = tetPost
    Enabled = False
    OnTimer = TmrSessionDurationTimer
    Left = 608
    Top = 56
  end
  object tmrNeedServoDown: TJvTimer
    EventTime = tetPost
    Enabled = False
    Interval = 50
    OnTimer = tmrNeedServoDownTimer
    Left = 888
    Top = 88
  end
  object od: TOpenDialog
    DefaultExt = 'log'
    Filter = 
      #1060#1072#1081#1083#1099' Stars (*.log)|*.log|'#1060#1072#1081#1083#1099' mrk (*.mrk)|*.mrk|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*' +
      ')|*.*'
    Left = 772
    Top = 16
  end
  object JvSubTimer: TJvTimer
    EventTime = tetPost
    Enabled = False
    Interval = 25
    Threaded = False
    OnTimer = JvSubTimerTimer
    Left = 800
    Top = 496
  end
end
