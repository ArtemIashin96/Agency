unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uVidMode, StdCtrls, iniFiles, OpenGL, uCommon, ExtCtrls, math,
  ComCtrls, JvExControls, JvxSlider, uDebugLog, JvTimer, PntPanel, Menus,
  uSettingsFm, uHasWonMsg, Types, dGlut, mmSystem, TeEngine, Series, TeeProcs,
  Chart, uJoys, JvExExtCtrls, JvExtComponent, JvClock, uLPT, uOpenComThread,
  JvLED, StrUtils, Ap, spline3, uModuleInterface, uPlStimModuleInterface, ComObj,
  uMainRes, JvNetscapeSplitter, uSubTest, Contnrs, Buttons;

//варианты ответа исп-го, в связи с которыми возможны следующие подвар-ты:
//classif|human
//aNoIntnsnNoAlert NoAction
//1.   cn|cn - нет желания, нет мозговой активности, нет предупреждения и нет действия
//     ss|ss - нет желания, но есть мозговая активность, не обнаруженная классификатором, нет действия. Что здесь происходило мы никогда не узнаем.
//aNoIntnsnYesAlert YesAction
//2.   cd|ss - классификатор правильно обнаружил мозг.акт-ть, но осознание её отстутствует. Действие здесь психологически вынужденное, но физиологически корректное (диссоциация).
//     fa|cn - нет мозговой активности, но классификатор ошибочно сработал. Осознания законно нет. Действие здесь психофизиологически вынужденное.
//aYesIntnsnNoAlert YesAction
//3.   ss|cd - есть желание и есть мозговая активность, не распознанная классификатором. Действие здесь психофизиологически естественно.
//     cn|fa? - нет мозг.акт-ти и классификатор корректно молчал, но чел.ошибочно вообразил, что он хотел, но не было алерта. Действие здесь иллюзорно, т.к. не согласуется с реальной мозг.акт-тью:
//              психологически естественное, но физиологически вынужденное (диссоциация).
//aYesIntnsnYesAlert YesAction
//4.   cd|cd - есть желание и есть мозговая активность, обнаруженная классификатором. Действие здесь психофизиологически абсолютно естественно.
//     fa|fa? - есть желание, но нет специфической мозговой акт-ти, а классификатор сработал ложно. Дейстие иллюзорно, т.к. не согласуется с реальной мозговой акт-тью. Может ли быть такое?!
type
  TExpVariants = (evIncorrect, evOneVariant, evTwoVariant, evThirdVariant, evFourthVariant, evFifthVariant, evSixthVariant, evSeventhVariant,
                  evEighthVariant, evNinthVariant, evTenthVariant, evEleventhVariant, ev12Variant);
  TExperimentStage = (esOne, esTwo, esThree, esFour, esFive);


type
  TGLCoord3d = packed record
    x: GLFloat;
    y: GLFloat;
    z: GLFloat;
  end;

type
  TSetUp = function: Pointer; cdecl;
  TTearDown = procedure(ptr: Pointer); cdecl;
  TsendEvent = procedure(ptr: Pointer; str: PAnsiChar); cdecl;

  TCallbackProc = procedure(x, y: double; timestamp: UInt64); cdecl;
  //ф-ция, передающая ЭЭГ данные + доп. каналы + канал меток из Резонанса
  //данные идут с Fs=1000Гц, последовательностью: ch1_smpl1, ch2_smpl2, ...,chN_smplM, ch1_smpl2, ch2_smpl2, chN_smplM
  TEEGCallbackProc = procedure(data: pointer; channels: Integer; samples: Integer; timestamp: UInt64); cdecl;
  TRegisterCallback = procedure(ptr: pointer; ACallback: TCallbackProc); cdecl;

type
  TfmMain = class(TForm)
    PopupMenu1: TPopupMenu;
    mnuSettings: TMenuItem;
    mnuNewGame: TMenuItem;
    N1: TMenuItem;
    mnuQuit: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    BoardPnl: TPntPanel;
    GroupBox1: TGroupBox;
    lblLPPos1: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    TrckBarLP: TTrackBar;
    edtLPPos1: TEdit;
    edtLPPos2: TEdit;
    edtLPDifPos: TEdit;
    edtLPMaxTime: TEdit;
    edtLPValuesLen: TEdit;
    edtLPCritUpValue: TEdit;
    edtLPMinTime: TEdit;
    edtLPCritDownValue: TEdit;
    edtLPFullCritValue: TEdit;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Label15: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    edtDifPedalsMaxTimeNotifictn: TEdit;
    edtDifPedalsMinTimeNotifictn: TEdit;
    edtCommonCrit: TEdit;
    edtSynchroCriteria: TEdit;
    edtDifYokeMaxTimeNotifictn: TEdit;
    edtDifYokeMinTimeNotifictn: TEdit;
    GroupBox3: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    TrckBarRP: TTrackBar;
    edtRPPos1: TEdit;
    edtRPPos2: TEdit;
    edtRPDifPos: TEdit;
    edtRPMaxTime: TEdit;
    edtRPValuesLen: TEdit;
    edtRPCritUpValue: TEdit;
    edtRPMinTime: TEdit;
    edtRPCritDownValue: TEdit;
    edtRPFullCritValue: TEdit;
    TrackBar1: TTrackBar;
    Edit3: TEdit;
    GroupBox4: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    TrckBarYoke: TTrackBar;
    edtYokePos1: TEdit;
    edtYokePos2: TEdit;
    edtYokeDifPos: TEdit;
    edtYokeMaxTime: TEdit;
    edtYokeValuesLen: TEdit;
    edtYokeCritUpValue: TEdit;
    edtYokeMinTime: TEdit;
    edtYokeCritDownValue: TEdit;
    edtYokeFullCritValue: TEdit;
    btnStartEmul: TButton;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    chrtCommonCriteria: TChart;
    srsCurCommonCriteria: TBarSeries;
    chrtHistCommonRltvVelocity: TChart;
    BarSrsCommonRltvVelocity: TBarSeries;
    edt5PercentileCommonRltvVelocity: TEdit;
    edt50PercentileCommonRltvVelocity: TEdit;
    edt95PercentileCommonRltvVelocity: TEdit;
    chrtHistCommonDeSynch: TChart;
    BarSrsCommonDeSynch: TBarSeries;
    edt5PercentileCommonDeSync: TEdit;
    edt50PercentileCommonDeSync: TEdit;
    edt95PercentileCommonDeSync: TEdit;
    chrtHistCommonCriteria: TChart;
    BarSrsCommonCriteria: TBarSeries;
    edt5PercentileCommonCriteria: TEdit;
    edt50PercentileCommonCriteria: TEdit;
    edt95PercentileCommonCriteria: TEdit;
    btnClearArrays: TButton;
    edtTrialsCount: TEdit;
    btnUseIt: TButton;
    btnRestoreDefault: TButton;
    JvInitTmr: TJvTimer;
    tmrTrckBarJoyPosEmul: TJvTimer;
    btn2StartEmul: TButton;
    TabSheet4: TTabSheet;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    btnSendData: TButton;
    btnReceiveData: TButton;
    edtrMrkEvtActionCode: TEdit;
    btnReceiveInit: TButton;
    btnPortReset: TButton;
    edLPTAdress: TEdit;
    edLPTAdress2: TEdit;
    Edit5: TEdit;
    btnSendDataToControlReg: TButton;
    Button8: TButton;
    edtrMrkBgnIntrvlCode: TEdit;
    edtrMrkEndIntrvlCode: TEdit;
    edtLPT_IO_Result: TEdit;
    Label55: TLabel;
    Button7: TButton;
    TmrSessionDuration: TJvTimer;
    Label57: TLabel;
    edtMrkAlertSubjAction: TEdit;
    mnuDebugPnlVisible: TMenuItem;
    mnuBackdropstart: TMenuItem;
    TabSheet5: TTabSheet;
    Button1: TButton;
    Chart1: TChart;
    Series1: TBarSeries;
    Series2: TLineSeries;
    tmrNeedServoDown: TJvTimer;
    TabSheet6: TTabSheet;
    ch: TChart;
    LineSeries1: TLineSeries;
    LineSeries2: TLineSeries;
    btnResetCurves: TButton;
    DebugPnl: TPanel;
    Label1: TLabel;
    LedDevOnAir: TJvLED;
    Label2: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    SldrFovY: TJvxSlider;
    Edit1: TEdit;
    Memo1: TMemo;
    JvxSlider1: TJvxSlider;
    JvxSlider2: TJvxSlider;
    edtX_: TEdit;
    edtY_: TEdit;
    btnShowGL: TButton;
    btn3StartEmul: TButton;
    btnDoAlertSubjAction: TButton;
    cbxComNum: TComboBox;
    edtComSpeed: TEdit;
    btnStartWorkWithComPort: TButton;
    Button4: TButton;
    btnServoUpDown: TButton;
    edtReoPos: TEdit;
    edtSnsPos: TEdit;
    edtSrvPos: TEdit;
    edtRT: TEdit;
    edtAvrgRT: TEdit;
    edtFrcActnTShift: TEdit;
    edtRTValCnt: TEdit;
    edtAlrtDrtnT: TEdit;
    btnSuspendDecTShift: TButton;
    btnResumeDecTShift: TButton;
    edtAvrgReactionAccuracy: TEdit;
    edtReactionAccuracy: TEdit;
    GroupBox5: TGroupBox;
    Label64: TLabel;
    Label67: TLabel;
    Label56: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    edtRVlctyTime: TEdit;
    edtAvrgRVlctyT: TEdit;
    edtAmpLimbToUp: TEdit;
    edtLimb1UpCnt: TEdit;
    edtAvrgAmpLimbToUp: TEdit;
    edtGoalRVlctyTime: TEdit;
    edtGoalAmpLimbToUp: TEdit;
    btnGetTstData: TButton;
    Label75: TLabel;
    BitBtnOpenLogFile: TBitBtn;
    EdtLoadLogFileName: TEdit;
    od: TOpenDialog;
    Memo2: TMemo;
    Label76: TLabel;
    Label77: TLabel;
    edtTstNum: TEdit;
    Label78: TLabel;
    mmDelayServoFromBgnIntrvl: TMemo;
    Label79: TLabel;
    edtTstNumPos: TEdit;
    TabSheet7: TTabSheet;
    Chart2: TChart;
    FastLineSeries1: TFastLineSeries;
    btnStart: TButton;
    Label80: TLabel;
    edtChnlNum: TEdit;
    chkBxNotchFilter50: TCheckBox;
    JvSubTimer: TJvTimer;
    JvxSlider3: TJvxSlider;
    edtAmplThreshold: TEdit;
    lblAmplThreshold: TLabel;
    Edit2: TEdit;
    Label81: TLabel;
    edtMinRT: TEdit;
    procedure JvLPTZeroOnTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SldrFovYChange(Sender: TObject);
    procedure BoardPnlPaint(Sender: TObject);
    procedure BoardPnlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuSettingsClick(Sender: TObject);
    procedure mnuNewGameClick(Sender: TObject);
    procedure mnuQuitClick(Sender: TObject);
    procedure JvxSlider1Change(Sender: TObject);
    procedure JvxSlider2Change(Sender: TObject);
    procedure btnShowGLClick(Sender: TObject);
    procedure JvInitTmrTimer(Sender: TObject);
    procedure tmrTrckBarJoyPosEmulTimer(Sender: TObject);
    procedure btnStartEmulClick(Sender: TObject);
    procedure btnClearArraysClick(Sender: TObject);
    procedure btnUseItClick(Sender: TObject);
    procedure btnRestoreDefaultClick(Sender: TObject);
    procedure btnDoAlertSubjActionClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnReceiveDataClick(Sender: TObject);
    procedure btnSendDataToControlRegClick(Sender: TObject);
    procedure btnPortResetClick(Sender: TObject);
    procedure btnReceiveInitClick(Sender: TObject);
    procedure edtrMrkEvtActionCodeChange(Sender: TObject);
    procedure edtrMrkBgnIntrvlCodeChange(Sender: TObject);
    procedure edtrMrkEndIntrvlCodeChange(Sender: TObject);
    procedure TmrSessionDurationTimer(Sender: TObject);
    procedure edtMrkAlertSubjActionChange(Sender: TObject);
    procedure mnuDebugPnlVisibleClick(Sender: TObject);
    procedure mnuBackdropstartClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure cbxComNumChange(Sender: TObject);
    procedure btnServoUpDownClick(Sender: TObject);
    procedure tmrNeedServoDownTimer(Sender: TObject);
    procedure chAfterDraw(Sender: TObject);
    procedure chClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure chMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure chMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnResetCurvesClick(Sender: TObject);
    procedure edtComSpeedChange(Sender: TObject);
    procedure edtFrcActnTShiftChange(Sender: TObject);
    procedure edtAvrgRTChange(Sender: TObject);
    procedure btnSuspendDecTShiftClick(Sender: TObject);
    procedure btnResumeDecTShiftClick(Sender: TObject);
    procedure JvNetscpSpl_DynAnalysisMaximize(Sender: TObject);
    procedure JvNetscpSpl_DynAnalysisMinimize(Sender: TObject);
    procedure edtAlrtDrtnTChange(Sender: TObject);
    procedure BitBtnOpenLogFileClick(Sender: TObject);
    procedure btnGetTstDataClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure edtChnlNumChange(Sender: TObject);
    procedure JvSubTimerTimer(Sender: TObject);
    procedure chkBxNotchFilter50Click(Sender: TObject);
    procedure JvxSlider3Change(Sender: TObject);
    procedure edtAmplThresholdChange(Sender: TObject);
    procedure btnSendDataClick(Sender: TObject);
  private
    { Private declarations }
    FLock: Boolean;
    FPreferencesChanged: Boolean;
    FIniFileName: string;
    FLockCtrls: Boolean;
    FVidModeSelectedIndex: Integer;
    FFullScreenMode: Boolean;
    FDebugPnlVisible: Boolean;
    FEmulMode: Boolean;
    FFullScreen: Boolean;
    FDefSessionDurationInMs: Int64;
    FSessionDurationInMs: Int64;
    FCurSessionDurationInMs: Int64;
    FCurGameSessionNumber: Integer;
    FGameResults: TIntArr;
    FAnswer: TAnswers;
    FExperimentStage: TExperimentStage;
    FRndAlertIntervals: array of Integer;
    FRndAlertIntervalsForFastPresent: array of Integer;
    //
    FTerminated: Boolean;
    FDevBusy: Boolean;
    FDevWorkState: TDevWorkState;
    FOpenComThread: TOpenComThread;
    FSubTests: TObjectList;
    function SubTestExist(const ATestNumber: Integer; const ATstNumPos: Integer; var TestIndex: Integer): Boolean;
    function AddSubTest(ASubTest: TSubTest): Integer;
    procedure ClearSubTests;
    function SubTestCount: Integer;
    function LoadAsciiLogFile(const AFileName: string): Boolean;
    procedure ServoAmplitudeToUpAdjustment;
    procedure ServoTimeToUpDownAdjustment;
    procedure GenerateNewRndAlertIntervalsForFastPresent(const ALength: Integer);
    procedure GenerateNewRndAlertIntervals(const ALength: Integer);
    procedure ClearNewRndAlertIntervals;
    procedure ClearNewRndAlertIntervalsForFastPresent;
    function GetNewRndAlertIntervalValue(): Integer;
    function GetNewRndAlertIntervalValueForFastPresent(): Integer;
    procedure ClearFormControls;
    procedure SetFormControls;
    procedure LoadSettingsFromINI(const IniFileName: WideString);
    procedure SaveSettingsToINI(const IniFileName: WideString);
    procedure GLInit;
    procedure JoysInit;
    procedure JoysDeInit;
    procedure Init;
    procedure Term;
    procedure TexInit;
    procedure TexDeinit;
    procedure CheckTotalResultAndShowWndMsg;
    procedure calc_select_line(mouse_x: Integer; mouse_y: Integer; var p1: TGLCoord3d; var p2: TGLCoord3d);//!! пока ненужные тут ф-ции
    procedure WorldCoordByMouseXY(X, Y, Z: GLfloat; var p1: TGLCoord3d);//!!
    procedure SetFullScreen(const Value: Boolean);
    procedure SetScreenMode;
    procedure SetVidModeSelectedIndex(const Value: Integer);
    procedure SetFullScreenMode(const Value: Boolean);
    procedure SetDefSessionDurationInMs(const Value: Int64);
    procedure SetCurSessionDurationInMs(const Value: Int64);
    procedure SetCurGameSessionNumber(const Value: Integer);
    //work with comport
    procedure TerminateWorkWithComPort;
    procedure GetComPorts(aList: TStrings; const aNameStart: string);
    procedure ScanComPorts;
    function OpenComPort: Boolean;
    function SetComSettings: Boolean;
    function CloseComPort: Boolean;
    procedure ComSettingsInitialize;
    procedure ComWaitVisibility;
    procedure ComDeInitialize;
    procedure OpenComThreadTerminate(Sender: TObject);
    function StartWorkWithComPort: Boolean;
    function GetWorkState: TDevWorkState;
    procedure SetWorkState(const Value: TDevWorkState);
    procedure OpenComThreadTerminate_(var MSG: TMessage); message UM_OPEN_COM_THREAD_TERMINATE;
    function GetSubTest(Index: Integer): TSubTest;
  public
    { Public declarations }
    procedure UpdateVCLCtrls(var Message: TMessage); message UM_UPDATE_VCL;
    procedure DrawOpenGL(var Message: TMessage); message UM_DRAW_OPENGL;
    procedure StartExperiment(var Message: TMessage); message UM_START_EXPERIMENT;
    procedure NeedSubjAnswerDialog(var Message: TMessage); message UM_NEED_SUBJ_ANSWER_DIALOG;
    procedure UpdateCntrls(var Message: TMessage); message UM_UPDATE_CTRLS;
    procedure FeedbackSuccSignalApply(var Message: TMessage); message UM_FEEDBACK_SUCC_SIGNAL_APPLY;
    procedure FeedbackFailSignalApply(var Message: TMessage); message UM_FEEDBACK_FAIL_SIGNAL_APPLY;
    procedure TicSndEffectApply(var Message: TMessage); message UM_TIC_SIGNAL_APPLY;
    procedure BeginExperiment;
    procedure ShowGL(const AGLCtrlVis: Boolean);
    procedure DoAlertSubjAction();
    procedure DoForcedSubjAction;
    procedure ViewHistCommonCriteria;
    procedure ViewHistCommonRltvVelocity;
    procedure ViewHistCommonDeSynch;
    procedure SendEvent_(const X, Y: Integer);
    property VidModeSelectedIndex: Integer read FVidModeSelectedIndex write SetVidModeSelectedIndex;
    property FullScreen: Boolean read FFullScreen write SetFullScreen;
    property FullScreenMode: Boolean read FFullScreenMode write SetFullScreenMode;
    property DefSessionDurationInMs: Int64 read FDefSessionDurationInMs write SetDefSessionDurationInMs;
    property CurSessionDurationInMs: Int64 read FCurSessionDurationInMs write SetCurSessionDurationInMs;
    property CurGameSessionNumber: Integer read FCurGameSessionNumber write SetCurGameSessionNumber;
    property WorkState: TDevWorkState read GetWorkState write SetWorkState;
    property SubTest[Index: Integer]: TSubTest read GetSubTest;
    //
    procedure DefaultCurves;
    procedure DrawCurves;
    procedure Interpolation;
  protected

  end;

function CreatePlStimModule: Boolean;
function getlocateX(s: TchartSeries; x: double): double;
function getlocate(s: TchartSeries; x: double): double;
function GetServoPosByReoPos(const ReoPos: Word): Word;
function MaestroSetTarget(const Channel: Byte; const Target: Word): Boolean;
function MaestroPololuSetTarget(const Channel: Byte; const Target: Word): Boolean;
procedure ProcMMTime(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD) stdcall;
//procedure SendForcedActionEvent(var TimePC: Int64);
procedure SendSubjectActionEvent(const TimePC: Int64);
procedure glGenTextures (n: GLsizei; textures: PGLuint); stdcall; external opengl32;
procedure glBindTexture (target: GLEnum; texture: GLuint); stdcall; external opengl32;
procedure glTexSubImage2D (target: GLEnum; level, xoffset, yoffset: GLint; width, height: GLsizei; format,
    atype: GLEnum; pixels: Pointer); stdcall; external opengl32;
procedure glDeleteTextures (n: GLsizei; textures: PGLuint); stdcall; external opengl32;
procedure ServoMoveUpDown;
procedure AlertSubjectAction(const Hndl: THandle);
function SendMarker_(const Acode: Byte): Byte;
procedure SendMrkToPortAndWriteLogMsg(const AData: Byte; const AMsg: string; const TimePC: Int64);
function AddRTValue(const AValue: Integer): Integer;
function GetRTValuesCount: Integer;//получить кол-во годных событий поднятия пальца, по которым измерялось RT
procedure ClearRTValues;
function AddReactnVlcityTimeValue(const AValue: Integer): Integer;
function GetReactnVlcityTimeValuesCount: Integer;
procedure ClearReactnVlcityTimeValues;
function AddReactionAccuracy(const AValue: Double): Integer;
function GetReactionAccuracyValuesCount: Integer;
procedure ClearReactionAccuracyValues;

function AddAmplValueLimbToUp(const AValue: Integer): Integer;//!! Лишние переменные
function GetAmplValuesLimbToUpCount: Integer;//!! Лишние переменные
procedure ClearAmplValuesLimbToUp;//!! Лишние переменные

function AddTimeValueLimbUpDown(const AValue: Integer): Integer;
function GetTimeValuesLimbUpDownCount: Integer;
procedure ClearTimeValuesLimbUpDown;

procedure SetIntrvlPeriod(const ms: Integer);
procedure SetAlertActionPeriod(const ms: Integer);
procedure SetAlertDurationPeriod(const ms: Integer);
procedure SetBackdropPeriod(const ms: Integer);
procedure SetForceActionPeriod(const ms: Integer);
procedure SetRTestObjectPeriod(const ms: Integer);
procedure SetIntervalVCLUpdatePeriod(const ms: Integer);
procedure SetIntervalDrawOpenGLPeriod(const ms: Double);
procedure SetFeedbackSignalDefermentPeriod(const ms: Integer);
procedure SetServoParamsAdjPeriod(const ms: Integer);
procedure SetHitToIntervalTimeCorrection(const ms: Integer);
procedure SetHypotheticAvrgRT(const ms: Integer);
function HitToInterval(const TimePc: Int64): Boolean;
procedure TestReactionAccuracy;

const
 BOARD_IMG_WIDTH = 1024;
 BOARD_IMG_HEIGHT  = 1024;
 CHIP_IMG_WIDTH = 64;
 CHIP_IMG_HEIGHT = 64;
 MAXXGRAPH = 5000;

 HypotheticAvrgRT = 360;

var
  fmMain: TfmMain;

  LastPc: Int64;
  LastDrawPc: Int64;
  LastPcIntrvl: Int64;
  LastPcAlertAction: Int64;
  LastPcForcedAction: Int64;
  LastPcRTestObject: Int64;
  LastPcBackdrop: Int64;
  LastPcFeedbackSignal: Int64;
  LastPcServoParamsAdj: Int64;
  IntervalVCLUpdate: Int64;
  IntrvlPeriodInTick: Int64;
  AlertActionPeriodInTick: Int64;
  AlertActionDurationInTick: Int64;
  ForcedActionPeriodInTick: Int64;
  RTestObjectPeriodInTick: Int64;
  IntervalVCLUpdatePeriodInTick: Int64;
  IntervalDrawOpenGLPeriodInTick: Int64;
  BackdropPeriodInTick: Int64;
  FeedbackSignalPeriodInTick: Int64;
  ServoParamsAdjPeriodInTick: Int64;
  HitToIntervalTimeCorrectionInTick: Int64;//коррекция в тесте попадания события поднятия пальца в интервал целевого стимула. Нужна чтобы положит.обр.связь также давалась, если событие наступило раньше
  HypotheticAvrgRTInTick: Int64;//гипотетическое время реакции человека, которое ещё допустимо

  AllowDialogAutoHideTimer: Boolean;
  NeedPrecisionServoAdjust: Boolean;
  Loses: Integer;//кол-во ошибок - палец поднят невовремя
  HitToInterval_: Boolean;

  CurFBSignalDelay: Integer;

  Max_Value : Double = 0;
  Min_Value : Double = MaxInt;

  DC : HDC;
  hrc: HGLRC;
  TimerId : uint;  // идентификатор таймера
  X_, Y_, Z_: GLfloat;
  RTestObj_X: GLfloat;
  RTestObj_Y: GLfloat;
  Fillness: GLfloat;
  Angle : GLfloat;
  AlertCntr: Integer = 0;
  ServoParamsAdjCntr: Integer = 0;
  BoardBitmap: TBitmap;
  ChipBitmap: TBitmap;
  BoardGL: array [0..BOARD_IMG_HEIGHT - 1, 0..BOARD_IMG_WIDTH - 1, 0..2] of GLubyte;
  ChipGL: array [0..CHIP_IMG_HEIGHT - 1, 0..CHIP_IMG_WIDTH - 1, 0..2] of GLubyte;
  TexObj : Array [0..2] of GLUint;
  CVector3_1: TGLCoord3d;
  CVector3_2: TGLCoord3d;
  quadObj : GLUquadricObj;
  chipX_, chipY_: GLDouble;
  //
  ComBaudRate: Cardinal;
  //
  Done: Boolean;
  player: Integer;
  CurchipX, CurchipY: Integer;
  ChipSize_: Extended;
  DefPrelimChipSize: Extended = 0.03;
  DefChipSize: Extended = 0.0714;//0.13;
  FovY: Extended = 55.0;
  PrelimChipX, PrelimChipY: Integer;
  //
  IPlStimModule: IPlStimModuleInterface;
  Lib: HMODULE;
  SetUp: TSetUp;
  TearDown: TTearDown;
  SendEvent: TsendEvent;
  RegisterCallback: TregisterCallback;
  handle_: Pointer;
  //
  BoardPnlEnabled: Boolean;
//  NeedCourse: Boolean;
  CallbackRegistered: Boolean;
  GLCtrlVis: Boolean;
  AlertMoveToUp: Boolean;
  NeedAlertMoveUpDown: Boolean;

  NeedPC3: Boolean = True;
  NeedPC4: Boolean = False;
  Pc3, Pc4: Int64;
  AlertTime: Integer;
  AllowCalcServoParams: Boolean;
  AllowAlertSubjectAction: Boolean;
  NeedAlertSubjectAction: Boolean = False;
  AllowForcedSubjectAction: Boolean = False;
  NeedForcedSubjectAction: Boolean;
  AllowRTestObject: Boolean = False;
  NeedSuccFeedbackSignal: Boolean;
  NeedFailFeedbackSignal: Boolean;
  NeedTicSignal: Boolean;
  NeedResultPresent: Boolean = True;
  AllowSuccFeedbackSignal: Boolean = True;
  AllowFailFeedbackSignal: Boolean = True;
  AllowTicSignal: Boolean = True;
  BaseAllowSuccFeedbackSignal: Boolean = True;//вспомогательные переменные для временного хранения статуса allow
  BaseAllowFailFeedbackSignal: Boolean = True;
  BaseAllowTicSignal: Boolean = True;
  //ExperimentSettings
  MrkFeedbackSuccSignalCode: Integer = 8;
  MrkFeedbackFailSignalCode: Integer = 7;
  MrkBeginIntrvlCode: Integer = 12;
  MrkEndIntrvlCode: Integer = 13;
  MrkEvtActionCode: Integer = 10;
  MrkEMG_EventAriseCode: Integer = 20;//код ЭМГ события (движение)
  MrkEvtForcedActionCode: Integer = 16;//код принудительного поднятия пальца сервой
  MrkAlertSubjActionCode: Integer = 9;//значение, посылаемое в порт, когда возникает предупреждающе о действии событие
  MrkBackdropBeginCode: Integer = 14;
  MrkBackdropEndCode: Integer = 15;
  MrkForcedNextActionCode: Integer = 11;//действие ускоренного вызова окна диалога в вето-варианте
  NeedMrkCode: Boolean;
  NeedSubjAction: Boolean;//не даёт добавлять знач-я критерия и отрисовывать рез-т наж-я, если торчит модальное окно
  NeedOnesEvent: Boolean = False;
  Flg: Boolean = False;
  TmpCntr: Integer = 0;
  TmpCntr2: Integer = 0;
  NeedSuspend: Boolean = False;
  ExpVariants: TExpVariants;
  //work with comport
  EvtOpenComThread: THandle;//для эвента ожидания потока на получение хендла порта
  MaestroServoPos: Word;
  NeedServoUp: Boolean;
  NeedServoDown: Boolean;
  NeedServoMoveUpDown: Boolean;
  ReactionTime: Integer;
  AvrgReactionTime: Integer;
  MinReactionTime: Integer;
  InitialAvrgReactionTime: Integer;
  AvrgReactionAccuracy: Double;
  ReactionAccuracy: Double;
  ReactionVelocityTime: Integer;
  AvrgReactionVelocityTime: Integer;
  GoalReactionVelocityTime: Integer;
  AvrgAmplitudeLimbToUp: Integer;//!!
  GoalAmplitudeLimbToUp: Integer;
  AvrgTimeValueLimbUpDown: Integer;//!! Лишние переменные
  NeedAmplServoAdjust: Boolean = False;
  NeedTimeLimbToUpDownServoAdjust: Boolean = False;
  //
  gx,gy: integer;
  metka1, metka2, metka3, metka4: string;
  XValue, YValue: Double;
  SelectedXIndx: Integer;
  PointFixed: Boolean = True;
  NeedPointMoved: Boolean = False;
  BaseXPoints:  TReal1DArray;
  BaseYPoints:  TReal1DArray;
  DesiredXValues: TReal1DArray;
  RezC: TReal1DArray;
  IntrpResltValues: TReal1DArray;
  NeedAlertSubjActionToRight: Boolean;
  NeedEvtsDecrement: Boolean = True;
  AllowDecTShift: Boolean = True;
  ForceActionTimeShift: Integer = 0;//задержка forced action относительно целевого стимула
  IntrvlPeriod: Integer;
  IntervalDefTimeLen: Integer = 15000;
  IntervalDefTimeLenForFastPresent: Integer = 4000;//отдельно для теста с быстрым предъявлением
  DefAlertDurationTime: Integer = 500;
  AlertDurationTime: Integer;//начальное значение длительности горения светодиода
  ReactionTimeCorrection: Integer = 20;//69;{коррекция в "0" для программного целевого стимула}//время реакции чел-ка или сервы от момента предъявления целевого стимула в мс
  ActionDelayTimeCorrection: Integer = 24;//44;//задержка в "0" по показаниям фотодиодов для программного целевого стимула
  LimbOneHasUp: Boolean;
  LimbOneHasDown: Boolean = True;
  AntiChatteringCntr: Integer = 0;
  LimbOneUpTimeCntr: Int64;
  LimbOneDownTimeCntr: Int64;
  AlertSubjActionTimeCntr: Int64;
  EndIntrvlTimeCntr: Int64;
  RTValues: TIntegerDynArray;
  ReactnVlcityTimeValues: TIntegerDynArray;
  ReactionAccuracyValues: TDoubleDynArray;
  AmplValuesLimbToUp: TIntegerDynArray;
  TimeValuesLimbUpDown: TIntegerDynArray;
  NewAlertInterval: Integer;
  NeedGetPos: Boolean = True;
  NeedSetTarget: Boolean = True;
  ServoNeedMax: Word = 4*(SERVO_MAX+500);//макс.величина поднятия пальца. Надо подстраивать под инд.стиль!
  ServoNeedMin: Word = 4*SERVO_MIN;
  ServoVlcty: Integer = 120;
  LimbOneUpCntr: Integer;//кол-во событий поднятия польца вообще
  SuccessSndEffect: HEFFECT;
  FailureSndEffect: HEFFECT;
  TicSndEffect: HEFFECT;
  TacSndEffect: HEFFECT;
  EndExperimentSndEffect: HEFFECT;
  SuccessSndFileName: string;
  FailureSndFileName: string;
  TicSndFileName: string;
  TacSndFileName: string;
  EndExperimentSndFileName: string;

  Cntr: Int64;
  ChnlCntrs: array [0..ACTICHAMP_CH_CNT-1] of Integer;
  StubData: TDoubleDynArray;
  FiltersEnabled: Boolean;
  JvTimerLPTZero: TJvTimer;

implementation

{$R *.dfm}

function CreatePlStimModule: Boolean;
var
  ii: IInterface;
  im: IModuleInterface;
begin
  ii := CreateComObject(Class_PlStimModule);
  if (ii <> nil) then
  begin
    ii.QueryInterface(IPlStimModuleInterface, IPlStimModule);
    ii.QueryInterface(IModuleInterface, im);
//    im.NotifyWindowHandle := fmMain.Handle;
  end;
end;

// подмена LOCATE TCHART
function getlocateX(s: TchartSeries; x: double): double;
var
  i: Integer;
begin
 Result := 0;
 //
 for i:= 0 to s.XValues.Count-1 do
  if s.XValue[i] >= x then
  begin
    Result := s.XValue[i];
    Break;
  end
end;

function getlocate(s: TchartSeries; x: double): double;
var
  i: Integer;
begin
 Result := 0;
 //
 for i:= 0 to s.YValues.Count-1 do
  if s.XValue[i] >= x then
  begin
    Result := s.YValue[i];
    Break;
  end
end;

function GetServoPosByReoPos(const ReoPos: Word): Word;
var
  indx: Integer;
begin
  //делаем сначала линейное преобразование в д-н всех положений серво (REO_MAX-REO_MIN)
  indx := Trunc(0 + ((SERVO_RANGE-1 - 0) * ( (ReoPos-REO_MIN)/(REO_MAX-REO_MIN) )) + 0.5);
  //это значение используем как индекс и берём из массива интерполированных значений передаточной кривой
  Result := Trunc(IntrpResltValues[indx]);
//  Result := Trunc(SERVO_MIN + ((SERVO_MAX - SERVO_MIN) * ( (ReoPos-0)/(REO_MAX-REO_MIN) )) + 0.5);
end;

///** Implements the Maestro's Set Target serial command.
// * channel: Channel number from 0 to 23
// * target: The target value (for a servo channel, the units are quarter-milliseconds)
// * Returns 1 on success, 0 on failure.
// * Fore more information on this command, see the "Serial Servo Commands"
// * section of the Maestro User's Guide: http://www.pololu.com/docs/0J40 */
function MaestroSetTarget(const Channel: Byte; const Target: Word): Boolean;
var
	bytesTransferred: Cardinal;
	success: Boolean;
begin
  Result := False;
	// Compose the command.
	MaestroSetTargetCmd[1] := channel;
	MaestroSetTargetCmd[2] := Target and $7F;
	MaestroSetTargetCmd[3] := (Target shr 7) and $7F;

	// Send the command to the device.
	success := WriteFile(ComVar.hCom, MaestroSetTargetCmd, MaestroSetTargetCmd_size, bytesTransferred, nil);
	if (success) and (MaestroSetTargetCmd_size = bytesTransferred) then
		Result := True;
end;

function MaestroPololuSetTarget(const Channel: Byte; const Target: Word): Boolean;
var
	bytesTransferred: Cardinal;
	success: Boolean;
begin
  Result := False;
	// Compose the command.
	MaestroPololuSetTargetCmd[3] := channel;
	MaestroPololuSetTargetCmd[4] := Target and $7F;
	MaestroPololuSetTargetCmd[5] := (Target shr 7) and $7F;

	// Send the command to the device.
	success := WriteFile(ComVar.hCom, MaestroPololuSetTargetCmd, MaestroPololuSetTargetCmd_size, bytesTransferred, nil);
	if (success) and (MaestroPololuSetTargetCmd_size = bytesTransferred) then
		Result := True;
end;

procedure ServoMoveUpDown;
begin
  if NeedSetTarget then //запросы крутить серву через раз в цикле MMTime
  begin
  //  servoPos := MaestroServoPos;
    if NeedServoUp then
    begin
      if MaestroServoPos > servoNeedMax then
      begin
       //addlogmessage('fdgfdg.log', 'ServoUp  ' + Inttostr(MaestroServoPos));
        //MaestroServoPos := servoNeedMax;
        dec(MaestroServoPos, ServoVlcty);//скорость движ-я сервы вверх. Надо подстраивать под инд.стиль!
        MaestroServoPos := max(ServoNeedMax, MaestroServoPos);
        MaestroSetTarget(1, MaestroServoPos{MaestroServoPos});
      end
      else
      begin
        NeedServoUp := False;
        NeedServoDown := True;
        //fmMain.tmrNeedServoDown.Enabled := True;//включаем таймер ожидания пока серва отработает движ-е вверх. Надо подгонять под экземпляр!
      end;
    end;
    if NeedServoDown then
    begin
      if MaestroServoPos < servoNeedMin then
      begin
        //MaestroServoPos := servoNeedMin;
        inc(MaestroServoPos, ServoVlcty);//скорость движ-я сервы вниз. Надо подстраивать под инд.стиль!
        MaestroServoPos := min(ServoNeedMin, MaestroServoPos);
        //addlogmessage('fdgfdg.log', 'ServoDn  ' + Inttostr(MaestroServoPos));
        MaestroSetTarget(1, MaestroServoPos{MaestroServoPos});
  //      if MaestroServoPos = servoNeedMin then
  //        MaestroSetTarget(1, 0{MaestroServoPos});
      end
      else
      begin
        NeedServoMoveUpDown := False;
        NeedServoUp := True;
        NeedServoDown := False;
        NeedSetTarget := True;
      end;
    end;
  end;
  NeedSetTarget := not NeedSetTarget;
end;

//procedure ServoMoveUpDown;
//begin
//  if NeedSetTarget then //запросы крутить серву через раз в цикле MMTime
//  begin
//  //  servoPos := MaestroServoPos;
//    if NeedServoUp then
//    begin
//      if MaestroServoPos > servoNeedMax then
//      begin
//       //addlogmessage('fdgfdg.log', 'ServoUp  ' + Inttostr(MaestroServoPos));
//        //MaestroServoPos := servoNeedMax;
//        dec(MaestroServoPos, 200);//скорость движ-я сервы вверх. Надо подстраивать под инд.стиль!
//        MaestroServoPos := max(ServoNeedMax, MaestroServoPos);
//        MaestroSetTarget(1, MaestroServoPos{MaestroServoPos});
//      end
//      else
//      begin
//        NeedServoUp := False;
//        NeedServoDown := True;
//        //fmMain.tmrNeedServoDown.Enabled := True;//включаем таймер ожидания пока серва отработает движ-е вверх. Надо подгонять под экземпляр!
//      end;
//    end;
//    if NeedServoDown then
//    begin
//      if MaestroServoPos < servoNeedMin then
//      begin
//        //MaestroServoPos := servoNeedMin;
//        inc(MaestroServoPos, 200);//скорость движ-я сервы вниз. Надо подстраивать под инд.стиль!
//        MaestroServoPos := min(ServoNeedMin, MaestroServoPos);
//        //addlogmessage('fdgfdg.log', 'ServoDn  ' + Inttostr(MaestroServoPos));
//        MaestroSetTarget(1, MaestroServoPos{MaestroServoPos});
//  //      if MaestroServoPos = servoNeedMin then
//  //        MaestroSetTarget(1, 0{MaestroServoPos});
//      end
//      else
//      begin
//        NeedServoMoveUpDown := False;
//        NeedServoUp := True;
//        NeedServoDown := False;
//      end;
//    end;
//  end;
//  NeedSetTarget := not NeedSetTarget;
//end;

//аппаратный вариант со светодиодом
procedure AlertSubjectAction(const Hndl: THandle);
begin
  QueryPerformanceCounter(Pc);
  if AlertMoveToUp then
  begin
    MaestroSetTarget(3, 4*SERVO_MIN);//photodiode on
    AlertMoveToUp := False;
  end;
//  if AlertCntr >= 50 then
//  begin
//    MaestroSetTarget(3, ServoNeedMax);//photodiode off
//    AlertCntr := 0;
//    NeedAlertMoveUpDown := False;
//    AlertMoveToUp := True;
//  end;
//  inc(AlertCntr);
  if Pc >= LastPcAlertAction + AlertActionDurationInTick then
  begin
    //выключить стимул
    MaestroSetTarget(3, 4*SERVO_MAX);
    NeedAlertMoveUpDown := False;
    AlertMoveToUp := True;
//    AlertActionDurationInTick := MaxInt;//чтобы снова сюда не попасть
  end;
end;

//программный вариант с ним джиттеринг +-17 мс
//procedure AlertSubjectAction(const Hndl: THandle);
//begin
//  if NeedAlertSubjActionToRight then
//  begin
//    //предупреждающий сигнал - колебание коромысла вправо и возврат в исх.позицию 180
//    if AlertMoveToUp then
//    begin
//      Angle := Angle - 0.2;
//      if Angle <= 156{150} then
//        AlertMoveToUp := False;
//    end
//    else
//    begin
//      Angle := 180;
//      //Angle := Angle + 0.2;
//      if Angle >= 180 then
//      begin
//        Angle := 180;
//        NeedAlertMoveUpDown := False;
//        AlertMoveToUp := True;
//      end;
//    end;
//  end
//  else
//  begin
//    //предупреждающий сигнал - колебание коромысла влево и возврат в исх.позицию 180
//    if AlertMoveToUp then
//    begin
//      Angle := Angle + 0.2;
//      if Angle >= 190{210} then
//        AlertMoveToUp := False;
//    end
//    else
//    begin
//      Angle := 180;
//      Angle := Angle - 0.2;
//      if Angle <= 180 then
//      begin
//        Angle := 180;
//        NeedAlertMoveUpDown := False;
//        AlertMoveToUp := True;
//      end;
//    end;
//  end;
//  InvalidateRect(Hndl, nil, False);
//end;

//старый вариант с 2-мя getpos
//procedure AlertSubjectAction(const Hndl: THandle);
//begin
//  if NeedAlertSubjActionToRight then
//  begin
//    //предупреждающий сигнал - колебание коромысла вправо и возврат в исх.позицию 180
//    if AlertMoveToUp then
//    begin
//      Angle := Angle - 6;
//      if Angle <= 156{150} then
//        AlertMoveToUp := False;
//    end
//    else
//    begin
//      Angle := 180;
//      //Angle := Angle + 6;
//      if Angle >= 180 then
//      begin
//        Angle := 180;
//        NeedAlertMoveUpDown := False;
//        AlertMoveToUp := True;
//      end;
//    end;
//  end
//  else
//  begin
//    //предупреждающий сигнал - колебание коромысла влево и возврат в исх.позицию 180
//    if AlertMoveToUp then
//    begin
//      Angle := Angle + 1{0.4};
//      if Angle >= 190{210} then
//        AlertMoveToUp := False;
//    end
//    else
//    begin
//      Angle := 180;
//      Angle := Angle - 6;
//      if Angle <= 180 then
//      begin
//        Angle := 180;
//        NeedAlertMoveUpDown := False;
//        AlertMoveToUp := True;
//      end;
//    end;
//  end;
//  InvalidateRect(Hndl, nil, False);
//end;

procedure SendMrkToPortAndWriteLogMsg(const AData: Byte; const AMsg: string; const TimePC: Int64);
begin
  //17.08.2016 есть проблема с тем, что если посылать маркеры в ЭЭГ слишком быстро (4 мс и меньше), то один из них не доходит
  //может поднять частоту дискретизации записи ЭЭГ? Сейчас проблема при 500Гц
  SendMarker_(AData);
  AddMsgDataToLogFile_(NameForLogFile, AMsg, TimePC);
end;

function AddRTValue(const AValue: Integer): Integer;
begin
  SetLength(RTValues, Length(RTValues)+1);
  RTValues[High(RTValues)] := AValue;
  Result := Length(RTValues);
end;

function GetRTValuesCount: Integer;
begin
  Result := Length(RTValues);
end;

procedure ClearRTValues;
begin
  Finalize(RTValues);
end;

function AddReactnVlcityTimeValue(const AValue: Integer): Integer;
begin
  SetLength(ReactnVlcityTimeValues, Length(ReactnVlcityTimeValues)+1);
  ReactnVlcityTimeValues[High(ReactnVlcityTimeValues)] := AValue;
  Result := Length(ReactnVlcityTimeValues);
end;

function GetReactnVlcityTimeValuesCount: Integer;
begin
  Result := Length(ReactnVlcityTimeValues);
end;

procedure ClearReactnVlcityTimeValues;
begin
  Finalize(ReactnVlcityTimeValues);
end;

function AddReactionAccuracy(const AValue: Double): Integer;
begin
  SetLength(ReactionAccuracyValues, Length(ReactionAccuracyValues)+1);
  ReactionAccuracyValues[High(ReactionAccuracyValues)] := AValue;
  Result := Length(ReactionAccuracyValues);
end;

function GetReactionAccuracyValuesCount: Integer;
begin
  Result := Length(ReactionAccuracyValues);
end;

procedure ClearReactionAccuracyValues;
begin
  Finalize(ReactionAccuracyValues);
end;

function AddAmplValueLimbToUp(const AValue: Integer): Integer;
begin
  SetLength(AmplValuesLimbToUp, Length(AmplValuesLimbToUp)+1);
  AmplValuesLimbToUp[High(AmplValuesLimbToUp)] := AValue;
  Result := Length(AmplValuesLimbToUp);
end;

function GetAmplValuesLimbToUpCount: Integer;
begin
  Result := Length(AmplValuesLimbToUp);
end;

procedure ClearAmplValuesLimbToUp;
begin
  Finalize(AmplValuesLimbToUp);
end;

function AddTimeValueLimbUpDown(const AValue: Integer): Integer;
begin
  SetLength(TimeValuesLimbUpDown, Length(TimeValuesLimbUpDown)+1);
  TimeValuesLimbUpDown[High(TimeValuesLimbUpDown)] := AValue;
  Result := Length(TimeValuesLimbUpDown);
end;

function GetTimeValuesLimbUpDownCount: Integer;
begin
  Result := Length(TimeValuesLimbUpDown);
end;

procedure ClearTimeValuesLimbUpDown;
begin
  Finalize(TimeValuesLimbUpDown);
end;

procedure SetIntrvlPeriod(const ms: Integer);
begin
  QueryPerformanceCounter(LastPcIntrvl);
  IntrvlPeriodInTick := Trunc(Pf * ms / 1000 + 0.5);
end;

procedure SetAlertActionPeriod(const ms: Integer);
begin
  AlertActionPeriodInTick := Trunc(Pf * ms / 1000 + 0.5);
  NeedAlertSubjectAction := False;
end;

procedure SetAlertDurationPeriod(const ms: Integer);
begin
  AlertActionDurationInTick := Trunc(Pf * ms / 1000 + 0.5);
end;

procedure SetBackdropPeriod(const ms: Integer);
begin
  BackdropPeriodInTick := Trunc(Pf * ms / 1000 + 0.5);
  LastPcBackdrop:= Pc;
end;

procedure SetForceActionPeriod(const ms: Integer);
begin
  ForcedActionPeriodInTick := Trunc(Pf * ms / 1000 + 0.5);
  NeedForcedSubjectAction := False;
end;

procedure SetRTestObjectPeriod(const ms: Integer);
begin
  RTestObjectPeriodInTick := Trunc(Pf * ms / 1000 + 0.5);
//  AddMsgDataToLogFile_('_log', ' RTestObjectPeriodInTick= ' + IntToStr(LastPcRTestObject), Pc);//!! убрать
  LastPcRTestObject := Pc;
end;

procedure SetIntervalVCLUpdatePeriod(const ms: Integer);
begin
  IntervalVCLUpdatePeriodInTick := Trunc(Pf * ms / 1000 + 0.5);
  LastPc:= Pc;
end;

procedure SetIntervalDrawOpenGLPeriod(const ms: Double);
begin
  IntervalDrawOpenGLPeriodInTick := Trunc(Pf * ms / 1000 + 0.5);
  LastDrawPc := Pc;
end;

procedure SetFeedbackSignalDefermentPeriod(const ms: Integer);
begin
  FeedbackSignalPeriodInTick := Trunc(Pf * ms / 1000 + 0.5);
end;

procedure SetServoParamsAdjPeriod(const ms: Integer);
begin
  ServoParamsAdjPeriodInTick := Trunc(Pf * ms / 1000 + 0.5);
  LastPcServoParamsAdj := Pc;
end;

procedure SetHitToIntervalTimeCorrection(const ms: Integer);
begin
  HitToIntervalTimeCorrectionInTick := Trunc(Pf * ms / 1000 + 0.5);
end;

procedure SetHypotheticAvrgRT(const ms: Integer);
begin
  HypotheticAvrgRTInTick := Trunc(Pf * ms / 1000 + 0.5);
end;

function HitToInterval(const TimePc: Int64): Boolean;
begin
//  Result := (TimePc > LastPcAlertAction - HitToIntervalTimeCorrectionInTick) and (TimePc <= LastPcAlertAction + AlertActionDurationInTick);
//тест попадания события поднятия пальца в интервал действия стимула. Считается от начала интервала, т.к. стимула может наступить позднее, чем вызывается эта ф-ция
//Коррекция - хитрость. Тест проходит, если событие наступает чуть раньше стимула
//это нужно в тестах с отрицательными значениями TShift для Forced action чтобы не было различий в звуковых сигналах подтверждения. Испытуемый должен думать, что всё ок :)
  Result := (TimePc > (LastPcIntrvl + AlertActionPeriodInTick) - HitToIntervalTimeCorrectionInTick) and (TimePc < (LastPcIntrvl + AlertActionPeriodInTick) + {HypotheticAvrgRTInTick}AlertActionDurationInTick);
end;

procedure TestReactionAccuracy;
begin
  ReactionAccuracy := RTestObj_X;//берём значение координаты пролетающего объекта. Он есть мера точности реакции
  if (Abs(ReactionAccuracy) <= 0.2) and AllowSuccFeedbackSignal then
  begin
    NeedSuccFeedbackSignal := True;
    NeedFailFeedbackSignal := False;
  end
//    PostMessage(fmMain.Handle, UM_FEEDBACK_SUCC_SIGNAL_APPLY, 0, 0) //Надо переделать для единообразия, чтобы звук ОС был через 200мс после движения!
  else
   if AllowFailFeedbackSignal then
   begin
     NeedSuccFeedbackSignal := False;
     NeedFailFeedbackSignal := True;
   end;
//     PostMessage(fmMain.Handle, UM_FEEDBACK_FAIL_SIGNAL_APPLY, 0, 0);//Надо переделать для единообразия, чтобы звук ОС был через 200мс после движения!
  AddReactionAccuracy(ReactionAccuracy);
  if Length(ReactionAccuracyValues) > 0 then
    AvrgReactionAccuracy := Sum(ReactionAccuracyValues) / Length(ReactionAccuracyValues);

  AddMsgDataToLogFile_(NameForLogFile, 'RctnAccValue ' + 'RAValue= ' + FloatToStrF(ReactionAccuracy, ffFixed, 8, 3), Pc);
end;

procedure ProcMMTime(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD) stdcall;
var
  wndHndl: HWND;
  difAmpl: Integer;
  difTime: Integer;
  curServoVlcty: Integer;
  curServoNeedMax: Integer;
  x_min, xi_min: Integer;
  x_max, xi_max: Integer;
begin
  QueryPerformanceCounter(Pc);

//  if NeedSuspend then
//    Exit;
  {
  глюки Maestro Polou 6: вызов MaestroGetPosition блокирует ProcMMTime в диалоговом окне
  последовательный вызов MaestroGetPosition(0 MaestroGetPosition(2 вызывает путаницу - значения потенциометра и контактного датчика
  неожиданно во время работы программы меняются местами.
  }

  if not NeedSuspend then
  begin
    wndHndl := HWND(dwUser);
    //серво следует за позицией, пересчитанной из показаний потенциометра
    //с потенциометра получаются значения 0..1023
    //они переводятся линейно в д-н серво

    //принудительно поднять-опустить палец сервой, если надо
    //при этом выставление позиции сервой через потенциометр временно блокируется
    if NeedServoMoveUpDown then
        ServoMoveUpDown
    else
    begin
      //если принудительное поднятие отработало, то выбираем способ выставления позиции серво по показанию потенциометра
  //    MaestroServoPos := 4*GetServoPosByReoPos(MaestroReoPos);
  //    MaestroSetTarget(1, MaestroServoPos);
    end;
    //по очереди опрашиваем за цикл, иначе - глюки Maestro - путает местами ответные значения с порта
    //в итоге, получаем 500Гц опрос - 2мс точность
    //плюсы - цикл ProcMMTime проворачивается в 2 раза быстрее
    if NeedGetPos then
      MaestroGetPosition(2, LimbOneUpSensorVal)//получить значение с датчика поднятия пальца
    else
      MaestroGetPosition(0, MaestroReoPos);//с потенциометра получаются значения 0..1023
    NeedGetPos := not NeedGetPos;

//    MaestroGetErrors(MaestroErrCode);
//    if MaestroErrCode <> 0 then
//      AddMsgDataToLogFile_('_Err', IntToStr(MaestroErrCode), Pc);

    case RequestType of
      rtBeginBackdrop://старт записи фона ЭЭГ
      begin
        if QrPC0 = 0 then
          QueryPerformanceCounter(QrPC0);
        SendMrkToPortAndWriteLogMsg(MrkBackdropBeginCode, 'MrkBackdrop ' + 'MrkBackdropBegin=' + IntToStr(MrkBackdropBeginCode), Pc);
        PostMessage(wndHndl, UM_UPDATE_CTRLS, 0, 0);
        RequestType := rtAmongBackdrop;
      end;
      rtAmongBackdrop:
      begin
        if Pc >= LastPcBackdrop + BackdropPeriodInTick then
          RequestType := rtEndBackdrop;
      end;
      rtEndBackdrop://финиш записи фона ЭЭГ
      begin
        SendMrkToPortAndWriteLogMsg(MrkBackdropEndCode, 'MrkBackdrop ' + 'MrkBackdropEnd' + IntToStr(MrkBackdropEndCode), Pc);
        PostMessage(wndHndl, UM_UPDATE_CTRLS, 0, 0);
        IPlStimModule.Effect_StartPlay(EndExperimentSndEffect, False);
        RequestType := rtNone;
      end;
      rtStartExperiment:
      begin
        NeedMrkCode := False;
        NeedSubjAction := False;
        PostMessage(wndHndl, UM_START_EXPERIMENT, 0, 0);
        ClearRTValues;
        ClearReactnVlcityTimeValues;
        ClearReactionAccuracyValues;
        ClearAmplValuesLimbToUp;
        ClearTimeValuesLimbUpDown;
        RequestType := rtNone;
      end;
      rtNeedGetSubjAnswer:
      begin
        //вызов диалогового окна для получения ответа испытуемого
        PostMessage(wndHndl, UM_NEED_SUBJ_ANSWER_DIALOG, 0, 0);
        RequestType := rtNone;
      end;
      rtBeginIntrvl:
      begin
        SendMrkToPortAndWriteLogMsg(MrkBeginIntrvlCode, 'MrkEvent ' + 'MrkBeginIntrvlCode= ' + IntToStr(MrkBeginIntrvlCode), Pc);
        NeedAlertSubjectAction := AllowAlertSubjectAction and (NewAlertInterval > 0);
        NeedForcedSubjectAction := AllowForcedSubjectAction and (NewAlertInterval > 0);
        NeedTicSignal := AllowTicSignal;
        if NeedTicSignal then
          PostMessage(wndHndl, UM_TIC_SIGNAL_APPLY, 0, 0);
        //IPlStimModule.Effect_StartPlay(TicSndEffect, False);
        LimbOneHasUp := False;//чтобы сработало измерение RT, скорости движение пальца вверз-вниз по контактному датчику
        SetIntrvlPeriod(IntrvlPeriod);
        LastPcAlertAction := LastPcIntrvl;
        LastPcForcedAction := LastPcIntrvl;
        RequestType := rtAmongIntrvl;
        NeedMrkCode := True;
        NeedSubjAction := True;
        NeedOnesEvent := True;
        HitToInterval_ := False;
      end;
      rtAmongIntrvl://посреди интервала
      begin
        //контролируем, не закончился ли интервал
        if Pc >= LastPcIntrvl + IntrvlPeriodInTick then
        begin
          //интервал закончился
          EndIntrvlTimeCntr := Pc;
          RequestType := rtEndIntrvl;
          BeginIntrvlFlg := False;//!!!!!!!!!!!!!!!!!!!
        end;
        //контролируем, не настало ли время появления целевого стимула
        if Pc >= LastPcAlertAction + AlertActionPeriodInTick then
        begin
          //настало время появления целевого стимула
          if NeedAlertSubjectAction then
          begin
            EMG_EventArise := False;//сбрасываем флаг обнаружения ЭМГ активности
            SendMrkToPortAndWriteLogMsg(MrkAlertSubjActionCode, 'AlertSubjAction ' + 'AlertSubjActionCode= ' + IntToStr(MrkAlertSubjActionCode), Pc);
            AddMsgDataToLogFile_(NameForLogFile, 'AlertDurationTime ' + 'AlertDurationTime= ' + IntToStr(AlertDurationTime), Pc);
            LastPcAlertAction := Pc;
            AlertSubjActionTimeCntr := Pc;//засекаем момент
            fmMain.DoAlertSubjAction();
          end;
        end;
        //контролируем, не настало ли время forced action
        if Pc >= LastPcForcedAction + ForcedActionPeriodInTick then
        begin
          //время Forced Action
          if NeedForcedSubjectAction then
          begin
            LastPcForcedAction := Pc;
            fmMain.DoForcedSubjAction;
            AddMsgDataToLogFile_(NameForLogFile, 'ForcedSubjAction ' + 'ForcedSubjActionCode= ' + IntToStr(MrkEvtForcedActionCode), Pc);
            //SendMrkToPortAndWriteLogMsg(MrkEvtForcedActionCode, 'ForcedSubjAction ' + 'ForcedSubjActionCode= ' + IntToStr(MrkEvtForcedActionCode), Pc);
          end;
        end;
        //смотрим, не настало ли время пролёта по экрану тестового стимула
        if Pc >= LastPcRTestObject + RTestObjectPeriodInTick then
        begin
          //AddMsgDataToLogFile_('_log', ' LastPcRTestObject=' + IntToStr(LastPcRTestObject), Pc);//!! убрать
          AllowRTestObject := True;
          LastPcRTestObject := MaxInt64;//чтобы больше не сработало
        end;

      end;
      rtEndIntrvl:
      begin
        RequestType := rtNeedGetSubjAnswer;
        NeedSubjAction := False;
        ReactionTime := Trunc((LimbOneUpTimeCntr - AlertSubjActionTimeCntr) / pf * 1000 + 0.5) - ReactionTimeCorrection{коррекция в "0"};//время реакции чел-ка или сервы от момента предъявления целевого стимула в мс
        if (ReactionTime > -150) and (ReactionTime < 1000) then //проверка значения на адекватность
          AddRTValue(ReactionTime);
        if Length(RTValues) > 0 then
          AvrgReactionTime := Trunc(SumInt(RTValues) / Length(RTValues)+0.5);

        MinReactionTime := MinIntValue(RTValues);

//        //время движения пальца вверх-вниз по контактному датчику, ms
//        if (LimbOneDownTimeCntr - LimbOneUpTimeCntr > 0) then
//          ReactionVelocityTime := Trunc((LimbOneDownTimeCntr - LimbOneUpTimeCntr) / pf * 1000 + 0.5);
//        if ReactionVelocityTime < 1000 then
//          AddReactnVlcityTimeValue(ReactionVelocityTime);
//
//        if Length(ReactnVlcityTimeValues) > 0 then
//          AvrgReactionVelocityTime := Trunc(SumInt(ReactnVlcityTimeValues) / Length(ReactnVlcityTimeValues)+0.5);

        SendMrkToPortAndWriteLogMsg(MrkEndIntrvlCode, 'MrkEvent ' + 'MrkEndIntrvlCode= ' + IntToStr(MrkEndIntrvlCode), EndIntrvlTimeCntr);
       // IPlStimModule.Effect_StartPlay(TacSndEffect, False);
        AddMsgDataToLogFile_(NameForLogFile, 'RTValue ' + 'RTValue= ' + IntToStr(ReactionTime), EndIntrvlTimeCntr);
        AddMsgDataToLogFile_(NameForLogFile, 'AvrgRT ' + 'AvrgRT= ' + IntToStr(AvrgReactionTime), EndIntrvlTimeCntr);
        AddMsgDataToLogFile_(NameForLogFile, 'MinRT ' + 'MinRT= ' + IntToStr(MinReactionTime), EndIntrvlTimeCntr);
        AddMsgDataToLogFile_(NameForLogFile, 'RTValCnt ' + 'edtRTValCnt= ' + IntToStr(GetRTValuesCount), EndIntrvlTimeCntr);

        AddMsgDataToLogFile_(NameForLogFile, 'AmplitudeLimbToUp ' + 'AmplitudeLimbToUp= ' + IntToStr(AmplitudeLimbToUp), Pc);
        AddMsgDataToLogFile_(NameForLogFile, 'AvrgAmplitudeLimbToUp ' + 'AvrgAmplitudeLimbToUp= ' + IntToStr(AvrgAmplitudeLimbToUp), Pc);

        AddMsgDataToLogFile_(NameForLogFile, 'ReactionVelocityTime ' + 'ReactionVelocityTime= ' + IntToStr(ReactionVelocityTime), EndIntrvlTimeCntr);
        AddMsgDataToLogFile_(NameForLogFile, 'AvrgReactionVelocityTime ' + 'AvrgReactionVelocityTime= ' + IntToStr(AvrgReactionVelocityTime), EndIntrvlTimeCntr);
      end;
      rtEndExperiment:
      begin
        Finalize(LineDelaysArr);
        InitialAvrgReactionTime := AvrgReactionTime;
        //тут надо писать в лог все средние значения измеренных параметров!
        AddMsgDataToLogFile_(NameForLogFile, 'AvrgRTValue ' + 'AvrgRTValue= ' + IntToStr(AvrgReactionTime), Pc);
        AddMsgDataToLogFile_(NameForLogFile, 'MinRTValue ' + 'MinRTValue= ' + IntToStr(MinReactionTime), Pc);
        AddMsgDataToLogFile_(NameForLogFile, 'AvrgReactionVelocityTime ' + 'AvrgReactionVelocityTime= ' + IntToStr(AvrgReactionVelocityTime), Pc);
        if ExpVariants in [evSeventhvariant, evEighthVariant] then
          AddMsgDataToLogFile_(NameForLogFile, 'AvrgReactionAccuracyValue ' + 'AvrgReactionAccuracyValue= ' + FloatToStr(AvrgReactionAccuracy), Pc);

        SendMrkToPortAndWriteLogMsg(0, 'MrkEvent ' + 'EndExperiment', Pc);
        PostMessage(wndHndl, UM_UPDATE_CTRLS, Integer(RequestType), 0);
        NeedSubjAction := False;
        IPlStimModule.Effect_StartPlay(EndExperimentSndEffect, False);
        RequestType := rtNone;
      end;
      rtServoParamsAdjustment:
      begin
        if Pc >= LastPcServoParamsAdj + ServoParamsAdjPeriodInTick then
        begin
          NeedOnesEvent := True;
          if NeedAmplServoAdjust then
          begin
            difAmpl := (GoalAmplitudeLimbToUp - AmplitudeLimbToUp);
            if ((Abs(difAmpl) > 0) and (Abs(difAmpl) <= 5)) or (ServoParamsAdjCntr >= 40) then
            begin
              RequestType := rtServoParamsAdjusted;
              AdjustedAmplitudeLimbToUp := AmplitudeLimbToUp;
              Exit;
            end;

            NeedPrecisionServoAdjust := (Abs(difAmpl) <= 50);

            inc(ServoParamsAdjCntr);
            fmMain.DoForcedSubjAction;
            curServoNeedMax := ServoNeedMax;
            if NeedPrecisionServoAdjust then
            begin
              if difAmpl > 0 then
                dec(curServoNeedMax, 4*2)
              else
                inc(curServoNeedMax, 4*2);
            end
            else
            begin
              if difAmpl > 0 then
                dec(curServoNeedMax, 4*8)
              else
                inc(curServoNeedMax, 4*8);
            end;
            ServoNeedMax := Min(4*SERVO_MIN, Max(4*SERVO_MAX, curServoNeedMax));
          end;
          if NeedTimeLimbToUpDownServoAdjust then
          begin
            difTime := GoalReactionVelocityTime  - ReactionVelocityTime;
            if ((Abs(difTime) > 0) and (Abs(difTime) <= 5)) or (ServoParamsAdjCntr >= 40) then
            begin
              RequestType := rtServoParamsAdjusted;
              AdjustedTimeLimbToUpDown := ReactionVelocityTime;
              Exit;
            end;
            NeedPrecisionServoAdjust := (Abs(difTime) <= 50);
            inc(ServoParamsAdjCntr);
            fmMain.DoForcedSubjAction;
            curServoVlcty := ServoVlcty;
            if NeedPrecisionServoAdjust then
            begin
              if difTime > 0 then
                dec(curServoVlcty, 1)
              else
                inc(curServoVlcty, 1);
            end
            else
            begin
              if difTime > 0 then
                dec(curServoVlcty, 4)
              else
                inc(curServoVlcty, 4);
            end;
            ServoVlcty := Max(1, curServoVlcty);
          end;

          LastPcServoParamsAdj := Pc;
        end;
      end;
      rtServoParamsAdjusted:
      begin
        RequestType := rtNone;
        NeedSubjAction := False;
        AllowSuccFeedbackSignal := BaseAllowSuccFeedbackSignal;
        AllowFailFeedbackSignal := BaseAllowFailFeedbackSignal;
        AllowTicSignal := BaseAllowTicSignal;
        Application.MessageBox(PChar('Целевая средн.амп-да по потенц-ру: ' + IntToStr(GoalAmplitudeLimbToUp) + ' Целевое средн.время движ-я: ' + IntToStr(GoalReactionVelocityTime) + #10#13 +
        ' Текущие режимы серво: ' + ' апл-да по потенц-ру: ' + IntToStr(AdjustedAmplitudeLimbToUp) +
        ' время движ-я: ' + IntToStr(AdjustedTimeLimbToUpDown) + #10#13 + ' Кол-во итераций: ' + IntToStr(ServoParamsAdjCntr)), PChar(strModuleName), MB_ICONINFORMATION);
      end;
    end;
    //если сигнал ОС нужен и настало его время - применяем
    if (Pc >= LastPcFeedbackSignal + FeedbackSignalPeriodInTick) then
    begin
      if NeedSuccFeedbackSignal then
      begin
        PostMessage(wndHndl, UM_FEEDBACK_SUCC_SIGNAL_APPLY, 0, 0);
        //FeedbackSuccSignalApply;
      end else
      if NeedFailFeedbackSignal then
      begin
        PostMessage(wndHndl, UM_FEEDBACK_FAIL_SIGNAL_APPLY, 0, 0);
        //FeedbackFailSignalApply;
      end;
      LastPcFeedbackSignal := MaxInt64;
    end;

    if NeedAlertMoveUpDown then
      AlertSubjectAction(fmMain.BoardPnl.Handle);

  //  if WorkMode in [wmGettingData, wmNeedCalculateData, wmCalculatedData] then
    begin
      JPedals.wxpos := {GetServoPosByReoPos}(MaestroReoPos);

      difPosLO := GetJoyDifPos_(LimbOneData, JPedals.wxpos);

      if (difPosLO <> -1) then
        AddJoyPosition_(LimbOneData);

      //если пошевелили джоями - однократно отправляем в порт событие
      //переделать!! отправлять событие по аналоговому входу от реле
  //    if (difPosLO > 1) and NeedMrkCode{or (difPosLT > 1) } then
  //    begin
  //      SendSubjectActionEvent;
  //      inc(CntrInt1);
  //    end;

  //    if (LimbOneUpSensorVal > 10) then
  //      inc(AntiChatteringCntr)
  //    else
  //      AntiChatteringCntr := max(0, dec(AntiChatteringCntr));

      //если подняли палец - срабатывает контактный датчик -  отправляем в порт событие
      //разрешаем только один раз за интервал
      if {NeedMrkCode} NeedSubjAction and NeedOnesEvent then
      begin
        if (LimbOneUpSensorVal > 50) and (not LimbOneHasUp) then
        begin
          LimbOneUpTimeCntr := Pc; //засекаем момент события
          LimbOneHasUp := True;//флаг однократного срабатывания для контактного датчика поднятия пальца. Палец должен быть исходно опущен.
          LimbOneHasDown := False;
          SendSubjectActionEvent(Pc);
          inc(LimbOneUpCntr);
          //если время поднятия пальца попало в интервал действия стимула - заводим таймер и при его срабатывании применяем звуковой сигнал обратной связи
          LastPcFeedbackSignal := Pc;
          if ExpVariants in [evNinthVariant] then//самозапуск серво при размыкании контактного датчика в 10 варианте
          begin
            NeedSubjAction := True; //??
            fmMain.DoForcedSubjAction;
            AddMsgDataToLogFile_(NameForLogFile, 'ForcedSubjAction ' + 'ForcedSubjActionCode= ' + IntToStr(MrkEvtForcedActionCode), Pc);
          end;

          HitToInterval_ := HitToInterval(Pc);
          NeedFailFeedbackSignal := AllowAlertSubjectAction and AllowFailFeedbackSignal;

          if AllowRTestObject then
          begin
            TestReactionAccuracy;
          end;
          //inc(CntrInt1);
        end;

        if (LimbOneUpSensorVal < 50) and (not LimbOneHasDown) then //палец вернулся в исх.полож-е
        begin
          SetIntrvlPeriod(2000);//досрочный вызов диалогового окна
          NeedOnesEvent := False;//доп флаг однократного срабатывания события палец поднят - палец опущен
          LimbOneDownTimeCntr := Pc;
          LimbOneHasUp := False;
          LimbOneHasDown := True;

          MinIntValue2(LimbOneData.Values, x_min, xi_min);
          MaxIntValue2(LimbOneData.Values, x_max, xi_max);
          AmplitudeLimbToUp := Abs(x_max - x_min);

          if EMG_EventArise then//если сработало ЭМГ событие по порогу (было физическое движение)
          begin
            SendMrkToPortAndWriteLogMsg(MrkEMG_EventAriseCode, 'MrkEvent ' + 'MrkEMG_EventAriseCode= ' + IntToStr(MrkEMG_EventAriseCode), EMG_EventAriseTimeCntr);
//            inc(Cntr2);
          end;

          if HitToInterval_ = False then
          begin
            inc(Loses);
          end;

          if AllowAlertSubjectAction then
          begin
//            if HitToInterval_ then
//              inc(Cntr2);
//            if EMG_EventArise then
//              inc(Cntr2);

            if HitToInterval_ and EMG_EventArise then
              NeedSuccFeedbackSignal := AllowSuccFeedbackSignal
            else
              NeedFailFeedbackSignal := AllowFailFeedbackSignal;
            if ExpVariants in [evThirdVariant, evFourthVariant{, evNinthVariant, evTenthVariant, evEleventhVariant}] then//в тесте со случайным ForcedAction и с самопредъявлением всегда сигнал succ
            begin
              NeedSuccFeedbackSignal := AllowSuccFeedbackSignal;
              NeedFailFeedbackSignal := False;
            end;
//            if ExpVariants in [evFourthVariant] then
//            begin
//              if HitToInterval_ and EMG_EventArise then
//                NeedFailFeedbackSignal := AllowFailFeedbackSignal
//              else
//                NeedSuccFeedbackSignal := AllowSuccFeedbackSignal;
//            end;
          end;

          //расчёт среднего максимума амплитуды поднятия пальца вверх по показаниям потенциометра
          if NeedSubjAction then
          begin
//            inc(TmpCntr);
            //считаем средний параметр амплитуды поднятия пальца только если не производится подбор параметров серво
            if not (RequestType in [rtServoParamsAdjustment]) then
            begin
              if (AmplitudeLimbToUp > 50) then //на случай дребезга
              begin
                AddAmplValueLimbToUp(AmplitudeLimbToUp);
                if Length(AmplValuesLimbToUp) > 0 then
                  AvrgAmplitudeLimbToUp := Trunc(SumInt(AmplValuesLimbToUp) / Length(AmplValuesLimbToUp)+0.5);
              end;
              AllowCalcServoParams := Length(AmplValuesLimbToUp) >= 5;//10;//надо накопить определённое кол-во измерений чтобы ф-ция подбора параметров серво могла работать
            end;
          end;

          //время движения пальца вверх-вниз по контактному датчику, ms
          if (LimbOneDownTimeCntr - LimbOneUpTimeCntr > 0) then
            ReactionVelocityTime := Trunc((LimbOneDownTimeCntr - LimbOneUpTimeCntr) / pf * 1000 + 0.5);
          if not (RequestType in [rtServoParamsAdjustment]) then//если не в состоянии калибровки параметров серво
          begin
            if (ReactionVelocityTime > 10) and (ReactionVelocityTime < 5000) then //из-за дребезга знач-я могут быть маленькими, так что надо это учитывать, как и неадекватно большие знач-я
              AddReactnVlcityTimeValue(ReactionVelocityTime)
            else
              ReactionVelocityTime := 0;

            if Length(ReactnVlcityTimeValues) > 0 then
              AvrgReactionVelocityTime := Trunc(SumInt(ReactnVlcityTimeValues) / Length(ReactnVlcityTimeValues)+0.5);
          end;
        end;
      end;

      //чтобы алерт не срабатывал тогда, когда есть данные
      //AllowAlertSubjectAction := (Length(LeftToeData.Values) < 3) or (Length(RightToeData.Values) < 3) or (Length(YokeData.Values) < 3);
      //чтобы не сработал назначенный где-то алерт, если двинули джоями, т.е. действие уже совершено
  //    if (difPosLO > 1) {or (difPosLT > 1))} then
  //      AllowAlertSubjectAction := False;
      //если данных для обработки нет, то джои на месте, алерт разрешаем
      //с другой стороны, если двинули джоями, то алерт надо запретить и разрешить повторно в том месте, где взводится новый алерт

      if (Length(LimbOneData.Values) >= 5) {or (Length(LimbTwoData.Values) >= 3)} then
        WorkMode := wmNeedCalculateData;
      //Работает ненадёжно! Размах определяется некорректно! Видимо, потому, что при движении значения чуть скачут в направлении уменьшения значений, поэтому надо делать по-другому!
      //если джои вернулись в исх.позицию с учётом дрбезга потенциометра - считаем критерии
      if (JPedals.wxpos <= LimbOneData.MinPos + 1) then //
      begin
        inc(WatchdogCntr);
        if WorkMode = wmNeedCalculateData then
        begin
//          GetLimbMoveCriteria_(LimbOneData, moveLOUpCriteria, moveLODownCriteria, LORltvVelUp,  LORltvVelDown, LOMaxTimeUp, LOMinTimeDown);
//          //GetLimbMoveCriteria_(LimbTwoData, moveLTUpCriteria, moveLTDownCriteria, LTRltvVelUp, LTRltvVelDown, LTMaxTimeUp, LTMinTimeDown);
//
//          CalcCommonCriteria_;
//          if (WorkMode = wmCalculatedData) then
//          begin
////            JoyValuesClear_(LimbOneData);
////            JoyValuesClear_(LimbTwoData);
//            NeedCtrlUpdate := True;
//            //inc(Cntr64);
//          end;
        end;
      end
      else
      begin
        WatchdogCntr := 0;
      end;
      //очищаем массивы по сторожевому таймеру
      if WatchdogCntr >= 400 then
      begin
        WatchdogCntr := 0;
        JoyValuesClear_(LimbOneData);
        JoyValuesClear_(LimbTwoData);
      end;
    end;
  end;
    //периодический update VCL компонентов.
  if Pc >= LastPc + IntervalVCLUpdatePeriodInTick  then
  begin
    PostMessage(wndHndl, UM_UPDATE_VCL, 0, 0);
    LastPc := Pc;
  end;
    //периодический update OpenGL отрисовки
  if Pc >= LastDrawPc + IntervalDrawOpenGLPeriodInTick  then
  begin
    PostMessage(wndHndl, UM_DRAW_OPENGL, 0, 0);
    LastDrawPc := Pc;
  end;
end;

//procedure SendForcedActionEvent(var TimePC: Int64);
//var
//  data: Byte;
//  strMsg: string;
//begin
//  data := MrkEvtForcedActionCode;
//  SendMarker(data);
//  strMsg := 'MrkEvent ' + 'MrkEvtForcedActionCode= ' + IntToStr(data);
//  AddMsgDataToLogFile_(NameForLogFile, strMsg, TimePC);
////  inc(SubjActEvtCounter);
//end;

procedure SendSubjectActionEvent(const TimePC: Int64);
begin
//  if NeedMrkCode then
  begin
    SendMrkToPortAndWriteLogMsg(MrkEvtActionCode, 'MrkEvent ' + 'MrkEvtActionCode= ' + IntToStr(MrkEvtActionCode), TimePC);
    NeedMrkCode := False;
  end;
end;

procedure DrawDataFromCircleBuf(APCircBuf: PTArrOfDblDynArray; const ChnlIndx: Integer; const ANewPortionDataCnt: Integer);
var
  i: Integer;
  DrawDataIndx: Integer;
begin
  DrawDataIndx := DrawDataIndxes[ChnlIndx];
  i := 0;
  while i < ANewPortionDataCnt do
  begin
    fmMain.FastLineSeries1.YValue[Cntr] := APCircBuf^[ChnlIndx][DrawDataIndx];
    DrawDataIndx := (DrawDataIndx + 1 + CIRCLE_BUF_LEN) mod CIRCLE_BUF_LEN;
    Cntr := (Cntr + 1 + MAXXGRAPH) mod MAXXGRAPH;
    inc(i);
  end;
  DrawDataIndxes[ChnlIndx] := DrawDataIndx;
end;

procedure callme(data: pointer; channels: Integer; samples: Integer; timestamp: UInt64); cdecl;
var
//  strMsg: string;
  Data_: TArrOfDblDynArray;
  LinearBuf: TDoubleDynArray;
  i,j: Integer;
  tm: Int64;
begin
//  fmMain.Caption := 'channels: ' + IntToStr(channels) + ' samples: ' + IntToStr(samples);

//  QueryPerformanceCounter(tm);
//  AddMsgDataToLogFile_('callme', ' samples: ' + IntToStr(samples) + ' timestamp: ' + IntToStr(timestamp), tm);

  SetLength(Data_, samples);
  try
    i := 0;
    while i < samples do
    begin
      SetLength(Data_[i], channels);
      Move(data^, Data_[i][0], SizeOf(Double)*channels);
      inc(Integer(data), SizeOf(Double)*channels);
      inc(i);
    end;

//    i := 0;
//    while i < samples do
//    begin
//      //на повторную прорисовку обновляем существующие точки
//      fmMain.FastLineSeries1.YValue[Cntr] := Data_[i][ChnlIndx];
//      inc(Cntr);
//      if Cntr >= MAXXGRAPH then
//        Cntr := 0;
//      inc(i);
//    end;

//    //подумать. Возможно, переделать всё на один линейный буфер. Нужен блок для тестирования!
    SetLength(LinearBuf, samples);
    try
      j := 0;
      while j < channels do
      begin
        i := 0;
        while i < samples do
        begin
          LinearBuf[i] := Data_[i][j];
          inc(i);
        end;
        Circle_buff_proc(@LinearBuf, j, samples);
        inc(j);
      end;
    finally
      Finalize(LinearBuf);
    end;

    fmMain.Caption := IntToStr(Cntr2);

  finally
   i := 0;
   while i < samples do
   begin
     SetLength(Data_[i], 0);
     inc(i);
   end;
   SetLength(Data_, 0);
  end;

  if FiltersEnabled then
    DrawDataFromCircleBuf(@CircBufFil2Data, EMGChnlIndx, samples)
  else
    DrawDataFromCircleBuf(@CircBufData, EMGChnlIndx, samples);
end;

procedure SetDCPixelFormat (hdc : HDC);
var
  pfd : TPixelFormatDescriptor;
  nPixelFormat : Integer;
begin
  FillChar (pfd, SizeOf (pfd), 0);
  pfd.dwFlags  := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  nPixelFormat := ChoosePixelFormat (hdc, @pfd);
  SetPixelFormat (hdc, nPixelFormat, @pfd);
end;

  // mouse_x, mouse_y  - оконные координаты курсора мыши.
  // p1, p2            - возвращаемые параметры - концы селектирующего отрезка,
  //                     лежащие соответственно на ближней и дальней плоскостях
  //                     отсечения.
procedure TfmMain.calc_select_line(mouse_x: Integer; mouse_y: Integer; var p1: TGLCoord3d; var p2: TGLCoord3d);
var
  viewport: array[0..3] of GLint; // параметры viewport-a.
  projection: array[0..15] of GLdouble;// матрица проекции.
  modelview: array[0..15] of GLdouble;// видовая матрица.
  vx,vy,vz: GLdouble;// координаты курсора мыши в системе координат viewport-a.
  wx,wy,wz: GLdouble;// возвращаемые мировые координаты.
begin
  glGetIntegerv(GL_VIEWPORT,@viewport);           // узнаём параметры viewport-a.
  glGetDoublev(GL_PROJECTION_MATRIX, @projection); // узнаём матрицу проекции.
  glGetDoublev(GL_MODELVIEW_MATRIX, @modelview);   // узнаём видовую матрицу.
  // переводим оконные координаты курсора в систему координат viewport-a.
  vx := mouse_x;
  vy := mouse_y;//viewport[3] - mouse_y; //

  if( vy = 0 )then vy := 1;

  glReadPixels(mouse_x, -mouse_y, 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT, @vz);

  // вычисляем ближний конец селектирующего отрезка.
//  vz := -1;
  gluUnProject(vx, viewport[3]-vy, vz, @modelview, @projection, @viewport, wx, wy, wz);
  CVector3_1.x := wx;
  CVector3_1.y := wy;
  CVector3_1.z := wz;
  p1 := CVector3_1;
//  // вычисляем дальний конец селектирующего отрезка.
//  vz := 1;
//  gluUnProject(vx, vy, vz, @modelview, @projection, @viewport, wx, wy, wz);
//  CVector3_2.x := wx;
//  CVector3_2.y := wy;
//  CVector3_2.z := wz;
//  p2 := CVector3_2;
end;

procedure TfmMain.FeedbackSuccSignalApply(var Message: TMessage);
var
  pdwStatus: Cardinal;
begin
  NeedSuccFeedbackSignal := False;
  SendMrkToPortAndWriteLogMsg(MrkFeedbackSuccSignalCode, 'MrkEvent ' + 'MrkFeedbackSuccSignal= ' + IntToStr(MrkFeedbackSuccSignalCode), Pc);
  // sound
//  sndPlaySound(PWideChar(SuccessSndFileName), SND_FILENAME or SND_ASYNC);
//  NeedSuspend := True;
  IPlStimModule.Effect_StartPlay(SuccessSndEffect, False);
//  repeat //ждём пока проиграется звук
//    FIPlStimModule.Effect_GetStatus(SuccessSndEffect, pdwStatus);
//    Application.ProcessMessages;
//  until (pdwStatus <> 1{DSBSTATUS_PLAYING});
//  NeedSuspend := False;
end;

procedure TfmMain.FeedbackFailSignalApply(var Message: TMessage);
var
  pdwStatus: Cardinal;
begin
  NeedFailFeedbackSignal := False;
  SendMrkToPortAndWriteLogMsg(MrkFeedbackFailSignalCode, 'MrkEvent ' + 'MrkFeedbackFailSignal= ' + IntToStr(MrkFeedbackFailSignalCode), Pc);
  // sound
 // sndPlaySound(PWideChar(FailureSndFileName), SND_FILENAME or SND_ASYNC);
//  NeedSuspend := True;
  IPlStimModule.Effect_StartPlay(FailureSndEffect, False);
//  repeat //ждём пока проиграется звук
//    FIPlStimModule.Effect_GetStatus(SuccessSndEffect, pdwStatus);
//    Application.ProcessMessages;
//  until (pdwStatus <> 1{DSBSTATUS_PLAYING});
//  NeedSuspend := False;
end;

procedure TfmMain.cbxComNumChange(Sender: TObject);
begin
  if not FLockCtrls then
  begin
    if cbxComNum.ItemIndex <> -1 then
      ComVar.PortName := AnsiStrToTAscii(cbxComNum.Items.Strings[cbxComNum.ItemIndex]);
  end;
end;

procedure TfmMain.chAfterDraw(Sender: TObject);
var
  i: integer;
  tmpX,tmpY:Double;
begin
  with (Sender as TChart).Canvas do
  begin
    Font.Size := 8; Font.Color := clsilver;
    //прицел-
    if gx > 1 then
    begin
      pen.Color := clsilver;
      moveto(gx,0);     lineto(gx,gy-20);
      moveto(gx,gy+20); lineto(gx,ch.Height);

      moveto(gx-15,gy); lineto(gx-5,gy);
      moveto(gx+45,gy); lineto(gx+5,gy);

      TextOut(gx+10,gy+font.Height-2,metka1);
      TextOut(gx+10,gy,metka2);
      TextOut(gx+10 + 50,gy+font.Height-2, metka3);
      TextOut(gx+10 + 50,gy, metka4);
    end;
  end;
end;

procedure TfmMain.chClickSeries(Sender: TCustomChart; Series: TChartSeries;
  ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  tmpX,tmpY: Double;
  xk, yk: Double;  // координата xk:yk серии
  intFlag: Integer;

begin
  ch.Series[0].GetCursorValues(tmpX,tmpY); // переводим координаты из позиции курсора
  // бегающие маркеры -----------------------------------------------------
  // текущее значение по оси X
//  Caption := strInt;
  xk := strtofloat(ch.Series[0].GetHorizAxis.LabelValue(tmpX));
  // выясняем значение графика в nk- отсчете
  yk := {ch.Series[0].YValue[Trunc(xk+0.5)];//}getlocate(ch.Series[0], xk);

//  if NeedInsertNewPoint(xk) then
//  begin
//    SetLength(BaseXPoints, Length(BaseXPoints)+1);
//    BaseXPoints[High(BaseXPoints)] := High(BaseXPoints);
//    InsertValue(BaseYPoints, Ceil(xk), (Series1.YValue[Floor(xk)] + Series1.YValue[Ceil(xk)]) / 2);
//    Series1.Clear;
//    i := 0;
//    while i < Length(BaseYPoints) do
//    begin
//      Series1.AddXY(BaseXPoints[i], BaseYPoints[i]);
//      inc(i);
//    end;
//  end;

//  Caption := 'x= ' +  FloatToStr(xk) + ' y= ' + FloatToStr(yk) + ' Xfrac= ' + IntToStr(intFlag);
  // позиция маркера-
//  if (xk < ch.BottomAxis.Maximum) and (xk >= ch.BottomAxis.Minimum-0.1) then
//  begin // fix- выход за координаты
//    ch.Series[1].XValue[0]:= Trunc(xk+0.5);
//    ch.Series[1].YValue[0]:= yk
//  end;

  XValue := series.xvalue[ValueIndex];
  YValue := series.yvalue[ValueIndex];

 //sb.Panels[0].Text:= 'X=' + FloatToStr(XValue);//format('X= %f', [series.xvalue[valueindex]]);
 //sb.Panels[1].Text:= 'Y=' + FloatToStr(YValue);//format('Y= %f', [series.yvalue[valueindex]]);

  PointFixed := False;
  NeedPointMoved := True;
end;

procedure TfmMain.ClearFormControls;
begin
  FLockCtrls := True;

  FLockCtrls := False;
end;

procedure TfmMain.ClearNewRndAlertIntervals;
begin
  Finalize(FRndAlertIntervals);
end;

procedure TfmMain.ClearNewRndAlertIntervalsForFastPresent;
begin
  Finalize(FRndAlertIntervalsForFastPresent);
end;

procedure TfmMain.ClearSubTests;
begin
  FSubTests.Clear;
end;

function TfmMain.CloseComPort: Boolean;
begin
  Result := False;
  if (ComVar.hCom <> 0) and
     (ComVar.hCom <> INVALID_HANDLE_VALUE) then
  begin
    Result := CloseHandle(ComVar.hCom);
    ComVar.hCom := 0;
  end;
end;

procedure TfmMain.ComDeInitialize;
begin
  if ComVar.hCom <> 0 then
  begin
    SetCommMask(ComVar.hCom, 0);
    Sleep(10);
  end;
end;

procedure TfmMain.ComSettingsInitialize;
begin
  if cbxComNum.ItemIndex <> -1 then
    ComVar.PortName := AnsiStrToTAscii(cbxComNum.Items.Strings[cbxComNum.ItemIndex]);
//  ComVar.PortNum := StrToIntDef(edtComNum.Text, 0);
  ComVar.DCB.Parity := NOPARITY;
  ComVar.DCB.StopBits := ONESTOPBIT;
  ComVar.DCB.BaudRate := ComBaudRate;
  ComVar.DCB.ByteSize := 8;
  ComVar.ComVisibility := False;
  ComVar.hCom := 0;
end;

procedure TfmMain.ComWaitVisibility;
begin
  ComSettingsInitialize;
  FOpenComThread := TOpenComThread.Create(True);
  try
    EvtOpenComThread := CreateEvent(nil, False, False, nil);
    FOpenComThread.ExitEvent := EvtOpenComThread;
    FOpenComThread.PComVar := @ComVar;
    FOpenComThread.OnTerminate := OpenComThreadTerminate;
    FOpenComThread.FreeOnTerminate := True;//False;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    FOpenComThread.Suspended := False;
  except
    WorkState := dwsTerm;
  end;
end;

procedure TfmMain.edtAlrtDrtnTChange(Sender: TObject);
begin
  if not FLockCtrls then
    AlertDurationTime := StrToIntDef(edtAlrtDrtnT.Text, 250);
end;

procedure TfmMain.edtAmplThresholdChange(Sender: TObject);
begin
  EMG_AmplThresh := StrToFloatDef(edtAmplThreshold.Text, 0);
end;

procedure TfmMain.edtAvrgRTChange(Sender: TObject);
begin
  if not FLockCtrls then
  begin
    AvrgReactionTime := StrToIntDef(edtAvrgRT.Text, 0);
    InitialAvrgReactionTime := AvrgReactionTime;
  end;
end;

procedure TfmMain.edtChnlNumChange(Sender: TObject);
begin
  EMGChnlIndx := StrToIntDef(edtChnlNum.Text, 0) - 1;
  EMGChnlIndx := max(0, min(ACTICHAMP_CH_CNT-1, EMGChnlIndx));
end;

procedure TfmMain.edtComSpeedChange(Sender: TObject);
begin
  ComBaudRate := StrToIntDef(edtComSpeed.Text, 57600);
  ComVar.DCB.BaudRate := ComBaudRate;
end;

procedure TfmMain.edtFrcActnTShiftChange(Sender: TObject);
begin
  if not FLockCtrls then
    ForceActionTimeShift := StrToIntDef(edtFrcActnTShift.Text, 0);
end;

procedure TfmMain.edtMrkAlertSubjActionChange(Sender: TObject);
begin
  MrkAlertSubjActionCode := StrToIntDef(edtMrkAlertSubjAction.Text, 9);
end;

procedure TfmMain.edtrMrkBgnIntrvlCodeChange(Sender: TObject);
begin
  MrkBeginIntrvlCode := StrToIntDef(edtrMrkBgnIntrvlCode.Text, 12);
end;

procedure TfmMain.edtrMrkEndIntrvlCodeChange(Sender: TObject);
begin
  MrkEndIntrvlCode := StrToIntDef(edtrMrkEndIntrvlCode.Text, 13);
end;

procedure TfmMain.edtrMrkEvtActionCodeChange(Sender: TObject);
begin
  MrkEvtActionCode := StrToIntDef(edtrMrkEvtActionCode.Text, 10);
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Action := caFree;
end;

procedure TfmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: Integer;
  data: Byte;
  strMsg: string;
begin
  ShowCursor_;

  if FTerminated then
  begin
    WorkState := dwsTerm;
    i := 0;
    while (not (FDevWorkState = dwsTerminated)) and
          (i < 3000) do
    begin
      Application.ProcessMessages;
      Sleep(1);
      inc(i);
    end;

    if (i >= 3000) and
       (FDevWorkState <> dwsTerminated) then
    begin

      WorkState := dwsTerminated;
    end;

    CanClose := True;
    Application.ProcessMessages;
  end
  else
  begin
    CanClose := False;
    Exit;
  end;

  if WorkWithLPT then
  begin
    CanClose := False;
    data := StrToIntDef(edtrMrkEndIntrvlCode.Text, 0);
    SendMarker_(data);
    strMsg := 'MrkEvent ' + 'MrkEndIntrvlCode= ' + IntToStr(data);
    QueryPerformanceCounter(Pc);
    AddMsgDataToLogFile_(NameForLogFile, strMsg, Pc);
    CanClose := True;
  end
  else
    CanClose := True;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
  i: Integer;
  ii: IInterface;
  im: IModuleInterface;
begin
  LogFileDirectory := ExtractFilePath(ParamStr(0)) + LOGS_DEF_DIR;
  DataFileDirectory := ExtractFilePath(ParamStr(0));
  SndFileDirectory := ExtractFilePath(ParamStr(0)) + SOUND_DEF_DIR;
  OnlyFileName := 'AgencyStim';
  DateTimeToString(NameForLogFile, 'ddmmyyyyhhmmss', Now);
  NameForLogFile := '_' + NameForLogFile;

  SuccessSndFileName := WideString(SndFileDirectory + 'majorChordEd.wav');
  FailureSndFileName := WideString(SndFileDirectory + 'Failure.wav');
  TicSndFileName := WideString(SndFileDirectory + 'Tic.wav');
  TacSndFileName := WideString(SndFileDirectory + 'Tac.wav');
  EndExperimentSndFileName := WideString(SndFileDirectory + 'success1.wav');

  QueryPerformanceFrequency(Pf);
  QueryPerformanceCounter(Pc1);

  Init;

  ScanComPorts;
  StartWorkWithComPort;

  ExpVariants := evOneVariant;

  if WorkWithLPT  and (not LPTPortReset) then
    Application.Terminate;

  NeedMrkCode := False;
  NeedSubjAction := False;

  ClearFormControls;
  SetFormControls;

  GLInit;
  TexInit;
  JoysInit;

  GenerateNewRndAlertIntervals(1000);//случайные интервалы для контрольного этапа
  GenerateNewRndAlertIntervalsForFastPresent(1000);

  glColor3f (0.0, 0.0, 1.0);
  Angle := 0;

//  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//  glEnable(GL_BLEND);
//  // Сглаживание точек
//  glEnable(GL_POINT_SMOOTH);
//  glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);
//  // Сглаживание линий
//  glEnable(GL_LINE_SMOOTH);
//  glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
//  // Сглаживание полигонов
////  glEnable(GL_POLYGON_SMOOTH);
////  glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);

  if not FEmulMode then
    handle_ := SetUp();

  EMGChnlIndx := StrToIntDef(edtChnlNum.Text, 1) - 1;
  i := 0;
  while i < MAXXGRAPH do
  begin
    fmMain.FastLineSeries1.AddY(0);
    inc(i);
  end;
  FiltersEnabled := chkBxNotchFilter50.Checked;
  EMG_AmplThresh := StrToFloatDef(edtAmplThreshold.Text, 0);

  BoardPnlEnabled := False;
  CallbackRegistered := False;
  GLCtrlVis := True;

  FCurSessionDurationInMs := 0;

  DefaultCurves;
  LoadCurvesDataFromFile(BaseYPoints, IntrpResltValues);
  DrawCurves;

  SetIntervalVCLUpdatePeriod(33);
  SetIntervalDrawOpenGLPeriod({1.666666666666666666}16.66666666666666666666666666667);
  SetFeedbackSignalDefermentPeriod(200);//период отработки звукового сигнала подтверждения
  //!! переделать на три варианта: 200, 250, 300.
  SetServoParamsAdjPeriod(600);//период цикла отработки серво при подборе её параметров
  SetHitToIntervalTimeCorrection(100);
  SetHypotheticAvrgRT(HypotheticAvrgRT);

  LastPcRTestObject := MaxInt64;

//  CreatePlStimModule;
  IPlStimModule.QueryInterface(IModuleInterface, im);
  im.NotifyWindowHandle := fmMain.Handle;

  SuccessSndEffect := IPlStimModule.Effect_LoadFromFile(PWideChar(SuccessSndFileName));
  FailureSndEffect := IPlStimModule.Effect_LoadFromFile(PWideChar(FailureSndFileName));
  TicSndEffect := IPlStimModule.Effect_LoadFromFile(PWideChar(TicSndFileName));
  TacSndEffect := IPlStimModule.Effect_LoadFromFile(PWideChar(TacSndFileName));
  EndExperimentSndEffect := IPlStimModule.Effect_LoadFromFile(PWideChar(EndExperimentSndFileName));

  JvTimerLPTZero := TJvTimer.Create(nil);
  JvTimerLPTZero.Threaded := True;
  JvTimerLPTZero.EventTime := tetPost;
  JvTimerLPTZero.Enabled := False;
  JvTimerLPTZero.Interval := 5;
  JvTimerLPTZero.OnTimer := JvLPTZeroOnTimer;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  Finalize(MaximumsBufData);

  Finalize(LineDelaysArr);

  JvTimerLPTZero.Free;

  timeKillEvent(TimerID);

  SaveCurvesDataToFile(BaseYPoints, IntrpResltValues);

  ClearAmplValuesLimbToUp;
  ClearTimeValuesLimbUpDown;
  ClearReactionAccuracyValues;
  ClearRTValues;
  ClearReactnVlcityTimeValues;
  Finalize(BaseXPoints);
  Finalize(BaseYPoints);
  Finalize(RezC);
  Finalize(DesiredXValues);
  Finalize(IntrpResltValues);

  if not FEmulMode then
    TearDown(handle_);

  ClearNewRndAlertIntervals;
  ClearNewRndAlertIntervalsForFastPresent;

  LPTPortReset;

  JoysDeInit;
  //
  //выключаем сглаживание
  glDisable(GL_BLEND);
  glDisable(GL_POINT_SMOOTH);
  glDisable(GL_LINE_SMOOTH);
  glDisable(GL_POLYGON_SMOOTH);

  TexDeinit;
  gluDeleteQuadric (quadObj);
  wglMakeCurrent(0, 0);//
  wglDeleteContext(hrc);//
  ReleaseDC(Handle, DC);
  DeleteDC(DC);

  Term;

  IPlStimModule.Effect_Free(TicSndEffect);
  IPlStimModule.Effect_Free(TacSndEffect);
  IPlStimModule.Effect_Free(SuccessSndEffect);
  IPlStimModule.Effect_Free(FailureSndEffect);
  IPlStimModule.Effect_Free(EndExperimentSndEffect);
//  IPlStimModule := nil;
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    if RequestType in [rtStartExperiment, rtBeginBackdrop, rtEndBackdrop, rtAmongBackdrop, rtNeedGetSubjAnswer, rtBeginIntrvl, rtAmongIntrvl, rtEndIntrvl] then
      RequestType := rtEndExperiment
    else
    begin
      FTerminated := True;
      Application.Terminate;
    end;
  //  Application.Terminate;
  end;
  if Key = Ord('T') then
  begin
    NeedResultPresent := True;
    case Application.MessageBox(PChar('Тест точности реакции ' + #10#13 + 'Отображать результаты во время выполнения? ' ), PChar(strModuleName), MB_YESNO + MB_ICONQUESTION) of
    IDYES:
      begin
        NeedResultPresent := True;
        AllowSuccFeedbackSignal := True;
        AllowFailFeedbackSignal := True;
      end;
    IDNO:
      begin
        NeedResultPresent := False;
        AllowSuccFeedbackSignal := False;
        AllowFailFeedbackSignal := False;
      end;
    end;

    if (not (RequestType in [rtNone])) then
      if (not (RequestType in [rtEndExperiment])) then
        RequestType := rtEndExperiment;

    FDefSessionDurationInMs := 60000;
    FSessionDurationInMs := FDefSessionDurationInMs;
    ExpVariants := evSeventhVariant;
    fmMain.Caption := 'Exp ' + IntToStr(Integer(ExpVariants));
    RequestType := rtStartExperiment;
  end;
  if Key = Ord('S') then//приостановить декремент временного сдвига для Forced action
  begin
    AllowDecTShift := False;
  end;
  if Key = Ord('U') then
  begin
    AllowDecTShift := True;
  end;
  if Key = Ord('A') then//итеративная настройка режимов серво на найденные для исп-го параметры (амплитуды поднятия пальца)
  begin
    GoalAmplitudeLimbToUp := AvrgAmplitudeLimbToUp;//350;//!! для отладки В рабочем варианте берётся текущее знач-е, измеренное на 1 этапе
    AmplitudeLimbToUp := 0;
    AllowCalcServoParams := True;
    case Application.MessageBox(PChar('Настройка режимов серво. ' + 'Целевая средн.амп-да по потенц-ру: ' + IntToStr(GoalAmplitudeLimbToUp)), PChar(strModuleName), MB_ICONINFORMATION) of
      IDOK:
      begin
        SetServoParamsAdjPeriod(1000);//период цикла отработки серво при подборе её параметров
        NeedSubjAction := True;
        ServoAmplitudeToUpAdjustment;
      end;
    end;
  end;
  if Key = Ord('V') then//итеративная настройка режимов серво на найденные для исп-го параметры (скорости поднятия пальца)
  begin
    //AvrgAmplitudeLimbToUp := 350;
    ReactionVelocityTime := 0;
    AllowCalcServoParams := True;
    GoalReactionVelocityTime := AvrgReactionVelocityTime;//200;//!! для отладки
    case Application.MessageBox(PChar('Настройка режимов серво. ' + ' Целевое средн.время движ-я: ' + IntToStr(GoalReactionVelocityTime)), PChar(strModuleName), MB_ICONINFORMATION) of
      IDOK:
      begin
        SetServoParamsAdjPeriod(1000);//период цикла отработки серво при подборе её параметров
        NeedSubjAction := True;
        ServoTimeToUpDownAdjustment;
      end;
    end;
  end;
  if Key = 32{space} {Ord('F')} then
  begin
    if (ExpVariants in [evTenthVariant]) then
    begin
      if NeedSubjAction and NeedOnesEvent then
      begin
        DoForcedSubjAction;
        AddMsgDataToLogFile_(NameForLogFile, 'ForcedSubjAction ' + 'ForcedSubjActionCode= ' + IntToStr(MrkEvtForcedActionCode), Pc);
        //SendMrkToPortAndWriteLogMsg(MrkEvtForcedActionCode, 'ForcedSubjAction ' + 'ForcedSubjActionCode= ' + IntToStr(MrkEvtForcedActionCode), Pc);
      end;
    end
    else
    begin
      NeedOnesEvent := True;
      DoForcedSubjAction;
      AddMsgDataToLogFile_(NameForLogFile, 'ForcedSubjAction ' + 'ForcedSubjActionCode= ' + IntToStr(MrkEvtForcedActionCode), Pc);
      //SendMrkToPortAndWriteLogMsg(MrkEvtForcedActionCode, 'ForcedSubjAction ' + 'ForcedSubjActionCode= ' + IntToStr(MrkEvtForcedActionCode), Pc);
    end;
  end;
end;

procedure TfmMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p1: TGLCoord3d;
  Zval : GLfloat;
 //
 chipX, chipY: Integer;//индексы игрового поля: 0,0 - лев.верхн.угол, 1,1 - прав.нижн.
 i, j: Integer;
begin
//  WorldCoordByMouseXY(X, Y, Zval, p1);
//
//  Panel1.Caption := ('Мировые координаты для z=' + FloatToStr(Zval)
//                    + ' : ' + chr (13) + '(' + FloatToStr(p1.x)
//                    + '; ' + FloatToStr(p1.y)
//                    + '; ' + FloatToStr(p1.z) + ')');
//
//  //получить координаты клетки игровой доски
//  chipY := Trunc(((-p1.y+1) * (BOARDSIZE + 1) / 2));//r
//  chipX := Trunc(((p1.x+1) * (BOARDSIZE + 1) / 2));//c
//  Caption := '' + IntTostr(chipX) + ' ' + IntToStr(chipY);
//
//  if (chipX >= 0) and (chipX <= BoardSize) and (chipY >= 0) and (chipY <= BoardSize) then
//  begin
////    if BoardArray[chipX, chipY] <> 0 then
////      BoardArray[chipX, chipY] := 0
////    else
////      BoardArray[chipX, chipY] := 1;
////    InvalidateRect(Handle, nil, False);
//
////  player := 1;
//    i := chipY * (BOARDSIZE + 1) + chipX;
//    if BoardArray[chipY, chipX] = 0 then
//    begin
//      BoardArray[chipY, chipX] := player;
//      j := 0;
//      while j < Length(MoveList) do
//      begin
//        if MoveList[j, 0] = i then
//        begin
//          MoveList[j, 1] := player;
//          Break;
//        end;
//        inc(j);
//      end;
//
////      if player = 1 then
////        player := 2
////      else
////        player := 1;
//
//      UpdateBoardValue(chipY, chipX);
//    //  InvalidateRect(Handle, nil, False);
//      Done := True;
//
//      CurchipX := chipX;
//      CurchipY := chipY;
//      JvTimer1.Enabled := True;
//      while JvTimer1.Enabled do
//        Application.ProcessMessages;
//
//      NextCourse;
//    end;
//  end;
end;

procedure TfmMain.FormResize(Sender: TObject);
const
  k = 1;
  // sp: array [0..3] of GLFloat = (1,0,0,1);
  // mat_specular: array [0..3] of GLFloat = (1,1,1,1);

begin
//  glViewPort(0, 0, BoardPnl.ClientWidth, BoardPnl.ClientHeight);
//  glMatrixMode(GL_PROJECTION);
//  glLoadIdentity;
//  gluPerspective(FovY, BoardPnl.ClientWidth / BoardPnl.ClientHeight, 1.0, 30.0);
//  glMatrixMode(GL_MODELVIEW);
//  //glEnable(GL_COLOR_MATERIAL);
// // glEnable(GL_DEPTH_TEST);
//  InvalidateRect(BoardPnl.Handle, nil, False);

 glViewPort (0, 0, BoardPnl.ClientWidth, BoardPnl.ClientHeight);
 glMatrixMode(GL_PROJECTION);
 glLoadIdentity;
 //gluPerspective(FovY, 3, 7.0, 13.0);
 gluPerspective(FovY, BoardPnl.ClientWidth / BoardPnl.ClientHeight, 7.0, 13.0);
 glMatrixMode(GL_MODELVIEW);
 glEnable(GL_COLOR_MATERIAL);
 glEnable(GL_DEPTH_TEST);
 glLoadIdentity;
 glTranslatef(0.0, 0.0, -9.0);
end;

procedure TfmMain.GenerateNewRndAlertIntervalsForFastPresent(const ALength: Integer);
var
  i, j, k: Integer;
  Checked_: Boolean;
begin
  SetLength(FRndAlertIntervalsForFastPresent, 0);
  k := 0;
  i := 0;
  while i < ALength do
  begin
    Checked_ := False;
    j := 501;
    while j < IntervalDefTimeLenForFastPresent - 500 do
    begin
      if Random < 0.005{0.004} then
      begin
        SetLength(FRndAlertIntervalsForFastPresent, Length(FRndAlertIntervalsForFastPresent)+1);
        FRndAlertIntervalsForFastPresent[k] := j;
        inc(k);
        Checked_ := True;
        Break;
      end;
      inc(j, Random(30));
    end;
    //если ни разу не сработало условие - интервал = 0
//    if (not Checked_) and (Random < 0.03) then
//    begin
//      SetLength(FRndAlertIntervalsForFastPresent, Length(FRndAlertIntervalsForFastPresent)+1);
//      FRndAlertIntervalsForFastPresent[k] := 0;
//      inc(k);
//    end;
    inc(i);
  end;
end;

procedure TfmMain.GenerateNewRndAlertIntervals(const ALength: Integer);
var
  i, j, k: Integer;
  Checked_: Boolean;
begin
  SetLength(FRndAlertIntervals, 0);
  k := 0;
  i := 0;
  while i < ALength do
  begin
    Checked_ := False;
    //интересует интервал 2000-15000 мс
    j := 2001;
    while j < IntervalDefTimeLen - 1000 do
    begin
      if Random < 0.005{0.004} then
      begin
        SetLength(FRndAlertIntervals, Length(FRndAlertIntervals)+1);
        FRndAlertIntervals[k] := j;
        inc(k);
        Checked_ := True;
        Break;
      end;
      inc(j, Random(90));
    end;
    //если ни разу не сработало условие - интервал = 0
    if (not Checked_) and (Random < 0.03) then
    begin
      SetLength(FRndAlertIntervals, Length(FRndAlertIntervals)+1);
      FRndAlertIntervals[k] := 0;
      inc(k);
    end;
    inc(i);
  end;
end;

//procedure TfmMain.GenerateNewRndAlertIntervals(const ALength: Integer);
//var
//  i: Integer;
//  newAlertInterval: Integer;
//begin
//  SetLength(FRndAlertIntervals, ALength);
//  i := 0;
//  while i < ALength do
//  begin
//    Randomize;
//    repeat
//      newAlertInterval := Random(6000);
//    until newAlertInterval > 1000;
//    FRndAlertIntervals[i] := newAlertInterval;
//    inc(i);
//  end;
//end;

procedure TfmMain.GetComPorts(aList: TStrings; const aNameStart: string);
var
  vBuf: string;
  vRes: integer;
  vErr: Integer;
  vBufSize: Integer;
  vNameStartPos: Integer;
  vName: string;
begin
  vBufSize := 1024 * 5;
  vRes := 0;

  while vRes = 0 do
    begin
      setlength(vBuf, vBufSize) ;
      SetLastError(ERROR_SUCCESS);
      vRes := QueryDosDevice(nil, @vBuf[1], vBufSize) ;
      vErr := GetLastError();

      //Вариант для двухтонки
      if (vRes <> 0) and (vErr = ERROR_INSUFFICIENT_BUFFER) then
        begin
          vBufSize := vRes;
          vRes := 0;
        end;

      if (vRes = 0) and (vErr = ERROR_INSUFFICIENT_BUFFER) then
        begin
          vBufSize := vBufSize + 1024;
        end;

      if (vErr <> ERROR_SUCCESS) and (vErr <> ERROR_INSUFFICIENT_BUFFER) then
        begin
          raise Exception.Create(SysErrorMessage(vErr) );
        end
    end;
  setlength(vBuf, vRes) ;

  vNameStartPos := 1;
  vName := GetNextSubstring(vBuf, vNameStartPos);

  aList.BeginUpdate();
  try
    aList.Clear();
    while vName <> '' do
      begin
        if StartsStr(aNameStart, vName) then
          aList.Add(vName);
        vName := GetNextSubstring(vBuf, vNameStartPos);
      end;
  finally
    aList.EndUpdate();
  end;
end;

function TfmMain.GetNewRndAlertIntervalValue(): Integer;
begin
  Result := FRndAlertIntervals[Random(Length(FRndAlertIntervals))];
end;

function TfmMain.GetNewRndAlertIntervalValueForFastPresent(): Integer;
begin
  Result := FRndAlertIntervalsForFastPresent[Random(Length(FRndAlertIntervalsForFastPresent))];
end;

function TfmMain.GetSubTest(Index: Integer): TSubTest;
begin
  Result := TSubTest(FSubTests[Index]);
end;

function TfmMain.GetWorkState: TDevWorkState;
begin
  Result := FDevWorkState;
end;

//function TfmMain.GetNewRndAlertIntervalValue(): Integer;
//begin
//  Randomize;
// // if Random(5) > 0 then //в 3/4 случаев берём знач-е из массива для генерации алерта
//    Result := FRndAlertIntervals[Random(Length(FRndAlertIntervals))]
// // else
// //   Result := -1;
//end;

procedure TfmMain.GLInit;
const
   mat_specular : Array [0..3] of GLfloat = (1.0, 1.0, 1.0, 0.15);
   mat_shininess : GLfloat = 100.0;
   position : Array [0..3] of GLfloat = (0.5, 0.5, 1.0, 0.0);
begin
  DC := GetDC(BoardPnl.Handle);
  SetDCPixelFormat(DC);
  hrc := wglCreateContext(DC);
  wglMakeCurrent(DC, hrc);
  quadObj := gluNewQuadric;
  gluQuadricDrawStyle (quadObj, GLU_FILL);
  glEnable(GL_DEPTH_TEST);// разрешаем тест глубины
  glEnable(GL_LIGHTING); // разрешаем работу с освещенностью
  glEnable(GL_LIGHT0);   // включаем источник света 0
  glEnable (GL_COLOR_MATERIAL);

//  glEnable (GL_BLEND);
//  glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//  glShadeModel (GL_FLAT);
//  glClearColor (0.0, 0.0, 0.0, 0.0);
//   // оптические свойства материалов и источник света
////   glMaterialfv(GL_FRONT, GL_SPECULAR, @mat_specular);
////   glMaterialfv(GL_FRONT, GL_SHININESS, @mat_shininess);
////   glLightfv(GL_LIGHT0, GL_POSITION, @position);
//   glEnable(GL_LIGHTING);
//   glEnable(GL_LIGHT0);
//   glEnable(GL_DEPTH_TEST);
end;

procedure TfmMain.JoysInit;
begin
  JoyValuesClear_(LimbOneData);
  JoyValuesClear_(LimbTwoData);

  LimbOneData.MaxPos := REO_MAX;
  LimbOneData.MinPos := REO_MIN;
  LimbTwoData.MaxPos := REO_MAX;
  LimbTwoData.MinPos := REO_MIN;
  LimbOneData.WPos := REO_MIN;
  LimbTwoData.WPos := REO_MIN;

//  if EmulationModeOn then
  begin
    JPedals.wXpos := LimbOneData.MinPos;
    JPedals.wYpos := LimbTwoData.MinPos;
  end;
end;

procedure TfmMain.JoysDeInit;
begin
  Finalize(ADynIntArr);

  ClearCommonRltvVelocityValuesArray;
  ClearCommonDeSynchValuesArray;
  ClearCommonCritArray;

  JoyValuesClear_(LimbOneData);
  JoyValuesClear_(LimbTwoData);
end;

procedure TfmMain.Init;
var
  i: Integer;
begin
  ReadVideoModes;

  FIniFileName := ExtractFilePath(ParamStr(0)) + 'PAgencyStim.ini';
  LoadSettingsFromINI(FIniFileName);

  BaseAllowSuccFeedbackSignal := AllowSuccFeedbackSignal;
  BaseAllowFailFeedbackSignal := AllowFailFeedbackSignal;
  BaseAllowTicSignal := AllowTicSignal;

  SetScreenMode;
  FullScreen := fmMain.FullScreenMode;  //!!

  BoardBitmap := TBitmap.Create;
  ChipBitmap := TBitmap.Create;

  FTerminated := False;
  FSubTests := TObjectList.Create;

  SetLength(CircBufData, ACTICHAMP_CH_CNT);
  SetLength(CircBufFilData, ACTICHAMP_CH_CNT);
  SetLength(CircBufFil2Data, ACTICHAMP_CH_CNT);
  i := 0;
  while i < Length(CircBufData) do
  begin
    SetLength(CircBufData[i], CIRCLE_BUF_LEN);
    inc(i);
  end;
  i := 0;
  while i < Length(CircBufFilData) do
  begin
    SetLength(CircBufFilData[i], CIRCLE_BUF_LEN);
    SetLength(CircBufFil2Data[i], CIRCLE_BUF_LEN);
    inc(i);
  end;
end;

procedure TfmMain.Interpolation;
var
  i: integer;
begin
  //подготовка к интерполяции
  BuildAkimaSpline(BaseXPoints, BaseYPoints, Length(BaseYPoints), RezC);
  //получения интерполированных значений по Y
  SetLength(IntrpResltValues, SERVO_RANGE);
  i := 0;
  while i < SERVO_RANGE do
  begin
    IntrpResltValues[i] := Trunc(SplineInterpolation(RezC, DesiredXValues[i]) + 0.5);
    inc(i);
  end;
end;

procedure TfmMain.JvInitTmrTimer(Sender: TObject);
begin
  if not EmulationModeOn then
  begin
    joygetpos(JoyPedalsID,@JPedals);//указат.палец
  end
  else
  begin
    JPedals.wxpos := 0;
    JPedals.wypos := 0;
  end;
  if (JPedals.wxpos = 0) and (JPedals.wypos = 0) and
     (WorkState = dwsInitialized) or (WorkState = dwsWork) then
  begin
    JvInitTmr.Enabled := False;
    WorkMode := wmGettingData;

    if TimerID <> 0 then
       timeKillEvent(TimerID);
    TimerID := timeSetEvent(1, 0, @ProcMMTime, Cardinal(Self.Handle), TIME_PERIODIC);
  end;
end;

procedure TfmMain.JvLPTZeroOnTimer(Sender: TObject);
begin
  Out32(LPTAdress, 0);
  JvTimerLPTZero.Enabled := False;
end;

procedure TfmMain.JvNetscpSpl_DynAnalysisMaximize(Sender: TObject);
begin
  Resize;
  InvalidateRect(BoardPnl.Handle, nil, False);
end;

procedure TfmMain.JvNetscpSpl_DynAnalysisMinimize(Sender: TObject);
begin
  Resize;
  InvalidateRect(BoardPnl.Handle, nil, False);
end;

procedure TfmMain.JvSubTimerTimer(Sender: TObject);
var
  data: Pointer;
  samples: Integer;
  timestamp: UInt64;
  i, j, k: Integer;
  BufData: array [0..ACTICHAMP_CH_CNT-1] of TDoubleDynArray;
begin
  samples := 50;

  j := 0;
  while j < ACTICHAMP_CH_CNT do
  begin
    SetLength(BufData[j], samples);
    inc(j);
  end;
  try

    //одинаковый синус по всем каналом, но с разным сдвигом
    j := 0;
    while j < ACTICHAMP_CH_CNT do
    begin
      i := 0;
      while i < samples do
      begin
        BufData[j][i] := sin(ChnlCntrs[j] * (Pi / 180))*1000 + (j*100);
        ChnlCntrs[j] := (ChnlCntrs[j] + 18 + 360) mod 360;
        inc(i);
      end;
      inc(j);
    end;

  SetLength(StubData, SizeOf(Double)*ACTICHAMP_CH_CNT*samples);

  //пихаем всё в линейный массив, как требует ф-ция callme
  k := 0;
  i := 0;
  while i < samples do
  begin
    j := 0;
    while j < ACTICHAMP_CH_CNT do
    begin
      StubData[k] := BufData[j][i];//Random*100 + (j*10);
      inc(k);
      inc(j);
    end;
    inc(i);
  end;

  data := @StubData[0];
  callme(data, ACTICHAMP_CH_CNT, samples, timestamp);

  finally
    j := 0;
    while j < ACTICHAMP_CH_CNT do
    begin
      SetLength(BufData[j], 0);
      inc(j);
    end;
    Finalize(BufData);
  end;
end;

//
procedure TfmMain.JvxSlider1Change(Sender: TObject);
begin
//  X_ := JvxSlider1.Value;
//  edtX_.Text := IntToStr(JvxSlider1.Value);
//  InvalidateRect(BoardPnl.Handle, nil, False);
  edtX_.Text := FloatTostr(JvxSlider1.Value / 10);
  RTestObj_Y := JvxSlider1.Value / 10;
  InvalidateRect(BoardPnl.Handle, nil, False);
end;

procedure TfmMain.JvxSlider2Change(Sender: TObject);
begin
  Y_ := JvxSlider2.Value;
  edtY_.Text := IntToStr(JvxSlider2.Value);
  InvalidateRect(BoardPnl.Handle, nil, False);
end;

procedure TfmMain.JvxSlider3Change(Sender: TObject);
begin
//  Angle := JvxSlider3.Value;
  Edit2.Text := FloatTostr(JvxSlider3.Value / 10);
  RTestObj_X := JvxSlider3.Value / 10;
  InvalidateRect(BoardPnl.Handle, nil, False);
end;

procedure TfmMain.SldrFovYChange(Sender: TObject);
begin
  if not FLockCtrls then
  begin
    FovY := SldrFovY.Value;
    Resize;
  //  chipX_ := JvxSliderX.Value / 1000;
    edit1.Text := FloatToStr(FovY);
    InvalidateRect(BoardPnl.Handle, nil, False);
  end;
end;

procedure TfmMain.StartExperiment(var Message: TMessage);
var
  strMsg: string;
  timePC: Int64;
begin
//  if not CallbackRegistered then
//    RegisterCallback(handle_, @callme);
//  CallbackRegistered := True;

  if not FEmulMode then
  begin
    if not CallbackRegistered then
    begin
      RegisterCallback(handle_, @callme);
      CallbackRegistered := True;
    end;
  end
  else
    JvSubTimer.Enabled := True;

  LimbOneUpCntr := 0;
  FCurGameSessionNumber := 1;
  FCurSessionDurationInMs := 0;
  Finalize(FGameResults);
  BoardPnlEnabled := True;

  edtFrcActnTShift.Text := IntToStr(AvrgReactionTime);

  ClearCommonCritArray;
  ClearCommonDeSynchValuesArray;
  ClearCommonRltvVelocityValuesArray;
  CommonCriteria := 0;
  Angle := 0;
  //JvtmrIntrvl.Interval := IntervalDefTimeLen;

  if QrPC0 = 0 then
    QueryPerformanceCounter(QrPC0);

  timePC := QrPC0;

  SendMrkToPortAndWriteLogMsg(0, 'MrkEvent ' + 'StartExperiment', timePC);

  strMsg := 'ExpVariant: ' + IntToStr(Integer(ExpVariants));
  AddMsgDataToLogFile_(NameForLogFile, strMsg, timePC);
  strMsg := 'SessionDurationInMs: ' + IntToStr(FDefSessionDurationInMs);
  AddMsgDataToLogFile_(NameForLogFile, strMsg, timePC);

  ShowGL(True);

  BeginExperiment;

  AvrgReactionTime := 0;
  MinReactionTime := 0;
  AvrgReactionVelocityTime := 0;
  GoalReactionVelocityTime := 0;
end;

function TfmMain.StartWorkWithComPort: Boolean;
var
  i: Integer;
begin
  Result := False;
//  if cbxComNum.ItemIndex <> -1 then
  begin
    FDevBusy := True;
    try
    //  LoadSettingsFromINI(FIniFileName);
//      ComVar.PortName := AnsiStrToTAscii(cbxComNum.Items.Strings[cbxComNum.ItemIndex]);
      if WorkState <> dwsTerminated then
      begin
        WorkState := dwsTerm;
        i := 0;
        while (not (FDevWorkState = dwsTerminated)) and
              (i < 3000) do
        begin
          Application.ProcessMessages;
          Sleep(1);
          inc(i);
        end;

        if (i >= 3000) and
           (WorkState <> dwsTerminated) then
          WorkState := dwsTerminated;

        Sleep(100);
        WorkState := dwsStart;
      end
      else
        WorkState := dwsStart;

      Result := True;
    finally
      FDevBusy := False;
    end;
  end;
end;

function TfmMain.SubTestCount: Integer;
begin
  Result := FSubTests.Count;
end;

procedure TfmMain.TexInit;
var
  i, j: Integer;
  k : GLint;
begin
  glEnable(GL_TEXTURE_2D);
  glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL );
  glGenTextures(3, @TexObj );

  glBindTexture( GL_TEXTURE_2D, TexObj[0] );
  BoardBitmap.LoadFromFile('clock_1024_1024.bmp'{'elitefon.ru-126542_1024_1024.bmp'}); // загрузка текстуры из файла

   {--- заполнение битового массива ---}
   //для доски
    i := 0;
    while i < BOARD_IMG_HEIGHT do
    begin
      j := 0;
      while j < BOARD_IMG_WIDTH do
      begin
        BoardGL[i, j, 0] := GetRValue(BoardBitmap.Canvas.Pixels[i,j]);
        BoardGL[i, j, 1] := GetGValue(BoardBitmap.Canvas.Pixels[i,j]);
        BoardGL[i, j, 2] := GetBValue(BoardBitmap.Canvas.Pixels[i,j]);
        inc(j);
      end;
      inc(i);
    end;

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,
                 BOARD_IMG_WIDTH, BOARD_IMG_HEIGHT,     // здесь задается размер текстуры
                 0, GL_RGB, GL_UNSIGNED_BYTE, @BoardGL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);

   glBindTexture( GL_TEXTURE_2D, TexObj[1] );
   ChipBitmap.LoadFromFile('chip_black_64x64.bmp');
   //для фишек
    For i := 0 to CHIP_IMG_HEIGHT - 1 do
      For j := 0 to CHIP_IMG_WIDTH - 1 do
      begin
        ChipGL [i, j, 0] := GetRValue(ChipBitmap.Canvas.Pixels[i,j]);
        ChipGL [i, j, 1] := GetGValue(ChipBitmap.Canvas.Pixels[i,j]);
        ChipGL [i, j, 2] := GetBValue(ChipBitmap.Canvas.Pixels[i,j]);
      end;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,
                 CHIP_IMG_WIDTH, CHIP_IMG_HEIGHT,     // здесь задается размер текстуры
                 0, GL_RGB, GL_UNSIGNED_BYTE, @ChipGL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);


   glBindTexture( GL_TEXTURE_2D, TexObj[2] );
   ChipBitmap.LoadFromFile('chip_white_64x64.bmp');
   //для фишек
    For i := 0 to CHIP_IMG_HEIGHT - 1 do
      For j := 0 to CHIP_IMG_WIDTH - 1 do
      begin
        ChipGL [i, j, 0] := GetRValue(ChipBitmap.Canvas.Pixels[i,j]);
        ChipGL [i, j, 1] := GetGValue(ChipBitmap.Canvas.Pixels[i,j]);
        ChipGL [i, j, 2] := GetBValue(ChipBitmap.Canvas.Pixels[i,j]);
      end;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,
                 CHIP_IMG_WIDTH, CHIP_IMG_HEIGHT,     // здесь задается размер текстуры
                 0, GL_RGB, GL_UNSIGNED_BYTE, @ChipGL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
end;

procedure TfmMain.TicSndEffectApply(var Message: TMessage);
var
  pdwStatus: Cardinal;
begin
//  sndPlaySound(PWideChar(TicSndFileName), SND_FILENAME or SND_ASYNC);
//  NeedSuspend := True;
  IPlStimModule.Effect_StartPlay(TicSndEffect, False);
//  repeat //ждём пока проиграется звук
//    FIPlStimModule.Effect_GetStatus(SuccessSndEffect, pdwStatus);
//    Application.ProcessMessages;
//  until (pdwStatus <> 1{DSBSTATUS_PLAYING});
//  NeedSuspend := False;
end;

//procedure TfmMain.tmrAlertSubjectActionTimer(Sender: TObject);
//begin
//  //предупреждающий сигнал - колебание коромысла влево и возврат в исх.позицию 180
//  if AlertMoveToUp then
//  begin
//    Angle := Angle + 6{18};
//    if Angle >= 210{270} then
//      AlertMoveToUp := False;
//  end
//  else
//  begin
//    Angle := 180;
//    //Angle := Angle + 7;
//    if Angle >= 180 then
//    begin
//      Angle := 180;
//      tmrAlertSubjectAction.Enabled := False;
//      AlertMoveToUp := True;
//      AllowAlertSubjectAction := False;
//    end;
//  end;
//  InvalidateRect(BoardPnl.Handle, nil, False);
//end;

procedure TfmMain.tmrNeedServoDownTimer(Sender: TObject);
begin
  NeedServoDown := True;
  tmrNeedServoDown.Enabled := False;
end;

procedure TfmMain.TmrSessionDurationTimer(Sender: TObject);
begin
  inc(FCurSessionDurationInMs, 1000);
end;

procedure TfmMain.tmrTrckBarJoyPosEmulTimer(Sender: TObject);
const
  //скорость движ-я лев.педали
  VelLPUpDelay:Integer = 0;//задержка начала движения
//  VelLPDownDelay:Integer = 10;
  VelLPUp: Integer = 3000;//вперед
  VelLPDown: Integer = 3000;//назад
  //скорость движ-я прав.педали
  VelRPUp: Integer = 3000;
  VelRPDown: Integer = 2900;
  //скорость движ-я штурвала
  VelYokeUp: Integer = 1500;
  VelYokeDown: Integer = 1400;
begin
//  if EmulVelLPUp_Delay < VelLPUpDelay then
//    inc(EmulVelLPUp_Delay);
//  EmulNeedLPDelayMoveToUp := not (EmulVelLPUp_Delay >= VelLPUpDelay);
//
////  if not EmulNeedLPDelayMoveToUp then
//  begin
//    if EmulNeedLPMoveToUp then
//    begin
//      if not EmulNeedLPDelayMoveToUp then
//        inc(EmulLimbOne_wxpos, VelLPUp);
//      EmulNeedLPMoveToUp := not (EmulLimbOne_wxpos >= LimbOneData.MaxPos);
//    end
//    else
//    begin
//      if (not EmulNeedRPMoveToUp) then
//        if (EmulLimbOne_wxpos - VelLPDown >= 0)  then
//          dec(EmulLimbOne_wxpos, VelLPDown)
//        else
//          EmulLimbOne_wxpos := 0;
//    end;
//    JPedals.wxpos := min(LimbOneData.MaxPos, max(0, EmulLimbOne_wxpos));
//  end;
////  if Pedals_wxpos = 0 then
////    tmrTrckBarLPPosEmul.Enabled := False;
//
//  if EmulNeedRPMoveToUp then
//  begin
//    inc(EmulLimbTwo_wypos, VelRPUp);
//    EmulNeedRPMoveToUp := not (EmulLimbTwo_wypos >= LimbTwoData.MaxPos);
//  end
//  else
//  begin
//    if (not EmulNeedLPMoveToUp) then
//      if (EmulLimbTwo_wypos - VelRPDown >= 0) then
//        dec(EmulLimbTwo_wypos, VelRPDown)
//      else
//        EmulLimbTwo_wypos := 0;
//  end;
//  JPedals.wypos := min(LimbTwoData.MaxPos, max(0, EmulLimbTwo_wypos));
//
//  if EmulNeedYokeMoveToUp then
//  begin
//    inc(EmulYoke_wypos, VelYokeUp);
//    EmulNeedYokeMoveToUp := not (EmulYoke_wypos >= YokeData.MaxPos);
//  end
//  else
//  begin
//    if (not EmulNeedYokeMoveToUp) then
//      if (EmulYoke_wypos - VelYokeDown >= 0)  then
//        dec(EmulYoke_wypos, VelYokeDown)
//      else
//        EmulYoke_wypos := 0;
//  end;
//  JYoke.wypos := min(YokeData.MaxPos, max(YokeData.MinPos, EmulYoke_wypos));
//
//  if (JPedals.wxpos = LimbOneData.MinPos) and
//     (JPedals.wypos = LimbTwoData.MinPos) and
//     (JYoke.wYpos = YokeData.MinPos) then
//  begin
//    tmrTrckBarJoyPosEmul.Enabled := False;
//  end;
end;

procedure TfmMain.UpdateCntrls(var Message: TMessage);
var
  rt: TRequestType;
begin
  rt := TRequestType(Message.WParam);
  if rt in [rtBeginBackdrop] then
    mnuBackdropstart.Caption := 'Backdrop Started';
  if RequestType in [rtEndBackdrop] then
  begin
    mnuBackdropstart.Caption := 'Backdrop Stoped';
    ShowMessage('Backdrop 120 sec has recorded');
  end;
  if rt in [rtEndExperiment] then
  begin
    ShowCursor_;
    fmMain.TmrSessionDuration.Enabled := False;
    ShowMessage('Этап эксперимента завершён.');
  end;
end;

procedure TfmMain.UpdateVCLCtrls(var Message: TMessage);
var
  normAvrgPos: Double;
  strMsg: string;
  data: Byte;
  errCode: Word;
begin
 // Caption := IntToStr(TmpCntr);
  //exit;
//  if AllowAlertSubjectAction then
//    AlertSubjectAction(fmMain.BoardPnl.Handle);
//  if MaestroErrCode <> 0 then
//  begin
//    errCode := MaestroErrCode;
//    LedDevOnAir.ColorOn := clRed;
//    AddMsgDataToLogFile_('_Err', ' HiByte= ' + IntToStr(HiByte(errCode)) + ' LoByte= ' + IntToStr(LoByte(errCode)), Pc);
//  end;
  FLockCtrls := True;

  edtReoPos.Text := IntToStr(MaestroReoPos);
  edtSnsPos.Text := IntToStr(LimbOneUpSensorVal);
  edtSrvPos.Text := IntToStr(Trunc(MaestroServoPos/4 + 0.5));
  edtRT.Text := IntToStr(ReactionTime);
  edtAvrgRT.Text := IntToStr(AvrgReactionTime);
  edtMinRT.Text := IntToStr(MinReactionTime);
  edtRVlctyTime.Text := IntToStr(ReactionVelocityTime);
  edtGoalRVlctyTime.Text := IntToStr(GoalReactionVelocityTime);
  edtAvrgRVlctyT.Text := IntToStr(AvrgReactionVelocityTime);
  edtLimb1UpCnt.Text := IntToStr(LimbOneUpCntr);
  edtAmpLimbToUp.Text := IntToStr(AmplitudeLimbToUp);
  edtGoalAmpLimbToUp.Text := IntToStr(GoalAmplitudeLimbToUp);
  edtAvrgAmpLimbToUp.Text := IntToStr(AvrgAmplitudeLimbToUp);
  edtRTValCnt.Text := IntToStr(GetRTValuesCount);
  edtFrcActnTShift.Text := IntToStr(ForceActionTimeShift);
  edtAlrtDrtnT.Text := IntToStr(AlertDurationTime);
  edtReactionAccuracy.Text := FloatToStrF(ReactionAccuracy, ffFixed, 8, 3);
  edtAvrgReactionAccuracy.Text := FloatToStrF(AvrgReactionAccuracy, ffFixed, 8, 3);
//  edtTimeLimbUpDown.Text := IntToStr(TimeLimbToUpDown); //!! надо разобраться с измерением времени движения !!!!!!!!!!!!! Возможно, это не надо
//  edtAvrgTimeLimbUpDown.Text := IntToStr(AvrgTimeValueLimbUpDown);

  if NeedSuspend then
    Exit;

  if WorkMode in [wmNeedCalculateData, wmCalculatedData] then
  begin
    TrckBarLP.position := REO_MAX - JPedals.wxpos;//указат.палец
    TrckBarRP.position := REO_MAX - JPedals.wypos;//средний палец (пока не реализовано)

 //   Caption := IntTostr(JYoke.wButtons);
    //  caption := IntTostr(65535 - JYoke.wypos);

    if Length(LimbOneData.Values) >= 3 then //в массиве должны хотя бы быть точки начала, крайней максимальной и конечной позиции при обратном ходе
    begin
      edtLPPos1.Text := IntToStr(LimbOneData.Wpos1);
      edtLPPos2.Text := IntToStr(LimbOneData.Wpos2);
      edtLPDifPos.Text := IntToStr(difPosLO);
      edtLPValuesLen.Text := IntToStr(Length(LimbOneData.Values));
      edtLPMaxTime.Text := IntToStr(LOMaxTimeUp);
      edtLPMinTime.Text := IntToStr(LOMinTimeDown);
      edtLPCritUpValue.Text := FloatToStr(moveLOUpCriteria);
      edtLPCritDownValue.Text := FloatToStr(moveLODownCriteria);
    end;
    if Length(LimbTwoData.Values) >= 3 then
    begin
      edtRPPos1.Text := IntToStr(LimbTwoData.Wpos1);
      edtRPPos2.Text := IntToStr(LimbTwoData.Wpos2);
      edtRPDifPos.Text := IntToStr(difPosLT);
      edtRPValuesLen.Text := IntToStr(Length(LimbTwoData.Values));
      edtRPMaxTime.Text := IntToStr(LTMaxTimeUp);
      edtRPMinTime.Text := IntToStr(LTMinTimeDown);
      edtRPCritUpValue.Text := FloatToStr(moveLTUpCriteria);
      edtRPCritDownValue.Text := FloatToStr(moveLTDownCriteria);
    end;

    //if (difPosLP > 0) and (difPosRP > 0) then
//    if (not FLock) and (LTMaxTimeUp > 0) then
//    begin
//      FLock := True;
//      if LOMaxTimeUp > LTMaxTimeUp then
//      begin
//        DifMaxTimeUp := LOMaxTimeUp - LTMaxTimeUp;
//        edtDifPedalsMaxTimeNotifictn.Text := 'Правая раньше на: ' + IntToStr(DifMaxTimeUp);
//      end
//      else
//        if LTMaxTimeUp > LOMaxTimeUp then
//        begin
//          DifMaxTimeUp := LTMaxTimeUp - LOMaxTimeUp;
//          edtDifPedalsMaxTimeNotifictn.Text := 'Левая раньше на: ' + IntToStr(DifMaxTimeUp);
//        end
//      else
//        begin
//          DifMaxTimeUp := 0;
//          edtDifPedalsMaxTimeNotifictn.Text := 'Одновременно ' + IntToStr(DifMaxTimeUp);
//        end;
//
//      if LOMinTimeDown > LTMinTimeDown then
//      begin
//        DifMinTimeDown := LOMinTimeDown - LTMinTimeDown;
//        edtDifPedalsMinTimeNotifictn.Text := 'Правая раньше на: ' + IntToStr(DifMinTimeDown);
//      end
//      else
//        if LTMinTimeDown > LOMinTimeDown then
//        begin
//          DifMinTimeDown := LTMinTimeDown - LOMinTimeDown;
//          edtDifPedalsMinTimeNotifictn.Text := 'Левая раньше на: ' + IntToStr(DifMinTimeDown);
//        end
//      else
//        begin
//          DifMinTimeDown := 0;
//          edtDifPedalsMinTimeNotifictn.Text := 'Одновременно ' + IntToStr(DifMinTimeDown);
//        end;
//      FLock := False;
//    end;
  end;
    if (not FLock) and NeedCtrlUpdate and (WorkMode = wmCalculatedData) then
    begin
      FLock := True;
      NeedCtrlUpdate := False;
      if NeedSubjAction then
      begin
//        SetIntrvlPeriod(2000);
//        //JvtmrIntrvl.Interval := 2000;
//     //   NeedSubjAction := False;
//  //      Caption := IntToStr(Cntr64);
//        edtSynchroCriteria.Text := FloatToStr(SynchroCriteria);
//        //среднее по критериям вверх-вниз отдельно по педалям и штурвалу
//        edtLPFullCritValue.Text := FloatToStr(LOFullCritValue);
//        edtRPFullCritValue.Text := FloatToStr(LTFullCritValue);
//        //полный общий критерий учитывает синхронность движений
//        edtCommonCrit.Text := FloatToStr(CommonCriteria);
//        srsCurCommonCriteria.Add(CommonCriteria, '', clGreen);
//
//        ViewHistCommonRltvVelocity;
//        //ViewHistCommonDeSynch;
//        ViewHistCommonCriteria;
//        edtTrialsCount.Text := IntToStr(Length(CommonCritArray));
//        if not(RequestType in [rtNone]) then
//        begin
////          strMsg := 'SeparatelyAxisVelocity: ' + {' LTRltvVelUp= ' + IntToStr(LTRltvVelUp) + ' LTRltvVelDown= ' + IntToStr(LTRltvVelDown) +} ' LORltvVelUp= ' + IntToStr(LORltvVelUp) +
////                  ' LORltvVelDown= ' + IntToStr(LORltvVelDown);
////          AddMsgDataToLogFile_(NameForLogFile, strMsg, Pc);
////  //        strMsg := 'SeparatelyAxisDesynch: ' + ' difTimeUpLOLT= ' + IntToStr(difTimeMaxLOLT) + ' difTimeDownLOLT= ' + IntToStr(difTimeMinLOLT);
////  //        AddMsgDataToLogFile_(NameForLogFile, strMsg);
////          strMsg := 'AvrgEffectiveness:' + ' CommonRltvVelocity= ' + IntToStr(CommonRltvVelocity) {+ ' CommonDeSynch= ' + IntToStr(CommonDeSynch)} + ' CommonCriteria= ' + FloatToStr(CommonCriteria);
////          AddMsgDataToLogFile_(NameForLogFile, strMsg, Pc);
//        end;
      end;
      FLock := False;
    end;
//  if NeedSubjAction then
  begin
    With fmMain do
    begin
      //отрисовка усреднённой позиции по всем осям
      //нужные выходные углы поворота коромысла:
      //мин - 180 (вертикально)
      //макс - 270 (поворот влево до 90 град относит. вертик.позиции)
      //усреднённая позиция по всем осям, нормированная в 0..1
//      normAvrgPos := (JPedals.wxpos - SERVO_MIN)/(SERVO_MAX - SERVO_MIN);
//      if not tmrAlertSubjectAction.Enabled then
//        Angle := 180 + (270-180)* ((normAvrgPos - 0)/ (1-0));
      //заполненность колбы
//      Fillness := CommonCriteria * 100;
//
//      InvalidateRect(BoardPnl.Handle, nil, False);
    end;
  end;

 // Caption := IntToStr(JYoke.wButtons);
 //для вето-варианта: если предупр.сигнал осознан, то не выполняем действия, а пропускаем эпоху
//  if NeedBtnFire2Down = False then
//    NeedBtnFire2Down := JYoke.wButtons = 256;
//  if (JYoke.wButtons = 257) and (NeedBtnFire2Down) then
//  begin
//    data := MrkForcedNextAction;
//    SendMarker(data);
//    strMsg := 'MrkEvent ' + 'MrkForcedNextAction= ' + IntToStr(data);
//    AddMsgDataToLogFile_(NameForLogFile, strMsg);
//
//    NeedBtnFire2Down := False;
//    JvtmrIntrvl.Interval := 2000;
//  end;
  FLockCtrls := False;
end;

procedure TfmMain.ViewHistCommonCriteria;
var
  i: Integer;
  Rate: TIntegerDynArray;
  Intervals: TDoubleDynArray;
  prcntl: Double;
begin
//  if CommonCriteria > 0 then
  begin
    AddCommonCritToArray(CommonCriteria);
    HistogramCalculate(CommonCritArray, Rate, Intervals, 20);
    try
      BarSrsCommonCriteria.Clear;
      i := 0;
      while i < Length(Intervals) do
      begin
        BarSrsCommonCriteria.Add(Rate[i], '', clGreen);
        inc(i);
      end;
      prcntl := Percentile(CommonCritArray, 34);
      edt5PercentileCommonCriteria.Text := FloatToStr(prcntl);
      prcntl := Percentile(CommonCritArray, 50);
      edt50PercentileCommonCriteria.Text := FloatToStr(prcntl);
      prcntl := Percentile(CommonCritArray, 84);
      edt95PercentileCommonCriteria.Text := FloatToStr(prcntl);
    finally
      Finalize(Rate);
      Finalize(Intervals);
    end;
  end;
end;

procedure TfmMain.ViewHistCommonDeSynch;
var
  i: Integer;
  Rate: TIntegerDynArray;
  Intervals: TDoubleDynArray;
  prcntl: Double;
begin
  //строим гистограмму распред-я общ. десинхронизации по осям
  if (CommonDeSynch > 0) and (CommonDeSynch < 4000) then
  begin
    AddCommonDeSynchValueToArray(CommonDeSynch);
    HistogramCalculate(CommonDeSynchValuesArray, Rate, Intervals, 20);
    try
      BarSrsCommonDeSynch.Clear;
      i := 0;
      while i < Length(Intervals) do
      begin
        BarSrsCommonDeSynch.Add(Rate[i], '', clGreen);
        inc(i);
      end;
      CommonDeSynchPrcntl_Lo := Percentile(CommonDeSynchValuesArray, 34);
      edt5PercentileCommonDeSync.Text := FloatToStr(CommonDeSynchPrcntl_Lo);
      CommonDeSynchPrcntl_Med := Percentile(CommonDeSynchValuesArray, 50);
      edt50PercentileCommonDeSync.Text := FloatToStr(CommonDeSynchPrcntl_Med);
      CommonDeSynchPrcntl_Hi := Percentile(CommonDeSynchValuesArray, 84);
      edt95PercentileCommonDeSync.Text := FloatToStr(CommonDeSynchPrcntl_Hi);
    finally
      Finalize(Rate);
      Finalize(Intervals);
    end;
  end;
end;

procedure TfmMain.ViewHistCommonRltvVelocity;
var
  i: Integer;
  Rate: TIntegerDynArray;
  Intervals: TDoubleDynArray;
  prcntl: Double;
begin
  if (CommonRltvVelocity > 0) and (CommonRltvVelocity < 4000) then
  begin
    AddCommonRltvVelocityValueToArray(CommonRltvVelocity);
    HistogramCalculate(CommonRltvVelocityValuesArray, Rate, Intervals, 20);
    try
      BarSrsCommonRltvVelocity.Clear;
      i := 0;
      while i < Length(Intervals) do
      begin
        BarSrsCommonRltvVelocity.Add(Rate[i], '', clGreen);
        inc(i);
      end;
      CommonRltvVelocityPrcntl_Lo := Percentile(CommonRltvVelocityValuesArray, 34);
      edt5PercentileCommonRltvVelocity.Text := FloatToStr(CommonRltvVelocityPrcntl_Lo);
      CommonRltvVelocityPrcntl_Med := Percentile(CommonRltvVelocityValuesArray, 50);
      edt50PercentileCommonRltvVelocity.Text := FloatToStr(CommonRltvVelocityPrcntl_Med);
      CommonRltvVelocityPrcntl_Hi := Percentile(CommonRltvVelocityValuesArray, 84);
      edt95PercentileCommonRltvVelocity.Text := FloatToStr(CommonRltvVelocityPrcntl_Hi);
    finally
      Finalize(Rate);
      Finalize(Intervals);
    end;
  end;
end;

procedure TfmMain.TexDeinit;
begin
  glDeleteTextures(3, @TexObj );
end;

procedure drawCircle(x: GLfloat; y: GLFloat; r: GLFloat; amountSegments: Integer);
var
  i: Integer;
begin
//  glBegin(GL_LINE_LOOP);
//  i := 0;
//  while i < amountSegments do
//  begin
//
//    inc(i);
//  end;
//  for(int i = 0; i < amountSegments; i++)
//
//
//  float angle = 2.0 * 3.1415926 * float(i) / float(amountSegments);
//
//  float dx = r * cosf(angle);
//
//  float dy = r * sinf(angle);
//
//  glVertex2f(x + dx, y + dy);
//  glEnd();

end;

procedure TfmMain.WorldCoordByMouseXY(X, Y, Z: GLfloat; var p1: TGLCoord3d);
var
 Viewport : Array [0..3] of GLInt;
 mvMatrix, ProjMatrix : Array [0..15] of GLDouble;
 RealY : GLint ;          // позиция OpenGL y - координаты
 wx, wy, wz : GLdouble ;  // возвращаемые мировые x, y, z координаты
 Zval : GLfloat;
begin
  glGetIntegerv (GL_VIEWPORT, @Viewport);
  glGetDoublev (GL_MODELVIEW_MATRIX, @mvMatrix);
  glGetDoublev (GL_PROJECTION_MATRIX, @ProjMatrix);
  // viewport[3] - высота окна в пикселях
  RealY := Trunc(viewport[3] - Y - 1);

  //получаем Z коорд. по X, Y
  glReadPixels(Trunc(X), RealY, 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT, @Zval);

  gluUnProject (Trunc(X), RealY, Zval,
                @mvMatrix, @ProjMatrix, @Viewport, wx, wy, wz);

  Z := Zval;
  p1.x := wx;
  p1.y := wy;
  p1.z := wz;
end;

function TfmMain.AddSubTest(ASubTest: TSubTest): Integer;
begin
  Result := FSubTests.Add(ASubTest);
end;

function TfmMain.LoadAsciiLogFile(const AFileName: string): Boolean;
var
  TxtFile: TextFile;
  ReadStr: AnsiString;
  SubStrPos: Integer;
  SubStrPos2: Integer;
  st: TSubTest;
  slst: TStringList;
  SubStr: AnsiString;
  SubStrT1, SubStrT2: AnsiString;
  intrvl: TInterval;
begin
  Result := False;
  if FileExists(AFileName) then
  begin
    AssignFile(TxtFile, AFileName);
    Reset(TxtFile);
    try
      ClearSubTests;
      while not Eof(TxtFile) do
      begin
        ReadLn(TxtFile, ReadStr);
        ReadStr := RemoveSymbols(ReadStr, #0);
        SubStrPos := fAnsiPos('ExpVariant:', ReadStr, 2);
        if (SubStrPos > 0) then
        begin
          st := TSubTest.Create;//нашли? добавляем в список новый субтест
          SubStr := GetSubstrG(ReadStr, 3, ' ');
          st.TestNumber := StrToInt(SubStr);
          AddSubTest(st);
        end;
        SubStrPos := fAnsiPos('SessionDurationInMs:', ReadStr, 2);
        if (SubStrPos > 0) then
        begin
          SubStr := GetSubstrG(ReadStr, 3, ' ');
          st.SessionDurationInMs := StrToInt(SubStr);
        end;
        SubStrPos := fAnsiPos('MrkBeginIntrvlCode=', ReadStr, 3);
        if (SubStrPos > 0) then
        begin
          FillChar(intrvl, SizeOf(intrvl), 0);
          SubStrT1 := GetSubstrG(ReadStr, 1, ' ');
        end;
        SubStrPos := fAnsiPos('MrkEvtActionCode=', ReadStr, 3);
        if (SubStrPos > 0) then
        begin
          SubStrT2 := GetSubstrG(ReadStr, 1, ' ');
          if (SubStrT1 <> '') and (SubStrT2 <> '') then
          begin
            //время события FA относительно времени начала интервала
            intrvl.EvtActionTimeRltvBeginIntrvl := Trunc(StrToFloatDef(SubStrT2, 0) - StrToFloatDef(SubStrT1, 0) + 0.5);
            SubStrT1 := '';
            SubStrT2 := '';
          end;
        end;
        SubStrPos := fAnsiPos('AlertDurationTime', ReadStr, 2);
        if (SubStrPos > 0) then
        begin
          SubStr := GetSubstrG(ReadStr, 4, ' ');
          intrvl.AlertDurationTime := StrToInt(SubStr);
        end;
        SubStrPos := fAnsiPos('RTValue', ReadStr, 2);
        if (SubStrPos > 0) then
        begin
          SubStr := GetSubstrG(ReadStr, 4, ' ');
          intrvl.RTValue := StrToInt(SubStr);
        end;
        SubStrPos := fAnsiPos('AvrgRT', ReadStr, 2);
        if (SubStrPos > 0) then
        begin
          SubStr := GetSubstrG(ReadStr, 4, ' ');
          intrvl.AvrgRTValue := StrToInt(SubStr);
        end;
        SubStrPos := fAnsiPos('AmplitudeLimbToUp', ReadStr, 2);
        if (SubStrPos > 0) then
        begin
          SubStr := GetSubstrG(ReadStr, 4, ' ');
          intrvl.AmplitudeLimbToUp := StrToInt(SubStr);
        end;
        SubStrPos := fAnsiPos('AvrgAmplitudeLimbToUp', ReadStr, 2);
        if (SubStrPos > 0) then
        begin
          SubStr := GetSubstrG(ReadStr, 4, ' ');
          intrvl.AvrgAmplitudeLimbToUp := StrToInt(SubStr);
        end;
        SubStrPos := fAnsiPos('ReactionVelocityTime', ReadStr, 2);
        if (SubStrPos > 0) then
        begin
          SubStr := GetSubstrG(ReadStr, 4, ' ');
          intrvl.ReactionVelocityTime := StrToInt(SubStr);
        end;
        SubStrPos := fAnsiPos('AvrgReactionVelocityTime', ReadStr, 2);
        if (SubStrPos > 0) then
        begin
          SubStr := GetSubstrG(ReadStr, 4, ' ');
          intrvl.AvrgReactionVelocityTime := StrToInt(SubStr);
        end;
        SubStrPos := fAnsiPos('AnswerType', ReadStr, 2);
        if (SubStrPos > 0) then
        begin
          SubStr := GetSubstrG(ReadStr, 3, ' ');
          if CompareStr(SubStr, 'NoAnswer') = 0 then
            intrvl.AnswerType := aNoAnswer;
          if CompareStr(SubStr, 'aAVal1') = 0 then
            intrvl.AnswerType := aAVal1;
          if CompareStr(SubStr, 'aAVal2') = 0 then
            intrvl.AnswerType := aAVal2;
          if CompareStr(SubStr, 'aAVal3') = 0 then
            intrvl.AnswerType := aAVal3;
          if CompareStr(SubStr, 'aAVal4') = 0 then
            intrvl.AnswerType := aAVal4;
          if CompareStr(SubStr, 'aAVal5') = 0 then
            intrvl.AnswerType := aAVal5;
          if CompareStr(SubStr, 'aAVal6') = 0 then
            intrvl.AnswerType := aAVal6;
          if CompareStr(SubStr, 'aAVal7') = 0 then
            intrvl.AnswerType := aAVal7;
          if CompareStr(SubStr, 'aAVal8') = 0 then
            intrvl.AnswerType := aAVal8;
          if CompareStr(SubStr, 'aAVal9') = 0 then
            intrvl.AnswerType := aAVal9;
          if CompareStr(SubStr, 'aAVal10') = 0 then
            intrvl.AnswerType := aAVal10;
          st.AddInterval(intrvl);
        end;
//          if CompareStr(ReadedStr, strAnswSequence) = 0 then

//          slst := TStringList.Create;
//          try
//            slst.Delimiter := ',';
//            slst.DelimitedText := ReadStr;
//            i:=0;
//            while i < slst.Count do
//            begin
//              answerCode := StrToInt(slst.Strings[j]);
//              inc(i);
//            end;
//          finally
//            slst.Free;
//          end;
      end;
    finally
      CloseFile(TxtFile);
    end;
    Result := True;
  end;
end;

procedure TfmMain.LoadSettingsFromINI(const IniFileName: WideString);
var
  iniFile: TIniFile;
  Section: string;
  tmpStr: string;
begin
  iniFile := TIniFile.Create(InifileName);
  try
    Section := 'WorkSettings';
    FDebugPnlVisible := iniFile.ReadBool(Section, 'DebugPnlVisible', true);
    FEmulMode := iniFile.ReadBool(Section, 'EmulMode', False);
    FVidModeSelectedIndex := iniFile.ReadInteger(Section, 'VidModeSelectedIndex', 0);
    FFullScreenMode := iniFile.ReadBool(Section, 'FullScreenMode', true);
    FovY := iniFile.ReadFloat(Section, 'FovY', 55);//параметр вида - угол зрения сцены
    DefChipSize := iniFile.ReadFloat(Section, 'DefChipSize', 0.06);//размер фишек на доске
    Section := 'GameSettings';
    DefSessionDurationInMs := iniFile.ReadInteger(Section, 'SessionDurationInMs', 1);
    AllowAlertSubjectAction := iniFile.ReadBool(Section, 'NeedAlertSubjectAction', True);
    AllowDialogAutoHideTimer := iniFile.ReadBool(Section, 'AllowDialogAutoHideTimer', True);
    AllowSuccFeedbackSignal := iniFile.ReadBool(Section, 'AllowSuccFeedbackSignal', True);
    AllowFailFeedbackSignal := iniFile.ReadBool(Section, 'AllowFailFeedbackSignal', True);
    AllowTicSignal := iniFile.ReadBool(Section, 'AllowTicSignal', True);
    Section := 'JoySettings';
    JoyPedalsID := iniFile.ReadInteger(Section, 'JoyPedalsID', 0);
    EmulationModeOn := iniFile.ReadBool(Section, 'EmulationModeOn', True);
    DelayMin := iniFile.ReadInteger(Section, 'DelayMin', 1);//допустимый для испыт-го мин-макс для параметра синхронности
    DelayMax := iniFile.ReadInteger(Section, 'DelayMax', 2000);
    //мин-макс для парам.скорости перемещения джоев в мс, кот. ещё допустим для исп-го
    //исходя из этого д-на идёт пересчёт в шкалу 0..1
    PartialDerivativeMin := iniFile.ReadInteger(Section, 'PartialDerivativeMin', 1);
    PartialDerivativeMax := iniFile.ReadInteger(Section, 'PartialDerivativeMax', 2000);
    Section := 'LPTSettings';
    WorkWithLPT := iniFile.ReadBool(Section, 'WorkWithLPT', False);
    tmpStr := iniFile.ReadString(Section, 'LPTAdress', '378');
    LPTAdress := HexToInt(AnsiString(tmpStr));
    tmpStr := iniFile.ReadString(Section, 'LPTAdress2', '378');
    LPTAdress2 := HexToInt(AnsiString(tmpStr));
    Section := 'ComSettings';
    ComVar.PortName := AnsiStrToTAscii(AnsiString(iniFile.ReadString(Section, 'DevComPortName', '')));
    ComBaudRate := iniFile.ReadInteger(Section, 'BaudRate', 57600);
    Section := 'ExperimentSettings';
    MrkBeginIntrvlCode := iniFile.ReadInteger(Section, 'MrkBeginIntrvlCode', 12);
    MrkEndIntrvlCode := iniFile.ReadInteger(Section, 'MrkEndIntrvlCode', 13);
    MrkEvtActionCode := iniFile.ReadInteger(Section, 'MrkEvtActionCode', 10);
    MrkAlertSubjActionCode := iniFile.ReadInteger(Section, 'MrkAlertSubjAction', 9);
    ReactionTimeCorrection := iniFile.ReadInteger(Section, 'ReactionTimeCorrection', 69);
    ActionDelayTimeCorrection := iniFile.ReadInteger(Section, 'ActionDelayTimeCorrection', 44);
    ForceActionTimeShift := iniFile.ReadInteger(Section, 'ForceActionTimeShift', 0);
    ServoNeedMax := iniFile.ReadInteger(Section, 'ServoNeedMax', 1200);
    ServoVlcty := iniFile.ReadInteger(Section, 'ServoVlcty', 120);
  finally
    iniFile.Free;
  end;
end;

procedure TfmMain.CheckTotalResultAndShowWndMsg;
var
  p: Integer;
  strMsg: string;
begin
//  p := CheckTotalResult;
//  with TfmHasWon.Create(fmMain) do
//  try
//    Caption := 'EyeGomoku';
//    if (p = 1) or (p = 2) then
//      lblMsg.Caption := PChar('All game sessions complete ' + #10#13 +
//                        PChar('Player ' + IntToStr(p) + ' has won!'))
//    else
//      if p = 3 then
//        lblMsg.Caption := PChar('All game sessions complete ' + #10#13 +
//                          PChar('Draw!'));
//    TmrHumanCourse.Enabled := False;
//
//    strMsg := lblMsg.Caption;
//    AddMsgDataToLogFile_(NameForLogFile, strMsg);
//
//    ShowModal;
//  finally
//    Release;
//  end;
end;

procedure TfmMain.chkBxNotchFilter50Click(Sender: TObject);
begin
  FiltersEnabled := chkBxNotchFilter50.Checked;
end;

procedure TfmMain.chMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
 // i: integer;
  tmpX,tmpY:Double;
  xk, yk: double;  // координата xk:yk серии
  Xindx: Integer;
begin
  gx:=x; gy:=y;
  ch.Repaint;
  ch.Series[0].GetCursorValues(tmpX,tmpY); // переводим координаты из позиции курсора

  metka1:= FloatToStr(getlocateX(ch.Series[1], tmpX));
  metka2:= FloatToStr(getlocate(ch.Series[1], tmpY));//ch.Series[1].GetVertAxis.LabelValue(tmpY);
 // Caption := 'X= ' + FloatToStr(tmpX) + ' Y= ' + FloatToStr(tmpY);

  if not PointFixed then
  begin
   // SetneighbourhoodPoints(Trunc(XValue+0.5), tmpY);
  // getlocate(ch.Series[0], xk);
//
   tmpX := getlocateX(ch.Series[0], tmpX);
   Xindx := ch.Series[0].XValues.Locate(tmpX);
   if Xindx <> -1 then
   begin
     if NeedPointMoved then
     begin
       NeedPointMoved := False;
       SelectedXIndx := Xindx;
     end;
     if SelectedXIndx = Xindx then
     begin
       ch.Series[0].YValue[Xindx] := tmpY;
       BaseYPoints[High(BaseYPoints)-Xindx] := tmpY;
     end;
   end;

// Caption :=FloatToStr(Xindx);

   // ch.Series[0].YValue[Trunc(tmpX+0.5)] := tmpY;
    // позиция маркера-
//    if (XValue < ch.BottomAxis.Maximum) and (XValue >= ch.BottomAxis.Minimum-0.1) then
//    begin // fix- выход за координаты
//      ch.Series[1].XValue[0]:= XValue;
//      ch.Series[1].YValue[0]:= tmpY;
//    end;
  end;

//  // бегающие маркеры -----------------------------------------------------
//  // текущее значение по оси X
//  xk:= strtofloat(ch.Series[0].GetHorizAxis.LabelValue(tmpX));
//  // выясняем значение графика в nk- отсчете
//  yk:= getlocate(ch.Series[0], xk);
//
//  Caption := 'x= ' +  FloatToStr(xk) + ' y= ' + FloatToStr(yk);
//  // позиция маркера-
//  if (xk < ch.BottomAxis.Maximum) and (xk >= ch.BottomAxis.Minimum-0.1) then
//  begin // fix- выход за координаты
//    ch.Series[1].XValue[0]:= xk;
//    ch.Series[1].YValue[0]:= yk
//  end
  // end бегающие маркеры -------------------------------------------------
end;

procedure TfmMain.chMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PointFixed := True;
  Interpolation;
  DrawCurves;
end;

procedure TfmMain.SendEvent_(const X, Y: Integer);
var
  str: String;
begin
//  str :=  IntToStr(X)+':'+IntToStr(Y);//!!
//  SendEvent(handle_, PAnsiChar(UTF8Encode(str)));
end;

procedure TfmMain.ServoAmplitudeToUpAdjustment;
begin
  if AllowCalcServoParams then
  begin
    if GoalAmplitudeLimbToUp > 0 then
    begin
      ServoNeedMax := 4*(SERVO_MIN-300);//начальное знач-е амплитуды
      //ServoVlcty := 120;//произвольное фиксированное "типичное" знач-е скорости серво, на кот. будет настраиваться амплитуда
      ServoParamsAdjCntr := 0;
      NeedAmplServoAdjust := True;
      NeedTimeLimbToUpDownServoAdjust := False;
      AllowSuccFeedbackSignal := False;
      AllowFailFeedbackSignal := False;
      AllowTicSignal := False;
      RequestType := rtServoParamsAdjustment;
    end
    else
      Application.MessageBox(PChar('Некорректное значение целевой амплитуды'), PChar(strModuleName), MB_ICONERROR);
  end
  else
    Application.MessageBox(PChar('Недостаточно проб для проведения настройки серворежимов'), PChar(strModuleName), MB_ICONERROR);
end;

procedure TfmMain.ServoTimeToUpDownAdjustment;
begin
  if AllowCalcServoParams then
  begin
    if GoalReactionVelocityTime  > 0 then
    begin
      //ServoNeedMax := 4*(SERVO_MIN-508);//фиксированное произвольное знач-е ампл-ды, на кот. будет настраиваться скорость
      ServoVlcty := 120;//начальное знач-е скорости
      ServoParamsAdjCntr := 0;
      NeedTimeLimbToUpDownServoAdjust := True;
      NeedAmplServoAdjust := False;
      AllowSuccFeedbackSignal := False;
      AllowFailFeedbackSignal := False;
      AllowTicSignal := False;
      RequestType := rtServoParamsAdjustment;
    end
    else
      Application.MessageBox(PChar('Некорректное значение целевой скорости'), PChar(strModuleName), MB_ICONERROR);
  end
  else
    Application.MessageBox(PChar('Недостаточно проб для проведения настройки серворежимов'), PChar(strModuleName), MB_ICONERROR);
end;

procedure TfmMain.BoardPnlMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//
end;

procedure TfmMain.BoardPnlPaint(Sender: TObject);
const
  mat_solid : Array [0..3] of GLfloat = (0.75, 0.75, 0.0, 1.0);
  mat_zero : Array [0..3] of GLfloat = (0.0, 0.0, 0.0, 1.0);
  mat_transparent : Array [0..3] of GLfloat = (0.0, 0.8, 0.8, 0.6);
  mat_emission : Array [0..3] of GLfloat = (0.0, 0.3, 0.3, 0.6);
var
  i, j: Integer;
  ps : TPaintStruct;
  x: Extended;
//  x_: Extended;
  texObjID: Integer;
  boardCoordStep: Extended;
  chipSize: Extended;
begin
//  if not BoardPnl.Visible then
//    Exit;

  BeginPaint(Handle, ps);

//  glClearColor (0, 0, 0, 1.0);//для проверки таймингов фотоэлементов (повышение контраста)
  glClearColor (0.35, 0.35, 0.35, 1.0);//default
//  glClearColor (132/255, 94/255, 47/255, 1.0);//цвет фона
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);// очистка буфера цвета и буфера глубины

  //координаты текстуры и прямоугольника игровой доски
//  glPushMatrix;
//  glEnable(GL_TEXTURE_2D);
//  glBindTexture( GL_TEXTURE_2D, TexObj[0] );
//  glTranslatef(0.0, 0.0, -2.0);
//  glScalef (5.5, 3.0, 0.0);
//  glBegin(GL_QUADS);
//   glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, -1.0, 0.0);
//   glTexCoord2f(0.0, 1.0); glVertex3f(-1.0, 1.0, 0.0);
//   glTexCoord2f(1.0, 1.0); glVertex3f(1.0, 1.0, 0.0);
//   glTexCoord2f(1.0, 0.0); glVertex3f(1.0, -1.0, 0.0);
//  glEnd;
//  glDisable(GL_TEXTURE_2D);
//  glPopMatrix;

  glPushMatrix;

  glDisable (GL_BLEND);

  //рисуем коромысло в центре, которое будет вращаться под воздействием исп-го
//  glColor3f (1, 1, 1);//для проверки таймингов фотоэлементов (повышение контраста)
//  glColor3f (0.6, 0.6, 0.6);//default
//  glPushMatrix;
//  glTranslatef(X_, Y_, -2.0);
//  glRotatef(Angle, 0.0, 0.0, 1.0);
//  glScalef (1.5, 20.0, -1);
//  glutSolidCube (0.1);
//  glPopMatrix;

  //засекаем и выводим время цикла предупреждения о предстоящем действии
//  if (Angle > 180) and (NeedPC3) then
//  begin
//    QueryPerformanceCounter(Pc3);
//    NeedPC3 := False;
//    NeedPC4 := True;
//  end;
//  if (Angle = 180) and (NeedPC4) then
//  begin
//    QueryPerformanceCounter(Pc4);
//    NeedPC4 := False;
//    AlertTime := Trunc(((Pc4 - Pc3)/Pf * 1000) + 0.5);
//    Caption := IntToStr(AlertTime);
//  end;

  //рисуем вспомогательные объекты
  //объект в центре для точки фиксации
//  glColor3f (0.5, 0.5, 0.5);
//  glPushMatrix;
//  glTranslatef(X_, 0, -2.0);
//  glutSolidSphere(0.1, 50, 50);
//  glPopMatrix;

  //вертикальная линия, разделяющая экран на две равные части
  glColor3f (0.5, 0.5, 0.5);
  glPushMatrix;
  glTranslatef(X_, Y_, -2.0);
  glRotatef(Angle, 0.0, 0.0, 1.0);
  glScalef (0.05, 34.0, -1);
  glutSolidCube (0.1);
  glPopMatrix;

  //
  if AllowRTestObject then
  begin
    RTestObj_X := RTestObj_X - {0.016666666666666}0.04166666666666666666666666666668;
    glColor3f (1.0, 1.0, 1.0);
    glPushMatrix;
    glTranslatef(RTestObj_X, 0, -1.5);
    glutSolidSphere(0.05, 50, 50);
    glPopMatrix;
    AllowRTestObject := RTestObj_X > -3;
  end;

  SwapBuffers(DC);

  EndPaint(Handle, ps);
end;


//procedure TfmMain.BoardPnlPaint(Sender: TObject);
//const
//  mat_solid : Array [0..3] of GLfloat = (0.75, 0.75, 0.0, 1.0);
//  mat_zero : Array [0..3] of GLfloat = (0.0, 0.0, 0.0, 1.0);
//  mat_transparent : Array [0..3] of GLfloat = (0.0, 0.8, 0.8, 0.6);
//  mat_emission : Array [0..3] of GLfloat = (0.0, 0.3, 0.3, 0.6);
//var
//  i, j: Integer;
//  ps : TPaintStruct;
//  x: Extended;
////  x_: Extended;
//  texObjID: Integer;
//  boardCoordStep: Extended;
//  chipSize: Extended;
//begin
////  if not BoardPnl.Visible then
////    Exit;
//
//  BeginPaint(Handle, ps);
//
////  glClearColor (0, 0, 0, 1.0);//для проверки таймингов фотоэлементов (повышение контраста)
//  glClearColor (0.35, 0.35, 0.35, 1.0);//default
////  glClearColor (132/255, 94/255, 47/255, 1.0);//цвет фона
//  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);// очистка буфера цвета и буфера глубины
//
////  //координаты текстуры и прямоугольника игровой доски
////  glPushMatrix;
////  glEnable(GL_TEXTURE_2D);
////  glBindTexture( GL_TEXTURE_2D, TexObj[0] );
////  glTranslatef(0.0, 0.0, -2.0);
////  //glScalef (5.5, 3.0, 0.0);
////  glBegin(GL_QUADS);
////   glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, -1.0, 0.0);
////   glTexCoord2f(0.0, 1.0); glVertex3f(-1.0, 1.0, 0.0);
////   glTexCoord2f(1.0, 1.0); glVertex3f(1.0, 1.0, 0.0);
////   glTexCoord2f(1.0, 0.0); glVertex3f(1.0, -1.0, 0.0);
////  glEnd;
////  glDisable(GL_TEXTURE_2D);
////  glPopMatrix;
////
////  glPushMatrix;
////
////  glDisable (GL_BLEND);
////
////  //рисуем прямоугольник в центре, которое будет использоваться в качестве стрелки либеттовских часов
////  glColor3f (0, 0, 0);//для проверки таймингов фотоэлементов (повышение контраста)
//// // glColor3f (0.6, 0.6, 0.6);//default
////  glPushMatrix;
////  //glTranslatef(0, 0, -2.0);
////  glRotatef(Angle, 0, 0, -2.0);
////  glTranslatef(0.0, 0.15, -2.0);
////  glScalef (0.6, 8.0, 20);
////  glutSolidCone (0.07, 0.01, 5, 5);
////  //glutSolidCube (0.1);
////  glPopMatrix;
////
////  //засекаем и выводим время цикла предупреждения о предстоящем действии
//////  if (Angle > 180) and (NeedPC3) then
//////  begin
//////    QueryPerformanceCounter(Pc3);
//////    NeedPC3 := False;
//////    NeedPC4 := True;
//////  end;
//////  if (Angle = 180) and (NeedPC4) then
//////  begin
//////    QueryPerformanceCounter(Pc4);
//////    NeedPC4 := False;
//////    AlertTime := Trunc(((Pc4 - Pc3)/Pf * 1000) + 0.5);
//////    Caption := IntToStr(AlertTime);
//////  end;
////
////  //рисуем вспомогательные объекты
////  //объект в центре для точки фиксации
////  glColor3f (0.5, 0.5, 0.5);
////  glPushMatrix;
////  glTranslatef(0, 0, -2.0);
////  glutSolidSphere(0.08, 50, 50);
////  glPopMatrix;
//
//  //вертикальная линия, разделяющая экран на две равные части
//  glColor3f (0.0, 0.0, 0.0);
//  glPushMatrix;
//  //glTranslatef(X_, Y_, -2.0);
//  glRotatef(Angle, 0.0, 0.0, -2.0);
//  glTranslatef(0.0, 0.4, -2.0);
//  glScalef (0.2, 11.5, -1);
//  glutSolidCube (0.1);
//  glPopMatrix;
//
//  //
//  if AllowRTestObject then
//  begin
//    RTestObj_X := RTestObj_X - 0.01{0.1666666666666666666666666666667};
//    glColor3f (1.0, 1.0, 1.0);
//    glPushMatrix;
//    glTranslatef(RTestObj_X, 0, -2.0);
//    glutSolidSphere(0.05, 50, 50);
//    glPopMatrix;
//    AllowRTestObject := RTestObj_X > -2;
//  end;
//
//  SwapBuffers(DC);
//
//  EndPaint(Handle, ps);
//end;

procedure TfmMain.btnClearArraysClick(Sender: TObject);
begin
  ClearCommonCritArray;
  ClearCommonDeSynchValuesArray;
  ClearCommonRltvVelocityValuesArray;

  BarSrsCommonCriteria.Clear;
  BarSrsCommonRltvVelocity.Clear;
  BarSrsCommonDeSynch.Clear;
  srsCurCommonCriteria.Clear;

  edtTrialsCount.Text := '0';
  edt5PercentileCommonRltvVelocity.Text := '0';
  edt50PercentileCommonRltvVelocity.Text := '0';
  edt95PercentileCommonRltvVelocity.Text := '0';

  edt5PercentileCommonDeSync.Text := '0';
  edt50PercentileCommonDeSync.Text := '0';
  edt95PercentileCommonDeSync.Text := '0';

  edt5PercentileCommonCriteria.Text := '0';
  edt50PercentileCommonCriteria.Text := '0';
  edt95PercentileCommonCriteria.Text := '0';
end;

procedure TfmMain.DefaultCurves;
var
  i, k: integer;
begin
  //желаемые значения по Х после интерполяции
  SetLength(DesiredXValues, SERVO_RANGE);
  k := SERVO_MIN;
  i := 0;
  while i < SERVO_RANGE do
  begin
    DesiredXValues[i] := k;
    dec(k);
    inc(i);
  end;

  //значения по Х до интерполяции
  SetLength(BaseXPoints, BASE_POINTS_CNT);
  i := 0;
  while i < Length(BaseXPoints) do
  begin
    BaseXPoints[i] := Trunc(SERVO_MIN - ((SERVO_RANGE-1) / (BASE_POINTS_CNT-1) * i)+0.5);
    inc(i);
  end;
  //значения по Y до интерполяции
  SetLength(BaseYPoints, BASE_POINTS_CNT);
  i := 0;
  while i < Length(BaseYPoints) do
  begin
    BaseYPoints[i] := Trunc(SERVO_MIN - ( (SERVO_RANGE-1) / (BASE_POINTS_CNT-1) * i)+0.5);
    inc(i);
  end;

  Interpolation;
end;

procedure TfmMain.DoAlertSubjAction();
begin
  NeedAlertSubjectAction := False;
  AlertMoveToUp := True;
  NeedAlertMoveUpDown := True;
  //Randomize;
  //NeedAlertSubjActionToRight := Random > 0.5;
  //if not NeedAlertSubjActionToRight then
  //   DoForcedSubjAction;
  //    sleep(10);
end;

//procedure TfmMain.DoAlertSubjAction();
//var
//  data: Byte;
//  strMsg: string;
//begin
//  if AllowAlertSubjectAction then
//  begin
//    data := MrkAlertSubjActionCode;
//    SendMarker(data);
//    AlertMoveToUp := True;
//    //Randomize;
//    //NeedAlertSubjActionToRight := Random > 0.5;
//    //if not NeedAlertSubjActionToRight then
// //   DoForcedSubjAction;
////    sleep(10);
//    tmrDoForceAction.Enabled := True;
//    tmrAlertSubjectAction.Enabled := True;
//    strMsg := 'AlertSubjAction ' + 'AlertSubjActionCode= ' + IntToStr(data);
//    AddMsgDataToLogFile_(NameForLogFile, strMsg);
//  end;
//end;

procedure TfmMain.DoForcedSubjAction;
begin
  NeedServoUp := True;
  NeedServoDown := False;
  NeedServoMoveUpDown := True;
  NeedForcedSubjectAction := False;
end;

procedure TfmMain.DrawCurves;
var
  i: integer;
begin
  //отрисуем интерполированные значения
  LineSeries2.LinePen.Width:= 2;
  LineSeries2.Clear;
  i:=High(IntrpResltValues);
  while i >= 0 do
  begin
    LineSeries2.AddXY(DesiredXValues[i], IntrpResltValues[i]);
    dec(i);
  end;
  //отрисуем исходные значения
  LineSeries1.LinePen.Width:= 3;
  LineSeries1.Clear;
  i := High(BaseYPoints);
  while i >= 0 do
  begin
    LineSeries1.AddXY(BaseXPoints[i], BaseYPoints[i]);
    dec(i);
  end;
end;

procedure TfmMain.DrawOpenGL(var Message: TMessage);
begin
//  if NeedSuspend then
//    Exit;
  Fillness := CommonCriteria * 100;
  InvalidateRect(BoardPnl.Handle, nil, False);
end;

procedure TfmMain.btnDoAlertSubjActionClick(Sender: TObject);
begin
//  PostMessage(Self.Handle, UM_NEED_ALERT_ACTION, Integer(0), 0);
//  NeedPC3 := True;
//  NeedPC4 := False;
  //AllowAlertSubjectAction := True;//NeedAlertSubjectAction;//True;
  QueryPerformanceCounter(Pc);
  LastPcAlertAction := Pc;
  SetAlertDurationPeriod(AlertDurationTime);
  DoAlertSubjAction;
//  DoAlertSubjAction();
//    AddMsgDataToLogFile_(NameForLogFile, 'Alert');
end;

function TfmMain.SubTestExist(const ATestNumber: Integer; const ATstNumPos: Integer; var TestIndex: Integer): Boolean;
var
  i: Integer;
  st: TSubTest;
  numPos: Integer;
begin
  Result := False;
  TestIndex := -1;
  numPos := 0;
  i := 0;
  while i < SubTestCount do
  begin
    st := SubTest[i];
    if st.TestNumber = ATestNumber then
    begin
      inc(numPos);
      if numPos = ATstNumPos then
      begin
        TestIndex := i;
        Result := True;
        Break;
      end;
    end;
    inc(i);
  end;
end;

procedure TfmMain.btnGetTstDataClick(Sender: TObject);
var
  i: Integer;
  indx: Integer;
  st: TSubTest;
begin
  if SubTestExist(StrToIntDef(edtTstNum.Text,1), StrToIntDef(edtTstNumPos.Text, 1), indx) then
  begin
    st := SubTest[indx];
    Memo2.Clear;
    i := 0;
    while i < st.IntervalsCount do
    begin
      Memo2.Lines.Add(IntToStr(Integer(st.Intervals[i].AnswerType)));
      inc(i);
    end;
    mmDelayServoFromBgnIntrvl.Clear;
    i := 0;
    while i < st.IntervalsCount do
    begin
      mmDelayServoFromBgnIntrvl.Lines.Add(IntToStr(Integer(st.Intervals[i].EvtActionTimeRltvBeginIntrvl)));
      inc(i);
    end;
  end;
end;

procedure TfmMain.btnPortResetClick(Sender: TObject);
begin
  LPTPortReset;
//  IntVar := 0;
//  edtActEvtCount.Text := IntToStr(IntVar);
end;

procedure TfmMain.btnReceiveDataClick(Sender: TObject);
begin
  edtLPT_IO_Result.Text := ReceiveTrigger;
end;

procedure TfmMain.btnReceiveInitClick(Sender: TObject);
var
  data: byte;
  portAdr: Word;
begin
  data := 43;
  portAdr := LPTAdress + 2;
  Out32(portAdr, data);
  portAdr := LPTAdress2 + 2;
  Out32(portAdr, data);
  //!! на PCI и PCMCI плате если дважды не сделать, то не работает порт на вход!
  portAdr := LPTAdress + 2;
  Out32(portAdr, data);
  portAdr := LPTAdress2 + 2;
  Out32(portAdr, data);
end;

procedure TfmMain.btnResetCurvesClick(Sender: TObject);
begin
  DefaultCurves;
  DrawCurves;
end;

procedure TfmMain.btnRestoreDefaultClick(Sender: TObject);
begin
  DelayMin := 50;//допустимый для испыт-го мин-макс для параметра синхронности
  DelayMax := 200;//
  //мин-макс для парам.скорости перемещения джоев в мс, кот. ещё допустим для исп-го
  //исходя из этого д-на идёт пересчёт в шкалу 0..1
  PartialDerivativeMin := 250;
  PartialDerivativeMax := 500;
end;

procedure TfmMain.btnResumeDecTShiftClick(Sender: TObject);
begin
  AllowDecTShift := True;
end;

procedure TfmMain.BeginExperiment;
var
  i: Integer;
  fmDialog: TfmHasWon;
  needFlg: Boolean;
  rndInt: Integer;
  Cnt: Integer;
begin
  NeedSuspend := True;
  fmDialog := TfmHasWon.Create(fmMain);
  try
    TmrSessionDuration.Enabled := False;
    fmDialog.redtInstruction.Visible := True;
    fmDialog.chrtCommonCriteria.Visible := False;
    fmDialog.lblMsg.Caption := 'Инструкция';

    fmDialog.rgrpsAnswer.Visible := False;
    fmDialog.tmrAutoCloseWnd.Enabled := False;

    IntrvlPeriod := IntervalDefTimeLen;
    FSessionDurationInMs := FDefSessionDurationInMs;
    Loses := 0;
    AlertDurationTime := DefAlertDurationTime;

    case ExpVariants of
      evOneVariant:
      begin
        //без FA с физ. действиями исп-го
        fmDialog.redtInstruction.Text := strOneVariantInstruction;
        AllowAlertSubjectAction := True;
        AllowForcedSubjectAction := False;
        AllowSuccFeedbackSignal := BaseAllowSuccFeedbackSignal;
        AllowFailFeedbackSignal := BaseAllowFailFeedbackSignal;
      end;
      evTwoVariant:
      begin
        //FA по ср.вр. р-ции с физ. действиями исп-го
        //нужно знач-е ср.ВР!
        fmDialog.redtInstruction.Text := strTwoVariantInstruction;
        AllowAlertSubjectAction := True;
        AllowForcedSubjectAction := True;
        AllowSuccFeedbackSignal := BaseAllowSuccFeedbackSignal;
        AllowFailFeedbackSignal := BaseAllowFailFeedbackSignal;
        ForceActionTimeShift := AvrgReactionTime;//по умолч. Можно задать вручную в контроле на форме. Пересчитывается в конце каждого интервала
        //надо бы тут выставлять скорость сервы по средней скорости, измереннной на 1 этапе
      end;
      evThirdVariant:
      begin
        //случайный FA
        fmDialog.redtInstruction.Text := strThirdVariantInstruction;
        AllowAlertSubjectAction := True;
        AllowForcedSubjectAction := True;
        AllowSuccFeedbackSignal := BaseAllowSuccFeedbackSignal;
        AllowFailFeedbackSignal := BaseAllowFailFeedbackSignal;
        //ForceActionTimeShift := //выставляется перед генерацией нового времени события см.
      end;
      evFourthVariant:
      begin
        //FA по ср.вр.р-ции
        fmDialog.redtInstruction.Text := strFourthVariantInstruction;
        AllowAlertSubjectAction := True;
        AllowForcedSubjectAction := True;
        AllowSuccFeedbackSignal := BaseAllowSuccFeedbackSignal;
        AllowFailFeedbackSignal := BaseAllowFailFeedbackSignal;
        ForceActionTimeShift := AvrgReactionTime;//по умолч. Можно задать вручную в контроле на форме. Пересчитывается в конце каждого интервала
      end;
      evFifthVariant:
      begin
        fmDialog.redtInstruction.Text := strFifthVariantInstruction;
        AllowAlertSubjectAction := True;
        AllowForcedSubjectAction := True;
        AllowSuccFeedbackSignal := BaseAllowSuccFeedbackSignal;
        AllowFailFeedbackSignal := BaseAllowFailFeedbackSignal;
        ForceActionTimeShift := 0;
      end;
      evSixthVariant:
      begin
        fmDialog.redtInstruction.Text := strSixthVariantInstruction;
        AllowAlertSubjectAction := True;
        AllowForcedSubjectAction := True;
        AllowSuccFeedbackSignal := BaseAllowSuccFeedbackSignal;
        AllowFailFeedbackSignal := BaseAllowFailFeedbackSignal;
        ForceActionTimeShift := AvrgReactionTime;//вынести в настройки
        //AlertDurationTime := AvrgReactionTime + 50;//вынести в настройки
      end;
      evSeventhVariant:
      begin
        NeedResultPresent := True;
        AllowSuccFeedbackSignal := True;
        AllowFailFeedbackSignal := True;
        fmDialog.redtInstruction.Text := strSeventhVariantInstruction;
        RTestObj_X := 2;
        FSessionDurationInMs := 60000;//
        IntrvlPeriod := 5000;
        //AllowRTestObject := True;
      end;
      evEighthVariant:
      begin
        NeedResultPresent := False;
        AllowSuccFeedbackSignal := False;
        AllowFailFeedbackSignal := False;
        fmDialog.redtInstruction.Text := strSeventhVariantInstruction;
        RTestObj_X := 2;
        FSessionDurationInMs := 60000;//
        IntrvlPeriod := 5000;
        //AllowRTestObject := True;
      end;
      evNinthVariant:
      begin
        fmDialog.redtInstruction.Text := strNinthVariantInstruction;
        AllowAlertSubjectAction := True;
        AllowForcedSubjectAction := False;
        AllowSuccFeedbackSignal := BaseAllowSuccFeedbackSignal;
        AllowFailFeedbackSignal := BaseAllowFailFeedbackSignal;
        ForceActionTimeShift := AvrgReactionTime;//
      end;
      evTenthVariant:
      begin
        fmDialog.redtInstruction.Text := strTenthVariantInstruction;
        AllowAlertSubjectAction := True;
        AllowForcedSubjectAction := True;
        AllowSuccFeedbackSignal := BaseAllowSuccFeedbackSignal;
        AllowFailFeedbackSignal := BaseAllowFailFeedbackSignal;
        ForceActionTimeShift := AvrgReactionTime;//по умолч. Можно задать вручную в контроле на форме. Пересчитывается в конце каждого интервала
      end;
      evEleventhVariant:
      begin
        fmDialog.redtInstruction.Text := strEleventhVariantInstruction;
        AllowAlertSubjectAction := True;
        AllowForcedSubjectAction := True;
        AllowSuccFeedbackSignal := BaseAllowSuccFeedbackSignal;
        AllowFailFeedbackSignal := BaseAllowFailFeedbackSignal;
        ForceActionTimeShift := AvrgReactionTime;//по умолч. Можно задать вручную в контроле на форме. Пересчитывается в конце каждого интервала
      end;
      ev12Variant:
      begin

      end;
    end;

    ShowCursor_;
    fmDialog.ShowModal;
    if fmDialog.ModalResult <> 0 then
    begin
      if FCurSessionDurationInMs + IntervalDefTimeLen < FSessionDurationInMs then
      begin
        if ExpVariants in [evSeventhVariant] then //в тесте точности реакции время сигнала ОС фиксировано
          SetFeedbackSignalDefermentPeriod(200) else
        begin
          //оцениваем примерно сколько предъявлений может прийтись на сессию
          Cnt := FSessionDurationInMs div 4000;
          GenerateLineDelays(Cnt);//создаём вектор из 3-х вар-тов задержек, равномерно перемешанных
          CurFBSignalDelay := GetNextFBSignalDelay;//берём очередное значение из этого ряда
          if CurFBSignalDelay <> -1 then
            SetFeedbackSignalDefermentPeriod(CurFBSignalDelay)
          else
            Exit;
        end;
        if ExpVariants in [evNinthVariant] then
        begin
          Cnt := FSessionDurationInMs div 4000;
          GenerateEpochTypeArr(Cnt);
          if GetNextEpochType then
          begin
            AlertDurationTime := 100;
            ForceActionTimeShift := 50;
          end
          else
          begin
            AlertDurationTime := DefAlertDurationTime;
            ForceActionTimeShift := AvrgReactionTime;
          end;
        end;

        if not (ExpVariants in [evSeventhVariant, evEighthVariant]) then
          newAlertInterval := GetNewRndAlertIntervalValue
        else
          newAlertInterval := 20000{GetNewRndAlertIntervalValueForFastPresent};
        //если надо, то задаём равномерно случайное срабатывание FA в пределах времени интервала
        if ExpVariants in [evThirdVariant] then
        begin
          repeat
            ForceActionTimeShift := Random(IntervalDefTimeLen);
          until (ForceActionTimeShift > 500) and (ForceActionTimeShift < IntervalDefTimeLen - 1000);
          SetForceActionPeriod(ForceActionTimeShift);
        end
        else
        if ExpVariants in [evEleventhVariant] then
        begin
          rndInt := Random(InitialAvrgReactionTime + 100 + 50);
          ForceActionTimeShift := rndInt - 100;
          SetForceActionPeriod(newAlertInterval - ActionDelayTimeCorrection + ForceActionTimeShift);
        end
        else
        if ExpVariants in [ev12Variant] then
        begin
//          rndInt := Random(100);
//          ForceActionTimeShift := tInit + rndInt;
//          tInit := tInit - tStep;
//          SetForceActionPeriod(newAlertInterval - ActionDelayTimeCorrection + ForceActionTimeShift);
        end
        else
        begin
          SetForceActionPeriod(newAlertInterval - ActionDelayTimeCorrection + ForceActionTimeShift);
        end;
        if ExpVariants in [evSeventhVariant, evEighthVariant] then
        begin
          SetRTestObjectPeriod(2000);
        end;
        // needFlg := NeedForcedSubjAction and (newAlertInterval > 0);
        {ActionDelayTimeCorrection - коррекция, которая даёт одинаковость из-за того, что возможно запаздывает вывод на экран}
        //со светодиодным алертом наоборот, кажется, запаздывает серва
        SetAlertActionPeriod(newAlertInterval);
        //SetAlertActionPeriod(newAlertInterval - ActionDelayTimeCorrection);//для программного алерта
        //AlertDurationTime :=
        SetAlertDurationPeriod(AlertDurationTime);

        TmrSessionDuration.Enabled := True;
        HideCursor_;
        RequestType := rtBeginIntrvl;//состояние - начать новый интервал
        BeginIntrvlFlg := True;
      end
      else
      begin
        RequestType := rtEndExperiment;
      end;
    end;
  finally
    fmDialog.Free;
  end;
  NeedSuspend := False;
end;

procedure TfmMain.BitBtnOpenLogFileClick(Sender: TObject);
begin
  if od.Execute(Handle) then
  begin
    if od.FilterIndex = 1 then
    begin
      if LoadAsciiLogFile(od.FileName) then
      begin
         EdtLoadLogFileName.Text := od.FileName;
         MessageDlg('Log Файл загружен', mtInformation, [mbOK], 0);
      end;
    end;
  end;
end;

procedure TfmMain.btnStartClick(Sender: TObject);
begin
  if not FEmulMode then
  begin
    if not CallbackRegistered then
    begin
      RegisterCallback(handle_, @callme);
      CallbackRegistered := True;
    end;
  end
  else
    JvSubTimer.Enabled := True;
end;

procedure TfmMain.btnStartEmulClick(Sender: TObject);
begin
  if EmulationModeOn then
  begin
    EmulLimbOne_wxpos := LimbOneData.MinPos;
    EmulLimbTwo_wypos := LimbTwoData.MinPos;
    EmulNeedLPMoveToUp := True;
    EmulNeedRPMoveToUp := True;

    EmulVelLPUp_Delay := 0;
    EmulNeedLPDelayMoveToUp := True;

 //   JvTimer1.Enabled := True;
    tmrTrckBarJoyPosEmul.Enabled := True;
  end;
end;

procedure TfmMain.btnSuspendDecTShiftClick(Sender: TObject);
begin
  AllowDecTShift := False;
end;

procedure TfmMain.btnUseItClick(Sender: TObject);
begin
  DelayMin := Trunc(CommonDeSynchPrcntl_Med - 3*CommonDeSynchPrcntl_Lo + 0.5);//допустимый для испыт-го мин-макс для параметра синхронности
  DelayMax := Trunc(CommonDeSynchPrcntl_Med + 3*CommonDeSynchPrcntl_Hi + 0.5);//
  //мин-макс для парам.скорости перемещения джоев в мс, кот. ещё допустим для исп-го
  //исходя из этого д-на идёт пересчёт в шкалу 0..1
  PartialDerivativeMin := Trunc(CommonRltvVelocityPrcntl_Med - 3*CommonRltvVelocityPrcntl_Lo + 0.5);
  PartialDerivativeMax := Trunc(CommonRltvVelocityPrcntl_Med + 3*CommonRltvVelocityPrcntl_Hi + 0.5);
end;

function FindValMinIndx(AData: TDoubleDynArray; AValue: Double): Integer;
var
  i: Integer;
begin
  Result := -1;
  i := 0;
  while i < Length(AData) do
  begin
    if SameValue(AData[i], AValue) then
    begin
      Result := i;
      Break;
    end;
    inc(i);
  end;
end;

procedure GetPowerDistr(ARes: TDoubleDynArray; N: Integer);
const
  RAND_MAX = 32768;
var
  i: Integer;
//  N: Integer;        //number of generated randoms
  r: Double;              //uniform distributed random in [0:1]
  alpha: Double;         //power of spectra
  x0: Double;             //x min of generated randoms
  x1: Double;            //x max of generated randoms
  p0: Double;
  p1: Double;       //temporary var for powers
  E: Double;              //generated random
begin
//  N := 300000;        //number of generated randoms
  r := 0;              //uniform distributed random in [0:1]
  alpha := 2;         //power of spectra
  x0 := 1;             //x min of generated randoms
  x1 := 10;            //x max of generated randoms
  p0 := 0;
  p1 := 0;       //temporary var for powers
  E := 0;              //generated random
  //
  p0 := power(x0, alpha + 1);
  p1 := power(x1, alpha + 1);
  //
  randomize();
  i := 0;
  while i < N do
  begin
    r := random{RAND_MAX};
    if r = 0 then//awoid to take log(0)
      Continue;
    E := power(r * (p1 - p0) + p0, 1{1.0/(alpha + 1.0)});
    ARes[i] := round(E);
    inc(i);
  end;
end;

procedure TfmMain.Button1Click(Sender: TObject);
var
  i, j, k: Integer;
  Rate: TIntegerDynArray;
  Intervals: TDoubleDynArray;
  arrData: TDoubleDynArray;
  arrData2: TDoubleDynArray;
  arrData3: TDoubleDynArray;
  valInt: Integer;

  kk, m: Double;
  s: Double;
  yArr: array of Double;
  cntr: Integer;
  Checked: Boolean;
begin
//  if CommonCriteria > 0 then
  begin
//matlab code:
// var1
//    N=10000;
//    m=5;
//    s2=10;
//    s=sqrt(s2);
//    k=0;
//    x=[];
//    y=[];
//    for i=1:N
//      x(i) = k;
//      y(i) = 1/(s*sqrt(2*pi)) * exp( -( (k-m)^2/(2*s^2) ) );
//      k=k+0.001;
//    end;
// var2
//    N=10000;
//    m=5000;
//    s2=5000000;
//    s=sqrt(s2);
//      k=0;
//      %x=[];
//      y=[];
//      for i=1:N
//        %x(i) = k;
//        y(i) = 1/(s*sqrt(2*pi)) * exp( -( (i-m)^2/(2*s^2) ) );
//        %k=k+1;
//      end;
//      plot(y)

    //попытка сделать по нормальному распределению. Не доделал...
//    SetLength(yArr, 10000);
//    m := 5000;
//    s := sqrt(5000000);
//    i := 0;
//    while i < 10000 do
//    begin
//      yArr[i] := 1/(s*sqrt(2*pi)) * exp( -( power(i-m, 2)/(2*power(s,2)) ) ) * power(10, 3.74859);
//      inc(i);
//    end;
//
//    //SetLength(arrData2, 10000);
//    k := 0;
//    i := 0;
//    while i < 10000 do
//    begin
//      j := 0;
//      while j < 100 do
//      begin
//        if Random <= yArr[i] then
//        begin
//          SetLength(arrData2, Length(arrData2)+1);
//          arrData2[k] := i;
//          inc(k);
//        end;
//        inc(j);
//      end;
//      inc(i);
//    end;

//    SetLength(arrData2, 10000);
//    k := 0;
//    i := 0;
//    while i < 10000 do
//    begin
//      cntr := 0;
//      j := 0;
//      while j < 1000 do
//      begin
//        if Random <= yArr[i]then
//          inc(cntr);
//        inc(j);
//      end;
//      arrData2[i] := cntr;
//      inc(i);
//    end;

    k := 0;
    i := 0;
    while i < 10000 do
    begin
      Checked := False;
      j := 2001;
      while j < IntervalDefTimeLen - 1000 do
      begin
        if Random < 0.005{0.0003}{0.0015} then
        begin
          SetLength(arrData2, Length(arrData2)+1);
          arrData2[k] := j;
          inc(k);
          Checked := True;
          Break;
        end;
        inc(j, Random(90));
      end;
      //если ни разу не сработало условие - интервал = 0
      if (not Checked) and (Random < 0.03) then
      begin
        SetLength(arrData2, Length(arrData2)+1);
        arrData2[k] := 0;
        inc(k);
      end;
      inc(i);
    end;
//
    SetLength(arrData3, 1000);
    i := 0;
    while i < 1000 do
    begin
      k := Random(Length(arrData2));
      arrData3[i] := arrData2[k];
      inc(i);
    end;

//    i := 0;
//    while i < 1000 do
//    begin
//      j := 0;
//      k := 0;
//      SetLength(arrData, 3000);
////      FillChar(arrData, Length(arrData), 0);
//      Randomize;
//      while j < 3000 do
//      begin
// //       arrData[Random(Length(arrData))] := 1;
//        if random > 0.5 then
//          arrData[j] := 1;
//        inc(j);
//      end;
//      valInt := FindValMinIndx(arrData, 1);
//      if valInt <> -1 then
//      begin
//       SetLength(arrData2, Length(arrData2)+1);
//       arrData2[High(arrData2)] := valInt;
//       inc(k);
//      end;
//      Finalize(arrData);
//      inc(i);
//    end;
    //
//    SetLength(arrData3, 3000);
//    GetPowerDistr(arrData3, 3000);
    HistogramCalculate(arrData3, Rate, Intervals, 50);
//    HistogramCalculate(arrData2, Rate, Intervals, 20);
    try
      Series1.Clear;
      i := 0;
      while i < Length(Intervals) do
      begin
        Series1.AddXY(Intervals[i], Rate[i], '', clGreen);
        inc(i);
      end;
//      Series2.Clear;
//      i := 0;
//      while i < Length(yArr) do
//      begin
//        Series2.AddXY(i, yArr[i], '', clRed);
//        inc(i);
//      end;
    finally
      Finalize(Rate);
      Finalize(Intervals);
      Finalize(arrData2);
      Finalize(arrData3);
    end;
  end;
end;

procedure TfmMain.Button4Click(Sender: TObject);
begin
  ScanComPorts;
end;

function SendMarker_(const Acode: Byte): Byte;
begin
  Result := SendTrigger(Acode);
  JvTimerLPTZero.Enabled := True;
end;

procedure TfmMain.btnSendDataClick(Sender: TObject);
var
  data: Byte;
  res: Byte;
begin
  data := StrToIntDef(edtrMrkEvtActionCode.Text, 0);
  res := SendMarker_(data);
//  res := SendTrigger(data);
  Caption := IntToStr(res);
end;

procedure TfmMain.btnSendDataToControlRegClick(Sender: TObject);
var
  data: Byte;
  res: Byte;
begin
  data := StrToIntDef(Edit5.Text, 0);
  Out32(LPTAdress + 2, Data);
//  Sleep(50);
//  LPTPortReset;
//  res := SendTrigger(data);
//  Caption := IntToStr(res);
end;

procedure TfmMain.btnServoUpDownClick(Sender: TObject);
begin
  NeedSubjAction := True; //??
  NeedOnesEvent := True;
  DoForcedSubjAction;
end;

procedure TfmMain.ShowGL(const AGLCtrlVis: Boolean);
begin
  if AGLCtrlVis then
  begin
 //   BoardPnl.Parent := fmMain;
 //   BoardPnl.Visible := True;

    wglMakeCurrent(0, 0);//
    wglDeleteContext(hrc);//
    ReleaseDC(Handle, DC);
    DeleteDC(DC);

    DC := GetDC(BoardPnl.Handle);
    SetDCPixelFormat(DC);
    hrc := wglCreateContext(DC);
    wglMakeCurrent(DC, hrc);

    glEnable(GL_DEPTH_TEST);// разрешаем тест глубины
    glEnable(GL_LIGHTING); // разрешаем работу с освещенностью
    glEnable(GL_LIGHT0);   // включаем источник света 0
    glEnable (GL_COLOR_MATERIAL);

   // TexInit;
    GLInit;

  //  PageControl1.Visible := False;

    Resize;
    InvalidateRect(BoardPnl.Handle, nil, False);
  end
  else
  begin
  //  BoardPnl.Parent := TabSheet3;
  //  BoardPnl.Visible := True;

    wglMakeCurrent(0, 0);//
    wglDeleteContext(hrc);//
    ReleaseDC(Handle, DC);
    DeleteDC(DC);

    DC := GetDC(BoardPnl.Handle);
    SetDCPixelFormat(DC);
    hrc := wglCreateContext(DC);
    wglMakeCurrent(DC, hrc);

    glEnable(GL_DEPTH_TEST);// разрешаем тест глубины
    glEnable(GL_LIGHTING); // разрешаем работу с освещенностью
    glEnable(GL_LIGHT0);   // включаем источник света 0
    glEnable (GL_COLOR_MATERIAL);

   // TexInit;
    GLInit;

  //  PageControl1.Visible := True;

    Resize;
    InvalidateRect(BoardPnl.Handle, nil, False);
  end;
end;

procedure TfmMain.btnShowGLClick(Sender: TObject);
begin
  ShowGL(True);
end;

procedure TfmMain.mnuQuitClick(Sender: TObject);
begin
  Close;
//  Application.Terminate;
end;

procedure TfmMain.mnuBackdropstartClick(Sender: TObject);
begin
  SetBackdropPeriod(120000);
  RequestType := rtBeginBackdrop;
end;

procedure TfmMain.mnuDebugPnlVisibleClick(Sender: TObject);
begin
 FDebugPnlVisible := not FDebugPnlVisible;
 DebugPnl.Visible := FDebugPnlVisible;
 ShowGL(GLCtrlVis);
 GLCtrlVis := not GLCtrlVis;
end;

procedure TfmMain.mnuNewGameClick(Sender: TObject);
//var
//  strMsg: string;
begin
  RequestType := rtStartExperiment;
////  if not CallbackRegistered then
////    RegisterCallback(handle_, @callme);
////  CallbackRegistered := True;
//
//  FCurGameSessionNumber := 1;
//  FCurSessionDurationInMs := 0;
//  Finalize(FGameResults);
//  BoardPnlEnabled := True;
//
//
//  ClearCommonCritArray;
//  ClearCommonDeSynchValuesArray;
//  ClearCommonRltvVelocityValuesArray;
//  CommonCriteria := 0;
//  Angle := 180;
//  JvtmrIntrvl.Interval := 10000;
//
//  if QrPC0 = 0 then
//    QueryPerformanceCounter(QrPC0);
//
//  strMsg := 'ExpVariant: ' + IntToStr(Integer(ExpVariants));
////  strMsg := 'CurGameSessionNumber= ' + IntToStr(FCurGameSessionNumber) +
////            ' CurSessionDurationInMs= ' + IntToStr(FCurSessionDurationInMs);
//  AddMsgDataToLogFile_(NameForLogFile, strMsg);
//
//  strMsg := 'SessionDurationInMs: ' + IntToStr(FSessionDurationInMs);
//  AddMsgDataToLogFile_(NameForLogFile, strMsg);
//
//  ShowGL(True);
//
//  BeginExperiment;
end;

procedure TfmMain.mnuSettingsClick(Sender: TObject);
var
  i: Integer;
begin
//  fmSettings := TfmSettings.Create(fmMain);
  with TfmSettings.Create(fmMain) do
  try
    CmbBxScrAdj.Clear;
    i:=0;
    while i < MaxVideoModes do
    begin
      if VideoModes[i].Description <> '' then
        CmbBxScrAdj.Items.Add (VideoModes[i].Description);
      inc(i);
    end;
    LockedCtrls := True;
    CmbBxScrAdj.ItemIndex := FVidModeSelectedIndex;
    ChBxFullScr.Checked := FFullScreenMode;
    SEdBoardSize.Value := 0;
    SEdAIPower.Value := 0;
    SEdGoalLineCnt.Value := 0;
    ChkBxDialogAutoHideTimer.Checked := AllowDialogAutoHideTimer;
    tpSessionDuration.DateTime := SetTimeByMilliseconds(FDefSessionDurationInMs);
    rgrpExpVariants.ItemIndex := Integer(ExpVariants)-1;
    LockedCtrls := False;
    ShowModal;
    case ModalResult of
      mrOk:
      begin
        if not FLockCtrls then
        begin
          if ScreenSettingsChanged then
          begin
            FFullScreenMode := ChBxFullScr.Checked;
            FVidModeSelectedIndex := CmbBxScrAdj.ItemIndex;

            TexDeinit;
            SetScreenMode;
            FullScreen := FFullScreenMode;
            TexInit;
            InvalidateRect(BoardPnl.Handle, nil, False);
          end;
          if GameSettingsChanged then
          begin
            FDefSessionDurationInMs := GetTimeInMilliseconds(tpSessionDuration.DateTime);
            FSessionDurationInMs := FDefSessionDurationInMs;
            ExpVariants := TExpVariants(rgrpExpVariants.ItemIndex+1);
            AllowDialogAutoHideTimer := ChkBxDialogAutoHideTimer.Checked;
            fmMain.Caption := 'Exp ' + IntToStr(Integer(ExpVariants));
          end;
        end;
      end;
    end;
  finally
    Release;
  end;
end;

procedure TfmMain.NeedSubjAnswerDialog(var Message: TMessage);
var
  i: Integer;
  newAlertInterval: Integer;
  strMsg: string;
  fmDialog: TfmHasWon;
  needFlg: Boolean;
  forceActionTimeShift_: Integer;
  alertDurationTime_: Integer;
  rndInt: Integer;
  r: Integer;
begin
  NeedSuspend := True;
  fmDialog := TfmHasWon.Create(Application);
  try
    TmrSessionDuration.Enabled := False;
    fmDialog.redtInstruction.Visible := False;
    fmDialog.chrtCommonCriteria.Visible := True;
    fmDialog.lblMsg.Caption := 'Сводные результаты';
    fmDialog.tmrAutoCloseWnd.Enabled := AllowDialogAutoHideTimer;

//    fmDialog.srsCurCommonCriteria.Clear;
//    i := 0;
//    while i < Length(CommonCritArray) do
//    begin
//      fmDialog.srsCurCommonCriteria.AddBar(CommonCritArray[i], '', clGreen);
//      inc(i);
//    end;
    fmDialog.srsCurCommonCriteria.Clear;
    i := 0;
    while i < Length(RTValues) do
    begin
      fmDialog.srsCurCommonCriteria.AddBar(RTValues[i], '', clGreen);
      inc(i);
    end;

    fmDialog.edtAlertDurationTime.Text := IntToStr(AlertDurationTime);

    fmDialog.rgrpsAnswer.Visible := True;
    IntrvlPeriod := IntervalDefTimeLen;

    case ExpVariants of
      evOneVariant:
      begin
        //уменьшаем время горения светодиода с каждой итерацией
        if Loses < 5 then //если кол-во опозданий меньше порога
        begin
          alertDurationTime_ := AlertDurationTime;
          dec(alertDurationTime_, 10);
          AlertDurationTime := max(50, alertDurationTime_);
        end;

        fmDialog.rgrpsAnswer.Visible := False;
        //AllowDialogAutoHideTimer := True;
        fmDialog.srsCurCommonCriteria.Clear;
        i := 0;
        while i < Length(RTValues) do
        begin
          fmDialog.srsCurCommonCriteria.AddBar(RTValues[i], '', clGreen);
          inc(i);
        end;
      end;
      evTwoVariant:
      begin
        fmDialog.rgrpsAnswer.Visible := True;
        //AllowDialogAutoHideTimer := False;
      end;
      evThirdVariant:
      begin
        fmDialog.rgrpsAnswer.Visible := True;
        //AllowDialogAutoHideTimer := False;
      end;
      evFourthVariant:
      begin
        fmDialog.rgrpsAnswer.Visible := True;
        //AllowDialogAutoHideTimer := False;
      end;
      evFifthVariant:
      begin
        fmDialog.rgrpsAnswer.Visible := True;
        //AllowDialogAutoHideTimer := False;
      end;
      evSixthVariant:
      begin
        fmDialog.rgrpsAnswer.Visible := True;
        //AllowDialogAutoHideTimer := False;

        if AllowDecTShift then
        begin
          if NeedEvtsDecrement then //чтобы декремировало через раз
          begin
            forceActionTimeShift_ := ForceActionTimeShift;
            dec(forceActionTimeShift_, 5);
            ForceActionTimeShift := max(-100, forceActionTimeShift_);

            //alertDurationTime_ := AlertDurationTime;
            //dec(alertDurationTime_, 3);
            //AlertDurationTime := max(50, alertDurationTime_);
          end;
          NeedEvtsDecrement := not NeedEvtsDecrement;
        end;
      end;
      evSeventhVariant:
      begin
        fmDialog.chrtCommonCriteria.Visible := NeedResultPresent;
        AllowDialogAutoHideTimer := True;
        fmDialog.rgrpsAnswer.Visible := False;
        fmDialog.srsCurCommonCriteria.Clear;
        i := 0;
        while i < Length(ReactionAccuracyValues) do
        begin
          fmDialog.srsCurCommonCriteria.AddBar(ReactionAccuracyValues[i], '', clGreen);
          inc(i);
        end;
        RTestObj_X := 2;
        IntrvlPeriod := 5000;
        //AllowRTestObject := True;
      end;
      evEighthVariant:
      begin
        NeedResultPresent := False;
        AllowSuccFeedbackSignal := False;
        AllowFailFeedbackSignal := False;
        fmDialog.redtInstruction.Text := strSeventhVariantInstruction;

        fmDialog.chrtCommonCriteria.Visible := NeedResultPresent;
        AllowDialogAutoHideTimer := True;
        fmDialog.rgrpsAnswer.Visible := False;
        fmDialog.srsCurCommonCriteria.Clear;
        i := 0;
        while i < Length(ReactionAccuracyValues) do
        begin
          fmDialog.srsCurCommonCriteria.AddBar(ReactionAccuracyValues[i], '', clGreen);
          inc(i);
        end;
        RTestObj_X := 2;
        IntrvlPeriod := 5000;
      end;
      evNinthVariant:
      begin
        fmDialog.rgrpsAnswer.Visible := True;
      end;
      evTenthVariant:
      begin
        if MaxValue(MaximumsBufData) > Max_Value then
          Max_Value := MaxValue(MaximumsBufData);
        AddLogMessage('loglog12.txt', ' Max_Value= ' + FloatToStr(Max_Value));
        fmDialog.rgrpsAnswer.Visible := True;
      end;
      evEleventhVariant:
      begin
        if MaxValue(MaximumsBufData) < Min_Value then
          Min_Value := MaxValue(MaximumsBufData);
//        r := 0;
//        while r < Length(MaximumsBufData) do
//        begin
//          AddLogMessage('loglog13.txt', ' MaximumsBufData= ' + FloatToStr(MaximumsBufData[r]));
//          inc(r);
//        end;
        AddLogMessage('loglog12.txt', ' Min_Value= ' + FloatToStr(Min_Value));
        fmDialog.rgrpsAnswer.Visible := True;
      end;
      ev12Variant:
      begin
        fmDialog.rgrpsAnswer.Visible := True;
      end;
    end;

    ShowCursor_;
    fmDialog.ShowModal;
    if fmDialog.ModalResult <> 0 then
    begin
      FAnswer := TAnswers(fmDialog.SldrAgencyVal.Value);
      case FAnswer of
        aNoAnswer: strMsg := 'NoAnswer';//
        aAVal1: strMsg := 'aAVal1';//минимальный балл ощущения агентивности
        aAVal2: strMsg := 'aAVal2';//
        aAVal3: strMsg := 'aAVal3';//
        aAVal4: strMsg := 'aAVal4';//
        aAVal5: strMsg := 'aAVal5';//
        aAVal6: strMsg := 'aAVal6';
        aAVal7: strMsg := 'aAVal7';
        aAVal8: strMsg := 'aAVal8';
        aAVal9: strMsg := 'aAVal9';
        aAVal10: strMsg := 'aAVal10';//максимальный балл ощущения агентивности
      end;
      AddMsgDataToLogFile_(NameForLogFile, 'AnswerType ' + strMsg, Pc);

      strMsg := IntToStr(Trunc(fmDialog.SpnEdFeedbackSignalDelay.Value));
      AddMsgDataToLogFile_(NameForLogFile, 'Subj_estim_FBSignal_interval ' + strMsg, Pc);
      strMsg := IntToStr(CurFBSignalDelay);
      AddMsgDataToLogFile_(NameForLogFile, 'CurFBSignal_interval ' + strMsg, Pc);
      //если время эксперимента не вышло, то начинаем новый интервал
      if FCurSessionDurationInMs + IntervalDefTimeLen < FSessionDurationInMs then
      begin
        if ExpVariants in [evSeventhVariant] then
          SetFeedbackSignalDefermentPeriod(200) else
        begin
          //задаём следующую задержку для сигнала ОС из заранее подготовленного ряда (один из 3-х вариантов: 200мс, 250мс, 300мс)
          CurFBSignalDelay := GetNextFBSignalDelay;
          if CurFBSignalDelay <> -1 then
            SetFeedbackSignalDefermentPeriod(CurFBSignalDelay)
          else
            Exit;
        end;
//        repeat//в ситуации ответа по баллу агентивности поднятием пальца ждём пока не опустил палец
//          Application.ProcessMessages;
//        until MaestroReoPos <= 2;
        if not (ExpVariants in [evSeventhVariant, evEighthVariant]) then
          newAlertInterval := GetNewRndAlertIntervalValue
        else
          newAlertInterval := 20000{GetNewRndAlertIntervalValueForFastPresent};
        //если надо, то задаём равномерно случайное срабатывание FA в пределах времени интервала
        if ExpVariants in [evThirdVariant] then
        begin
          repeat
            ForceActionTimeShift := Random(IntervalDefTimeLen);
          until (ForceActionTimeShift > 500) and (ForceActionTimeShift < IntervalDefTimeLen - 1000);
          SetForceActionPeriod(ForceActionTimeShift);
        end
        else
        if ExpVariants in [evEleventhVariant] then
        begin
          rndInt := Random(InitialAvrgReactionTime + 100 + 50);
          ForceActionTimeShift := rndInt - 100;
          SetForceActionPeriod(newAlertInterval - ActionDelayTimeCorrection + ForceActionTimeShift);
        end
        else
        begin
          SetForceActionPeriod(newAlertInterval - ActionDelayTimeCorrection + ForceActionTimeShift);
        end;
        if ExpVariants in [evSeventhVariant, evEighthVariant] then
        begin
          SetRTestObjectPeriod(2000);
        end;
        //needFlg := NeedForcedSubjAction and (newAlertInterval > 0);
        {ActionDelayTimeCorrection - коррекция, которая даёт одинаковость из-за того, что запаздывает отрисовка}
        SetAlertActionPeriod(newAlertInterval);
        //SetAlertActionPeriod(newAlertInterval - ActionDelayTimeCorrection);//для программного алерта
        SetAlertDurationPeriod(AlertDurationTime);
        TmrSessionDuration.Enabled := True;
        HideCursor_;
        RequestType := rtBeginIntrvl;//состояние - начать новый интервал
        BeginIntrvlFlg := True;
      end
      else
      begin
        RequestType := rtEndExperiment;
      end;
      NeedSuspend := False;
    end;
  finally
    fmDialog.Free;
  end;
end;

function TfmMain.OpenComPort: Boolean;
var
  i: Integer;
  portName: AnsiString;
begin
  if (ComVar.hCom <> 0) and
     (ComVar.hCom <> INVALID_HANDLE_VALUE) then
  begin
    Result := True;
    Exit;//порт уже был открыт ранее - просто выходим из ф-ции
  end;
  ComVar.hCom := INVALID_HANDLE_VALUE;
  portName := ArrAnsiCharToAnsiStr(ComVar.PortName);
  i := 0;
  while (ComVar.hCom = INVALID_HANDLE_VALUE) and
        (i < PORT_INIT_REPEAT_ATTEMPT) do
  begin
    //попытка открыть порт
    ComVar.hCom := CreateFile(PChar('\\.\' + WideString(portName)),GENERIC_READ or GENERIC_WRITE,0,nil,OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0);
    Sleep(10);
    inc(i);
  end;
  Result := (ComVar.hCom <> INVALID_HANDLE_VALUE) and (ComVar.hCom <> 0);
end;

procedure TfmMain.OpenComThreadTerminate(Sender: TObject);
begin
  SendMessage(fmMain.Handle, UM_OPEN_COM_THREAD_TERMINATE, 0, 0);//SendMessage для того, чтобы поток не уничтожился до выполнения всех ф-ций при OnTerminate
  FOpenComThread := nil;
end;

procedure TfmMain.OpenComThreadTerminate_(var MSG: TMessage);
begin
  if FOpenComThread <> nil then
  begin
    ComVar.ComVisibility := FOpenComThread.ComVisibility;
    if ComVar.ComVisibility then
    begin
  //    PostMessage(fmMain.Handle, UM_OPEN_COM_THREAD_STOP_THREAD, 0, 0);
      WorkState := dwsInit;
    end;
  end;
end;

procedure TfmMain.SaveSettingsToINI(const IniFileName: WideString);
var
  iniFile: TIniFile;
  Section: string;
  tmpStr: string;
begin
  iniFile := TIniFile.Create(InifileName);
  try
    Section := 'WorkSettings';
    iniFile.WriteBool(Section, 'DebugPnlVisible', FDebugPnlVisible);
    iniFile.WriteBool(Section, 'EmulMode', FEmulMode);
    iniFile.WriteInteger(Section, 'VidModeSelectedIndex', FVidModeSelectedIndex);
    iniFile.WriteBool(Section, 'FullScreenMode', FFullScreenMode);
    iniFile.WriteFloat(Section, 'FovY', FovY);//параметр вида - угол зрения сцены
    iniFile.WriteFloat(Section, 'DefChipSize', DefChipSize);//размер фишек на доске
    Section := 'GameSettings';
    iniFile.WriteInteger(Section, 'SessionDurationInMs', FDefSessionDurationInMs);
    iniFile.WriteBool(Section, 'NeedAlertSubjectAction', AllowAlertSubjectAction);
    iniFile.WriteBool(Section, 'AllowDialogAutoHideTimer', AllowDialogAutoHideTimer);
    iniFile.WriteBool(Section, 'AllowSuccFeedbackSignal', AllowSuccFeedbackSignal );
    iniFile.WriteBool(Section, 'AllowFailFeedbackSignal', AllowFailFeedbackSignal );
    iniFile.WriteBool(Section, 'AllowTicSignal', AllowTicSignal);
    Section := 'JoySettings';
    iniFile.WriteInteger(Section, 'JoyPedalsID', JoyPedalsID);
    iniFile.WriteBool(Section, 'EmulationModeOn', EmulationModeOn);

    iniFile.WriteInteger(Section, 'DelayMin', DelayMin);//допустимый для испыт-го мин-макс для параметра синхронности
    iniFile.WriteInteger(Section, 'DelayMax', DelayMax);
    //мин-макс для парам.скорости перемещения джоев в мс, кот. ещё допустим для исп-го
    //исходя из этого д-на идёт пересчёт в шкалу 0..1
    iniFile.WriteInteger(Section, 'PartialDerivativeMin', PartialDerivativeMin);
    iniFile.WriteInteger(Section, 'PartialDerivativeMax', PartialDerivativeMax);
    Section := 'LPTSettings';
    iniFile.WriteBool(Section, 'WorkWithLPT', WorkWithLPT);
    tmpStr := IntToHex(LPTAdress, 3);
    iniFile.WriteString(Section, 'LPTAdress', tmpStr);
    tmpStr := IntToHex(LPTAdress2, 3);
    iniFile.WriteString(Section, 'LPTAdress2', tmpStr);
    Section := 'ComSettings';
    iniFile.WriteString(Section, 'DevComPortName', WideString(ArrAnsiCharToAnsiStr(ComVar.PortName)));
    iniFile.WriteInteger(Section, 'BaudRate', ComBaudRate);
    Section := 'ExperimentSettings';
    iniFile.WriteInteger(Section, 'MrkBeginIntrvlCode', MrkBeginIntrvlCode);
    iniFile.WriteInteger(Section, 'MrkEndIntrvlCode', MrkEndIntrvlCode);
    iniFile.WriteInteger(Section, 'MrkEvtActionCode', MrkEvtActionCode);
    iniFile.WriteInteger(Section, 'MrkAlertSubjAction', MrkAlertSubjActionCode);
    iniFile.WriteInteger(Section, 'ReactionTimeCorrection', ReactionTimeCorrection);
    iniFile.WriteInteger(Section, 'ActionDelayTimeCorrection', ActionDelayTimeCorrection);
    iniFile.WriteInteger(Section, 'ForceActionTimeShift', ForceActionTimeShift);
    iniFile.WriteInteger(Section, 'ServoNeedMax', ServoNeedMax);//параметр, задающий величину поднятия пальца
    iniFile.WriteInteger(Section, 'ServoVlcty', ServoVlcty);//параметр, задающий общую скорость поднятия вверх-вниз
  finally
    iniFile.Free;
  end;
end;

procedure TfmMain.ScanComPorts;
var
  i: Integer;
  PortsStrings: TStringList;
begin
  FLockCtrls := True;
  cbxComNum.Clear;
  PortsStrings := TStringList.Create;
  try
    GetComPorts(PortsStrings, 'COM');
    i:=0;
    while i < PortsStrings.Count do
    begin
      cbxComNum.Items.Add(PortsStrings.Strings[i]);
      inc(i);
    end;
  finally
    PortsStrings.Free;
  end;
  i:=0;
  while i < cbxComNum.Items.Count do
  begin
    if CompareText(cbxComNum.Items.Strings[i], ComVar.PortName) = 0 then
    begin
      cbxComNum.ItemIndex := i;
      Break;
    end;
    inc(i);
  end;
  FLockCtrls := False;
end;

//версия настроек порта как в примере для Maestro pololu
function TfmMain.SetComSettings: Boolean;
var
  TimeOuts : TCommTimeouts;
  success: Boolean;
begin
  Result := False;
  if (ComVar.hCom <> 0) and
     (ComVar.hCom <> INVALID_HANDLE_VALUE) then
  begin
    //получаем текущие параметры таймаутов
    success := GetCommTimeouts(ComVar.hCom,TimeOuts);
    if (not success) then
    begin
      WorkState := dwsTerm;
      Exit;
    end;
	  TimeOuts.ReadIntervalTimeout := 1000;
	  TimeOuts.ReadTotalTimeoutConstant := 1000;
	  TimeOuts.ReadTotalTimeoutMultiplier := 0;
	  TimeOuts.WriteTotalTimeoutConstant := 1000;
	  TimeOuts.WriteTotalTimeoutMultiplier := 0;
    //выполняем настройку порта с новыми таймаутами
    if not SetCommTimeouts(ComVar.hCom,TimeOuts) then
    begin
      WorkState := dwsTerm;
      Exit;
    end;

    success := GetCommState(ComVar.hCom, ComVar.DCB);
    if (not success) then
    begin
      WorkState := dwsTerm;
      Exit;
    end;
    ComVar.DCB.BaudRate := ComBaudRate;

    //выполняем настройку порта с новым DCB
    if not SetCommState(ComVar.hCom, ComVar.DCB) then
    begin
      WorkState := dwsTerm;
      Exit;
    end;

    ///* Flush out any bytes received from the device earlier. */
    if not FlushFileBuffers(ComVar.hCom) then
    begin
      WorkState := dwsTerm;
      Exit;
    end;

    Result := True;
  end;
end;

//рабочий старый вариант настроек
//function TfmMain.SetComSettings: Boolean;
//var
//  TimeOuts : TCommTimeouts;
//begin
//  Result := False;
//  if (ComVar.hCom <> 0) and
//     (ComVar.hCom <> INVALID_HANDLE_VALUE) then
//  begin
//    //устанавливаем маску эвентов (фактически маску прерываний)
//    //в данном случае будем иметь возникновение эвентов по принятию
//    //хотя бы одного байта и возможности записи в порт еще байт(ов)
//    if not (SetCommMask(ComVar.hCom,EV_RXCHAR or EV_TXEMPTY) and
//    //устанавливаем размер внутренних буферов приема-передачи в //драйвере порта
//            SetupComm(ComVar.hCom,512,512) and
//    //очищаем буферы приема-передачи
//            PurgeComm(ComVar.hCom,PURGE_TXABORT or PURGE_RXABORT or PURGE_TXCLEAR or PURGE_RXCLEAR)) then
//    begin
//      WorkState := dwsTerm;
//      Exit;
//    end;
//    //изменяем DCB
//    ComVar.DCB.Flags := $1;
//
//    //выполняем настройку порта с новым DCB
//    if not SetCommState(ComVar.hCom, ComVar.DCB) then
//    begin
//      WorkState := dwsTerm;
//      Exit;
//    end;
//    //получаем текущие параметры таймаутов
//    GetCommTimeouts(ComVar.hCom,TimeOuts);
//    //настраиваем текущие параметры таймаутов таким образом,
//    //чтобы ReadFile и WriteFile возвращали значения немедленно
//    TimeOuts.ReadIntervalTimeout := 1000;
//    TimeOuts.ReadTotalTimeoutMultiplier := 0;
//    TimeOuts.ReadTotalTimeoutConstant := 1000;
//    TimeOuts.WriteTotalTimeoutMultiplier := 0;
//    TimeOuts.WriteTotalTimeoutConstant := 1000;
//    //выполняем настройку порта с новыми таймаутами
//    if not SetCommTimeouts(ComVar.hCom,TimeOuts) then
//    begin
//      WorkState := dwsTerm;
//      Exit;
//    end;
//
//    ///* Flush out any bytes received from the device earlier. */
//    if not FlushFileBuffers(ComVar.hCom) then
//    begin
//      WorkState := dwsTerm;
//      Exit;
//    end;
//
//    Result := True;
//  end;
//end;

procedure TfmMain.SetCurGameSessionNumber(const Value: Integer);
begin
  FCurGameSessionNumber := Value;
end;

procedure TfmMain.SetCurSessionDurationInMs(const Value: Int64);
begin
  FCurSessionDurationInMs := Value;
end;

procedure TfmMain.SetFormControls;
begin
  FLockCtrls := True;
  SldrFovY.Value := Trunc(FovY);
  //SldrChipSize.Value := Trunc(DefChipSize * SldrChipSize.MaxValue);
  edit1.Text := FloatToStr(FovY);
  //edit2.Text := FloatToStr(DefChipSize);
  DebugPnl.Visible := FDebugPnlVisible;
  edLPTAdress.Text := IntToHex(LPTAdress, 3);
  edLPTAdress2.Text := IntToHex(LPTAdress2, 3);
  //
  edtComSpeed.Text := IntToStr(ComBaudRate);
  //Experiment settings
  edtrMrkBgnIntrvlCode.Text := IntToStr(MrkBeginIntrvlCode);
  edtrMrkEndIntrvlCode.Text := IntToStr(MrkEndIntrvlCode);
  edtrMrkEvtActionCode.Text := IntToStr(MrkEvtActionCode);
  edtMrkAlertSubjAction.Text := IntToStr(MrkAlertSubjActionCode);
  edtFrcActnTShift.Text := IntToStr(ForceActionTimeShift);
  FLockCtrls := False;
end;

procedure TfmMain.SetFullScreen(const Value: Boolean);
begin
  Left := 0;
  Top := 0;
  Width := Screen.Width;
  Height := Screen.Height;
  BorderIcons := [];
  if Value then
  begin
    FFullScreen := uVidMode.SetFullscreenMode(fmMain.VidModeSelectedIndex);
  //      FormStyle := fsStayOnTop;
    BorderStyle := bsNone;
    PopupMenu := nil;
  end
  else
  begin
    RestoreDefaultMode;
    FormStyle := fsNormal;
    FFullScreen := Value;
    BorderStyle := bsSingle;
  end;
end;
procedure TfmMain.SetFullScreenMode(const Value: Boolean);
begin
  FFullScreenMode := Value;
end;

procedure TfmMain.SetScreenMode;
var
  ColorDepth: Cardinal;
  Width: Cardinal;
  Height: Cardinal;
begin
  ColorDepth := VideoModes[fmMain.VidModeSelectedIndex].ColorDepth;
  Width := VideoModes[fmMain.VidModeSelectedIndex].Width;
  Height := VideoModes[fmMain.VidModeSelectedIndex].Height;

  ReadVideoModes;
  uVidMode.SetFullscreenMode(fmMain.VidModeSelectedIndex);
end;

procedure TfmMain.SetDefSessionDurationInMs(const Value: Int64);
begin
  FDefSessionDurationInMs := Value;
end;

procedure TfmMain.SetVidModeSelectedIndex(const Value: Integer);
begin
  FVidModeSelectedIndex := Value;
end;

procedure TfmMain.SetWorkState(const Value: TDevWorkState);
begin
  if Value <> FDevWorkState then
  begin
    FDevWorkState := Value;
    if (Value = dwsTerm) and
       (FDevWorkState = dwsTerminated) then
      Exit;
    //
    case FDevWorkState of
      dwsNone:
      begin
        //FDevWorkSubState := dwssNone;
      end;
      dwsStart:
      begin
        ComWaitVisibility;//если в execute потока попытка открыть Com-порт успешна, то при завершении потока устанавливается статус wsInit,
        //иначе поток зацикливается до тех пор, пока не получится открыть порт
      end;
      dwsInit:
      begin
        if (OpenComPort) and//снова открываем порт
           (SetComSettings) then//делаем настройки порта
          WorkState := dwsInitialized;
      end;
      dwsInitialized:
      begin
        LedDevOnAir.Status := True;
        LedDevOnAir.Hint := 'strDevOnAir';

        //серво в исходное состояние
        MaestroServoPos := 4*GetServoPosByReoPos(REO_MIN);
        MaestroSetTarget(1, MaestroServoPos);
        MaestroSetTarget(3, 4*SERVO_MAX);//photodiode off

        WorkState := dwsWork;
      end;
      dwsWork:
      begin
        //
      end;
      dwsTerm:
      begin
        TerminateWorkWithComPort;
      end;
      dwsTerminated:
      begin
        //FDevWorkSubState := dwssNone;
//        WorkState := dwsStart;
        LedDevOnAir.Status := False;
        LedDevOnAir.Hint := 'strDevOffAir';
      end;
    end;
    //
  end;
end;

procedure TfmMain.Term;
var
  i: Integer;
begin
  i := 0;
  while i < Length(CircBufData) do
  begin
    SetLength(CircBufData[i], 0);
    inc(i);
  end;
  i := 0;
  while i < Length(CircBufFilData) do
  begin
    SetLength(CircBufFilData[i], 0);
    SetLength(CircBufFil2Data[i], 0);
    inc(i);
  end;
  Finalize(CircBufData);
  Finalize(CircBufFilData);
  Finalize(CircBufFil2Data);

  JvSubTimer.Enabled := False;
  Finalize(StubData);

  ClearSubTests;
  FSubTests.Free;
  Finalize(FGameResults);
  BoardBitmap.Free;
  ChipBitmap.Free;

  FullScreen := False;
  SaveSettingsToINI(FIniFileName);
end;

procedure TfmMain.TerminateWorkWithComPort;
var
  waitRes: Cardinal;
begin
//  FWriteDataToComPortTimer.Enabled := False;
  ComVar.ComVisibility := False;
  if FOpenComThread <> nil then
  begin
    FOpenComThread.ComVisibility := False;
    FOpenComThread.Terminate;
    waitRes := WaitForSingleObject(EvtOpenComThread, 5000);
//    FOpenComThread.Free; //поток самоуничтожается, поэтому Free не нужен!
    FOpenComThread := nil;
//    CloseHandle(EvtOpenComThread);//сигнальный объект освобождается в потоке, поэтому здесь CloseHandle не нужен!
  end;
  ComDeInitialize;
  CloseComPort;
  WorkState := dwsTerminated;
end;

initialization
  CreatePlStimModule;

  Lib := LoadLibrary('eyegamesDll.dll');
  SetUp := GetProcAddress(Lib, 'setUp');
  TearDown := GetProcAddress(Lib, 'tearDown');
  SendEvent := GetProcAddress(Lib, 'sendEvent');
  RegisterCallback := GetProcAddress(Lib, 'registerEEGCallback');

finalization
  FreeLibrary(Lib);
  IPlStimModule := nil;

end.
