unit uCommon;

interface

uses
  SysUtils, SyncObjs, Windows, Types, Messages, Math, StrUtils, Ap, uDebugLog;

type
  TIIRFilterOrd2 = record
    b: array [0..2] of Double;
    a: array [0..2] of Double;
  end;

//for work with com port

type
  T256ascii = array [0..255] of AnsiChar;
  TDevWorkState = (dwsNone, dwsStart, dwsInit, dwsInitialized, dwsWork, dwsTerm, dwsTerminated);

const
  PORT_INIT_REPEAT_ATTEMPT = 3;
  PACKET_LENGTH = 9;
  //TM_SEND_INTERVAL = 1000{50};//интервал тика основного таймера обмена данными с портом
  //PORT_WAIT_TIME = TM_SEND_INTERVAL * 2{200};//!! Должно быть меньше, чем тик таймера записи в порт чтобы успеть обработать

  UM_OPEN_COM_THREAD_TERMINATE = WM_USER + 1009;
  UM_OPEN_COM_THREAD_STOP_THREAD = WM_USER + 1010;

type
  TArrPacket = array[0..PACKET_LENGTH - 1] of Byte;

//const
//  DPACKET_SIZE = SizeOf(TArrPacket);
type
  TAnswers = (aNoAnswer, aAVal1, aAVal2, aAVal3, aAVal4, aAVal5, aAVal6, aAVal7, aAVal8, aAVal9, aAVal10);

type
  TRequestType = (rtNone, rtStartExperiment, rtBeginBackdrop, rtEndBackdrop, rtAmongBackdrop, rtNeedGetSubjAnswer, rtBeginIntrvl, rtAmongIntrvl, rtEndIntrvl, rtEndExperiment, rtServoParamsAdjustment, rtServoParamsAdjusted);

type
  TPComVar = ^TComVar;
  //структура для работы с портом
  TComVar = packed record
    PortName: T256ascii;
    hCom: DWord;//дескриптор порта
    DCB: TDCB;
    ComStat: TComStat;//статус
    ReceivBuf: array [0..511] of Byte;//приёмный буфер
    PacketBuf: array [0..PACKET_LENGTH - 1] of Byte;//буфер для принятых пакетов
    CntBytes: Integer;//кол-во принятых байт
    ComVisibility: Boolean;
  end;
//
type
  TByte2DArr = array of array of Byte;
  TInt2DArr = array of array of Integer;
  TIntArr = array of Integer;
  TInt64Arr = array of Int64;
//  TBoolArr = array of Boolean;

var
  IIRNotch50HzOrd2: TIIRFilterOrd2;
  IIRHPF5_500HzOrd2: TIIRFilterOrd2;

var
  MaxInt64: Int64 = $7FFFFFFFFFFFFFFF - $FFFFFFFF;//минус длина интервала, чтобы не случилось Integer overflow

var
  ComVar: TComVar;
  MaestroGetErrorsCmd: array[0..0] of Byte = ($A1);
  MaestroGetPosCmd: array[0..1] of Byte = ($90, $00);//Compact protocol шаблон команды - запрос значения на канале
  MaestroPololuGetPosCmd: array[0..3] of Byte = ($AA, $0C, $10, $00);//Pololu protocol
  MaestroSetTargetCmd: array[0..3] of Byte = ($84, $00, $00, $00);//Compact protocol шаблон команды - выставление позиции серво
  MaestroPololuSetTargetCmd: array[0..5] of Byte = ($AA, $0C, $04, $00, $00, $00);//Pololu protocol

const
  MaestroGetErrorsCmd_size = SizeOf(MaestroGetErrorsCmd);
  MaestroGetPosCmd_size = SizeOf(MaestroGetPosCmd);
  MaestroPololuGetPosCmd_size = SizeOf(MaestroPololuGetPosCmd);
  MaestroSetTargetCmd_size = SizeOf(MaestroSetTargetCmd);
  MaestroPololuSetTargetCmd_size = SizeOf(MaestroPololuSetTargetCmd);
  SERVO_MIN = 2000;
  SERVO_MAX = 992;
  SERVO_RANGE = abs(SERVO_MAX - SERVO_MIN) + 1;
  REO_MIN = 0;
  REO_MAX = 1023;
  BASE_POINTS_CNT = 30;//исходное кол-во точек, по которым делается интерполяция кривой отклика сервы

const
  UM_UPDATE_VCL = WM_USER + 1001;
  UM_START_EXPERIMENT = WM_USER + 1002;
  UM_NEED_SUBJ_ANSWER_DIALOG = WM_USER + 1003;
  UM_UPDATE_CTRLS = WM_USER + 1004;
  UM_DRAW_OPENGL = WM_USER + 1005;
  UM_FEEDBACK_SUCC_SIGNAL_APPLY = WM_USER + 1006;
  UM_FEEDBACK_FAIL_SIGNAL_APPLY = WM_USER + 1007;
  UM_TIC_SIGNAL_APPLY = WM_USER + 1008;

const
  GL_NEAR = 2;
  GL_FAR = 100;
  GL_LEFT = -1;
  GL_RIGHT = 1;
  GL_BOTTOM = -1;
  GL_TOP = 1;
  GL_FAR_LEFT = GL_LEFT * GL_FAR / GL_NEAR;
  GL_FAR_RIGHT = GL_RIGHT * GL_FAR / GL_NEAR;
  GL_FAR_BOTTOM = GL_BOTTOM * GL_FAR / GL_NEAR;
  GL_FAR_TOP = GL_TOP * GL_FAR / GL_NEAR;
//  UM_NEED_ALERT_ACTION = WM_USER + 1001;

  EPSILON = 0.00001;
  LOG_FILE_DEF_EXT = '.log';
  CRVDATA_FILE_DEF_EXT = '.crv';
  LOGS_DEF_DIR = 'Logs\';
  SOUND_DEF_DIR = 'Sounds\';

//для работы с данными actiCHamp ***********************************************
const
  ACTICHAMP_CH_CNT = 69;
  CIRCLE_BUF_LEN = 5000;

type
  TArrOfDblDynArray = array of TDoubleDynArray;
  PTArrOfDblDynArray = ^TArrOfDblDynArray;
  PTDoubleDynArray = ^TDoubleDynArray;

var
  CircBufData: TArrOfDblDynArray;//список массивов данных. Строка списка - канал
  CircBufFilData: TArrOfDblDynArray;
  CircBufFil2Data: TArrOfDblDynArray;
  MaximumsBufData: TDoubleDynArray;
  DataEndIndexes: array [0..ACTICHAMP_CH_CNT-1] of Integer;
  DrawDataIndxes: array [0..ACTICHAMP_CH_CNT-1] of Integer;
  CircBufIsFilled: array [0..ACTICHAMP_CH_CNT-1] of Boolean;
//******************************************************************************

var
  Section: TCriticalSection;
  LogFileDirectory: string;
  DataFileDirectory: string;
  SndFileDirectory: string;
  OnlyFileName: string;
  NameForLogFile: string;
  TmpIntCntr: Integer;
  Pf, Pc1, Pc2: Int64;
//  QrPC: Int64 = 0;
  QrPC0: Int64 = 0;
  //
  MaestroReoPos: Word;
  LimbOneUpSensorVal: Word;
  MaestroErrCode: Word;

var
  AmplitudeLimbToUp: Integer;
  AdjustedAmplitudeLimbToUp: Integer;//амп-да по потенциометру после итеративной проц-ры настройки серво
  AdjustedTimeLimbToUpDown: Integer;
  RequestType: TRequestType;
  TimeLimbToUpDown: Integer; //!! Лишние переменные
  EMG_AmplThresh: Double;//порог амплитуды ЭМГ для события
  EMG_EventArise: Boolean;
  Pc: Int64;
  Cntr2: Int64;
  EMG_EventAriseTimeCntr: Int64;
  LineDelaysArr: TIntegerDynArray;
  EpochTypeArr: TBooleanDynArray;
  NextIndx: Integer;
  NextIndx2: Integer;

  EMGChnlIndx: Integer;
  BeginIntrvlFlg: Boolean = False;

  function GetNextEpochType: Boolean;
  function GetNextFBSignalDelay: Integer;
  procedure Delete_(const Index: Integer; var intArr: TIntegerDynArray);
  procedure GenerateEpochTypeArr(const Cnt: Integer);
  procedure GenerateLineDelays(const Cnt: Integer);

  function MaestroGetPosition(const Channel: Byte; var Position: Word): Boolean;
  function MaestroPololuGetPosition(const Channel: Byte; var Position: Word): Boolean;
  function MaestroGetErrors(var ErrCode: Word): Boolean;

  //
  procedure HideCursor_;
  procedure ShowCursor_;
  procedure BuildIndx(dblArray: TDoubleDynArray; intIndex: TIntegerDynArray; SizeArray: Integer; SendEvent: Boolean);
  function Percentile(const AData: TDoubleDynArray; const Boundaries: Double): Double;
  function HistogramCalculate(const AData: TDoubleDynArray; var HistYVal: TIntegerDynArray; var HistXVal: TDoubleDynArray; const IntrvlCnt: integer): Boolean;
  function GetTimeInMilliseconds(const ATime: TDateTime): Int64;
  function SetTimeByMilliseconds(const ATimeMS: Int64): TDateTime;
  function LoadCurvesDataFromFile(var ABaseYPoints: TReal1DArray; var AIntrplData: TReal1DArray): Boolean;
  function SaveCurvesDataToFile(var ABaseYPoints: TReal1DArray; var AIntrplData: TReal1DArray): Boolean;
  procedure AddMsgDataToLogFile_(const PostFix: string; const msgStr: string; const TimePC: Int64);
  procedure MinIntValue2(var Data: TCardinalDynArray; var Rslt: Integer; var Indx: Integer);
  procedure MaxIntValue2(var Data: TCardinalDynArray; var Rslt: Integer; var Indx: Integer);
  function HexToInt(HexStr : AnsiString) : Int64;
  function ArrAnsiCharToAnsiStr(const ArrAnsiChar: T256ascii): AnsiString;
  function AnsiStrToTAscii(const AnsiStr: AnsiString): T256ascii;
  function GetNextSubstring(aBuf: string; var aStartPos: integer): string;
  function GetSubstrG(st: AnsiString; const n: Integer; const dvdr: AnsiString): AnsiString;
  function fAnsiPos(ASubstr, Str: AnsiString; FromPos: integer): Integer;//поиск подстроки в строке
  function RemoveSymbols(Str: AnsiString; Symbol: AnsiString): AnsiString;
  function IIRFilter50HzOrd2(const xk, xk1, xk2, yk1, yk2: Double): Double;//алгоритм расчёта IIR Notch фильтра 50Гц 2-го порядка
  function IIRHPFilter5_500HzOrd2(const xk, xk1, xk2, yk1, yk2: Double): Double;
  function CheckAmplData(APData: PTDoubleDynArray; const ChnlIndx: Integer; const DataCurIndx: Integer; const ANewPortionDataCnt: Integer): Boolean;
  procedure Circle_buff_proc(APData: PTDoubleDynArray; const ChnlIndx: Integer; const ANewPortionDataCnt: Integer);

implementation

function GetNextEpochType: Boolean;//получить тип очередной эпохи. False - нормальная, True - заведомо неагентивная с коротким Tlit и временем Forced action
begin
  Result := False;
  if Length(EpochTypeArr) > 0 then
  begin
    Result := EpochTypeArr[NextIndx2];
    inc(NextIndx2);
    if NextIndx2 > High(EpochTypeArr) then
      NextIndx2 := 0;
  end;
end;

function GetNextFBSignalDelay: Integer;
begin
  Result := -1;
  if Length(LineDelaysArr) > 0 then
  begin
    Result := LineDelaysArr[NextIndx];
    inc(NextIndx);
    if NextIndx > High(LineDelaysArr) then
      NextIndx := 0;
  end;
end;

procedure Delete_(const Index: Integer; var intArr: TIntegerDynArray);
var
  i: Integer;
begin
  if (Index >= 0) and
     (Index < Length(intArr)) then
  begin
    i := Index + 1;
    while i < Length(intArr) do
    begin
      intArr[i - 1] := intArr[i];
      inc(i);
    end;
    SetLength(intArr, Length(intArr) - 1);
  end;
end;

//генерировать массив длиной Cnt из флагов типов эпох. False - нормальная эпоха, True - заведомо неагентивная, с короткими временами Tlit и Forced action
procedure GenerateEpochTypeArr(const Cnt: Integer);
var
  i: Integer;
  indx: Integer;
  indx2: Integer;
  IndxArr: TIntegerDynArray;
  intVal: Integer;
  len: Integer;
begin
  SetLength(EpochTypeArr, Cnt);
  i := 0;
  while i < Length(EpochTypeArr) do
  begin
    EpochTypeArr[i] := False;
    inc(i);
  end;
  SetLength(IndxArr, Cnt);
  i := 0;
  while i < Length(IndxArr) do
  begin
    IndxArr[i] := i;
    inc(i);
  end;
  try
    intVal := Trunc(Cnt * 0.3 + 0.5);//сколько нужно неагентивных эпох. Пока 30%
    len := Cnt;
    i := 0;//обеспечим случайные выборки из ряда
    while i < intVal do
    begin
      indx := Random(len);
      indx2 := IndxArr[indx];
      Delete_(indx, IndxArr);
      EpochTypeArr[indx2] := True;
      len := Length(IndxArr);
      inc(i);
    end;
  finally
    Finalize(IndxArr);
  end;
end;

//генерировать массив длиной Cnt из трех групп задержек, которые равномерно распределены в нём и равномерно представлены по кол-ву
procedure GenerateLineDelays(const Cnt: Integer);
var
  i: Integer;
  indx: Integer;
  indx2: Integer;
  len: Integer;
  intVal: Integer;
  fracVal: Integer;
  val_: Integer;
  delVal: Integer;
  IndxArr: TIntegerDynArray;
begin
  SetLength(LineDelaysArr, Cnt);
  SetLength(IndxArr, Cnt);
  i := 0;
  while i < Length(IndxArr) do
  begin
    IndxArr[i] := i;
    inc(i);
  end;
  try
    intVal := Cnt div 3;//кол-во единиц в группе из 3 видов задержек
    fracVal := Cnt mod 3;//что осталось
    len := Cnt;
    i := 0;
    while i < intVal do
    begin
      indx := Random(len);
      indx2 := IndxArr[indx];
      Delete_(indx, IndxArr);
      LineDelaysArr[indx2] := 200;
      len := Length(IndxArr);
      inc(i);
    end;
    i := 0;
    while i < intVal do
    begin
      indx := Random(len);
      indx2 := IndxArr[indx];
      Delete_(indx, IndxArr);
      LineDelaysArr[indx2] := 250;
      len := Length(IndxArr);
      inc(i);
    end;
    i := 0;
    while i < intVal do
    begin
      indx := Random(len);
      indx2 := IndxArr[indx];
      Delete_(indx, IndxArr);
      LineDelaysArr[indx2] := 300;
      len := Length(IndxArr);
      inc(i);
    end;
    i := 0;//на остаток выставляем случайно любую задержку
    while i < fracVal do
    begin
      indx := Random(len);
      indx2 := IndxArr[indx];
      Delete_(indx, IndxArr);

      val_ := Random(3);
      if val_ = 0 then
        delVal := 200;
      if val_ = 1 then
        delVal := 250;
      if val_ = 2 then
        delVal := 300;

      LineDelaysArr[indx2] := delVal;
      len := Length(IndxArr);
      inc(i);
    end;
  finally
    Finalize(IndxArr);
  end;
end;

function MaestroGetPosition(const Channel: Byte; var Position: Word): Boolean;
var
	response: array[0..1] of Byte;
	success: Boolean;
	bytesTransferred: Cardinal;
begin
  Result := False;
	// Compose the command.
  MaestroGetPosCmd[1] := Channel;

//  WriteFile(ComVar.hCom, MaestroGetPosCmd, MaestroGetPosCmd_size, bytesTransferred, nil);
//  ReadFile(ComVar.hCom, response, 2{SizeOf(response)}, bytesTransferred, nil);
//  Position := MAKEWORD(response[0], response[1]);
//  Result := True;

	// Send the command to the device.
  success := WriteFile(ComVar.hCom, MaestroGetPosCmd, MaestroGetPosCmd_size, bytesTransferred, nil);
	if (success) and (MaestroGetPosCmd_size = bytesTransferred) then
	begin
    //Get pos from device
    success := ReadFile(ComVar.hCom, response, 2{SizeOf(response)}, bytesTransferred, nil);
		if (success) and (2{sizeof(response)} = bytesTransferred) then
    begin
    	Position := MAKEWORD(response[0], response[1]);
	    Result := True;
    end;
	end;
end;

function MaestroPololuGetPosition(const Channel: Byte; var Position: Word): Boolean;
var
	response: array[0..1] of Byte;
	success: Boolean;
	bytesTransferred: Cardinal;
begin
  Result := False;
	// Compose the command.
  MaestroPololuGetPosCmd[3] := Channel;

//  WriteFile(ComVar.hCom, MaestroGetPosCmd, MaestroGetPosCmd_size, bytesTransferred, nil);
//  ReadFile(ComVar.hCom, response, 2{SizeOf(response)}, bytesTransferred, nil);
//  Position := MAKEWORD(response[0], response[1]);
//  Result := True;

	// Send the command to the device.
  success := WriteFile(ComVar.hCom, MaestroPololuGetPosCmd, MaestroPololuGetPosCmd_size, bytesTransferred, nil);
	if (success) and (MaestroPololuGetPosCmd_size = bytesTransferred) then
	begin
    //Get pos from device
    success := ReadFile(ComVar.hCom, response, 2{SizeOf(response)}, bytesTransferred, nil);
		if (success) and (2{sizeof(response)} = bytesTransferred) then
    begin
    	Position := MAKEWORD(response[0], response[1]);
	    Result := True;
    end;
	end;
end;

function MaestroGetErrors(var ErrCode: Word): Boolean;
var
	response: array[0..1] of Byte;
	success: Boolean;
	bytesTransferred: Cardinal;
begin
  Result := False;

	// Send the command to the device.
  success := WriteFile(ComVar.hCom, MaestroGetErrorsCmd, MaestroGetErrorsCmd_size, bytesTransferred, nil);
	if (success) and (MaestroGetErrorsCmd_size = bytesTransferred) then
	begin
    //Get pos from device
    success := ReadFile(ComVar.hCom, response, 2{SizeOf(response)}, bytesTransferred, nil);
		if (success) and (2{sizeof(response)} = bytesTransferred) then
    begin
    	ErrCode := MAKEWORD(response[0], response[1]);
	    Result := True;
    end;
	end;
end;

//Выключение курсора
procedure HideCursor_;
var
  CState: Integer;
begin
  CState := ShowCursor(True);
  while Cstate >= 0 do
    Cstate := ShowCursor(False);
end;

//Включение курсора
procedure ShowCursor_;
var
  Cstate: Integer;
begin
  Cstate := ShowCursor(True);
  while CState < 0 do
    CState := ShowCursor(True);
end;

////////////////////////////////////////////////////////////////
// Построение индекса для массива (сортировка по убыванию) //
////////////////////////////////////////////////////////////////
procedure BuildIndx(dblArray: TDoubleDynArray; intIndex: TIntegerDynArray; SizeArray: Integer; SendEvent: Boolean);
var
  i, n: Integer;
  xTotalCount, xCurrentCount: Integer;
  xN1, xN2, xN1z, xN2z, xZ, xOrd: Integer; // Индексы слияния и их границы
  xTemporary: TIntegerDynArray; // Массив слияния индексов
begin
  if SizeArray <=0 then exit;

  if SendEvent  then
  begin
    xCurrentCount :=0;
    xTotalCount := Round(SizeArray * log2(SizeArray));
  end;
  SetLength(xTemporary, SizeArray);
  for i := 0 to SizeArray - 1 do
    intIndex[i] := i;
  xZ := 1; // Начальный размер зоны слияния
  While (xZ < SizeArray) do
  begin
    xN1 := 0;
    While (xN1 < SizeArray) do
    begin
      xN1z :=xN1 + xZ;
      if xN1z > SizeArray then xN1z := SizeArray;
      xN2 := xN1z;
      xN2z := xN2 +xZ;
      if xN2z > SizeArray then xN2z := SizeArray;
      n := xN1;
      While ((xN1 < xN1z) or (xN2 < xN2z)) do  // Выбор из зон
      begin
        if SendEvent then
        begin
          Inc(xCurrentCount);
//          if (xCurrentCount mod (xTotalCount div 20) = 0) then
//              Application.ProcessMessages;
        end;
        if xN2 >= xN2z then
          xOrd := 1
        else if xN1 >= xN1z then
               xOrd := 2
             else if dblArray[intIndex[xN1]] > dblArray[intIndex[xN2]] then
                    xOrd := 1
                  else
                    xOrd := 2;
        if xOrd = 1 then
        begin
          xTemporary[n] := intIndex[xN1];
          Inc(xN1);
        end
        else
        begin
          xTemporary[n] := intIndex[xN2];
          Inc(xN2);
        end;
        Inc(n);
      end;
      xN1 := xN2;
    end;
    for i := 0 to SizeArray - 1 do
      intIndex[i] := xTemporary[i];
    xZ := xZ * 2;
  end;
  xTemporary := nil;
end;

function Percentile(const AData: TDoubleDynArray; const Boundaries: Double): Double;
var
  xIndex: TIntegerDynArray;
  TmpCnt,TmpVal: integer;
begin
  If Length(AData)=0 then exit;
  // построить индекс по убыванию
  xIndex := nil;
  SetLength(xIndex,High(AData)+1);
  try
    TmpCnt:=High(AData)+1;
    BuildIndx(AData, xIndex, TmpCnt, false);
    // найти процентиль
    TmpVal:=Round(Int( (High(AData)+1) /(100/(100-Boundaries)) )) ;
    Result := AData[xIndex[TmpVal]];
  finally
    Finalize(xIndex);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//функция расчёта гистограммы
//параметры
//вх.массив;
//вых.частоты (знач-я по Y);
//вых. знач-я (знач-я по X);
//кол-во интервалов по оси X
function HistogramCalculate(const AData: TDoubleDynArray; var HistYVal: TIntegerDynArray; var HistXVal: TDoubleDynArray; const IntrvlCnt: integer): Boolean;
var
  i, j, Num: Integer;
  MaxVal, MinVal, FltVal: Double;
  ResFltVal: Double;
  HistXValStep: Double;
  SumHistYValues: Int64;
begin
  Result := False;
  if Length(AData) > 0 then
  begin
    MaxVal := MaxValue(AData);
    MinVal := MinValue(AData);
    MaxVal := MaxVal - MinVal;
    if(MaxVal = 0) or (IntrvlCnt = 0) then
      Exit;

    HistXValStep:= MaxVal / IntrvlCnt;

    //подготавливаем интервалы значений по X
    Finalize(HistXVal); //значений по оси X гистограммы
    SetLength(HistXVal, IntrvlCnt);

    FltVal := MinVal + HistXValStep/2;

    i:=0;
    while i < IntrvlCnt do
    begin
      HistXVal[i] := FltVal;
      FltVal := FltVal + HistXValStep;
      inc(i);
    end;

    Finalize(HistYVal);//частот и...
    SetLength(HistYVal, IntrvlCnt);//...кол-во интервалов, на кот. подразделяется ось X

    //подсчитываем число вхождений значений входного массива в указанные диапазоны (интервалы по X) гистограммы
    //для всех интервалов, кроме последнего

    //MinVal := MinVal + HistXValStep/2;

    i := 0;
    while i < Length(AData) do
    begin
      FltVal := (AData[i] - MinVal);
      ResFltVal := FltVal / HistXValStep;
      Num := Ceil(ResFltVal);

      if (Num > 0) then
        dec(Num);

      inc(HistYVal[Num]);
      inc(i);
    end;

//    j := 1;
//    while j < Length(HistYVal) do
//    begin
//      i := 0;
//      while i < Length(AData) do
//      begin
//        if (AData[i] >= HistXVal[j-1]) and
//           (AData[i] < HistXVal[j]) then
//          inc(HistYVal[j-1]);
//        inc(i);
//      end;
//      inc(j);
//    end;


    //вычисление суммы чисел в получившемся частотном ряду
//    SumHistYValues := SumInt(HistYVal);
//    последнее знач-е частотного массива (последн.интервал) равно остаточному знач-ю, кот. не хватает до общ. суммы чисел
//    HistYVal[High(HistYVal)] := (High(AData) + 1) - SumHistYValues;
    Result := True;
  end;
end;

function GetTimeInMilliseconds(const ATime: TDateTime): Int64;
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(ATime, Hour, Min, Sec, MSec);
  Result := (Hour * 3600000) + (Min * 60000) + (Sec * 1000) + MSec;
end;

function SetTimeByMilliseconds(const ATimeMS: Int64): TDateTime;
var
  Hour, Min, Sec, MSec: Word;
begin
  Result := 0;
  if ATimeMS > 0 then
  begin
    Hour := ATimeMS div 3600000;
    Min := (ATimeMS mod 3600000) div 60000;
    Sec := ((ATimeMS mod 3600000) mod 60000) div 1000;
    MSec := ((ATimeMS mod 3600000) mod 60000) mod 1000;
    Result := EncodeTime(Hour, Min, Sec, MSec);
  end;
end;

function LoadCurvesDataFromFile(var ABaseYPoints: TReal1DArray; var AIntrplData: TReal1DArray): Boolean;
var
  fh: THandle;
  FullfileName: string;
  readBytes: Cardinal;
  aDataLen: Smallint;
begin
  Result := False;
  Section.Enter;
  FullfileName := DataFileDirectory + OnlyFileName + 'SrvCrv' + CRVDATA_FILE_DEF_EXT;
  fh := CreateFile(PChar(FullfileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if fh = INVALID_HANDLE_VALUE then
    Exit;
  try
    SetFilePointer(fh, 0, nil, FILE_BEGIN);
    try
      ReadFile(fh, aDataLen, SizeOf(aDataLen), readBytes, nil);
      if readBytes <> SizeOf(aDataLen) then
        Exit;
      SetLength(ABaseYPoints, aDataLen);
      ReadFile(fh, ABaseYPoints[0], SizeOf(ABaseYPoints[0]) * Length(ABaseYPoints), readBytes, nil);
      if readBytes <> (SizeOf(ABaseYPoints[0]) * Length(ABaseYPoints)) then
        Exit;
      ReadFile(fh, aDataLen, SizeOf(aDataLen), readBytes, nil);
      if readBytes <> SizeOf(aDataLen) then
        Exit;
      SetLength(AIntrplData, aDataLen);
      ReadFile(fh, AIntrplData[0], SizeOf(AIntrplData[0]) * Length(AIntrplData), readBytes, nil);
      if readBytes = (SizeOf(AIntrplData[0]) * Length(AIntrplData)) then
        Result := True;
    except
    end;
  finally
    CloseHandle(fh);
  end;
  Section.Leave;
end;

function SaveCurvesDataToFile(var ABaseYPoints: TReal1DArray; var AIntrplData: TReal1DArray): Boolean;
var
  fh: THandle;
  FullfileName: string;
  writtenBytes: Cardinal;
  aDataLen: Smallint;
begin
  Result := False;
  Section.Enter;
  FullfileName := DataFileDirectory + OnlyFileName + 'SrvCrv' + CRVDATA_FILE_DEF_EXT;
  fh := CreateFile(PChar(FullfileName), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if fh = INVALID_HANDLE_VALUE then
    Exit;
  try
    SetFilePointer(fh, 0, nil, FILE_BEGIN);
    try
      aDataLen := Length(ABaseYPoints);
      WriteFile(fh, aDataLen, SizeOf(aDataLen), writtenBytes, nil);
      if writtenBytes <> SizeOf(aDataLen) then
        Exit;
      WriteFile(fh, ABaseYPoints[0], SizeOf(ABaseYPoints[0]) * Length(ABaseYPoints), writtenBytes, nil);
      if writtenBytes <> (SizeOf(ABaseYPoints[0]) * Length(ABaseYPoints)) then
        Exit;
      aDataLen := Length(AIntrplData);
      WriteFile(fh, aDataLen, SizeOf(aDataLen), writtenBytes, nil);
      if writtenBytes <> SizeOf(aDataLen) then
        Exit;
      WriteFile(fh, AIntrplData[0], SizeOf(AIntrplData[0]) * Length(AIntrplData), writtenBytes, nil);
      if writtenBytes = (SizeOf(AIntrplData[0]) * Length(AIntrplData)) then
        Result := True;
    except
    end;
  finally
    CloseHandle(fh);
  end;
  Section.Leave;
end;

//ф-ция добавл-я в лог, кот. может писать файл, кот. читают. Также может вызываться одновременно из разных потоков
procedure AddMsgDataToLogFile_(const PostFix: string; const msgStr: string; const TimePC: Int64);
var
  fh  : THandle;
  writtenBytes : cardinal;
  FullfileName: string;
  varStr: string;
begin
  Section.Enter;
//  if TimePC = 0 then
//    QueryPerformanceCounter(TimePC);//!! может убрать и подавать всегда значение заранее? сделано 08.07.2016
  //в начале лога время относительно начала эксперимента
  varStr := FloatToStrF(((TimePC - QrPC0) / Pf) * 1000 , ffFixed, 8, 1) + ' ' + msgStr + #10#13;
 // DateTimeToString(lm, '[dd.mm.yyyy] [hh:mm:ss]: ', Now);
  FullfileName := LogFileDirectory + OnlyFileName + PostFix + LOG_FILE_DEF_EXT;
  fh := CreateFile(PChar(FullfileName), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if fh = INVALID_HANDLE_VALUE then Exit;
  try
    SetFilePointer(fh, 0, nil, FILE_END);
    try
      WriteFile(fh, varStr[1], SizeOf(varStr[1]) * Length(varStr), writtenBytes, nil);
    except
    end;
  finally
    CloseHandle(fh);
  end;
  Section.Leave;
end;

procedure MinIntValue2(var Data: TCardinalDynArray; var Rslt: Integer; var Indx: Integer);
var
  I: Integer;
begin
  Rslt := 0;
  Indx := -1;
  if Length(Data)> 0 then
  begin
    Rslt := Data[Low(Data)];
    Indx := 0;
    for I := Low(Data) + 1 to High(Data) do
      if Rslt > Data[I] then
      begin
        Rslt := Data[I];
        Indx := I;
      end;
  end;
end;

procedure MaxIntValue2(var Data: TCardinalDynArray; var Rslt: Integer; var Indx: Integer);
var
  I: Integer;
begin
  Rslt := 0;
  Indx := -1;
  if Length(Data)> 0 then
  begin
    Rslt := Data[Low(Data)];
    Indx := 0;
    for I := Low(Data) + 1 to High(Data) do
      if Rslt < Data[I] then
      begin
        Rslt := Data[I];
        Indx := I;
      end;
  end;
end;

function HexToInt(HexStr : AnsiString) : Int64;
var RetVar : Int64;
    i : byte;
begin
  HexStr := AnsiString(UpperCase(WideString(HexStr)));
  if HexStr[length(HexStr)] = 'H' then
     Delete(HexStr,length(HexStr),1);
  RetVar := 0;

  for i := 1 to length(HexStr) do begin
      RetVar := RetVar shl 4;
      if HexStr[i] in ['0'..'9'] then
         RetVar := RetVar + (byte(HexStr[i]) - 48)
      else
         if HexStr[i] in ['A'..'F'] then
            RetVar := RetVar + (byte(HexStr[i]) - 55)
         else begin
            Retvar := 0;
            break;
         end;
  end;
  Result := RetVar;
end;

function ArrAnsiCharToAnsiStr(const ArrAnsiChar: T256ascii): AnsiString;
var
  i: Integer;
  strLen: Integer;
begin
  SetLength(Result, Length(ArrAnsiChar));
  strLen := 0;
  i:=0;
  while i < Length(ArrAnsiChar) do
  begin
    if ArrAnsiChar[i] <> ''{#32} then
    begin
      Result[i+1] := ArrAnsiChar[i];
      inc(strLen);
    end;
    inc(i);
  end;
  SetLength(Result, strLen);
end;

function AnsiStrToTAscii(const AnsiStr: AnsiString): T256ascii;
var
  i: Integer;
begin
  FillChar(Result, SizeOf(Result), 0{#32});
  i:=0;
  while i < Length(AnsiStr) do
  begin
    Result[i] := AnsiChar(AnsiStr[i+1]);
    inc(i);
  end;
end;

//Достает из строки с нуль-терминированными подстроками следующую нуль-терминированную
//подстроку начиная с позиции aStartPos, потом устанавливает aStartPos на символ
//следующий за терминирующим #0.
function GetNextSubstring(aBuf: string; var aStartPos: integer): string;
var
  vLastPos: integer;
begin
  if (aStartPos < 1) then
    begin
      raise ERangeError.Create('aStartPos должен быть больше 0');
    end;

  if (aStartPos > Length(aBuf) ) then
    begin
      Result := '';
      Exit;
    end;

  vLastPos := PosEx(#0, aBuf, aStartPos);
  Result := Copy(aBuf, aStartPos, vLastPos - aStartPos);
  aStartPos := aStartPos + (vLastPos - aStartPos) + 1;
end;

//Вход: строка, номер выделяемой подстроки, тип разделителя; выход - подстрока.
function GetSubstrG(st: AnsiString; const n: Integer; const dvdr: AnsiString): AnsiString;
var
p : integer;
i: integer;
begin
  for i:=1 to n-1 do
  begin
    p := pos(dvdr,st);
    st := copy(st,p+1,Length(st)-p);
  end;
  p:=pos(dvdr,st);
  if p <> 0 then
    Result := copy(st,1,p-1)
  else
    Result := st;
end;

function fAnsiPos(ASubstr, Str: AnsiString; FromPos: integer): Integer;
var
  P: PAnsiChar;
  S: PAnsiChar;
  SubStr: PAnsiChar;
begin
  Result := 0;
  if (Length(Str) > 0) and
     (Length(ASubstr) > 0) then
  begin
    S := @(Str[1]);
    SubStr := @(ASubstr[1]);
    AnsiStrLower(S);
    AnsiStrLower(SubStr);
    P := AnsiStrPos(S + fromPos - 1, SubStr);
    if P <> nil then
      Result := Integer(P) - Integer(S) + 1;
  end;
end;

function RemoveSymbols(Str: AnsiString; Symbol: AnsiString): AnsiString;
var
  i, j: Integer;
  P: PAnsiChar;
  Str2: AnsiString;
  cnt1: Integer;
begin
  cnt1 := 0;
  SetLength(Str2, Length(Str));
  j := 1;
  i := 1;
  while i < Length(Str) do
  begin
    if Str[i] <> Symbol then
    begin
      Str2[j] := Str[i];
      inc(j);
      inc(cnt1);
    end;
    inc(i);
  end;
  SetLength(Str2, cnt1);
  Result := Str2;
end;

function IIRFilter50HzOrd2(const xk, xk1, xk2, yk1, yk2: Double): Double;//алгоритм расчёта IIR Notch фильтра 50Гц 2-го порядка
begin
  Result := IIRNotch50HzOrd2.b[0] * xk + IIRNotch50HzOrd2.b[1] * xk1 + IIRNotch50HzOrd2.b[2] * xk2 -
            IIRNotch50HzOrd2.a[1] * yk1 - IIRNotch50HzOrd2.a[2] * yk2;
end;

function IIRHPFilter5_500HzOrd2(const xk, xk1, xk2, yk1, yk2: Double): Double;//алгоритм расчёта IIR HP фильтра 5-500Гц 2-го порядка
begin
  Result := IIRHPF5_500HzOrd2.b[0] * xk + IIRHPF5_500HzOrd2.b[1] * xk1 + IIRHPF5_500HzOrd2.b[2] * xk2 -
            IIRHPF5_500HzOrd2.a[1] * yk1 - IIRHPF5_500HzOrd2.a[2] * yk2;
end;

procedure CalcMaxInBuf(APData: PTDoubleDynArray; const ChnlIndx: Integer; const DataCurIndx: Integer; const ANewPortionDataCnt: Integer);
var
  i, k: Integer;
  maxVal: Double;
begin
  k := DataCurIndx;
  maxVal := APData^[k];
  i := 0;
  while (i < ANewPortionDataCnt) do
  begin
    if (Abs(APData^[k]) > 0) and (Abs(APData^[k]) > maxVal) then
    begin
      maxVal := Abs(APData^[k]);
    end;
    k := (k + 1 + CIRCLE_BUF_LEN) mod CIRCLE_BUF_LEN;
    inc(i);
  end;
  SetLength(MaximumsBufData, Length(MaximumsBufData)+1);
  MaximumsBufData[High(MaximumsBufData)] := maxVal;
//  AddLOgMessage('loglog13.txt', FLoatToStr(maxVal));
end;

function CheckAmplData(APData: PTDoubleDynArray; const ChnlIndx: Integer; const DataCurIndx: Integer; const ANewPortionDataCnt: Integer): Boolean;
var
  i, k: Integer;
begin
  Result := False;
  k := DataCurIndx;
  i := 0;
  while (Result = False) and (i < ANewPortionDataCnt) do
  begin
    Result := Abs(APData^[k]) > EMG_AmplThresh;
    k := (k + 1 + CIRCLE_BUF_LEN) mod CIRCLE_BUF_LEN;
    inc(i);
  end;
end;

//перекидываем данные в кольцевой буфер, фильтруем и кидаем в другой кольцевой буфер
procedure Circle_buff_proc(APData: PTDoubleDynArray; const ChnlIndx: Integer; const ANewPortionDataCnt: Integer);
var
  i, k1, k2, k : Integer;
  CurrSamplesTaken: Integer;
  CurrentIndex, DataEndIndex: Integer;
begin
  DataEndIndex := DataEndIndexes[ChnlIndx];
  CurrentIndex := DataEndIndex;
  //переписываем данные из линейного в кольцевой буфер
  CurrSamplesTaken := min(ANewPortionDataCnt, CIRCLE_BUF_LEN - DataEndIndex);

  System.Move(APData^[0], CircBufData[ChnlIndx][DataEndIndex], CurrSamplesTaken * SizeOf(Double));//записываем в конец, сколько получилось
  if(CurrSamplesTaken < ANewPortionDataCnt) then//если есть фрагмент, выходящий за конец буфера, то
  begin
    DataEndIndex := ANewPortionDataCnt - CurrSamplesTaken;//ставим индекс от начала буфера на величину недописанных данных
    CircBufIsFilled[ChnlIndx] := True;
    System.Move(APData^[CurrSamplesTaken], CircBufData[ChnlIndx][0], DataEndIndex * SizeOf(Double));//дописываем фрагмент в начало буфера
  end
  else
  begin
    DataEndIndex := DataEndIndex + CurrSamplesTaken;
    if(DataEndIndex >= CIRCLE_BUF_LEN) then
    begin
      DataEndIndex := DataEndIndex - CIRCLE_BUF_LEN;
      CircBufIsFilled[ChnlIndx] := True;
    end;
  end;
  DataEndIndexes[ChnlIndx] := DataEndIndex;

  k := CurrentIndex;
  i:=0;
  while i < ANewPortionDataCnt do
  begin
    //фильтрация сетевой наводки 50Гц
    k1 := (k - 1 + CIRCLE_BUF_LEN) mod CIRCLE_BUF_LEN;//коррекция индекса для кольцевого массива
    k2 := (k - 2 + CIRCLE_BUF_LEN) mod CIRCLE_BUF_LEN;//коррекция индекса для кольцевого массива
    //notch фильтр 50Hz
    CircBufFilData[ChnlIndx][k] := IIRFilter50HzOrd2(CircBufData[ChnlIndx][k], CircBufData[ChnlIndx][k1], CircBufData[ChnlIndx][k2], CircBufFilData[ChnlIndx][k1], CircBufFilData[ChnlIndx][k2]);
    //ФВЧ 5-500Гц
    CircBufFil2Data[ChnlIndx][k] := IIRHPFilter5_500HzOrd2(CircBufFilData[ChnlIndx][k], CircBufFilData[ChnlIndx][k1], CircBufFilData[ChnlIndx][k2], CircBufFil2Data[ChnlIndx][k1], CircBufFil2Data[ChnlIndx][k2]);
    inc(i);
    k := (k + 1 + CIRCLE_BUF_LEN) mod CIRCLE_BUF_LEN;
  end;

  if (BeginIntrvlFlg) and   //!!!!!!!!!!!!!! разбраться  Должно работать так: RequestType = rtBeginIntrvl;
     (ChnlIndx = EMGChnlIndx) then
    CalcMaxInBuf(@CircBufFil2Data[ChnlIndx], ChnlIndx, CurrentIndex, ANewPortionDataCnt);

  //проверка сигнала по порогу амплитуды
//  dblVal := 0;
//  i := 0;
//  while i < samples do
//  begin
//    dblVal := dblVal + LinearBuf[i];
//    inc(i);
//  end;
  //fmMain.Caption := FloatToStr(dblVal/samples);

//  if CheckAmplData(@CircBufFil2Data[ChnlIndx], ChnlIndx, CurrentIndex, ANewPortionDataCnt) then
//    inc(Cntr2);

  //неплохо бы время события засекать
  if (EMG_EventArise = False) and (CheckAmplData(@CircBufFil2Data[ChnlIndx], ChnlIndx, CurrentIndex, ANewPortionDataCnt)) then
  begin
    EMG_EventAriseTimeCntr := Pc; //засекаем момент события
    EMG_EventArise := True;
  end;
//  if EMG_EventArise then
//    inc(Cntr2);
end;

initialization

  Section := TCriticalSection.Create;

  //IIR notch фильтр 50Гц 2-го порядка Fs=1000
  IIRNotch50HzOrd2.b[0] := 0.99375596495365681;
  IIRNotch50HzOrd2.b[1] := -1.890273484532959;
  IIRNotch50HzOrd2.b[2] :=  0.99375596495365703;

  IIRNotch50HzOrd2.a[0] := 1;
  IIRNotch50HzOrd2.a[1] := -1.890273484532959;
  IIRNotch50HzOrd2.a[2] := 0.98751192990731396;

  //IIR HPF 5-500Hz 2-го порядка Fs=1000
  IIRHPF5_500HzOrd2.b[0] := 0.97803047920655961;
  IIRHPF5_500HzOrd2.b[1] := -1.9560609584131192;
  IIRHPF5_500HzOrd2.b[2] :=  0.97803047920655961;

  IIRHPF5_500HzOrd2.a[0] := 1;
  IIRHPF5_500HzOrd2.a[1] := -1.9555782403150352;
  IIRHPF5_500HzOrd2.a[2] := 0.9565436765112032;

finalization
  Section.Free;

end.
