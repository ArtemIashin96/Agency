unit uSettingsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExControls, JvxSlider, Mask, JvExMask, JvSpin, ComCtrls,
  uCommon, ExtCtrls;

type
  TfmSettings = class(TForm)
    Button1: TButton;
    GroupBox7: TGroupBox;
    Label24: TLabel;
    CmbBxScrAdj: TComboBox;
    ChBxFullScr: TCheckBox;
    Button2: TButton;
    GroupBox1: TGroupBox;
    SEdBoardSize: TJvSpinEdit;
    SEdAIPower: TJvSpinEdit;
    SEdGoalLineCnt: TJvSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    tpSessionDuration: TDateTimePicker;
    Label30: TLabel;
    rgrpExpVariants: TRadioGroup;
    ChkBxDialogAutoHideTimer: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure rgrpExpVariantsClick(Sender: TObject);
    procedure tpSessionDurationChange(Sender: TObject);
  private
    { Private declarations }
    FFullScreenMode: Boolean;
    FVidModeSelectedIndex: Integer;
    FBoardSize: Integer;
    FAIPower: Integer;
    FGoalLineCnt: Integer;
    FSessionDurationInMs: Int64;
    FAllowDialogAutoHideTimer: Boolean;
    ExpVariant: Integer;
    FLockedCtrls: Boolean;
    procedure SetLockedCtrls(const Value: Boolean);
  public
    { Public declarations }
    function ScreenSettingsChanged: Boolean;
    function GameSettingsChanged: Boolean;
    property LockedCtrls: Boolean read FLockedCtrls write SetLockedCtrls;
  end;

//var
//  fmSettings: TfmSettings;

implementation

{$R *.dfm}

procedure TfmSettings.FormActivate(Sender: TObject);
begin
  FFullScreenMode := ChBxFullScr.Checked;
  FVidModeSelectedIndex := CmbBxScrAdj.ItemIndex;
  FAIPower := Trunc(SEdAIPower.Value);
  FAllowDialogAutoHideTimer := ChkBxDialogAutoHideTimer.Checked;
  FBoardSize := Trunc(SEdBoardSize.Value);
  FGoalLineCnt := Trunc(SEdGoalLineCnt.Value);
  FSessionDurationInMs := GetTimeInMilliseconds(tpSessionDuration.DateTime);
  ExpVariant := rgrpExpVariants.ItemIndex;
end;

function TfmSettings.ScreenSettingsChanged: Boolean;
begin
  Result := (ChBxFullScr.Checked <> FFullScreenMode) or
            (CmbBxScrAdj.ItemIndex <> FVidModeSelectedIndex);
end;

procedure TfmSettings.SetLockedCtrls(const Value: Boolean);
begin
  FLockedCtrls := Value;
end;

procedure TfmSettings.tpSessionDurationChange(Sender: TObject);
begin
//  FSessionDurationInMs := GetTimeInMilliseconds(tpSessionDuration.DateTime);
end;

function TfmSettings.GameSettingsChanged: Boolean;
begin
  Result := (Trunc(SEdAIPower.Value) <> FAIPower) or
            (Trunc(SEdBoardSize.Value) <> FBoardSize) or
            (Trunc(SEdGoalLineCnt.Value) <> FGoalLineCnt) or
            (GetTimeInMilliseconds(tpSessionDuration.DateTime) <> FSessionDurationInMs) or
            (ChkBxDialogAutoHideTimer.Checked <> FAllowDialogAutoHideTimer) or
            (rgrpExpVariants.ItemIndex <> ExpVariant);
end;

procedure TfmSettings.rgrpExpVariantsClick(Sender: TObject);
begin
  if not FLockedCtrls then
  begin
    if rgrpExpVariants.ItemIndex = 6 then
    begin
      tpSessionDuration.DateTime := SetTimeByMilliseconds(120000);
    end
    else
      tpSessionDuration.DateTime := SetTimeByMilliseconds(FSessionDurationInMs);
  end;
end;

end.
