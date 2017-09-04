unit uLocalization;

interface

uses
  Windows, Dialogs, Forms, IniFiles, SysUtils;

function LongFileName(ShortName: String): String;
function GetCurrentLocaleID: LCID;
function LoadNewResourceModules(ALocaleId: LCId): Longint;
function GetLocaleNameById(LocaleId: LCID): String; //! Возможно не поддерживается в Windows 7 и выше

implementation

function LongFileName(ShortName: String): String;
var
 SR: TSearchRec;

Begin 
 Result := ''; 
 If (pos ('\\', ShortName) + pos ('*', ShortName) +
     pos ('?', ShortName) <> 0) Or Not FileExists(ShortName) Then 
 Begin 
   { ignore NetBIOS name, joker chars and invalid file names } 
   Exit;
 End; 
 While FindFirst(ShortName, faAnyFile, SR) = 0 Do
 Begin 
   { next part as prefix }
   Result := '\' + SR.Name + Result; 
   SysUtils.FindClose(SR);  { the SysUtils, not the WinProcs procedure! }
   { directory up (cut before '\') }
   ShortName := ExtractFileDir (ShortName);
   If length (ShortName) <= 2 Then
   Begin
     Break;  { ShortName contains drive letter followed by ':' }
   End;
 End;
 Result := ExtractFileDrive (ShortName) + Result;
end;

function GetCurrentLocaleID: LCID;
var
  IniFileName: String;
  IniFile: TIniFile;
Begin
  Result := 25;
  IniFileName := ExtractFilePath(Application.ExeName) + 'locale.ini';
  if FileExists(IniFileName) then
  begin
    IniFile := TIniFile.Create(IniFileName);
    try
      Result := IniFile.ReadInteger('LOCALE', 'current_locale_id', 25);
    finally
      IniFile.Free;
    end;
  end;
End;

function LoadNewResourceModules(ALocaleId: LCId): Longint;
var
  LocaleName: WideString;
  LocaleFilesPath: WideString;
  CurModule: PLibModule;
  CurFileName: WideString;
  CurResFileName: WideString;
//  locale: LCID;
  NewInst: Longint;
Begin
  Result := 0;
//  locale := GetCurrentLocaleID;
  if ALocaleId > 0 then
  begin
    SetLength(LocaleName, 3);
    GetLocaleInfoW(ALocaleId, LOCALE_SABBREVLANGNAME, @LocaleName[1], Length(LocaleName) * 2);
    if LocaleName[1] <> #0 then
    begin
      LocaleFilesPath := ExtractFilePath(ParamStr(0)) + LocaleName + '\';

      CurModule := LibModuleList;
      while CurModule <> nil do
      begin
        CurFileName := LongFileName(GetModuleName(CurModule.Instance));
        CurResFileName := LocaleFilesPath + ChangeFileExt(ExtractFileName(CurFileName), '.' + LocaleName);
        if FileExists(CurResFileName) then
        begin
          NewInst := LoadLibraryExW(PWideChar(CurResFileName), 0, LOAD_LIBRARY_AS_DATAFILE);
          if NewInst <> 0 then
          begin
            if CurModule.ResInstance <> CurModule.Instance then
              FreeLibrary(CurModule.ResInstance);
            CurModule.ResInstance := NewInst;
          end;
        end;
        CurModule := CurModule.Next;
      end;
    end;
  end;
End;

function GetLocaleNameById(LocaleId: LCID): String; //! Возможно не поддерживается в Windows 7 и выше
var
  LocaleName: String;
begin
  SetLength(LocaleName, GetLocaleInfo(LocaleId, LOCALE_SLANGUAGE, nil, 0));
  GetLocaleInfo(LocaleId, LOCALE_SLANGUAGE, @LocaleName[1], Length(LocaleName));
  Result := Trim(LocaleName);
end;

END.
