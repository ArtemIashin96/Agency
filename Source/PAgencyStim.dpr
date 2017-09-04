program PAgencyStim;

uses
  Forms,
  uMain in 'uMain.pas' {fmMain},
  uVidMode in 'uVidMode.pas',
  uCommon in 'uCommon.pas',
  uSettingsFm in 'uSettingsFm.pas' {fmSettings},
  uHasWonMsg in 'uHasWonMsg.pas' {fmHasWon},
  uJoys in 'uJoys.pas',
  uLPT in 'uLPT.pas',
  uOpenComThread in 'uOpenComThread.pas',
  Ap in 'Ap.pas',
  spline3 in 'spline3.pas',
  uPlStimModuleInterface in 'Common\uPlStimModuleInterface.pas',
  uModuleInterface in 'Common\uModuleInterface.pas',
  uDSConfigInterface in 'Common\uDSConfigInterface.pas',
  uSecurityInterface in 'Common\uSecurityInterface.pas',
  uPlStimModule in 'StimModule\uPlStimModule.pas',
  uModules in 'Common\uModules.pas',
  uLocalization in 'Common\uLocalization.pas',
  uPlDirectSoundPluginInterface in 'StimModule\uPlDirectSoundPluginInterface.pas',
  uPlImagePluginInterface in 'StimModule\uPlImagePluginInterface.pas',
  uPlDirectSoundPlugin in 'StimModule\uPlDirectSoundPlugin.pas',
  uMainRes in 'uMainRes.pas',
  uSubTest in 'uSubTest.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
