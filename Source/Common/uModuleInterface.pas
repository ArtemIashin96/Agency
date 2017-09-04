unit uModuleInterface;

interface
uses
  Classes, Graphics,

  uDSConfigInterface, uSecurityInterface;

type
  IModuleInterface = interface(IInterface)
  ['{565323C5-D253-4A98-920E-A62BF4B12076}']
    function GetToolBarCount: Integer;
    function GetToolBarGUID(Index: Integer): TGUID;
    function GetGUID: TGUID;
    function GetModuleName: WideString;
//    function GetucPath: WideString;
//    procedure SetucPath(const Value: WideString);
//    function GetdscPath: WideString;
//    procedure SetdscPath(const Value: WideString);
    procedure SetIDSConfig(const Value: IDSConfigInterface);
    function GetIDSConfig: IDSConfigInterface;
    function GetISecMod: IsmzInterface;
    procedure SetISecMod(const Value: IsmzInterface);
    procedure SetNotifyWindowHandle(const Value: THandle);
    function GetNotifyWindowHandle: THandle;
    function GetIToolBarList: IInterfaceList;

    function ModuleInitialize: Boolean;

    procedure ReleaseAllRefs; //
    procedure uMSInfo;
    function GetlStr: WideString;

    property ToolBarGUIDs[Index: Integer]: TGUID read GetToolBarGUID;
    property ToolBarCount: Integer read GetToolBarCount;
    property GUID : TGUID read GetGUID;
//    property dscPath : WideString read GetdscPath write SetdscPath; //dsc - Diana Studio Config
//    property ucPath: WideString read GetucPath write SetucPath; // uc - User Config
    property IDSConfig: IDSConfigInterface read GetIDSConfig write SetIDSConfig;
    property ModuleName: WideString read GetModuleName;
    property ISecMod: IsmzInterface read GetISecMod write SetISecMod;
    property NotifyWindowHandle: THandle read GetNotifyWindowHandle write SetNotifyWindowHandle;
    property IToolBarList: IInterfaceList read GetIToolBarList;
  end;

  IModuleContainerInterface = Interface(IInterface)
  ['{2058DC5E-E1D4-4AE4-BD35-E67C35ED8840}']

    procedure SetGUID(const Value: TGUID);
    procedure SetIModule(const Value: IModuleInterface);
    function GetGUID: TGUID;
    function GetIModule: IModuleInterface;

    property GUID : TGUID read GetGUID write SetGUID;
    property IModule : IModuleInterface read GetIModule write SetIModule;
  End;


implementation

end.
