unit uPlImagePluginInterface;

interface

uses
  Windows, OpenGL;

const
  Class_PlImagePlugin: TGUID = '{0A2CA0B1-6073-449F-849F-17FED1C70AF1}';

type
  HIMAGE = Integer;
  HEFFECT = Integer;

  IPlImagePluginInterface = interface(IInterface)
  ['{E94A64FF-A587-4D28-81EF-394A6F248049}']
    function IMImage_Load(PData: Pointer; DataSize: Integer): HIMAGE;
    function IMImage_WindowShow(MonitorIndex: Integer; WindowRect: TRect): HWND;
    function IMImage_WindowHide: HRESULT;
    function IMImage_Show(AImage: HIMAGE): HRESULT;
    function IMImage_ShowPreview(AImage: HIMAGE): HRESULT;
    function IMImage_Hide(AImage: HIMAGE): HRESULT;
    function IMImage_GetData(AImage: HIMAGE; var PData: Pointer; var DataSize: Integer): HRESULT;
    function IMImage_Duplicate(AImage: HIMAGE): HIMAGE;
    procedure IMImage_Free(AImage: HIMAGE);

    function IMImage_GetPreviewTex(AImage: HIMAGE; ADC: HDC; ARC: HGLRC): GLuint;
    procedure IMImage_FreeGLContext(ADC: HDC; ARC: HGLRC);
  end;


implementation

end.
