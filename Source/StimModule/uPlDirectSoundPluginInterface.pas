unit uPlDirectSoundPluginInterface;

interface

uses
  Windows, MMSystem, DirectSound;

const
  Class_PlDirectSoundPlugin: TGUID = '{2DCAC7E0-BA75-49A7-986D-B0957A50F7D7}';

type
  HIMAGE = Integer;
  HEFFECT = Integer;

  IPlDirectSoundPluginInterface = interface(IInterface)
  ['{5EE2A534-7412-4CEB-ABB1-6C41B13F203E}']
    function DSEffect_Load(PWaveFormat: PWaveFormatEX; PData: Pointer; DataSize: Integer): HEFFECT;
    function DSEffect_GetStatus(AEffect: HEFFECT; var PdwStatus: Cardinal): HRESULT;
    function DSEffect_StartPlay(AEffect: HEFFECT; PlayLooping: Boolean): HRESULT;
    function DSEffect_StopPlay(AEffect: HEFFECT): HRESULT;
    function DSEffect_StartCapture: HEFFECT;
    function DSEffect_StopCapture(AEffect: HEFFECT): HRESULT;
    function DSEffect_GetSize(AEffect: HEFFECT; pdwAudioBytes: PDWORD): HRESULT;
    function DSEffect_GetFormat(AEffect: HEFFECT; pWaveFormat: PWaveFormatEx): HRESULT;
    function DSEffect_Lock(AEffect: HEFFECT; dwOffset, dwBytes: DWORD; ppvAudioPtr1: PPointer;
      pdwAudioBytes1: PDWORD; ppvAudioPtr2: PPointer; pdwAudioBytes2: PDWORD; dwFlags: DWORD): HResult;
    function DSEffect_Unlock(AEffect: HEFFECT; pvAudioPtr1: Pointer; dwAudioBytes1: DWORD;
      pvAudioPtr2: Pointer; dwAudioBytes2: DWORD): HResult;
    function DSEffect_Duplicate(AEffect: HEFFECT): HEFFECT;
    procedure DSEffect_Free(AEffect: HEFFECT);

    procedure DSSetWindowHandle(Win: HWND);
    function DSPluginInitialize: HRESULT;

  end;

implementation

end.
