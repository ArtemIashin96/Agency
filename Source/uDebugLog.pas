unit uDebugLog;

interface

uses Classes, SysUtils, Forms, Windows;

procedure AddLogMessage(FileName, Msg: String);

implementation

var
  QrPF, QrPC, QrPC0 : TLargeInteger;

procedure AddLogMessage(FileName, Msg: String);
var
  FName : String;
  F: TextFile;
  FileHandle : Integer;
Begin
  QueryPerformanceCounter(QrPC);
  if ExtractFileDir(FileName) = '' then
    FName := ExtractFilePath(Application.ExeName) + FileName
  else
    FName := FileName;
  if not FileExists(FName) then
  begin
    FileHandle := FileCreate(FName);
    if FileHandle >= 0 then
      FileClose(FileHandle);
  end;
  if FileExists(FName) then
  begin
    AssignFile(F, FName);
    Append(F);
    WriteLn(F, FloatToStrF(((QrPC - QrPC0) / QrPF) * 1000 , ffFixed, 8, 2) + ' ' + Msg);
    Flush(F);
    CloseFile(F);
  end;
End;

initialization
  QueryPerformanceFrequency(QrPF);
  QueryPerformanceCounter(QrPC0);
  if QrPF = 0 then
    QrPF := 1;
    

finalization

END.
