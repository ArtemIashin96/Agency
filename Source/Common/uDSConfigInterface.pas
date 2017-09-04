unit uDSConfigInterface;

interface

const
  Class_DSConfig: TGUID = '{7BE58F59-AA2E-477A-91B4-42B362E15A6F}';

type
  TSourceType = (stAllUsers, stCurrentUser, stCustom); // тип установки приложения: для всех пользователей, для текущего пользователя, другой

  IDSConfigInterface = Interface(IInterface)
  ['{FF99D8A5-B851-488B-B0BB-B35FDE3B3697}']
    function GetdsConfigFileName: WideString;
    function GetdsPath: WideString;
    function GetucPath: WideString;
    function GetdbClientLibraryPath: WideString;
    procedure SetisConfigured(const Value: Boolean);
    function GetisConfigured: Boolean;
    function GetdsdFileName: WideString;

    function LoadConfig(ConfigPath: WideString): Boolean;

    property dsConfigFileName : WideString read GetdsConfigFileName; //основной config Diana Studio
    property dsPath : WideString read GetdsPath; //ds - Diana Studio
    property ucPath : WideString read GetucPath; //uc - User Config
    property dbClientLibraryPath: WideString read GetdbClientLibraryPath;
    property isConfigured : Boolean Read GetisConfigured write SetisConfigured;
    property dsdFileName : WideString read GetdsdFileName;
  End;

implementation

end.
