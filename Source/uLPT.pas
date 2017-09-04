unit uLPT;

interface

uses Windows, mmSystem, SysUtils, JvTimer;

  function Inp32(PortAdr: word): byte; stdcall; external 'inpout32.dll';
  function Out32(PortAdr: word; Data: byte): byte; stdcall; external 'inpout32.dll';
  function IsInpOutDriverOpen(): Boolean; stdcall; external 'inpout32.dll';

  function SendMarker(const Acode: Byte): Byte;
  function LPTPortReset: Boolean;
  function SendTrigger(const Data: Byte): Byte;
  function ReceiveTrigger(): String;
  procedure KillTimerEvent(var tmId: Cardinal);
  procedure ProcMMTimeLPT(uTimerID, uMessage: UINT; dwUse, dw1, dw2: DWORD) stdcall;

var
  LPTAdress: Word;
  LPTAdress2: Word;
  FMTEventID: UINT;
  WorkWithLPT: Boolean = False;
//  LPTPortWasReset: Boolean = False;

implementation

procedure KillTimerEvent(var tmId: Cardinal);
begin
  if tmId <> 0 then
  begin
    timeKillEvent(tmId);
    tmId := 0;
  end;
end;

procedure ProcMMTimeLPT(uTimerID, uMessage: UINT; dwUse, dw1, dw2: DWORD) stdcall;
var
  i,j: Integer;
//  ii: IInvestigationInterface;
  res: Boolean;
  varTime: Integer;
  indx: Integer;
  codeUnit: Integer;
begin
  res := True;
//  ii := IInvestigationInterface(dwUse);
//  if ii <> nil then
  begin
    Out32(LPTAdress, 0);
//    LPTPortWasReset := True;
//    KillTimerEvent(FMTEventID);
  end;
end;

function SendMarker(const Acode: Byte): Byte;
begin
   if FMTEventID <> 0 then
    timeKillEvent(FMTEventID);
  Result := SendTrigger(Acode);
//  LPTPortWasReset := False;
  FMTEventID := timeSetEvent(4, 2, @ProcMMTimeLPT, Cardinal(0), TIME_ONESHOT);
//  while not LPTPortWasReset do
//  begin
//    Application.
//  end;
end;

function LPTPortReset: Boolean;
begin
  Result := False;
  if IsInpOutDriverOpen then
  begin
    Out32(LPTAdress + 2, 0);
    Out32(LPTAdress2 + 2, 0);
    Out32(LPTAdress, 0);
    Result := True;
  end;
end;

function SendTrigger(const Data: Byte): Byte;
begin
  Result := 0;
//  if IInvestigation <> nil then
  begin
    Result := Out32(LPTAdress, Data);
  end;
end;

function ReceiveTrigger(): String;
var
  data: byte;
//  portAdr: Word;
  str: string;
begin
  Result := '';
//  if IInvestigation <> nil then
  begin
    str := '';
//    data := 43;
//    Out32(LPT_BASE_ADDR + 2, data);
//    Out32(LPT_BASE_ADDR2 + 2, data);

    data := Inp32(LPTAdress);
    str := IntToStr(data);
    data := Inp32(LPTAdress2);
    str := str + ' ' + IntToStr(data);
    Result :=  str;  //!!
  end;
end;

end.
