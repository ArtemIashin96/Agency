unit uPlImagePlugin;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, Graphics, Forms, Contnrs, OpenGL,
  uPlImagePluginInterface, uImageForm, JPEG, pngImage, uGLObjects;

const
  MAX_IMAGES_COUNT = 1000;

type
  TPlImagePlugin = class(TComObject, IPlImagePluginInterface)
  //IPlImagePluginInterface
  public
    function IMImage_Load(PData: Pointer; DataSize: Integer): HIMAGE;
    function IMImage_WindowShow(MonitorIndex: Integer; WindowRect: TRect): HWND;
    function IMImage_WindowHide: HRESULT;
    function IMImage_Show(AImage: HIMAGE): HRESULT;
    function IMImage_ShowPreview(AImage: HIMAGE): HRESULT;
    function IMImage_Hide(AImage: HIMAGE): HRESULT;
    function IMImage_GetData(AImage: HIMAGE; var PData: Pointer; var DataSize: Integer): HRESULT;
    function IMImage_Duplicate(AImage: HIMAGE): HIMAGE;
    procedure IMImage_Free(AImage: HIMAGE);

    function IMImage_GetPreviewTex(AImage: HIMAGE; ADC: HDC; ARC: HGLRC): GLuint;
    procedure IMImage_FreeGLContext(ADC: HDC; ARC: HGLRC);

  private
    FImages: array[0..MAX_IMAGES_COUNT - 1] of TGraphic;
    FImageForm: TImageForm;
    FGLContainerList: TObjectList;

    FPTempMem: Pointer;
    procedure ReleaseAllImages;
    function GetMinFreeImageIndex: Integer;
    function GetGLContainer(ADC: HDC; ARC: HGLRC): TGLContainer;
    function GetOrCreateGLContainer(ADC: HDC; ARC: HGLRC): TGLContainer;

  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;


implementation

uses ComServ;

{ TPlImagePlugin }

destructor TPlImagePlugin.Destroy;
begin
  FImageForm.Release;
  ReleaseAllImages;
  if FPTempMem <> nil then
    FreeMem(FPTempMem);
  FGLContainerList.Free;
  inherited;
end;

function TPlImagePlugin.GetGLContainer(ADC: HDC; ARC: HGLRC): TGLContainer;
var
  i: Integer;
begin
  Result := nil;
  i := 0;
  while (Result = nil) and (i < FGLContainerList.Count) do
  begin
    if (TGLContainer(FGLContainerList.Items[i]).DC = ADC) and
       (TGLContainer(FGLContainerList.Items[i]).RC = ARC) then
      Result := TGLContainer(FGLContainerList.Items[i]);
    inc(i);
  end;
end;

function TPlImagePlugin.GetMinFreeImageIndex: Integer;
var
  i: Integer;
begin
  Result := -1;
  i := 0;
  while (Result = -1) and (i < MAX_IMAGES_COUNT) do
  begin
    if FImages[i] = nil then
      Result := i;
    inc(i);
  end;
end;

function TPlImagePlugin.GetOrCreateGLContainer(ADC: HDC;
  ARC: HGLRC): TGLContainer;
begin
  Result := GetGLContainer(ADC, ARC);
  if Result = nil then
  begin
    Result := TGLContainer.Create(ADC, ARC);
    FGLContainerList.Add(Result);
  end;
  
end;

function TPlImagePlugin.IMImage_Duplicate(AImage: HIMAGE): HIMAGE;
var
  index: Integer;
begin
  Result := 0;
  if (AImage - 1 >= 0) and
     (AImage - 1 < MAX_IMAGES_COUNT) then
  begin
    index := GetMinFreeImageIndex;
    if (index >= 0)then
    begin
      FImages[index] := TGraphicClass(FImages[AImage - 1].ClassType).Create;
      FImages[index].Assign(FImages[AImage - 1]);
      Result := index + 1;
    end;
  end;
end;

procedure TPlImagePlugin.IMImage_Free(AImage: HIMAGE);
begin
  if (AImage - 1 >= 0) and
     (AImage - 1 < MAX_IMAGES_COUNT) and
     (FImages[AImage - 1] <> nil) then
  begin
    if (FImageForm.Image = FImages[AImage - 1]) then
      FImageForm.Image := nil;
    FImages[AImage - 1].Free;
    FImages[AImage - 1] := nil;
  end;
end;

procedure TPlImagePlugin.IMImage_FreeGLContext(ADC: HDC; ARC: HGLRC);
var
  cont: TGLContainer;
begin
  cont := GetGLContainer(ADC, ARC);
  if cont <> nil then
    FGLContainerList.Remove(cont);
end;

function TPlImagePlugin.IMImage_GetData(AImage: HIMAGE; var PData: Pointer;
  var DataSize: Integer): HRESULT;
var
  ms: TMemoryStream;
begin
  Result := E_FAIL;
  if (AImage - 1 >= 0) and
     (AImage - 1 < MAX_IMAGES_COUNT) and
     (FImages[AImage - 1] <> nil) then
  begin
    if (FPTempMem <> nil) then
      FreeMem(FPTempMem);
    ms := TMemoryStream.Create;
    try
      FImages[AImage - 1].SaveToStream(ms);

      if (ms.Size > 0) then
      begin
        GetMem(FPTempMem, ms.Size);
        ms.Position := 0;
        if (ms.Read(FPTempMem^, ms.Size) = ms.Size) then
        begin
          PData := FPTempMem;
          DataSize := ms.Size;
          Result := S_OK;
        end;
      end;
    finally
      ms.Free;
    end;
  end;
end;

function TPlImagePlugin.IMImage_GetPreviewTex(AImage: HIMAGE; ADC: HDC;
  ARC: HGLRC): GLuint;
var
  cont: TGLContainer;
  texture: TGLStimTexture;
begin
  Result := 0;
  if (AImage - 1 >= 0) and
     (AImage - 1 < MAX_IMAGES_COUNT) and
     (FImages[AImage - 1] <> nil) then
  begin
    cont := GetOrCreateGLContainer(ADC, ARC);
    if cont <> nil then
    begin
      texture := cont.GetStimTexByImage(AImage);
      if texture = nil then
        texture := cont.AddNewTexture(AImage, FImages[AImage - 1]);
      if texture <> nil then
        Result := texture.TexName;
    end;
  end;
end;

function TPlImagePlugin.IMImage_Hide(AImage: HIMAGE): HRESULT;
begin
  Result := S_OK;
  if (FImageForm.ImageIndex = AImage - 1) then
  begin
    FImageForm.Image := nil;
    FImageForm.ImageIndex := -1;
  end;
//  FImageForm.imgImage.Picture.Bitmap.Width := 0;
//  FImageForm.imgImage.Picture.Bitmap.Height := 0;
//  FImageForm.Invalidate;
end;

function TPlImagePlugin.IMImage_Load(PData: Pointer; DataSize: Integer): HIMAGE;
var
  index: Integer;
  ms: TMemoryStream;
  p1, p2: PByte;
begin
  Result := 0;
  if DataSize > 1 then
  begin
    index := GetMinFreeImageIndex;
    if (index >= 0) then
    begin
      //определяем формат изображения по первым 2-м байтам
      p1 := pData;
      p2 := p1;
      inc(p2);
      // для bmp это $42 $4D
      // для jpg $ff $D8
      // для png $89 $50
      if (p1^ = $42) and (p2^ = $4D) then
        FImages[index] := TBitmap.Create
      else if (p1^ = $ff) and (p2^ = $D8) then
        FImages[index] := TJPEGImage.Create
      else if (p1^ = $89) and (p2^ = $50) then
        FImages[index] := TPNGObject.Create;
      ms := TMemoryStream.Create;
      try
        ms.WriteBuffer(PData^, DataSize);
        ms.Position := 0;
        FImages[index].LoadFromStream(ms);
        if (FImages[index].Width > 0) and
           (FImages[index].Height > 0) then
          Result := index + 1
        else
          FImages[index].Free;
      finally
        ms.Free;
      end;
    end;
  end;
end;

function TPlImagePlugin.IMImage_Show(AImage: HIMAGE): HRESULT;
begin
  Result := E_FAIL;
  if (AImage - 1 >= 0) and
     (AImage - 1 < MAX_IMAGES_COUNT) and
     (FImages[AImage - 1] <> nil) then
  begin
  //  FImageForm.imgImage.Picture.Graphic := FImages[AImage - 1];
    FImageForm.ImageIndex := AImage - 1;
    FImageForm.Image := FImages[AImage - 1];
    Result := S_OK;
  end;
end;

function TPlImagePlugin.IMImage_ShowPreview(AImage: HIMAGE): HRESULT;
var
  imf: TImageForm;
begin
  Result := E_FAIL;
  if (AImage - 1 >= 0) and
     (AImage - 1 < MAX_IMAGES_COUNT) and
     (FImages[AImage - 1] <> nil) then
  begin
    imf := TImageForm.Create(Application);
    try
     // imf.imgImage.Picture.Graphic := FImages[AImage - 1];
      imf.BorderStyle := bsToolWindow;
      imf.Image := FImages[AImage - 1];
      imf.ShowModal;
    finally
      imf.Release;
    end;
    Result := S_OK;
  end;
end;

function TPlImagePlugin.IMImage_WindowHide: HRESULT;
begin
  Result := S_OK;
  ShowWindow(FImageForm.Handle, SW_HIDE);
  FImageForm.Hide;
end;

function TPlImagePlugin.IMImage_WindowShow(MonitorIndex: Integer;
  WindowRect: TRect): HWND;
begin
  Result := 0;
  if (MonitorIndex >= 0) and
     (MonitorIndex < Screen.MonitorCount) then
  begin
    if not FImageForm.Showing then
    begin
      ShowWindow(FImageForm.Handle, SW_SHOWNOACTIVATE);
//      FImageForm.Show;
    end;
    OffsetRect(WindowRect, Screen.Monitors[MonitorIndex].Left, Screen.Monitors[MonitorIndex].Top);
    FImageForm.BoundsRect := WindowRect;
    Result := FImageForm.Handle;
  end
  else if FImageForm.Showing then
    FImageForm.Hide;
end;

procedure TPlImagePlugin.Initialize;
begin
  inherited;
  FImageForm := TImageForm.Create(Application);
  FGLContainerList := TObjectList.Create(True);
end;

procedure TPlImagePlugin.ReleaseAllImages;
var
  i: Integer;
begin
  i := 0;
  while (i < MAX_IMAGES_COUNT) do
  begin
    if (FImages[i] <> nil) then
    begin
      if (FImageForm.Image = FImages[i]) then
        FImageForm.Image := nil;
      FImages[i].Free;
      FImages[i] := nil;
    end;
    inc(i);
  end;
end;

initialization
  TComObjectFactory.Create(ComServer, TPlImagePlugin, Class_PlImagePlugin,
    'PlImagePlugin', '', ciMultiInstance, tmApartment);
end.
