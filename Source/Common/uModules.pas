unit uModules;

interface

uses
  Classes, ComObj, Controls, Graphics,

  Dialogs, IniFiles, SysUtils, Windows,

  uDSConfigInterface, uModuleInterface, USecurityInterface;

type
  TCustomModule = class(TComObject, IModuleInterface)
  protected
    FToolBarGuidList: TStringList;
    FIToolBarList: IInterfaceList;
    FucPath: WideString;
    FdscPath: WideString;
    FIDSConfig: IDSConfigInterface;
    FISecMod: IsmzInterface;
    FNotifyWindowHandle: THandle;
    FlStr: WideString;
    FCurLocaleID: Integer;

//    FSecurity: IsmzInterface;
    function GetToolBarCount: Integer;
    function GetToolBarGUID(Index: Integer): TGUID;
    function GetGUID: TGUID; virtual; abstract;
    function GetModuleName: WideString; virtual; abstract;
//    function GetucPath: WideString;
//    procedure SetucPath(const Value: WideString);
//    procedure SetdscPath(const Value: WideString);
//    function GetdscPath: WideString;
    procedure SetIDSConfig(const Value: IDSConfigInterface); virtual;
    function GetIDSConfig: IDSConfigInterface;
    function ModuleInitialize: Boolean; virtual; abstract;
    function GetISecMod: IsmzInterface;
    procedure SetISecMod(const Value: IsmzInterface); virtual;

    procedure ReleaseAllRefs; virtual;
    procedure SetNotifyWindowHandle(const Value: THandle); virtual;
    function GetNotifyWindowHandle: THandle;
    function GetIToolBarList: IInterfaceList;
    function GetlStr: WideString;  // функция возвращает строку с правами модуля
    procedure uMSInfo;
    procedure AddUserCo; virtual;// функция пользователя обработки запроса на права модуля
  public
    destructor Destroy; override;
    procedure Initialize; override;
  public
    property GUID : TGUID read GetGUID;
    property ToolBarGUIDs[Index: Integer]: TGUID read GetToolBarGUID;
    property ToolBarCount: Integer read GetToolBarCount;

//    property ucPath: WideString read GetucPath write SetucPath;
//    property dscPath : WideString read GetdscPath write SetdscPath;
    property IDSConfig: IDSConfigInterface read GetIDSConfig write SetIDSConfig;
    property ModuleName: WideString read GetModuleName;
    property ISecMod: IsmzInterface read GetISecMod write SetISecMod;
    property NotifyWindowHandle: THandle read GetNotifyWindowHandle write SetNotifyWindowHandle;
    property IToolBarList: IInterfaceList read GetIToolBarList;
  end;

  TModuleContainer = class(TInterfacedObject, IModuleContainerInterface)
  private
    FGUID: TGUID;
    FIModule: IModuleInterface;
  protected
    procedure SetGUID(const Value: TGUID);
    procedure SetIModule(const Value: IModuleInterface);
    function GetGUID: TGUID;
    function GetIModule: IModuleInterface;
  public
    constructor Create;
    destructor Destroy; override;

    property GUID : TGUID read GetGUID write SetGUID;
    property IModule : IModuleInterface read GetIModule write SetIModule;
  end;

implementation

uses
  uLocalization;

{ TCustomModule }
procedure TCustomModule.AddUserCo;
begin
  Flstr := '-1';
end;

destructor TCustomModule.Destroy;
begin
  FToolBarGuidList.Free;
  FIToolBarList := nil;
  inherited;
end;

{function TCustomModule.GetdscPath: WideString;
begin
  Result := FdscPath;
end;{}

function TCustomModule.GetIDSConfig: IDSConfigInterface;
begin
  Result := FIDSConfig;
end;



function TCustomModule.GetISecMod: IsmzInterface;
begin
  Result := FISecMod;
end;

function TCustomModule.GetIToolBarList: IInterfaceList;
begin
  Result := FIToolBarList;
end;

function TCustomModule.GetlStr: WideString;
begin
  AddUserCo;
  Result := FlStr;
end;

function TCustomModule.GetNotifyWindowHandle: THandle;
begin
  Result := FNotifyWindowHandle;
end;

function TCustomModule.GetToolBarCount: Integer;
begin
  Result := FToolBarGuidList.Count;
end;

function TCustomModule.GetToolBarGUID(Index: Integer): TGUID;
begin
  Result := StringToGUID(FToolBarGuidList.Strings[Index]);
end;

{function TCustomModule.GetucPath: WideString;
begin
  Result := FucPath;
end;{}

procedure TCustomModule.Initialize;
begin
  inherited;
  FToolBarGuidList := TStringList.Create;
  FIToolBarList := TInterfaceList.Create;
  FCurLocaleID := 1049; //по-молчанию русский
end;

procedure TCustomModule.ReleaseAllRefs;
begin
  FIToolBarList.Clear;
end;

{procedure TCustomModule.SetdscPath(const Value: WideString);
begin
  FdscPath := Value;
end;{}

procedure TCustomModule.SetIDSConfig(const Value: IDSConfigInterface);
var
  IniFile: TIniFile;
begin
  if (FIDSConfig <> Value) then
  begin
    FIDSConfig := Value;
    if (FIDSConfig <> nil) and FileExists(FIDSConfig.dsPath + 'config\ds.ini') then
    begin
      IniFile := TIniFile.Create(FIDSConfig.dsPath + 'config\ds.ini');
      try
        FCurLocaleID := IniFile.ReadInteger('CUR_LANGUAGE', 'ID', 1049);
        LoadNewResourceModules(FCurLocaleID);
      finally
        IniFile.Free;
      end;
    end;
  end;
end;

procedure TCustomModule.SetISecMod(const Value: IsmzInterface);
begin
  FISecMod := Value;
end;

procedure TCustomModule.SetNotifyWindowHandle(const Value: THandle);
begin
  FNotifyWindowHandle := Value;
end;

procedure TCustomModule.uMSInfo;
begin
  if ISecMod <> nil then
  begin
    FlStr :=ISecMod.GetMagicNumber(GUIDToString(GUID), '1');
  end
  else
    FlStr := '';
  FlStr := GetlStr;
end;

{procedure TCustomModule.SetucPath(const Value: WideString);
begin
  FucPath := Value;
end;{}

{ TModuleContainer }

constructor TModuleContainer.Create;
begin
  inherited;
end;

destructor TModuleContainer.Destroy;
begin
  FIModule := nil;
  inherited;
end;

function TModuleContainer.GetGUID: TGUID;
begin
  Result := FGUID;
end;

function TModuleContainer.GetIModule: IModuleInterface;
begin
  Result := FIModule;
end;

procedure TModuleContainer.SetGUID(const Value: TGUID);
begin
  FGUID := Value;

end;

procedure TModuleContainer.SetIModule(const Value: IModuleInterface);
begin
  FIModule := Value;
end;

end.
