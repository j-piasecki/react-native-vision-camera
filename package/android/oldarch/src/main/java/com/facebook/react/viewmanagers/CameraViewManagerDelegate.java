/**
* This code was generated by [react-native-codegen](https://www.npmjs.com/package/react-native-codegen).
*
* Do not edit this file as changes may cause incorrect behavior and will be lost
* once the code is regenerated.
*
* @generated by codegen project: GeneratePropsJavaDelegate.js
*/

package com.facebook.react.viewmanagers;

import android.view.View;
import androidx.annotation.Nullable;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.BaseViewManagerDelegate;
import com.facebook.react.uimanager.BaseViewManagerInterface;

public class CameraViewManagerDelegate<T extends View, U extends BaseViewManagerInterface<T> & CameraViewManagerInterface<T>> extends BaseViewManagerDelegate<T, U> {
  public CameraViewManagerDelegate(U viewManager) {
    super(viewManager);
  }
  @Override
  public void setProperty(T view, String propName, @Nullable Object value) {
    switch (propName) {
      case "enableGpuBuffers":
        mViewManager.setEnableGpuBuffers(view, value == null ? false : (boolean) value);
        break;
      case "androidPreviewViewType":
        mViewManager.setAndroidPreviewViewType(view, value == null ? null : (String) value);
        break;
      case "codeScannerOptions":
        mViewManager.setCodeScannerOptions(view, (ReadableMap) value);
        break;
      case "cameraId":
        mViewManager.setCameraId(view, value == null ? null : (String) value);
        break;
      case "enableFrameProcessor":
        mViewManager.setEnableFrameProcessor(view, value == null ? false : (boolean) value);
        break;
      case "enableLocation":
        mViewManager.setEnableLocation(view, value == null ? false : (boolean) value);
        break;
      case "enableBufferCompression":
        mViewManager.setEnableBufferCompression(view, value == null ? false : (boolean) value);
        break;
      case "photoQualityBalance":
        mViewManager.setPhotoQualityBalance(view, value == null ? null : (String) value);
        break;
      case "isActive":
        mViewManager.setIsActive(view, value == null ? false : (boolean) value);
        break;
      case "photo":
        mViewManager.setPhoto(view, value == null ? false : (boolean) value);
        break;
      case "video":
        mViewManager.setVideo(view, value == null ? false : (boolean) value);
        break;
      case "audio":
        mViewManager.setAudio(view, value == null ? false : (boolean) value);
        break;
      case "torch":
        mViewManager.setTorch(view, value == null ? null : (String) value);
        break;
      case "zoom":
        mViewManager.setZoom(view, value == null ? 0f : ((Double) value).doubleValue());
        break;
      case "exposure":
        mViewManager.setExposure(view, value == null ? 0f : ((Double) value).doubleValue());
        break;
      case "enableZoomGesture":
        mViewManager.setEnableZoomGesture(view, value == null ? false : (boolean) value);
        break;
      case "enableFpsGraph":
        mViewManager.setEnableFpsGraph(view, value == null ? false : (boolean) value);
        break;
      case "resizeMode":
        mViewManager.setResizeMode(view, value == null ? null : (String) value);
        break;
      case "format":
        mViewManager.setFormat(view, (ReadableMap) value);
        break;
      case "pixelFormat":
        mViewManager.setPixelFormat(view, value == null ? null : (String) value);
        break;
      case "fps":
        mViewManager.setFps(view, value == null ? 0 : ((Double) value).intValue());
        break;
      case "videoHdr":
        mViewManager.setVideoHdr(view, value == null ? false : (boolean) value);
        break;
      case "photoHdr":
        mViewManager.setPhotoHdr(view, value == null ? false : (boolean) value);
        break;
      case "lowLightBoost":
        mViewManager.setLowLightBoost(view, value == null ? false : (boolean) value);
        break;
      case "videoStabilizationMode":
        mViewManager.setVideoStabilizationMode(view, value == null ? null : (String) value);
        break;
      case "enableDepthData":
        mViewManager.setEnableDepthData(view, value == null ? false : (boolean) value);
        break;
      case "enablePortraitEffectsMatteDelivery":
        mViewManager.setEnablePortraitEffectsMatteDelivery(view, value == null ? false : (boolean) value);
        break;
      case "orientation":
        mViewManager.setOrientation(view, value == null ? null : (String) value);
        break;
      default:
        super.setProperty(view, propName, value);
    }
  }
}
