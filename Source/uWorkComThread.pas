unit uWorkComThread;

interface

uses Classes, Windows, uCommon, SysUtils, uDebugLog, Dialogs;

type
  TWorkComThread = class(TThread)
  private
    FPComVar: TPComVar;
    FHandle: THandle;
    FExitEvent: THandle;
//    FThreadTerminated: Boolean;
    procedure SetPComVar(const Value: TPComVar);
    procedure SetHandle(const Value: THandle);
    procedure SetExitEvent(const Value: THandle);
//    procedure SetThreadTerminated(const Value: Boolean);

  protected
    procedure Execute; override;

  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;

    property PComVar: TPComVar read FPComVar write SetPComVar;
    property Handle: THandle read FHandle write SetHandle;
    property ExitEvent: THandle read FExitEvent write SetExitEvent;
//    property ThreadTerminated: Boolean read FThreadTerminated write SetThreadTerminated;
  end;

function ChckSyncMask(const pX, pMask: Pointer): Boolean;
function ChckCmdMask(const pX, pMask: Pointer): Boolean;

implementation

function ChckSyncMask(const pX, pMask: Pointer): Boolean;
begin
  Result := (Byte(Pointer(Integer(pX)+0)^) = Byte(Pointer(Integer(pMask)+0)^)) and
            (Byte(Pointer(Integer(pX)+7)^) = Byte(Pointer(Integer(pMask)+7)^)) and
            (Byte(Pointer(Integer(pX)+8)^) = Byte(Pointer(Integer(pMask)+8)^));
end;

function ChckCmdMask(const pX, pMask: Pointer): Boolean;
begin
  Result := (Byte(Pointer(Integer(pX) + 1)^) = Byte(Pointer(Integer(pMask) + 1)^)) and
            (Byte(Pointer(Integer(pX) + 2)^) = Byte(Pointer(Integer(pMask) + 2)^));
//            (Byte(Pointer(Integer(pX) + 3)^) = Byte(Pointer(Integer(pMask) + 3)^)) and
//            (Byte(Pointer(Integer(pX) + 4)^) = Byte(Pointer(Integer(pMask) + 4)^)) and
//            (Byte(Pointer(Integer(pX) + 5)^) = Byte(Pointer(Integer(pMask) + 5)^));
end;

{ TWorkComThread }

constructor TWorkComThread.Create;
begin
  inherited Create(CreateSuspended);
 // FThreadTerminated := False;
end;

destructor TWorkComThread.Destroy;
begin
  if (FExitEvent <> INVALID_HANDLE_VALUE) or
     (FExitEvent <> 0) then
    CloseHandle(FExitEvent);
  inherited;
end;

procedure TWorkComThread.Execute;
var
  Kols,Mask,Trans,Errs: DWord;
  Ovr: TOverlapped;
  Buff: array [0..511] of Byte;
  Modems, LenPacket : DWord;
//  Receiv: Pointer;
  pRB: Pointer;
  ComVar: TComVar;
  i: Integer;
begin
  ComVar :=  PComVar^;
  FillChar(Buff,SizeOf(Buff),0);//�������������� �����
  FillChar(ComVar.ReceivBuf,SizeOf(ComVar.ReceivBuf),0);
  //�������������� TOverlapped ���������
  FillChar(Ovr,SizeOf(TOverlapped),0);
  Ovr.hEvent := CreateEvent(nil, true, false, #0);
  try
  {FThreadTerminated := not} ResetEvent(Ovr.hEvent);

  FillChar(ComVar.ReceivBuf, SizeOf(ComVar.ReceivBuf), 0);

  ResetEvent(FExitEvent);

  while not Terminated do
    with ComVar do
    begin
    if (ComVar.hCom = INVALID_HANDLE_VALUE) or
       (ComVar.hCom = 0) then
    begin
      Break;
    end;
      Mask := 0;
      //����������� (�������) ����� �������
      if not WaitCommEvent(hCom,Mask,@Ovr) then
      begin
        //������������ "����������" �������� �����-������
        if (GetLastError() = ERROR_IO_PENDING) and (WaitForSingleObject(Ovr.hEvent, PORT_WAIT_TIME) = Wait_Object_0) then
          GetOverlappedResult(hCom,Ovr,Trans,False)
        else
        begin
          Break;
        end;
      end;
      //������� ������ � ���������� ������� �����, �����������!!!
      if not ClearCommError(hCom,Errs,@ComStat) then
      begin
        Break;
      end;

//      if Mask = 0  then
//        Continue;
      if Mask <> 0 then
//      if (Mask and EV_RXCHAR) = EV_RXCHAR then
      begin
        Kols := 512;
        //���� ������ ���� �� ���� ����
	      if ComStat.cbInQue < 512 then
          Kols := ComStat.cbInQue;

        //�������� ������ �������� �����
        ReadFile(hCom, Buff, Kols, Kols, @Ovr);
        if Kols > 0 then
        begin
          //���� ���� ���� ���� ������ - ��������� � ����� ����������
          Move(Buff, ComVar.ReceivBuf[ComVar.CntBytes], Kols);
          inc(ComVar.CntBytes, Kols);

          //�������� � ���� ������� ������ ��� ������ ������� ������ ������ ������� ������
          while ComVar.CntBytes >= PACKET_LENGTH do
          begin
            if Terminated then
              Break;
            //�������� ��������������������
//            if ChckSyncMask(@ComVar.ReceivBuf, @ArMask) then
//            begin
//              Watchdog_Tag := 0;// ����� �� �������� Term � ���������� �������
//              //�������������������� - ��������� �����
//              LenPacket := PACKET_LENGTH;
//
//              //�������� ���������, ������������ ���� ��� ����� ������
//              Move(ReceivBuf, PacketBuf, LenPacket);
//
//              if ChckCmdMask(@ComVar.ReceivBuf, @ArTaskPreStartCmdConfirm) then//������ ����� � ������������ ���������� AlPreStart
//              begin
//                PostMessage(FHandle, CMRxPacket, Integer(@PacketBuf), TASK_PRESTART_CMD_MSG_CODE);//��������� �������� ������
//              end
//              else
//              if ChckCmdMask(@ComVar.ReceivBuf, @ArTaskPreFinishCmdConfirm) then//������ ����� � ������������ ���������� AlPreFinish
//              begin
//                PostMessage(FHandle, CMRxPacket, Integer(@PacketBuf), TASK_PREFINISH_CMD_MSG_CODE);//��������� �������� ������
//              end
//              else
//              if ChckCmdMask(@ComVar.ReceivBuf, @ArTaskPreActionCmdConfirm) then//������ ����� � ������������ ���������� AlPreAction
//              begin
//                PostMessage(FHandle, CMRxPacket, Integer(@PacketBuf), TASK_PREACTION_CMD_MSG_CODE);//��������� �������� ������
//              end
//              else
//              if ChckCmdMask(@ComVar.ReceivBuf, @ArPenaltyCmdConfirm) then//������ ����� � ���������� �����.�������
//              begin
//                PostMessage(FHandle, CMRxPacket, Integer(@PacketBuf), ACTION_PENALTY_CMD_MSG_CODE);//��������� �������� ������
//              end
//              else
//              if ChckCmdMask(@ComVar.ReceivBuf, @ArTaskFinishSuccCmdConfirm) then//������ ����� � ���������� ���������
//              begin
//                PostMessage(FHandle, CMRxPacket, Integer(@PacketBuf), ACTION_REWARD_CMD_MSG_CODE);//��������� �������� ������
//              end
//              else
//              if ChckCmdMask(@ComVar.ReceivBuf, @ArBatStatusCmdConfirm) then //������ ����� � ������� �������
//              begin
//                PostMessage(FHandle, CMRxPacket, Integer(@PacketBuf), BATSTATUS_CMD_MSG_CODE);//��������� �������� ������
//              end
//              else
//              begin
//                //�� ���� ������� �� ���������� - ���������, ��� ������� ������ ���������� �������
//                PostMessage(FHandle, CMRxPacket, Integer(@PacketBuf), SYNC_MSG_CODE);//��������� �������� ������
//              end;
//
//              //������� �� ������������ ������ ����� ������������� ���� ������
//              Move(ComVar.ReceivBuf[LenPacket], ComVar.ReceivBuf[0], ComVar.CntBytes);
//              dec(ComVar.CntBytes, LenPacket);
//            end
//            else
//            begin
//              //�� �������������������� - ������� ������ ���� �� ������� ����� ������
//              dec(ComVar.CntBytes);
//              Move(ComVar.ReceivBuf[1], ComVar.ReceivBuf[0], ComVar.CntBytes);
//            end;
          end;//while

//          LenPacket := 1;
//          //�������� ���������, ������������ ���� ��� ����� ������
//          GetMem(Receiv, LenPacket);
//          Move(ReceivBuf, Receiv^, LenPacket);
//          PostMessage(FHandle, CMRxPacket, Integer(Receiv), LenPacket);
        end;//if
      end;//if
      if ((Mask and EV_DSR) = EV_DSR) or ((Mask and EV_CTS) = EV_CTS) then
      begin
        //���� ��������� ��������� �������� �����
	      if Terminated then
          Break;
      end;
    end;//with
  finally
    CloseHandle(Ovr.hEvent);
    FHandle := 0;
    FPComVar := nil;
    {FThreadTerminated :=} SetEvent(FExitEvent);
  end;
end;

procedure TWorkComThread.SetExitEvent(const Value: THandle);
begin
  FExitEvent := Value;
end;

procedure TWorkComThread.SetHandle(const Value: THandle);
begin
  FHandle := Value;
end;

procedure TWorkComThread.SetPComVar(const Value: TPComVar);
begin
  FPComVar := Value;
end;

//procedure TWorkComThread.SetThreadTerminated(const Value: Boolean);
//begin
//  FThreadTerminated := Value;
//end;

end.
