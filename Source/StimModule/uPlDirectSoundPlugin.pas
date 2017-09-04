unit uPlDirectSoundPlugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, DirectSound, MMSystem, SysUtils, Dialogs,
  uPlDirectSoundPluginInterface;

const
  MAX_BUFFERS_COUNT = 500;


type

  TPlDirectSoundPlugin = class(TComObject, IPlDirectSoundPluginInterface)
  //IPlDirectSoundPluginInterface
  public
    function DSEffect_Load(PWaveFormat: PWaveFormatEX; PData: Pointer; DataSize: Integer): HEFFECT;
    function DSEffect_GetStatus(AEffect: HEFFECT; var PdwStatus: Cardinal): HRESULT;
    function DSEffect_StartPlay(AEffect: HEFFECT; PlayLooping: Boolean): HRESULT;
    function DSEffect_StopPlay(AEffect: HEFFECT): HRESULT;
    function DSEffect_StartCapture: HEFFECT;
    function DSEffect_StopCapture(AEffect: HEFFECT): HRESULT;
    function DSEffect_GetSize(AEffect: HEFFECT; pdwAudioBytes: PDWORD): HRESULT;
    function DSEffect_GetFormat(AEffect: HEFFECT; pWaveFormat: PWaveFormatEx): HRESULT;
    function DSEffect_Lock(AEffect: HEFFECT; dwOffset, dwBytes: DWORD; ppvAudioPtr1: PPointer;
      pdwAudioBytes1: PDWORD; ppvAudioPtr2: PPointer; pdwAudioBytes2: PDWORD; dwFlags: DWORD): HResult;
    function DSEffect_Unlock(AEffect: HEFFECT; pvAudioPtr1: Pointer; dwAudioBytes1: DWORD;
      pvAudioPtr2: Pointer; dwAudioBytes2: DWORD): HResult;
    function DSEffect_Duplicate(AEffect: HEFFECT): HEFFECT;
    procedure DSEffect_Free(AEffect: HEFFECT);

    procedure DSSetWindowHandle(Win: HWND);
    function DSPluginInitialize: HRESULT;

  private
    FIDirectSound: IDirectSound;
    FIDirectSoundCapture: IDirectSoundCapture;
    FIDirectSoundBuffer: IDirectSoundBuffer;
    FIDirectSoundCaptureBuffer: IDirectSoundCaptureBuffer;
    FWindowHandle: HWND;

    FIBuffers: array[0..MAX_BUFFERS_COUNT - 1] of IDirectSoundBuffer;

    procedure ReleaseAllBuffers;
    function GetMinFreeBufferIndex: Integer;

    function AppCreateWritePrimaryBuffer: Boolean;
    function AppCreateWritePrimaryCaptureBuffer: Boolean;
    function AppCreateWriteSecondaryBuffer(var AIBuffer: IDirectSoundBuffer;
      PWaveFormat: PWaveFormatEx; DataSize: Cardinal): Boolean;
    procedure AppWriteDataToBuffer(IBuffer: IDirectSoundBuffer;
      OffSet: DWord; var SoundData; SoundBytes: DWord);


  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;


implementation

uses ComServ;

{ TPlDirectSoundPlugin }

function TPlDirectSoundPlugin.AppCreateWritePrimaryBuffer: Boolean;
var
  bd: DSBUFFERDESC;
  wf: TWaveFormatEx;
begin
  Result := (FIDirectSound <> nil);
  if Result then
  begin
    FillChar(bd, sizeof(DSBUFFERDESC), 0);
    FillChar(wf, sizeof(TWaveFormatEx), 0);
    wf.wFormatTag := WAVE_FORMAT_PCM;
    wf.nChannels := 2;
    wf.nSamplesPerSec := 22050;//это возможно надо будет поправить
    wf.nBlockAlign := 4;
    wf.nAvgBytesPerSec := wf.nSamplesPerSec * wf.nBlockAlign;
    wf.wBitsPerSample := 16;
    wf.cbSize := 0;
    bd.dwSize := sizeof(DSBUFFERDESC);
    bd.dwFlags := DSBCAPS_PRIMARYBUFFER;
    bd.dwBufferBytes := 0;
    bd.lpwfxFormat := nil;
    Result := (FIDirectSound.SetCooperativeLevel(FWindowHandle, DSSCL_PRIORITY) = S_OK);
    if Result then
    begin
      Result := (FIDirectSound.CreateSoundBuffer(bd, FIDirectSoundBuffer, nil) = S_OK);
      if Result then
      begin
        Result := (FIDirectSoundBuffer.SetFormat(@wf) = S_OK);
        if Result then
        begin
          Result := (FIDirectSound.SetCooperativeLevel(FWindowHandle, DSSCL_NORMAL) = S_OK);
          if not Result then
            raise Exception.Create('Unable to set Cooperative Level');
        end
        else
          raise Exception.Create('Unable to Set Format');
      end
      else
        raise Exception.Create('Create Primary Sound Buffer failed');
    end
    else
      raise Exception.Create('Unable to set Cooperative Level');
  end;
end;

function TPlDirectSoundPlugin.AppCreateWritePrimaryCaptureBuffer: Boolean;
var
  bd: DSCBUFFERDESC;
  wf: TWaveFormatEx;
begin
  Result := (FIDirectSoundCapture <> nil);
  if Result then
  begin
    FillChar(bd, sizeof(DSBUFFERDESC), 0);
    FillChar(wf, sizeof(TWaveFormatEx), 0);
    wf.wFormatTag := WAVE_FORMAT_PCM;
    wf.nChannels := 2;
    wf.nSamplesPerSec := 22050;//это возможно надо будет поправить
    wf.nBlockAlign := 4;
    wf.nAvgBytesPerSec := wf.nSamplesPerSec * wf.nBlockAlign;
    wf.wBitsPerSample := 16;
    wf.cbSize := 0;
    bd.dwSize := sizeof(DSCBUFFERDESC);
    bd.dwFlags := 0;
    bd.dwBufferBytes := wf.nAvgBytesPerSec * 60; // выделяем на 1 минуту
    bd.lpwfxFormat := @wf;

    Result := (FIDirectSoundCapture.CreateCaptureBuffer(bd, FIDirectSoundCaptureBuffer, nil) = S_OK);
    if not Result then
      raise Exception.Create('Create Capture Sound Buffer failed');
  end;
end;

function TPlDirectSoundPlugin.AppCreateWriteSecondaryBuffer(
  var AIBuffer: IDirectSoundBuffer; PWaveFormat: PWaveFormatEx;
   DataSize: Cardinal): Boolean;
var
  bd: DSBUFFERDESC;
begin
  Result := (FIDirectSound <> nil);
  if Result then
  begin
    FillChar(bd, sizeof(DSBUFFERDESC), 0);

    bd.dwSize := sizeof(DSBUFFERDESC);
    bd.dwFlags := DSBCAPS_CTRLPOSITIONNOTIFY or DSBCAPS_GETCURRENTPOSITION2 or DSBCAPS_GLOBALFOCUS;//DSBCAPS_STATIC;
    bd.dwBufferBytes := DataSize;
    bd.lpwfxFormat := PWaveFormat;


    Result := (FIDirectSound.CreateSoundBuffer(bd, AIBuffer, nil) = S_OK);
    if not Result then
      raise Exception.Create('Create Secondary Sound Buffer failed');
  end;
end;

procedure TPlDirectSoundPlugin.AppWriteDataToBuffer(IBuffer: IDirectSoundBuffer;
  OffSet: DWord; var SoundData; SoundBytes: DWord);
var
  audioPtr1, audioPtr2: Pointer;
  audioBytes1, AudioBytes2: DWord;
  h: HResult;
  tempPtr: PByte;
begin
  h := IBuffer.Lock(OffSet, SoundBytes, @audioPtr1, @audioBytes1, @audioPtr2, @audioBytes2, 0);
  if (h = DSERR_BUFFERLOST) then
  begin
    IBuffer.Restore;
    if (IBuffer.Lock(OffSet, SoundBytes, @audioPtr1, @audioBytes1, @audioPtr2, @audioBytes2, 0) <> S_OK) then
      raise Exception.Create('Unable to Lock Sound Buffer');
  end
  else if (H <> DS_OK) then
  begin
    raise Exception.Create('Unable to Lock Sound Buffer');
  end;
  try
    tempPtr := @SoundData;
    Move(tempPtr^, AudioPtr1^, AudioBytes1);
    if (audioPtr2 <> nil) then
    begin
      inc(tempPtr, AudioBytes1);
      Move(tempPtr^, AudioPtr2^, AudioBytes2);
    end;
  finally
    if (IBuffer.Unlock(audioPtr1, audioBytes1, audioPtr2, audioBytes2) <> DS_OK) then
      raise Exception.Create('Unable to Unlock Sound Buffer');
  end;
end;

destructor TPlDirectSoundPlugin.Destroy;
begin
  ReleaseAllBuffers;
  //почему-то если не поставить в nil будет ошабка при уничтожении
  FIDirectSoundBuffer := nil;
  FIDirectSound := nil;
  FIDirectSoundCaptureBuffer := nil;
  FIDirectSoundCapture := nil;
  inherited;
end;

function TPlDirectSoundPlugin.DSEffect_Lock(AEffect: HEFFECT; dwOffset,
      dwBytes: DWORD; ppvAudioPtr1: PPointer; pdwAudioBytes1: PDWORD;
      ppvAudioPtr2: PPointer; pdwAudioBytes2: PDWORD; dwFlags: DWORD): HResult;
begin
  if (AEffect - 1 >= 0) and
     (AEffect - 1 < MAX_BUFFERS_COUNT) and
     (FIBuffers[AEffect - 1] <> nil) then
  begin
    Result := FIBuffers[AEffect - 1].Lock(dwOffset, dwBytes, ppvAudioPtr1, pdwAudioBytes1,
                                          ppvAudioPtr2, pdwAudioBytes2, dwFlags);
  end
  else
    Result := E_INVALIDARG;
end;

function TPlDirectSoundPlugin.DSEffect_Unlock(AEffect: HEFFECT;
  pvAudioPtr1: Pointer; dwAudioBytes1: DWORD; pvAudioPtr2: Pointer;
  dwAudioBytes2: DWORD): HResult;
begin
  if (AEffect - 1 >= 0) and
     (AEffect - 1 < MAX_BUFFERS_COUNT) and
     (FIBuffers[AEffect - 1] <> nil) then
  begin
    Result := FIBuffers[AEffect - 1].Unlock(pvAudioPtr1, dwAudioBytes1, pvAudioPtr2, dwAudioBytes2);
  end
  else
    Result := E_INVALIDARG;
end;

function TPlDirectSoundPlugin.DSEffect_Duplicate(AEffect: HEFFECT): HEFFECT;
var
  index: Integer;
begin
  Result := 0;
  if (AEffect - 1 >= 0) and
     (AEffect - 1 < MAX_BUFFERS_COUNT) and
     (FIDirectSound <> nil) then
  begin
    index := GetMinFreeBufferIndex;
    if (index >= 0) and
       (FIDirectSound.DuplicateSoundBuffer(FIBuffers[AEffect - 1], FIBuffers[index]) = S_OK) then
    begin
      Result := index + 1;
    end;
  end;
end;

procedure TPlDirectSoundPlugin.DSEffect_Free(AEffect: HEFFECT);
begin
  if (AEffect - 1 >= 0) and
     (AEffect - 1 < MAX_BUFFERS_COUNT) then
  begin
    FIBuffers[AEffect - 1] := nil;
  end;
end;


function TPlDirectSoundPlugin.DSEffect_GetFormat(AEffect: HEFFECT;
  pWaveFormat: PWaveFormatEx): HRESULT;
var
  sw: DWord;
begin
  if (AEffect - 1 >= 0) and
     (AEffect - 1 < MAX_BUFFERS_COUNT) and
     (FIBuffers[AEffect - 1] <> nil) then
  begin
    Result := FIBuffers[AEffect - 1].GetFormat(pWaveFormat, sizeof(TWaveFormatEX), @sw);
  end
  else
    Result := E_INVALIDARG;
end;

function TPlDirectSoundPlugin.DSEffect_Load(PWaveFormat: PWaveFormatEX;
  PData: Pointer; DataSize: Integer): HEFFECT;
var
  index: Integer;
begin
  Result := 0;
  index := GetMinFreeBufferIndex;
  if index >= 0 then
  begin
    if AppCreateWriteSecondaryBuffer(FIBuffers[index], PWaveFormat, DataSize) then
    begin
      AppWriteDataToBuffer(FIBuffers[index], 0, PData^, DataSize);
      Result := index + 1;
    end;
  end;
end;

function TPlDirectSoundPlugin.DSEffect_GetStatus(AEffect: HEFFECT; var PdwStatus: Cardinal): HRESULT;
begin
  if (AEffect - 1 >= 0) and
     (AEffect - 1 < MAX_BUFFERS_COUNT) and
     (FIBuffers[AEffect - 1] <> nil) then
  begin
    Result := FIBuffers[AEffect - 1].GetStatus(PdwStatus);
  end
  else
    Result := E_INVALIDARG;
end;


function TPlDirectSoundPlugin.DSEffect_StartPlay(AEffect: HEFFECT; PlayLooping: Boolean): HRESULT;
var
  status: DWORD;
begin
  if (AEffect - 1 >= 0) and
     (AEffect - 1 < MAX_BUFFERS_COUNT) and
     (FIBuffers[AEffect - 1] <> nil) then
  begin
    if (FIBuffers[AEffect - 1].GetStatus(status) = S_OK) and
       (status and DSBSTATUS_PLAYING <> 0) then
      FIBuffers[AEffect - 1].Stop;

    Result := FIBuffers[AEffect - 1].SetCurrentPosition(0);
    if Result = S_OK then
        FIBuffers[AEffect - 1].Play(0, 0, Integer(PlayLooping));
  end
  else
    Result := E_INVALIDARG;
end;

function TPlDirectSoundPlugin.DSEffect_StartCapture: HEFFECT;
var
  index: Integer;
  wf: TWaveFormatEX;
  sw: DWORD;
  status: DWORD;
begin
  Result := 0;
  if (FIDirectSoundCaptureBuffer <> nil) and
     (FIDirectSoundCaptureBuffer.GetStatus(@status) = S_OK) and
     (status and DSCBSTATUS_CAPTURING = 0) and
     (FIDirectSoundCaptureBuffer.GetFormat(@wf, sizeof(TWaveFormatEX), @sw) = S_OK) then
  begin
    index := GetMinFreeBufferIndex;
    if index >= 0 then
    begin
      //забиваем место под буффер куда будем переписывать данные после захвата
      if AppCreateWriteSecondaryBuffer(FIBuffers[index], @wf, 100) then
      begin
        if (FIDirectSoundCaptureBuffer.Start(0) = S_OK) then
          Result := index + 1;
      end;
    end;

  end;
end;


function TPlDirectSoundPlugin.DSEffect_StopCapture(AEffect: HEFFECT): HRESULT;
var
  index: Integer;
  wf: TWaveFormatEX;
  sw: DWORD;
  status: DWORD;
  audioPtr1, audioPtr2: Pointer;
  audioBytes1, AudioBytes2: DWord;
  cCursor, rCursor: DWORD;
begin
  Result := E_FAIL;
  index := AEffect - 1;
  if (index >= 0) and
     (index < MAX_BUFFERS_COUNT) and
     (FIDirectSoundCaptureBuffer <> nil) and
     (FIDirectSoundCaptureBuffer.GetFormat(@wf, sizeof(TWaveFormatEX), @sw) = S_OK) then
  begin
    if (FIDirectSoundCaptureBuffer.GetStatus(@status) = S_OK) and
       (status and DSCBSTATUS_CAPTURING <> 0) then
       FIDirectSoundCaptureBuffer.Stop;
    if (FIDirectSoundCaptureBuffer.GetCurrentPosition(@cCursor, @rCursor) = S_OK) and
       (FIDirectSoundCaptureBuffer.Lock(0, cCursor, @audioPtr1, @audioBytes1, @audioPtr2, @audioBytes2, 0) = S_OK)then
    begin
      try
        //освобождаем временный(фиктивный) буфер и создаем новый, куда будут записаны реальные данные
        FIBuffers[index] := nil;
        if AppCreateWriteSecondaryBuffer(FIBuffers[index], @wf, audioBytes1) then
        begin
          AppWriteDataToBuffer(FIBuffers[index], 0, audioPtr1^, audioBytes1);
          Result := S_OK;
        end;
      finally
        FIDirectSoundCaptureBuffer.Unlock(audioPtr1, audioBytes1, audioPtr2, audioBytes2);
      end;
    end;
  end;
  //пересоздаем буффер, чтобы очистить
  FIDirectSoundCaptureBuffer := nil;
  AppCreateWritePrimaryCaptureBuffer;
end;

function TPlDirectSoundPlugin.DSEffect_StopPlay(AEffect: HEFFECT): HRESULT;
begin
  if (AEffect - 1 >= 0) and
     (AEffect - 1 < MAX_BUFFERS_COUNT) and
     (FIBuffers[AEffect - 1] <> nil) then
  begin
    Result := FIBuffers[AEffect - 1].Stop;
  end
  else
    Result := E_INVALIDARG;
end;

function TPlDirectSoundPlugin.DSEffect_GetSize(AEffect: HEFFECT;
  pdwAudioBytes: PDWORD): HRESULT;
var
  bc: DSBCAPS;
begin
  if (AEffect - 1 >= 0) and
     (AEffect - 1 < MAX_BUFFERS_COUNT) and
     (FIBuffers[AEffect - 1] <> nil) then
  begin
    bc.dwSize := sizeof(DSBCAPS);
    Result := FIBuffers[AEffect - 1].GetCaps(bc);
    if Result = S_OK then
      pdwAudioBytes^ := bc.dwBufferBytes;
  end
  else
    Result := E_INVALIDARG;
end;

procedure TPlDirectSoundPlugin.DSSetWindowHandle(Win: HWND);
begin
  FWindowHandle := Win;
end;

function TPlDirectSoundPlugin.GetMinFreeBufferIndex: Integer;
var
  i: Integer;
begin
  Result := -1;
  i := 0;
  while (Result = -1) and (i < MAX_BUFFERS_COUNT) do
  begin
    if FIBuffers[i] = nil then
      Result := i;
    inc(i);
  end;
end;

procedure TPlDirectSoundPlugin.Initialize;
begin
  inherited;
  ReleaseAllBuffers;
end;

procedure TPlDirectSoundPlugin.ReleaseAllBuffers;
var
  i: Integer;
begin
  i := 0;
  while (i < MAX_BUFFERS_COUNT) do
  begin
    FIBuffers[i] := nil;
    inc(i);
  end;
end;

function TPlDirectSoundPlugin.DSPluginInitialize: HRESULT;
var
  res: Boolean;
begin
  Result := S_False;
  res := FWindowHandle <> 0;
  if res then
  begin
    res := DirectSoundCreate(nil, FIDirectSound, nil) = S_OK;
    if res then
    begin
      res := AppCreateWritePrimaryBuffer;
    end
    else
      raise Exception.Create('Failed to create IDirectSound object');
  end;
  if res then
  begin
    res := DirectSoundCaptureCreate(nil, FIDirectSoundCapture, nil) = S_OK;
    if res then
    begin
      res := AppCreateWritePrimaryCaptureBuffer;
    end
    else
      raise Exception.Create('Failed to create IDirectSoundCapture object');
  end;


  if res then
    Result := S_OK;
end;

initialization
  TComObjectFactory.Create(ComServer, TPlDirectSoundPlugin, Class_PlDirectSoundPlugin,
    'PlDirectSoundPlugin', '', ciMultiInstance, tmApartment);
end.
