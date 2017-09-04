unit uJoys;

interface

uses Types, Windows, Math, mmSystem, uCommon;

type
  TWorkMode = (wmNone, wmGettingData, wmNeedCalculateData, wmCalculatedData);

type
  T4Point = packed record
    X0: Integer;
    T: Cardinal;
    X1: Integer;
    X2: Integer;
    X3: Integer;
  end;
  TArrayOf3Point = array of T4Point;

type
  TJoyPosValues = record
    WPos: Cardinal;
    Wpos1: Cardinal;
    Wpos2: Cardinal;
    WPosTime: Cardinal;
    DifPos: Integer;
    MaxPos: Cardinal;//максимально возможная позиция оси
    MinPos: Cardinal;//минимально возможная позиция оси
    Values: TCardinalDynArray;
    Times: TCardinalDynArray;
    Flg: Boolean;
    ValuesIsFull: Boolean;
  end;

  function GetJoyDifPos_(var AJoy: TJoyPosValues; const APos: Cardinal): Integer;
  function AddJoyPosition_(var AJoy: TJoyPosValues): Integer;
  function AddToeValues_(var AJoy: TJoyPosValues): Integer;
  procedure JoyValuesClear_(var AJoy: TJoyPosValues);
  function GetVelocityCoefByPartialDerivativeValue_(const APartialDerivativeValue: Integer): Double;
  procedure GetLimbMoveCriteria_(var AJoy: TJoyPosValues; var MoveCritUp, MoveCritDown: Double; var RltvVelUp, RltvVelDown: Integer; var TimeInMaxUp, TimeInMaxDown: Cardinal);
  function GetKCoefByDelayValue_(const ADelayVal: Integer): Double;
  function GetDifTimeAllAxis_(const t1, t2: Cardinal): Cardinal;
  procedure CalcCommonCriteria_;
  //
  procedure ClearCommonCritArray;
  function AddCommonCritToArray(const AValue: Double): Integer;
  procedure ClearCommonDeSynchValuesArray;
  function AddCommonDeSynchValueToArray(const AValue: Double): Integer;
  procedure ClearCommonRltvVelocityValuesArray;
  function AddCommonRltvVelocityValueToArray(const AValue: Double): Integer;

var
  WorkMode: TWorkMode;
  JPedals: TJoyInfo;
  JoyPedalsID: Cardinal;
  LimbOneData, LimbTwoData: TJoyPosValues;
  WatchdogCntr: Int64;
  difPosLO, difPosLT: Integer;
  moveLTUpCriteria, moveLTDownCriteria: Double;
  moveLOUpCriteria, moveLODownCriteria: Double;
  SynchroCriteria: Double;
  LTMaxTimeUp, LTMinTimeDown: Cardinal;
  LOMaxTimeUp, LOMinTimeDown: Cardinal;
  DifMaxTimeUp, DifMinTimeDown: Integer;
  LTRltvVelUp, LTRltvVelDown, LORltvVelUp, LORltvVelDown: Integer;
  difTimeMaxLOLT, difTimeMinLOLT: Cardinal;
  CommonRltvVelocity: Integer;
  LTFullCritValue, LOFullCritValue: Double;
  CommonCriteria: Double;
  EmulLimbOne_wxpos, EmulLimbTwo_wypos: Cardinal;
  EmulationModeOn: Boolean;
  EmulVelLPUp_Delay: Integer;
  EmulVelLPDown_Delay: Integer;
  EmulNeedLPDelayMoveToUp: Boolean;
  EmulNeedLPMoveToUp: Boolean;
  EmulNeedRPMoveToUp: Boolean;
  ADynIntArr: TArrayOf3Point;
  NeedCtrlUpdate: Boolean;
  DelayMin: Integer;//надо сделать тестовый период, в котором настроить индивидуально переменные
  DelayMax: Integer;//от них зависит какие знач-я буду приходиться на д-н 0..1
  PartialDerivativeMin: Integer;
  PartialDerivativeMax: Integer;
  NeedBtnFire2Down: Boolean = True;
  Cntr64: Int64;
  CommonDeSynch: Integer;
  //
  CommonCritArray: TDoubleDynArray;
  CommonDeSynchValuesArray: TDoubleDynArray;
  CommonRltvVelocityValuesArray: TDoubleDynArray;
  CommonRltvVelocityPrcntl_Lo: Double;
  CommonRltvVelocityPrcntl_Med: Double;
  CommonRltvVelocityPrcntl_Hi: Double;
  CommonDeSynchPrcntl_Lo: Double;
  CommonDeSynchPrcntl_Med: Double;
  CommonDeSynchPrcntl_Hi: Double;

implementation

function GetJoyDifPos_(var AJoy: TJoyPosValues; const APos: Cardinal): Integer;
var
  minVal, maxVal: Integer;
begin
  Result := -1;
  if APos <> AJoy.WPos then
  begin
    QueryPerformanceCounter(Pc2);
    AJoy.WPos := APos;
    AJoy.WPosTime := Trunc(((Pc2 - Pc1)/Pf * 1000) + 0.5);//GetTickCount не успевает!;
    if AJoy.Flg then
      AJoy.Wpos1 := APos
    else
      AJoy.Wpos2 := APos;
    AJoy.Flg := not AJoy.Flg;

    minVal := Min(AJoy.Wpos1, AJoy.Wpos2);
    maxVal := Max(AJoy.Wpos1, AJoy.Wpos2);
    Result := maxVal - minVal;
  end;
end;

function AddJoyPosition_(var AJoy: TJoyPosValues): Integer;
begin
  Result := 0;
  if not AJoy.ValuesIsFull then
  begin
    AddToeValues_(AJoy);
  end
  else
    JoyValuesClear_(AJoy);
end;

function AddToeValues_(var AJoy: TJoyPosValues): Integer;
begin
  SetLength(AJoy.Values, Length(AJoy.Values)+1);
  AJoy.Values[High(AJoy.Values)] := AJoy.WPos;

  SetLength(AJoy.Times, Length(AJoy.Times)+1);
  AJoy.Times[High(AJoy.Times)] := AJoy.WPosTime;

  AJoy.ValuesIsFull := Length(AJoy.Values) >= 2000;
  Result := Length(AJoy.Values);
end;

procedure JoyValuesClear_(var AJoy: TJoyPosValues);
begin
  AJoy.WPos := AJoy.MinPos;
  AJoy.Wpos1 := AJoy.MinPos;
  AJoy.Wpos2 := AJoy.MinPos;
  AJoy.WPosTime := 0;
  AJoy.DifPos := 0;
  AJoy.Flg := True;
  SetLength(AJoy.Values, 0);
  SetLength(AJoy.Times, 0);
  AJoy.ValuesIsFull := False;
end;

function GetVelocityCoefByPartialDerivativeValue_(const APartialDerivativeValue: Integer): Double;
const
  VelocityCoefMin: Integer = 0;
  VelocityCoefMax: Integer = 1;
var
  VelCoef: Double;
  fraction: Integer;
begin
  fraction := max(PartialDerivativeMin, min(PartialDerivativeMax, APartialDerivativeValue));

  VelCoef :=  VelocityCoefMin + (VelocityCoefMax - VelocityCoefMin) * ((fraction - PartialDerivativeMin) / (PartialDerivativeMax - PartialDerivativeMin) );
  Result := 1 - VelCoef{max(VelocityCoefMin, min(VelocityCoefMax, VelCoef))};
end;

procedure GetLimbMoveCriteria_(var AJoy: TJoyPosValues; var MoveCritUp, MoveCritDown: Double; var RltvVelUp, RltvVelDown: Integer; var TimeInMaxUp, TimeInMaxDown: Cardinal);
var
  x_max: Integer;
  xi_max: Integer;
  amplitude: Integer;
//  timeRelativeVelocity: Integer;
begin
  MoveCritUp := 0;
  MoveCritDown := 0;
  TimeInMaxUp := 0;
  TimeInMaxDown := 0;
  if Length(AJoy.Values) >= 3 then //должно быть минимум 3 точки - начало-максимум-конец
  begin
    MaxIntValue2(AJoy.Values, x_max, xi_max);
    //амп-да и скорость нарастания при движении вверх
    amplitude := Abs(x_max - Integer(AJoy.Values[Low(AJoy.Values)]));
    //AmplitudeLimbToUp := amplitude;//!! надо бы потом сделать красивше
    RltvVelUp{timeRelativeVelocity} := AJoy.Times[xi_max] - AJoy.Times[Low(AJoy.Values)];//время точки с максимальной амплитудой при движении вперёд относительно начала
    TimeInMaxUp := AJoy.Times[xi_max];//время относительно начала работы проги
    MoveCritUp := amplitude/(AJoy.MaxPos - AJoy.MinPos) * GetVelocityCoefByPartialDerivativeValue_(RltvVelUp);
    //амп-да и скорость нарастания при движении вниз
    amplitude := Abs(x_max - Integer(AJoy.Values[High(AJoy.Values)]));
    RltvVelDown{timeRelativeVelocity} := AJoy.Times[High(AJoy.Values)] - AJoy.Times[xi_max];//разница t конца и максимума
    TimeInMaxDown := AJoy.Times[High(AJoy.Values)];//время относительно начала работы проги
    TimeLimbToUpDown := TimeInMaxDown - TimeInMaxUp;//время движения вверх-вниз !! значения тут какие-то странные!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    MoveCritDown := amplitude/(AJoy.MaxPos - AJoy.MinPos) * GetVelocityCoefByPartialDerivativeValue_(RltvVelDown);
  end;
end;

function GetKCoefByDelayValue_(const ADelayVal: Integer): Double;
const
  KCoefMin: Integer = 0;
  KCoefMax: Integer = 1;
var
  KCoefVal: Double;
  fraction: Integer;
begin
  fraction := max(DelayMin, min(DelayMax, ADelayVal));

  KCoefVal := KCoefMin + (KCoefMax - KCoefMin) * ((fraction - DelayMin) / (DelayMax - DelayMin) );
  Result := 1 - KCoefVal;//max(KCoefMin, min(KCoefMax, KCoefVal));
end;

function GetDifTimeAllAxis_(const t1, t2: Cardinal): Cardinal;
var
  minVal: Integer;
  maxVal: Integer;
begin
  minVal := Min(t1, t2);
  maxVal := Max(t1, t2);
  Result := maxVal - minVal;
end;

procedure CalcCommonCriteria_;
begin
  if WorkMode = wmNeedCalculateData then
  begin
    //средняя задержка по осям вверх-вниз
    //difTimeMaxLOLT := GetDifTimeAllAxis_(LOMaxTimeUp, LTMaxTimeUp);
    //difTimeMinLOLT := GetDifTimeAllAxis_(LOMinTimeDown, LTMinTimeDown);

    //CommonDeSynch := Trunc(((difTimeMaxLOLT + difTimeMinLOLT) / 2) + 0.5);
    //SynchroCriteria := GetKCoefByDelayValue_(CommonDeSynch);//перевод в шкалу 0..1

    //среднее по критериям вверх-вниз отдельно по педалям
    LOFullCritValue := (moveLOUpCriteria + moveLODownCriteria)/2;
    //LTFullCritValue := (moveLTUpCriteria + moveLTDownCriteria)/2;

    //вкрячим отдельно расчёт средней скорости по всем осям и направлениям. Надо для опред-я индивидуальных мин-максов
    CommonRltvVelocity := Trunc((({LTRltvVelUp + LTRltvVelDown +} LORltvVelUp + LORltvVelDown) /2) + 0.5);

    //полный общий критерий учитывает синхронность движений
    CommonCriteria := (LOFullCritValue {+ LTFullCritValue})/1{3 if isYoke} {* SynchroCriteria};
    WorkMode := wmCalculatedData;
  end;
end;

procedure ClearCommonCritArray;
begin
  Finalize(CommonCritArray);
end;

function AddCommonCritToArray(const AValue: Double): Integer;
begin
  SetLength(CommonCritArray, Length(CommonCritArray)+1);
  CommonCritArray[High(CommonCritArray)] := AValue;
  Result := Length(CommonCritArray);
end;

procedure ClearCommonDeSynchValuesArray;
begin
  Finalize(CommonDeSynchValuesArray);
end;

function AddCommonDeSynchValueToArray(const AValue: Double): Integer;
begin
  SetLength(CommonDeSynchValuesArray, Length(CommonDeSynchValuesArray)+1);
  CommonDeSynchValuesArray[High(CommonDeSynchValuesArray)] := AValue;
  Result := Length(CommonDeSynchValuesArray);
end;

procedure ClearCommonRltvVelocityValuesArray;
begin
  Finalize(CommonRltvVelocityValuesArray);
end;

function AddCommonRltvVelocityValueToArray(const AValue: Double): Integer;
begin
  SetLength(CommonRltvVelocityValuesArray, Length(CommonRltvVelocityValuesArray)+1);
  CommonRltvVelocityValuesArray[High(CommonRltvVelocityValuesArray)] := AValue;
  Result := Length(CommonRltvVelocityValuesArray);
end;

end.
