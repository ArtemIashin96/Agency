unit uHasWonMsg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, JvTimer, TeEngine, Series, TeeProcs, Chart, Dialogs,
  ComCtrls, mmSystem, uJoys, uCommon, JvExControls, JvxSlider, Mask, JvExMask,
  JvSpin;

type
  TfmHasWon = class(TForm)
    Bevel1: TBevel;
    tmrAutoCloseWnd: TJvTimer;
    lblMsg: TLabel;
    chrtCommonCriteria: TChart;
    srsCurCommonCriteria: TBarSeries;
    btnOk: TButton;
    redtInstruction: TRichEdit;
    rgrpsAnswer: TGroupBox;
    SldrAgencyVal: TJvxSlider;
    tmrDraw: TJvTimer;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label3: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edtAgencyVal: TEdit;
    btn_7: TButton;
    btn_8: TButton;
    btn_9: TButton;
    btn_4: TButton;
    btn_5: TButton;
    btn_6: TButton;
    btn_1: TButton;
    btn_2: TButton;
    btn_3: TButton;
    btn_0: TButton;
    GroupBox1: TGroupBox;
    SpnEdFeedbackSignalDelay: TJvSpinEdit;
    edtAlertDurationTime: TEdit;
    Label1: TLabel;
    btn_C: TButton;
    procedure tmrAutoCloseWndTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmrDrawTimer(Sender: TObject);
    procedure SldrAgencyValChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnDigitalBtnsClick(Sender: TObject);
    procedure SpnEdFeedbackSignalDelayChange(Sender: TObject);
    procedure btn_CClick(Sender: TObject);
  private
    { Private declarations }
    FTimeInSec: Integer;
    FAgencySldrVal: Integer;
    procedure SetAgencySldrVal(const Value: Integer);
  public
    { Public declarations }
    procedure WndCloseAttempt;
    property AgencySldrVal: Integer read FAgencySldrVal write SetAgencySldrVal;
  end;

  procedure ProcMMTime1(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD) stdcall;

var
  fmHasWon: TfmHasWon;
  NeedSwitchUp: Boolean = True;
  NeedSwitchDown: Boolean = True;
  NeedBtnFireDown: Boolean = True;
  TmrID: UInt;
  JYoke2: TJoyInfo;
  WatchDogCntr: Int64;
  MaestroReoPos2: Word;

implementation

{$R *.dfm}

procedure ProcMMTime1(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD) stdcall;
begin
//  inc(WatchDogCntr);
//  MaestroGetPosition(0, MaestroReoPos2);

//  joygetpos(JoyYokeID,@JYoke2);//штурвал
//  if NeedSwitchDown = False then
//    NeedSwitchDown := JYoke2.wButtons = 256;
//  if (JYoke2.wButtons = 264) and (NeedSwitchDown) then
//  begin
//    NeedSwitchDown := False;
//    if fmHasWon.rgrpsAnswer.ItemIndex < fmHasWon.rgrpsAnswer.Items.Count-1 then
//      fmHasWon.rgrpsAnswer.ItemIndex := fmHasWon.rgrpsAnswer.ItemIndex + 1
//    else
//      fmHasWon.rgrpsAnswer.ItemIndex := 0;
//  end;
//
//  if NeedSwitchUp = False then
//    NeedSwitchUp := JYoke2.wButtons = 256;
//  if (JYoke2.wButtons = 260) and (NeedSwitchUp) then
//  begin
//    NeedSwitchUp := False;
//    if fmHasWon.rgrpsAnswer.ItemIndex > 0 then
//      fmHasWon.rgrpsAnswer.ItemIndex := fmHasWon.rgrpsAnswer.ItemIndex - 1
//    else
//      fmHasWon.rgrpsAnswer.ItemIndex := fmHasWon.rgrpsAnswer.Items.Count-1;
//  end;
//
//  if NeedBtnFireDown = False then
//    NeedBtnFireDown := JYoke2.wButtons = 256;
//  if (JYoke2.wButtons = 258) and (NeedBtnFireDown) then
//  begin
//    NeedBtnFireDown := False;
//    fmHasWon.WndCloseAttempt;
//   // btnOk.Click;
//  end;
end;

procedure TfmHasWon.btnOkClick(Sender: TObject);
begin
  WndCloseAttempt;
end;

procedure TfmHasWon.btn_CClick(Sender: TObject);
begin
  SpnEdFeedbackSignalDelay.Value := 0;
end;

procedure TfmHasWon.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Action := caFree;
//  if TmrID <> 0 then
//     timeKillEvent(TmrID);
end;

procedure TfmHasWon.FormCreate(Sender: TObject);
begin
  FTimeInSec := 3;
  NeedSwitchUp := True;
  NeedSwitchDown := True;
  NeedBtnFireDown := True;

  fmHasWon := Self;
//  if TmrID <> 0 then
//     timeKillEvent(TmrID);
//  TmrID := timeSetEvent(10, 1, @ProcMMTime1, Cardinal(0), TIME_PERIODIC);
end;

procedure TfmHasWon.FormDestroy(Sender: TObject);
begin
  fmHasWon := nil;
end;

procedure TfmHasWon.FormKeyPress(Sender: TObject; var Key: Char);
var
  intVal: Integer;
begin
//  if Ord(Key) = 13 {Enter} then
//    Close
//  else
//  begin
//    intVal := StrToIntDef(Key, -1);
//    if intVal <> -1 then
//      inc(intVal);
//    SldrAgencyVal.Value := intVal;
//    edtAgencyVal.Text := IntToStr(intVal);
//  end;
end;

procedure TfmHasWon.btnDigitalBtnsClick(Sender: TObject);
var
  intVal: Integer;
begin
  tmrAutoCloseWnd.Enabled := False;
//  intVal := StrToIntDef((Sender as TButton).Caption, -1);
//  inc(intVal);
//  SldrAgencyVal.Value := intVal;
//  edtAgencyVal.Text := IntToStr(intVal);
  SpnEdFeedbackSignalDelay.Value := SpnEdFeedbackSignalDelay.Value * 10 + (Sender as TButton).Tag;
end;

procedure TfmHasWon.WndCloseAttempt;
begin
//  if (rgrpsAnswer.Visible = True) and (rgrpsAnswer.ItemIndex = -1) then
//  begin
//   btnOk.ModalResult := mrNone;
////   ShowMessage('Выберите вариант ответа!');
//  end
//  else
//  begin
//    btnOk.ModalResult := mrOk;
////    JvTimer1.Enabled := False;
//  if TmrID <> 0 then
//     timeKillEvent(TmrID);
//    Close;
//  end;
  tmrAutoCloseWnd.Enabled := False;
//  if TmrID <> 0 then
//     timeKillEvent(TmrID);
  btnOk.ModalResult := mrOk;
  Close;
end;

procedure TfmHasWon.tmrAutoCloseWndTimer(Sender: TObject);
begin
  dec(FTimeInSec);
  Caption := ' Время до закрытия окна: ' + IntToStr(FTimeInSec);
  if FTimeInSec = 0 then
    Close;
////  joygetpos(JoyYokeID,@JYoke);//штурвал
//  if NeedSwitchDown = False then
//    NeedSwitchDown := JYoke.wButtons = 256;
//  if (JYoke.wButtons = 264) and (NeedSwitchDown) then
//  begin
//    NeedSwitchDown := False;
//    if rgrpsAnswer.ItemIndex < rgrpsAnswer.Items.Count-1 then
//      rgrpsAnswer.ItemIndex := rgrpsAnswer.ItemIndex + 1
//    else
//      rgrpsAnswer.ItemIndex := 0;
//  end;
//
//  if NeedSwitchUp = False then
//    NeedSwitchUp := JYoke.wButtons = 256;
//  if (JYoke.wButtons = 260) and (NeedSwitchUp) then
//  begin
//    NeedSwitchUp := False;
//    if rgrpsAnswer.ItemIndex > 0 then
//      rgrpsAnswer.ItemIndex := rgrpsAnswer.ItemIndex - 1
//    else
//      rgrpsAnswer.ItemIndex := rgrpsAnswer.Items.Count-1;
//  end;
//
//  if NeedBtnFireDown = False then
//    NeedBtnFireDown := JYoke.wButtons = 256;
//  if (JYoke.wButtons = 258) and (NeedBtnFireDown) then
//  begin
//    NeedBtnFireDown := False;
//    WndCloseAttempt;
//   // btnOk.Click;
//  end;
//
////  Caption := IntToStr(JYoke.wButtons);
end;

procedure TfmHasWon.SetAgencySldrVal(const Value: Integer);
begin
  if Value <> FAgencySldrVal then
  begin
   // WatchDogCntr := 0;
   // FTimeInSec := 3;
    tmrAutoCloseWnd.Enabled := False;
  end;
  FAgencySldrVal := Value;
end;

procedure TfmHasWon.SldrAgencyValChange(Sender: TObject);
begin
  AgencySldrVal := SldrAgencyVal.Value;
//  if SldrAgencyVal.Value = 0 then
//    FTimeInSec := 3;
//  JvTimer1.Enabled := SldrAgencyVal.Value <> 0;
end;

procedure TfmHasWon.SpnEdFeedbackSignalDelayChange(Sender: TObject);
begin
  tmrAutoCloseWnd.Enabled := False;
end;

procedure TfmHasWon.tmrDrawTimer(Sender: TObject);
var
  strVal: string;
  mpos: Word;
begin
//  MaestroGetPosition(0, MaestroReoPos2);//с потенциометра получаются значения 0..1023
  inc(WatchDogCntr);
//  mpos := MaestroReoPos2;
//  if (mpos >= 0) and (mpos <= 3) then //с учётом дребезга потенциометра на крайнем значении
//    strVal := 'N/A';
//  if (mpos > 3) and (mpos <= 102.3) then
//    strVal := '1';
//  if (mpos > 102.3) and (mpos <= 204.6) then
//    strVal := '2';
//  if (mpos > 204.6) and (mpos <= 306.9) then
//    strVal := '3';
//  if (mpos > 306.9) and (mpos <= 409.2) then
//    strVal := '4';
//  if (mpos > 409.2) and (mpos <= 511.5) then
//    strVal := '5';
//  if (mpos > 511.5) and (mpos <= 613.8) then
//    strVal := '6';
//  if (mpos > 613.8) and (mpos <= 716.1) then
//    strVal := '7';
//  if (mpos > 716.1) and (mpos <= 818.4) then
//    strVal := '8';
//  if (mpos > 818.4) and (mpos <= 920.7) then
//    strVal := '9';
//  if (mpos > 920.7) and (mpos <= 1023) then
//    strVal := '10';
//
//  if strVal <> 'N/A' then
//    fmHasWon.SldrAgencyVal.Value := StrToInt(strVal)
//  else
//    fmHasWon.SldrAgencyVal.Value := 0;
//
//  edtAgencyVal.Text := strVal;

  tmrAutoCloseWnd.Enabled := WatchDogCntr >= 3;
end;

end.
