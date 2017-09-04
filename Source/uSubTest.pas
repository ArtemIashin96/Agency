unit uSubTest;

interface

uses uCommon;

type
  TInterval = record
    EvtActionTimeRltvBeginIntrvl: Integer;
    AlertDurationTime: Integer;
    RTValue: Integer;
    AvrgRTValue: Integer;
    RTValCnt: Integer;
    AmplitudeLimbToUp: Integer;
    AvrgAmplitudeLimbToUp: Integer;
    ReactionVelocityTime: Integer;
    AvrgReactionVelocityTime: Integer;
    AnswerType: TAnswers;
  end;
  TArrIntervals = array of TInterval;

type
  TSubTest = class(TObject)
  private
    FName: string;
    FTestNumber: Integer;
    FIntervals: TArrIntervals;
    FSessionDurationInMs: Integer;
    procedure SetName(const Value: string);
    procedure SetTestNumber(const Value: Integer);
    function GetInterval(Index: Integer): TInterval;
    function GetIntervalsCount: Integer;
    procedure SetSessionDurationInMs(const Value: Integer);

  public
    constructor Create;
    destructor Destroy; override;

    procedure ClearIntervals;
    function AddInterval(AInterval: TInterval): Integer;

    property Name: string read FName write SetName;
    property TestNumber: Integer read FTestNumber write SetTestNumber;
    property Intervals[Index: Integer]: TInterval read GetInterval;
    property IntervalsCount: Integer read GetIntervalsCount;
    property SessionDurationInMs: Integer read FSessionDurationInMs write SetSessionDurationInMs;
   // property AnswerType: TAnswers;
  end;

implementation

{ TSubTest }

function TSubTest.AddInterval(AInterval: TInterval): Integer;
begin
  Result := Length(FIntervals);
  SetLength(FIntervals, Length(FIntervals) + 1);
  FIntervals[Result] := AInterval;
end;

procedure TSubTest.ClearIntervals;
begin
  Finalize(FIntervals);
end;

constructor TSubTest.Create;
begin
  inherited;
end;

destructor TSubTest.Destroy;
begin
  ClearIntervals;
  inherited;
end;

function TSubTest.GetInterval(Index: Integer): TInterval;
begin
  Result := FIntervals[Index];
end;

function TSubTest.GetIntervalsCount: Integer;
begin
  Result := Length(FIntervals);
end;

procedure TSubTest.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TSubTest.SetSessionDurationInMs(const Value: Integer);
begin
  FSessionDurationInMs := Value;
end;

procedure TSubTest.SetTestNumber(const Value: Integer);
begin
  FTestNumber := Value;
end;

end.
