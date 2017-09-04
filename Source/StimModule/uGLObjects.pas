unit uGLObjects;

interface

uses
  Windows, Classes, Contnrs, Graphics, OpenGL, uPlImagePluginInterface;

type
  TGLStimTexture = class(TObject)
  private
    FImage: HIMAGE;
    FTexName: GLuint;
    procedure SetImage(const Value: HIMAGE);
    procedure SetTexName(const Value: GLuint);
  public
    property TexName: GLuint read FTexName write SetTexName;
    property Image: HIMAGE read FImage write SetImage;
  end;

  TGLContainer = class(TObject)
  private
    FDC: HDC;
    FRC: HGLRC;
    FStimTexList: TObjectList;

    function GetImageRect(AGraphic: TGraphic): TRect;
    procedure SwapRGBtoBGR(pData: PByte; pDataLength: Integer; BitCount: Integer);

    procedure SetDC(const Value: HDC);
    procedure SetRC(const Value: HGLRC);
    function GetStimTexture(index: Integer): TGLStimTexture;
    function GetStimTexturesCount: Integer;
  public
    constructor Create(ADC: HDC; ARC: HGLRC);
    destructor Destroy; override;

    procedure RemoveAllTextures;
    procedure RemoveTexture(AStimTex: TGLStimTexture);

    procedure RemoveTextureByImage(AImage: HImage);
    function GetStimTexByImage(AImage: HImage): TGLStimTexture;

    function AddNewTexture(AImage: HImage; AGraphic: TGraphic): TGLStimTexture;

    property DC: HDC read FDC write SetDC;
    property RC: HGLRC read FRC write SetRC;
    property StimTexture[index: Integer]: TGLStimTexture read GetStimTexture;
    property StimTexturesCount: Integer read GetStimTexturesCount;
  end;


procedure glBindTexture (target: GLenum; texture: GLuint); stdcall; external opengl32;
procedure glGenTextures (n: GLsizei; textures: PGLuint); stdcall; external opengl32;
procedure glDeleteTextures (n: GLsizei; const textures: PGLuint); stdcall; external opengl32;

implementation

{ TGLContainer }

function TGLContainer.AddNewTexture(AImage: HImage;
  AGraphic: TGraphic): TGLStimTexture;
const
  w = 128;
  h = 128;
var
  i: Integer;
  bmp: TBitmap;
  texName: GLuint;
  pData, p: PByte;
begin
  Result := nil;
  if wglMakeCurrent(FDC, FRC) then
  begin
    bmp := TBitmap.Create;
    GetMem(pData, w * h * 3);
    p := pData;
    try
      bmp.Width := w;
      bmp.Height := h;
      bmp.PixelFormat := pf24bit;

      bmp.Canvas.Brush.Color := clLtGray;
      bmp.Canvas.FillRect(Rect(0, 0, w, h));
      bmp.Canvas.StretchDraw(GetImageRect(AGraphic), AGraphic);
      bmp.Canvas.Pen.Color := clGray;
      bmp.Canvas.MoveTo(1, 1);
      bmp.Canvas.LineTo(w - 1, 1);
      bmp.Canvas.LineTo(w - 1, h - 1);
      bmp.Canvas.LineTo(1, h - 1);
      bmp.Canvas.LineTo(1, 1);
      i := 0;
      while i < h do
      begin
        Move(bmp.ScanLine[i]^, p^, w * 3);
        inc(p, w * 3);
        inc(i);
      end;
      SwapRGBtoBGR(pData, w * h * 3, 24);
      glGenTextures(1,@texName);
      glBindTexture(GL_TEXTURE_2D,texName);
      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
      glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
      glTexImage2D(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, pData);
      glBindTexture(GL_TEXTURE_2D, 0);
      Result := TGLStimTexture.Create;
      Result.FTexName := texName;
      Result.Image := AImage;
      FStimTexList.Add(Result);
    finally
      bmp.Free;
      FreeMem(pData, w * h * 3)
    end;
  end;
end;

constructor TGLContainer.Create(ADC: HDC; ARC: HGLRC);
begin
  FStimTexList := TObjectList.Create(True);
  FRC := ARC;
  FDC := ADC;
end;

procedure TGLContainer.RemoveAllTextures;
var
  i: Integer;
begin
  if wglMakeCurrent(FDC, FRC) then
  begin
    i := 0;
    while (i < StimTexturesCount) do
    begin
      glDeleteTextures(1, @StimTexture[i].TexName);
      inc(i);
    end;
  end;
  FStimTexList.Clear;
end;

procedure TGLContainer.RemoveTexture(AStimTex: TGLStimTexture);
begin
  if wglMakeCurrent(FDC, FRC) then
  begin
    glDeleteTextures(1, @AStimTex.TexName);
  end;
  FStimTexList.Remove(AStimTex);
end;

procedure TGLContainer.RemoveTextureByImage(AImage: HImage);
var
  st: TGLStimTexture;
begin
  st := GetStimTexByImage(AImage);
  if st <> nil then
  begin
    if wglMakeCurrent(FDC, FRC) then
    begin
      glDeleteTextures(1, @st.TexName);
    end;
    FStimTexList.Remove(st);
  end;
end;

destructor TGLContainer.Destroy;
begin
  RemoveAllTextures;
  FStimTexList.Free;
end;

function TGLContainer.GetImageRect(AGraphic: TGraphic): TRect;
const
  w = 128;
  h = 128;
var
  k: Double;
begin
  Result := Rect(0, 0, 0 ,0);
  if (AGraphic <> nil) and
     (AGraphic.Width <> 0) and
     (AGraphic.Height <> 0) then
  begin
    k := AGraphic.Height / AGraphic.Width;


    if k > 1 then
    begin
      Result.Top := 0;
      Result.Bottom := h;
      Result.Left := Trunc((w - h / k) / 2);
      Result.Right := Trunc((w + h / k) / 2);
    end
    else
    begin
      Result.Left := 0;
      Result.Right := w;
      Result.Top := Trunc((h - w * k) / 2);
      Result.Bottom := Trunc((h + w * k) / 2);
    end;
  end;
end;

function TGLContainer.GetStimTexByImage(AImage: HImage): TGLStimTexture;
var
  i: Integer;
begin
  Result := nil;
  i := 0;
  while (Result = nil) and (i < StimTexturesCount) do
  begin
    if StimTexture[i].Image = AImage then
      Result := StimTexture[i];
    inc(i);
  end;
end;

function TGLContainer.GetStimTexture(index: Integer): TGLStimTexture;
begin
  Result := TGLStimTexture(FStimTexList.Items[index]);
end;

function TGLContainer.GetStimTexturesCount: Integer;
begin
  Result := FStimTexList.Count;
end;

procedure TGLContainer.SetDC(const Value: HDC);
begin
  FDC := Value;
end;

procedure TGLContainer.SetRC(const Value: HGLRC);
begin
  FRC := Value;
end;

procedure TGLContainer.SwapRGBtoBGR(pData: PByte; pDataLength: Integer; BitCount: Integer);
var
  step: Integer;
  pR, pB: PByte;
  R: Byte;
begin
  case BitCount of
    24, 32:
    begin
      step := BitCount div 8;
      pR := pData;
      pB := pR;
      inc(pB, 2);
      while Integer(pB) < (Integer(pData) + pDataLength) do
      begin
        R := pR^;
        pR^ := pB^;
        pB^ := R;
        inc(pR, step);
        inc(pB, step);
      end;
    end;
  end;
end;

{ TGLStimTexture }

procedure TGLStimTexture.SetImage(const Value: HIMAGE);
begin
  FImage := Value;
end;

procedure TGLStimTexture.SetTexName(const Value: GLuint);
begin
  FTexName := Value;
end;

end.
