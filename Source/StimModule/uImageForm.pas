unit uImageForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TImageForm = class(TForm)
    imgImage: TImage;
    pbImage: TPaintBox;
    procedure pbImagePaint(Sender: TObject);
  private
    FImage: TGraphic;
    FImageIndex: Integer;

    function GetImageRect: TRect;
    procedure SetImage(const Value: TGraphic);
    procedure SetImageIndex(const Value: Integer);
    { Private declarations }
  public
    property Image: TGraphic read FImage write SetImage;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;

    procedure DrawImage;
  end;


implementation

{$R *.dfm}

{ TImageForm }

procedure TImageForm.DrawImage;
begin
  pbImage.Canvas.Brush.Color := clBtnFace;
  pbImage.Canvas.FillRect(Rect(0, 0, pbImage.Width, pbImage.Height));
  if FImage <> nil then
    pbImage.Canvas.StretchDraw(GetImageRect, FImage);
end;

function TImageForm.GetImageRect: TRect;
var
  k: Double;
begin
  Result := Rect(0, 0, 0 ,0);
  if (FImage <> nil) and
     (FImage.Width <> 0) and
     (FImage.Height <> 0) then
  begin
    k := FImage.Height / FImage.Width;


    if pbImage.Height / pbImage.Width < k then
    begin
      Result.Top := 0;
      Result.Bottom := pbImage.Height;
      Result.Left := Trunc((pbImage.Width - pbImage.Height / k) / 2);
      Result.Right := Trunc((pbImage.Width + pbImage.Height / k) / 2);
    end
    else
    begin
      Result.Left := 0;
      Result.Right := pbImage.Width;
      Result.Top := Trunc((pbImage.Height - pbImage.Width * k) / 2);
      Result.Bottom := Trunc((pbImage.Height + pbImage.Width * k) / 2);
    end;
  end;
end;

procedure TImageForm.pbImagePaint(Sender: TObject);
begin
  DrawImage;
end;

procedure TImageForm.SetImage(const Value: TGraphic);
begin
  if FImage <> Value then
  begin
    FImage := Value;
    DrawImage;
  end;
end;

procedure TImageForm.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
end;

end.
