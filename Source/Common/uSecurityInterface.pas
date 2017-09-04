unit uSecurityInterface;

interface

type
  IsmzInterface = Interface(IUnknown)
  ['{29FCF1B4-58BF-492F-B69C-254EE75C5AFF}']
    function IsModuleInstalled(Module: System.TGUID): boolean;
    function IsSerialValid(Serial: string): boolean;
    function GetMagicNumber(Module: string; Param: string): WideString;
  End;

implementation

end.
