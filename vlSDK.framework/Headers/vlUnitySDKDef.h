#ifndef VL_UNITY_SDK_DEF_H
#define VL_UNITY_SDK_DEF_H

#ifdef WIN32
    // Exporting functions to DLL?
    #ifdef VIS_BUILD_UNITYSDK_DLL
        #define VL_SDK_API __declspec(dllexport)
    // Otherwise, importing functions from DLL
    #else
        #define VL_SDK_API __declspec(dllimport)
    #endif // VIS_BUILD_UNITYSDK_DLL

    #define VL_CALLINGCONVENTION __stdcall

#else // WIN32
    #define VL_SDK_API
    #define VL_CALLINGCONVENTION
#endif //WIN32

#endif // VL_UNITY_SDK_DEF_H
