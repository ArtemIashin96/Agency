unit uVidMode;

interface

uses
  Windows, SysUtils, Forms;

     function SetFullscreenMode(ModeIndex: Integer) : Boolean;
     procedure TryToAddToList(DeviceMode: TDevMode);
     procedure ReadVideoModes;
     procedure RestoreDefaultMode;

const
  MAXVIDEOMODES = 200; // ����� ������ �������

type TVideoMode = record
  Width,
  Height,
  ColorDepth : Word;
  Description : String[20];
end;

 type
  TLowResMode = record
     Width,
     Height,
     ColorDepth : Word;
 end;

const
NumberLowResModes = 60;
LowResModes : array[0..NumberLowResModes-1] of TLowResMode =
((Width:320;Height:200;ColorDepth: 8),(Width:320;Height:200;ColorDepth:15),
 (Width:320;Height:200;ColorDepth:16),(Width:320;Height:200;ColorDepth:24),
 (Width:320;Height:200;ColorDepth:32),(Width:320;Height:240;ColorDepth: 8),
 (Width:320;Height:240;ColorDepth:15),(Width:320;Height:240;ColorDepth:16),
 (Width:320;Height:240;ColorDepth:24),(Width:320;Height:240;ColorDepth:32),
 (Width:320;Height:350;ColorDepth: 8),(Width:320;Height:350;ColorDepth:15),
 (Width:320;Height:350;ColorDepth:16),(Width:320;Height:350;ColorDepth:24),
 (Width:320;Height:350;ColorDepth:32),(Width:320;Height:400;ColorDepth: 8),
 (Width:320;Height:400;ColorDepth:15),(Width:320;Height:400;ColorDepth:16),
 (Width:320;Height:400;ColorDepth:24),(Width:320;Height:400;ColorDepth:32),
 (Width:320;Height:480;ColorDepth: 8),(Width:320;Height:480;ColorDepth:15),
 (Width:320;Height:480;ColorDepth:16),(Width:320;Height:480;ColorDepth:24),
 (Width:320;Height:480;ColorDepth:32),(Width:360;Height:200;ColorDepth: 8),
 (Width:360;Height:200;ColorDepth:15),(Width:360;Height:200;ColorDepth:16),
 (Width:360;Height:200;ColorDepth:24),(Width:360;Height:200;ColorDepth:32),
 (Width:360;Height:240;ColorDepth: 8),(Width:360;Height:240;ColorDepth:15),
 (Width:360;Height:240;ColorDepth:16),(Width:360;Height:240;ColorDepth:24),
 (Width:360;Height:240;ColorDepth:32),(Width:360;Height:350;ColorDepth: 8),
 (Width:360;Height:350;ColorDepth:15),(Width:360;Height:350;ColorDepth:16),
 (Width:360;Height:350;ColorDepth:24),(Width:360;Height:350;ColorDepth:32),
 (Width:360;Height:400;ColorDepth: 8),(Width:360;Height:400;ColorDepth:15),
 (Width:360;Height:400;ColorDepth:16),(Width:360;Height:400;ColorDepth:24),
 (Width:360;Height:400;ColorDepth:32),(Width:360;Height:480;ColorDepth: 8),
 (Width:360;Height:480;ColorDepth:15),(Width:360;Height:480;ColorDepth:16),
 (Width:360;Height:480;ColorDepth:24),(Width:360;Height:480;ColorDepth:32),
 (Width:400;Height:300;ColorDepth: 8),(Width:400;Height:300;ColorDepth:15),
 (Width:400;Height:300;ColorDepth:16),(Width:400;Height:300;ColorDepth:24),
 (Width:400;Height:300;ColorDepth:32),(Width:512;Height:384;ColorDepth: 8),
 (Width:512;Height:384;ColorDepth:15),(Width:512;Height:384;ColorDepth:16),
 (Width:512;Height:384;ColorDepth:24),(Width:512;Height:384;ColorDepth:32));

var
  VideoModes : array [0..MaxVideoModes] of TVideoMode;
  ScreenModeChanged : Boolean;
  NumberVideomodes : Integer = 1; // ��� ������� 1, 'default' �����

implementation
//=============================================================================
function SetFullscreenMode(ModeIndex: Integer) : Boolean;
// ������������� ���������� �������� ��������� 'ModeIndex'
var
  DeviceMode : TDevMode;
begin
  with DeviceMode do begin
    dmSize := SizeOf(DeviceMode);
    dmBitsPerPel := VideoModes[ModeIndex].ColorDepth;
    dmPelsWidth := VideoModes[ModeIndex].Width;
    dmPelsHeight := VideoModes[ModeIndex].Height;
    dmFields := DM_BITSPERPEL or DM_PELSWIDTH or DM_PELSHEIGHT;
    // ���� ����� �� ���������������, ScreenModeChanged = False
    Result := ChangeDisplaySettings(DeviceMode,CDS_FULLSCREEN) = DISP_CHANGE_SUCCESSFUL;
    if Result then ScreenModeChanged := True;
    if ModeIndex = 0 then ScreenModeChanged:=False;
  end;
end;
//=============================================================================
procedure TryToAddToList(DeviceMode: TDevMode);
// �������� ���������� � ������, ���� ��� �� �������������
// � ������������� ��� ����� ����������
var
  I : Integer;
begin
// �������� ������������� ����� (����� ��������� ��-�� ���������
// �����������, ��� ��-�� ����, ��� �� ���� ������� ���� �������������� ������).
  for I := 1 to NumberVideomodes - 1 do
    with DeviceMode do
      if ((dmBitsPerPel = VideoModes[I].ColorDepth) and
          (dmPelsWidth = VideoModes[I].Width) and
          (dmPelsHeight = VideoModes[I].Height)) then Exit;

// ������������ ������ (�� ������������� �����, �� ��������, ������� �� �� ���).

  if ChangeDisplaySettings(DeviceMode,CDS_TEST or CDS_FULLSCREEN) <> DISP_CHANGE_SUCCESSFUL then Exit;

// ��� - �����, ���������� ������, ��� ��� ��������� ��� � ������
  with DeviceMode do begin
    VideoModes[NumberVideomodes].ColorDepth:=dmBitsPerPel;
    VideoModes[NumberVideomodes].Width:=dmPelsWidth;
    VideoModes[NumberVideomodes].Height:=dmPelsHeight;
    VideoModes[NumberVideomodes].Description:=Format('%d x %d, %d bpp',[dmPelsWidth,dmPelsHeight,dmBitsPerPel]);
  end;
  Inc(NumberVideomodes);
end;
//=============================================================================
procedure ReadVideoModes;
var
  I, ModeNumber : Integer;
  done_ : Boolean;
  DeviceMode : TDevMode;
  DeskDC : HDC;
begin
  // ���������� 'default' �����
  with VideoModes[0] do
  try
    DeskDC := GetDC (0);
    ColorDepth := GetDeviceCaps (DeskDC, BITSPIXEL);
    Width := Screen.Width;
    Height := Screen.Height;
    Description := 'default';
  finally
    ReleaseDC(0, DeskDC);
  end;

  // ����������� ��� ��������� �����������
  ModeNumber:=0;
  done_ := False;
  repeat
    done_ := not EnumDisplaySettings(nil,ModeNumber,DeviceMode);
    TryToAddToList(DeviceMode);
    Inc(ModeNumber);
  until (done_ or (NumberVideomodes >= MaxVideoModes));

  // ����������� ���� � �������������� �������
  with DeviceMode do begin
    dmBitsPerPel:=8;
    dmPelsWidth:=42;
    dmPelsHeight:=37;
    dmFields:=DM_BITSPERPEL or DM_PELSWIDTH or DM_PELSHEIGHT;

  // ��������, ��� ������� �� �������� "��" �� ���� ������
  if ChangeDisplaySettings(DeviceMode,CDS_TEST or CDS_FULLSCREEN) <> DISP_CHANGE_SUCCESSFUL then
  begin
    I:=0;
    while (I < NumberLowResModes-1) and (NumberVideoModes < MaxVideoModes) do
    begin
      dmSize:=Sizeof(DeviceMode);
      dmBitsPerPel:=LowResModes[I].ColorDepth;
      dmPelsWidth:=LowResModes[I].Width;
      dmPelsHeight:=LowResModes[I].Height;
      dmFields:=DM_BITSPERPEL or DM_PELSWIDTH or DM_PELSHEIGHT;
      TryToAddToList(DeviceMode);
      Inc(I);
    end;
  end;
end;

end;
//=============================================================================
procedure RestoreDefaultMode;
// ����������� ��������������� ������ ������
begin
// ������ �������� ������ ���� ����������, ������ ������������ ��������������� ����
// ������ �� ���������� ���������� � ���������� ������� 0.
  ChangeDisplaySettings(devmode(nil^), CDS_FULLSCREEN);
end;
//=============================================================================
end.

