library pdsm;

uses
  ComServ,
  uPlStimModule in 'uPlStimModule.pas' {PlStimModule: CoClass},
  uDSConfigInterface in '..\Common\uDSConfigInterface.pas',
  uModuleInterface in '..\Common\uModuleInterface.pas',
  uModules in '..\Common\uModules.pas',
  uSecurityInterface in '..\Common\uSecurityInterface.pas',
  uLocalization in '..\Common\uLocalization.pas',
  uPlDirectSoundPlugin in 'uPlDirectSoundPlugin.pas' {PlDirectSoundPlugin: CoClass},
  uPlStimModuleInterface in '..\Common\uPlStimModuleInterface.pas',
  uPlDirectSoundPluginInterface in 'uPlDirectSoundPluginInterface.pas',
  uPlImagePlugin in 'uPlImagePlugin.pas' {PlImagePlugin: CoClass},
  uPlImagePluginInterface in 'uPlImagePluginInterface.pas',
  uImageForm in 'uImageForm.pas' {ImageForm},
  uGLObjects in 'uGLObjects.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.RES}

begin
end.
