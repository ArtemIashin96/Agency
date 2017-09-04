unit uPlStimModuleInterface;

interface

uses
  Windows, OpenGL, MMSystem;

const
  Class_PlStimModule: TGUID = '{1755994C-0B66-4A68-B454-E4EB28A82F4E}';

type
  HIMAGE = Integer;
  HEFFECT = Integer;

  IPlStimModuleInterface = interface(IInterface)
  ['{AB411CBE-6558-4775-8632-D280313879DA}']
    //Работа с изображениями
    function Image_LoadFromFile(const FileNameW: PWideChar): HIMAGE;
    function Image_LoadFromPointer(PData: Pointer; DataSize: Integer): HIMAGE;
    function Image_WindowShow(MonitorIndex: Integer; WindowRect: TRect): HWND;
    function Image_WindowHide: HRESULT;
    function Image_Show(AImage: HIMAGE): HRESULT;
    function Image_ShowPreview(AImage: HIMAGE): HRESULT;
    function Image_Hide(AImage: HIMAGE): HRESULT;
    function Image_GetData(AImage: HIMAGE; var PData: Pointer; var DataSize: Integer): HRESULT;
    function Image_Duplicate(AImage: HIMAGE): HIMAGE;
    procedure Image_Free(AImage: HIMAGE);

    function Image_GetPreviewTex(AImage: HIMAGE; ADC: HDC; ARC: HGLRC): GLuint;
    procedure Image_FreeGLContext(ADC: HDC; ARC: HGLRC);

    //Работа со звуком
    function Effect_LoadFromFile(const FileNameW: PWideChar): HEFFECT;
    function Effect_LoadFromPointer(var wf: tWAVEFORMATEX; PData: Pointer; DataSize: Integer): HEFFECT; overload;
    function Effect_LoadFromPointer(PData: Pointer; DataSize: Integer): HEFFECT; overload;
    function Effect_StartPlay(AEffect: HEFFECT; PlayLooping: Boolean): HRESULT;
    function Effect_StopPlay(AEffect: HEFFECT): HRESULT;
    function Effect_StartCapture: HEFFECT;
    function Effect_StopCapture(AEffect: HEFFECT): HRESULT;
    function Effect_GetData(AEffect: HEFFECT; var PData: Pointer; var DataSize: Integer): HRESULT;
    function Effect_GetStatus(AEffect: HEFFECT; var pdwStatus: Cardinal): HRESULT;
    function Effect_Duplicate(AEffect: HEFFECT): HEFFECT;
    procedure Effect_Free(AEffect: HEFFECT);

    procedure Sound_SetWindowHandle(Win: HWND);
    function ModuleInitialize: Boolean;   
  end;

implementation

end.
