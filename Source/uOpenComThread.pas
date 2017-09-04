unit uOpenComThread;

interface

uses Classes, Windows, SysUtils, uCommon, Dialogs;

type
  TOpenComThread = class(TThread)
  private
    FPComVar: TPComVar;
    FComVisibility: Boolean;
    FExitEvent: THandle;
//    FThreadTerminated: Boolean;
    procedure SetPComVar(const Value: TPComVar);
    procedure SetComVisibility(const Value: Boolean);
    procedure SetExitEvent(const Value: THandle);
//    procedure SetThreadTerminated(const Value: Boolean);

  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;

    procedure Init;
    procedure Term;
    property PComVar: TPComVar read FPComVar write SetPComVar;
    property ExitEvent: THandle read FExitEvent write SetExitEvent;
    property ComVisibility: Boolean read FComVisibility write SetComVisibility;
//    property ThreadTerminated: Boolean read FThreadTerminated write SetThreadTerminated;
  end;

implementation

{ TOpenComThread }

constructor TOpenComThread.Create;
begin
  inherited Create(CreateSuspended);
  Init;
end;

destructor TOpenComThread.Destroy;
begin
  Term;
  inherited;
end;

procedure TOpenComThread.Execute;
var
  portName: AnsiString;
begin
  FComVisibility := False;
  if PComVar <> nil then
  begin
    try
      PComVar^.hCom := INVALID_HANDLE_VALUE;
      PComVar^.ComVisibility := False;
      portName := ArrAnsiCharToAnsiStr(PComVar^.PortName);

      {FThreadTerminated := not} ResetEvent(FExitEvent);

      while (not Terminated) and
            (PComVar^.hCom = INVALID_HANDLE_VALUE) and
            (portName <> '') do
      begin
        //попытка открыть порт
        PComVar^.hCom := CreateFile(PChar('\\.\' + WideString(portName)),GENERIC_READ or GENERIC_WRITE,0,nil,OPEN_EXISTING,
            FILE_FLAG_OVERLAPPED,0);
        try
          Sleep(200);
        except
          CloseHandle(PComVar^.hCom);
          PComVar^.hCom := 0;
        end;
      end;
      if (PComVar^.hCom <> INVALID_HANDLE_VALUE) and (PComVar^.hCom <> 0) then
      begin
        FComVisibility := True;
        CloseHandle(PComVar^.hCom);
        PComVar^.hCom := 0;
      end;
    except
      CloseHandle(PComVar^.hCom);
      PComVar^.hCom := 0;
    end;
  end;

  ComVar.ComVisibility := ComVisibility;
  PComVar := nil;
  {FThreadTerminated :=} SetEvent(FExitEvent);
end;

procedure TOpenComThread.Init;
begin
//  FThreadTerminated := False;
end;

procedure TOpenComThread.SetComVisibility(const Value: Boolean);
begin
  FComVisibility := Value;
end;

procedure TOpenComThread.SetExitEvent(const Value: THandle);
begin
  FExitEvent := Value;
end;

procedure TOpenComThread.SetPComVar(const Value: TPComVar);
begin
  FPComVar := Value;
end;

//procedure TOpenComThread.SetThreadTerminated(const Value: Boolean);
//begin
//  FThreadTerminated := Value;
//end;

procedure TOpenComThread.Term;
begin
  CloseHandle(FExitEvent);
end;

end.
