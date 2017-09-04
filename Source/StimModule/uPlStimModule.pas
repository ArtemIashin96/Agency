unit uPlStimModule;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, uModules, MMSystem, SysUtils, Dialogs, OpenGL,
  uPlStimModuleInterface, uPlDirectSoundPluginInterface, uPlImagePluginInterface;

type
  TPlStimModule = class(TCustomModule, IPlStimModuleInterface)
  //IModuleInterface
  protected
    function GetGUID: TGUID; override;
    function GetModuleName: WideString; override;
    function ModuleInitialize: Boolean; override;
    procedure SetNotifyWindowHandle(const Value: THandle); override;
  //IPlStimModuleInterface
  public
    //Работа с изображениями
    function Image_LoadFromFile(const FileNameW: PWideChar): HIMAGE;
    function Image_LoadFromPointer(PData: Pointer; DataSize: Integer): HIMAGE;
    function Image_WindowShow(MonitorIndex: Integer; WindowRect: TRect): HWND;
    function Image_WindowHide: HRESULT;
    function Image_Show(AImage: HIMAGE): HRESULT;
    function Image_ShowPreview(AImage: HIMAGE): HRESULT;
    function Image_Hide(AImage: HIMAGE): HRESULT;
    function Image_GetData(AImage: HIMAGE; var PData: Pointer; var DataSize: Integer): HRESULT;
    function Image_Duplicate(AImage: HIMAGE): HIMAGE;
    procedure Image_Free(AImage: HIMAGE);

    function Image_GetPreviewTex(AImage: HIMAGE; ADC: HDC; ARC: HGLRC): GLuint;
    procedure Image_FreeGLContext(ADC: HDC; ARC: HGLRC);

    //Работа со звуком
    function Effect_LoadFromFile(const FileNameW: PWideChar): HEFFECT;
    function Effect_LoadFromPointer(var wf: tWAVEFORMATEX; PData: Pointer; DataSize: Integer): HEFFECT; overload;
    function Effect_LoadFromPointer(PData: Pointer; DataSize: Integer): HEFFECT; overload;
    function Effect_GetStatus(AEffect: HEFFECT; var pdwStatus: Cardinal): HRESULT;
    function Effect_StartPlay(AEffect: HEFFECT; PlayLooping: Boolean): HRESULT;
    function Effect_StopPlay(AEffect: HEFFECT): HRESULT;
    function Effect_StartCapture: HEFFECT;
    function Effect_StopCapture(AEffect: HEFFECT): HRESULT;
    function Effect_GetTime(AEffect: HEFFECT): Integer;
    function Effect_GetData(AEffect: HEFFECT; var PData: Pointer; var DataSize: Integer): HRESULT;
    function Effect_Duplicate(AEffect: HEFFECT): HEFFECT;
    procedure Effect_Free(AEffect: HEFFECT);

    procedure Sound_SetWindowHandle(Win: HWND);
  public
    procedure Initialize; override;
    destructor Destroy; override;
  private
    FIDSPlugin: IPlDirectSoundPluginInterface;
    FIImagePlugin: IPlImagePluginInterface;
    //указатель на временную область памяти используется для доступа к данным  звука
    FPTempMem: Pointer;

    function CreateTempMemAudio(pWaveFormat: PWaveFormatEx; pvAudioPtr1: Pointer; dwAudioBytes1: DWORD;
       pvAudioPtr2: Pointer; dwAudioBytes2: DWORD): Integer;
  end;

const
  FOURCC_RIFF   = $46464952;   { 'RIFF' }
  FOURCC_WAVE   = $45564157;   { 'WAVE' }
  FOURCC_FMT    = $20746d66;   { 'fmt ' }
  FOURCC_FACT   = $74636166;   { 'fact' }
  FOURCC_DATA   = $61746164;   { 'data' }  


implementation

uses ComServ;

{ TPlStimModule }

function TPlStimModule.CreateTempMemAudio(pWaveFormat: PWaveFormatEx;
  pvAudioPtr1: Pointer; dwAudioBytes1: DWORD; pvAudioPtr2: Pointer;
  dwAudioBytes2: DWORD): Integer;
const
  add_mem = 1024 * 100; //100 кб памяти резервируем для формата
var
  mi: MMIOINFO;
  mmfp: HMMIO;
  mminfopar      : TMMCKINFO;
  mminfosub      : TMMCKINFO;
  dwTotalSamples : Cardinal;
begin
  Result := 0;
  if FPTempMem <> nil then
    FreeMem(FPTempMem);
  GetMem(FPTempMem, dwAudioBytes1 + dwAudioBytes2 + add_mem);
  FillChar(mi, sizeof(mi), 0);
  mi.pchBuffer := FPTempMem;
  mi.cchBuffer := dwAudioBytes1 + dwAudioBytes2 + add_mem;
  mi.fccIOProc := FOURCC_MEM;
  mmfp := mmioOpen(nil, @mi, MMIO_CREATE or MMIO_READWRITE);
  if (mmfp <> 0) then
  begin
    try
      mminfopar.fccType := FOURCC_WAVE;
      mminfopar.cksize := 0;		 	// let the function determine the size
      if mmioCreateChunk(mmfp, @mminfopar, MMIO_CREATERIFF) = 0 then
      begin
        mminfosub.ckid   := FOURCC_FMT;
        mminfosub.cksize :=0; // let the function determine the size
        if mmioCreateChunk(mmfp, @mminfosub, 0) = 0 then
        begin
          if mmioWrite(mmfp, PAnsiChar(pWaveFormat), sizeof(tWAVEFORMATEX) + pWaveFormat.cbSize) = LongInt(sizeof(tWAVEFORMATEX) + pWaveFormat.cbSize) then
          begin
            // back out of format chunk...
            mmioAscend(mmfp, @mminfosub, 0);

          // write the fact chunk (required for all non-PCM .wav files...
          // this chunk just contains the total length in samples...
            mminfosub.ckid   := FOURCC_FACT;
            mminfosub.cksize := sizeof(DWORD);
            if mmioCreateChunk(mmfp, @mminfosub, 0) = 0 then
            begin
              dwTotalSamples := (dwAudioBytes1 + dwAudioBytes2) * 8 div pWaveFormat.wBitsPerSample;
              if mmioWrite(mmfp, PAnsiChar(@dwTotalSamples), sizeof(dwTotalSamples)) = sizeof(dwTotalSamples) then
              begin
                // back out of fact chunk...
                mmioAscend(mmfp, @mminfosub, 0);

                // now create and write the wave data chunk...
                mminfosub.ckid   := FOURCC_DATA;
                mminfosub.cksize := 0;	 	// let the function determine the size
                if mmioCreateChunk(mmfp, @mminfosub, 0) = 0 then
                begin
                  if mmioWrite(mmfp, PAnsiChar(pvAudioPtr1), dwAudioBytes1) <> -1 then
                  begin
                    if pvAudioPtr2 <> nil then
                      mmioWrite(mmfp, PAnsiChar(pvAudioPtr2), dwAudioBytes2);

                      // back out and cause the size of the data buffer to be written...
                    mmioAscend(mmfp, @mminfosub , 0);
                      // ascend out of the RIFF chunk...
                    mmioAscend(mmfp, @mminfopar, 0);

                    //Считываем длину получившегося файла
                    Result := mmioSeek(mmfp, 0, SEEK_END)
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    finally
      mmioClose(mmfp, 0);
    end;
  end;

end;

destructor TPlStimModule.Destroy;
begin
  if (FPTempMem <> nil) then
    FreeMem(FPTempMem);
  FIDSPlugin := nil;
  FIImagePlugin := nil;
  inherited;
end;

function TPlStimModule.Effect_Duplicate(AEffect: HEFFECT): HEFFECT;
begin
  if (FIDSPlugin <> nil) then
    Result := FIDSPlugin.DSEffect_Duplicate(AEffect)
  else
    Result := 0;
end;

procedure TPlStimModule.Effect_Free(AEffect: HEFFECT);
begin
  if (FIDSPlugin <> nil) then
    FIDSPlugin.DSEffect_Free(AEffect);
end;

function TPlStimModule.Effect_GetData(AEffect: HEFFECT; var PData: Pointer;
  var DataSize: Integer): HRESULT;
var
  es: DWord;
  wf: TWaveFormatEX;
  audioPtr1, audioPtr2: Pointer;
  audioBytes1, AudioBytes2: DWord;
begin
  if (FIDSPlugin <> nil) then
  begin
    Result := FIDSPlugin.DSEffect_GetSize(AEffect, @es);
    if (Result = S_OK) then
    begin
      Result := FIDSPlugin.DSEffect_GetFormat(AEffect, @wf);
      if (Result = S_OK) then
      begin
        Result := FIDSPlugin.DSEffect_Lock(AEffect, 0, es, @audioPtr1, @audioBytes1,
                                           @audioPtr2, @audioBytes2, 0);
        if (Result = S_OK) then
        begin
          try
//            DataSize := CreateTempMemAudio(@wf, audioPtr1, audioBytes1, audioPtr2, audioBytes2);
            GetMem(FPTempMem, audioBytes1);
            Move(audioPtr1^, FPTempMem^, audioBytes1);
//            FPTempMem := audioPtr1;
            DataSize := audioBytes1;

            if DataSize > 0 then
              PData := FPTempMem
            else
              Result := E_FAIL;
          finally
            FIDSPlugin.DSEffect_Unlock(AEffect, audioPtr1, audioBytes1, audioPtr2, audioBytes2);
          end;
        end;
      end;
    end;
  end
  else
    Result := S_FALSE;
end;

function TPlStimModule.Effect_GetStatus(AEffect: HEFFECT;
  var pdwStatus: Cardinal): HRESULT;
begin
  if (FIDSPlugin <> nil) then
    Result := FIDSPlugin.DSEffect_GetStatus(AEffect, pdwStatus)
  else
    Result := E_FAIL;
end;

function TPlStimModule.Effect_GetTime(AEffect: HEFFECT): Integer;
var
  es: DWord;
  wf: TWaveFormatEX;
begin
  if (FIDSPlugin <> nil) and
     (FIDSPlugin.DSEffect_GetSize(AEffect, @es) = S_OK) and
     (FIDSPlugin.DSEffect_GetFormat(AEffect, @wf) = S_OK) then
  begin
    Result := es * 1000 div wf.nAvgBytesPerSec;
  end
  else
    Result := 0;
end;

function TPlStimModule.Effect_LoadFromFile(const FileNameW: PWideChar): HEFFECT;
var
  fs: TFileStream;
  data: Pointer;
begin
  Result := 0;
  if FileExists(WideString(FileNameW)) then
  begin
    fs := TFileStream.Create(WideString(FileNameW), fmShareDenyNone{fmOpenRead});
    try
      GetMem(data, fs.Size);
      try
        fs.Position := 0;
        fs.ReadBuffer(data^, fs.Size);
        Result := Effect_LoadFromPointer(data, fs.Size);
      finally
        FreeMem(data);
      end;
    finally
      fs.Free;
    end;
  end;
end;

function TPlStimModule.Effect_LoadFromPointer(var wf: tWAVEFORMATEX; PData: Pointer;
  DataSize: Integer): HEFFECT;
var
  bufSize: Integer;
begin
  Result := 0;
  if (FIDSPlugin <> nil) and
     (PData <> nil) and
     (DataSize > 0) then
  begin
    bufSize := DataSize;
    if bufSize > 0 then
    begin
      Result := FIDSPlugin.DSEffect_Load(@wf, PData, bufSize);
    end;
  end;
end;

function TPlStimModule.Effect_LoadFromPointer(PData: Pointer;
  DataSize: Integer): HEFFECT;
var
  mi: MMIOINFO;
  mmfp: HMMIO;
  mminfopar      : TMMCKINFO;
  mminfosub      : TMMCKINFO;
  wf: tWAVEFORMATEX;
  buf: Pointer;
  bufSize: Cardinal;
begin
  Result := 0;
  if (FIDSPlugin <> nil) and
     (PData <> nil) and
     (DataSize > 0) then
  begin
    FillChar(mi, sizeof(mi), 0);
    mi.pchBuffer := PData;
    mi.cchBuffer := DataSize;
    mi.fccIOProc := FOURCC_MEM;
    mmfp := mmioOpen(nil, @mi, MMIO_READ);
    if (mmfp <> 0) then
    begin
      try
        //Читаем формат
        // search for wave type and format chunks...
        mminfopar.fccType := FOURCC_WAVE;
        if mmioDescend(mmfp, @mminfopar, nil, MMIO_FINDRIFF) <> 0 then
          Exit;
        mminfosub.ckid := FOURCC_FMT;
        if mmioDescend(mmfp, @mminfosub, @mminfopar, MMIO_FINDCHUNK) <> 0 then
          Exit;
        // read the wave format...
        if mmioRead(mmfp, PAnsiChar(@wf), mminfosub.cksize) <> LongInt(mminfosub.cksize) then
          Exit;
        mmioAscend(mmfp, @mminfosub, 0);
        //Читаем данные
        // search for data
        mminfosub.ckid := FOURCC_DATA;
        if mmioDescend(mmfp, @mminfosub, @mminfopar, MMIO_FINDCHUNK) <> 0 then
          Exit;
        bufSize := mminfosub.cksize;
        if bufSize > 0 then
        begin
          GetMem(buf, bufSize);
          try
            if mmioRead(mmfp, PAnsiChar(buf), bufSize) > 0 then
              Result := FIDSPlugin.DSEffect_Load(@wf, buf, bufSize);
          finally
            FreeMem(buf);
          end;
        end;
      finally
        mmioClose(mmfp, 0);
      end;
    end;
  end;
end;

function TPlStimModule.Effect_StartPlay(AEffect: HEFFECT; PlayLooping: Boolean): HRESULT;
begin
  if (FIDSPlugin <> nil) then
    Result := FIDSPlugin.DSEffect_StartPlay(AEffect, PlayLooping)
  else
    Result := E_FAIL;
end;

function TPlStimModule.Effect_StartCapture: HEFFECT;
begin
  if (FIDSPlugin <> nil) then
    Result := FIDSPlugin.DSEffect_StartCapture
  else
    Result := 0;
end;

function TPlStimModule.Effect_StopCapture(AEffect: HEFFECT): HRESULT;
begin
  if (FIDSPlugin <> nil) then
    Result := FIDSPlugin.DSEffect_StopCapture(AEffect)
  else
    Result := S_FALSE;
end;

function TPlStimModule.Effect_StopPlay(AEffect: HEFFECT): HRESULT;
begin
  if (FIDSPlugin <> nil) then
    Result := FIDSPlugin.DSEffect_StopPlay(AEffect)
  else
    Result := S_FALSE;
end;

function TPlStimModule.GetGUID: TGUID;
begin
  Result := Class_PlStimModule
end;

function TPlStimModule.GetModuleName: WideString;
begin
  Result := 'Stim';
end;

function TPlStimModule.Image_Duplicate(AImage: HIMAGE): HIMAGE;
begin
  if (FIImagePlugin <> nil) then
    Result := FIImagePlugin.IMImage_Duplicate(AImage)
  else
    Result := 0;
end;

procedure TPlStimModule.Image_Free(AImage: HIMAGE);
begin
  if (FIImagePlugin <> nil) then
    FIImagePlugin.IMImage_Free(AImage);
end;

procedure TPlStimModule.Image_FreeGLContext(ADC: HDC; ARC: HGLRC);
begin
  if (FIImagePlugin <> nil) then
    FIImagePlugin.IMImage_FreeGLContext(ADC, ARC);
end;

function TPlStimModule.Image_GetData(AImage: HIMAGE; var PData: Pointer;
  var DataSize: Integer): HRESULT;
begin
  if (FIImagePlugin <> nil) then
    Result := FIImagePlugin.IMImage_GetData(AImage, PData, DataSize)
  else
    Result := E_FAIL;
end;

function TPlStimModule.Image_GetPreviewTex(AImage: HIMAGE; ADC: HDC;
  ARC: HGLRC): GLuint;
begin
  if (FIImagePlugin <> nil) then
    Result := FIImagePlugin.IMImage_GetPreviewTex(AImage, ADC, ARC)
  else
    Result := 0;
end;

function TPlStimModule.Image_Hide(AImage: HIMAGE): HRESULT;
begin
  if (FIImagePlugin <> nil) then
    Result := FIImagePlugin.IMImage_Hide(AImage)
  else
    Result := E_FAIL;
end;

function TPlStimModule.Image_LoadFromFile(const FileNameW: PWideChar): HIMAGE;
var
  fs: TFileStream;
  data: Pointer;
begin
  Result := 0;
  if FileExists(WideString(FileNameW)) then
  begin
    fs := TFileStream.Create(WideString(FileNameW), fmOpenRead);
    try
      GetMem(data, fs.Size);
      try
        fs.Position := 0;
        fs.ReadBuffer(data^, fs.Size);
        Result := Image_LoadFromPointer(data, fs.Size);
      finally
        FreeMem(data);
      end;
    finally
      fs.Free;
    end;
  end;
end;

function TPlStimModule.Image_LoadFromPointer(PData: Pointer;
  DataSize: Integer): HIMAGE;
begin
  if (FIImagePlugin <> nil) then
    Result := FIImagePlugin.IMImage_Load(PData, DataSize)
  else
    Result := 0;
end;

function TPlStimModule.Image_Show(AImage: HIMAGE): HRESULT;
begin
  if (FIImagePlugin <> nil) then
    Result := FIImagePlugin.IMImage_Show(AImage)
  else
    Result := E_FAIL;
end;

function TPlStimModule.Image_ShowPreview(AImage: HIMAGE): HRESULT;
begin
  if (FIImagePlugin <> nil) then
    Result := FIImagePlugin.IMImage_ShowPreview(AImage)
  else
    Result := E_FAIL;
end;

function TPlStimModule.Image_WindowHide: HRESULT;
begin
  if (FIImagePlugin <> nil) then
    Result := FIImagePlugin.IMImage_WindowHide
  else
    Result := E_FAIL;
end;

function TPlStimModule.Image_WindowShow(MonitorIndex: Integer;
  WindowRect: TRect): HWND;
begin
  if (FIImagePlugin <> nil) then
    Result := FIImagePlugin.IMImage_WindowShow(MonitorIndex, WindowRect)
  else
    Result := 0;
end;

procedure TPlStimModule.Initialize;
var
  ii: IInterface;
begin
  inherited;
  ii := CreateComObject(Class_PlDirectSoundPlugin);
  if (ii <> nil) then
    ii.QueryInterface(IPlDirectSoundPluginInterface, FIDSPlugin);
  ii := CreateComObject(Class_PlImagePlugin);
  if (ii <> nil) then
    ii.QueryInterface(IPlImagePluginInterface, FIImagePlugin);
end;

function TPlStimModule.ModuleInitialize: Boolean;
begin
  Result := True;
//  if FIDSPlugin <> nil then
//  begin
//    FIDSPlugin.DSSetWindowHandle(FNotifyWindowHandle);
   // Result := FIDSPlugin.DSPluginInitialize = S_OK;
//  end;
end;

procedure TPlStimModule.SetNotifyWindowHandle(const Value: THandle);
begin
  inherited;
  Sound_SetWindowHandle(Value);
  FIDSPlugin.DSPluginInitialize;
end;

procedure TPlStimModule.Sound_SetWindowHandle(Win: HWND);
begin
  if FIDSPlugin <> nil then
    FIDSPlugin.DSSetWindowHandle(Win);
end;

initialization
  TComObjectFactory.Create(ComServer, TPlStimModule, Class_PlStimModule,
    'PlStimModule', '', ciMultiInstance, tmApartment);
end.
