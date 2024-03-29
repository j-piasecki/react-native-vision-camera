package com.mrousavy.camera

import com.facebook.react.bridge.ReadableMap
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.CameraViewManagerDelegate
import com.facebook.react.viewmanagers.CameraViewManagerInterface
import com.mrousavy.camera.types.CameraDeviceFormat
import com.mrousavy.camera.types.CodeScannerOptions
import com.mrousavy.camera.types.Orientation
import com.mrousavy.camera.types.PixelFormat
import com.mrousavy.camera.types.PreviewViewType
import com.mrousavy.camera.types.QualityBalance
import com.mrousavy.camera.types.ResizeMode
import com.mrousavy.camera.types.Torch
import com.mrousavy.camera.types.VideoStabilizationMode

@Suppress("unused")
class CameraViewManager : ViewGroupManager<CameraView>(), CameraViewManagerInterface<CameraView> {
  companion object {
    const val TAG = "CameraView"
  }

  private val mDelegate: ViewManagerDelegate<CameraView>

  init {
    mDelegate = CameraViewManagerDelegate(this)
  }

  override fun getDelegate() = mDelegate

  public override fun createViewInstance(context: ThemedReactContext): CameraView = CameraView(context)

  override fun onAfterUpdateTransaction(view: CameraView) {
    super.onAfterUpdateTransaction(view)
    view.update()
  }

  override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any>? =
    MapBuilder.builder<String, Any>()
      .put("cameraViewReady", MapBuilder.of("registrationName", "onViewReady"))
      .put("cameraInitialized", MapBuilder.of("registrationName", "onInitialized"))
      .put("cameraStarted", MapBuilder.of("registrationName", "onStarted"))
      .put("cameraStopped", MapBuilder.of("registrationName", "onStopped"))
      .put("cameraShutter", MapBuilder.of("registrationName", "onShutter"))
      .put("cameraError", MapBuilder.of("registrationName", "onError"))
      .put("cameraCodeScanned", MapBuilder.of("registrationName", "onCodeScanned"))
      .build()

  override fun getName(): String = TAG

  override fun onDropViewInstance(view: CameraView) {
    view.destroy()
    super.onDropViewInstance(view)
  }

  @ReactProp(name = "cameraId")
  override fun setCameraId(view: CameraView, cameraId: String?) {
    view.cameraId = cameraId
  }

  @ReactProp(name = "photo")
  override fun setPhoto(view: CameraView, photo: Boolean) {
    view.photo = photo
  }

  @ReactProp(name = "video")
  override fun setVideo(view: CameraView, video: Boolean) {
    view.video = video
  }

  @ReactProp(name = "audio")
  override fun setAudio(view: CameraView, audio: Boolean) {
    view.audio = audio
  }

  @ReactProp(name = "enableLocation")
  override fun setEnableLocation(view: CameraView, enableLocation: Boolean) {
    view.enableLocation = enableLocation
  }

  @ReactProp(name = "enableFrameProcessor")
  override fun setEnableFrameProcessor(view: CameraView, enableFrameProcessor: Boolean) {
    view.enableFrameProcessor = enableFrameProcessor
  }

  @ReactProp(name = "pixelFormat")
  override fun setPixelFormat(view: CameraView, pixelFormat: String?) {
    if (pixelFormat != null) {
      val newPixelFormat = PixelFormat.fromUnionValue(pixelFormat)
      view.pixelFormat = newPixelFormat
    } else {
      view.pixelFormat = PixelFormat.NATIVE
    }
  }

  @ReactProp(name = "enableDepthData")
  override fun setEnableDepthData(view: CameraView, enableDepthData: Boolean) {
    view.enableDepthData = enableDepthData
  }

  @ReactProp(name = "enableZoomGesture")
  override fun setEnableZoomGesture(view: CameraView, enableZoomGesture: Boolean) {
    view.enableZoomGesture = enableZoomGesture
  }

  @ReactProp(name = "enableFpsGraph")
  override fun setEnableFpsGraph(view: CameraView, enableFpsGraph: Boolean) {
    view.enableFpsGraph = enableFpsGraph
  }

  @ReactProp(name = "enableGpuBuffers")
  override fun setEnableGpuBuffers(view: CameraView, enableGpuBuffers: Boolean) {
    view.enableGpuBuffers = enableGpuBuffers
  }

  @ReactProp(name = "videoStabilizationMode")
  override fun setVideoStabilizationMode(view: CameraView, videoStabilizationMode: String?) {
    if (videoStabilizationMode != null) {
      val newMode = VideoStabilizationMode.fromUnionValue(videoStabilizationMode)
      view.videoStabilizationMode = newMode
    } else {
      view.videoStabilizationMode = null
    }
  }

  @ReactProp(name = "enablePortraitEffectsMatteDelivery")
  override fun setEnablePortraitEffectsMatteDelivery(view: CameraView, enablePortraitEffectsMatteDelivery: Boolean) {
    view.enablePortraitEffectsMatteDelivery = enablePortraitEffectsMatteDelivery
  }

  @ReactProp(name = "format")
  override fun setFormat(view: CameraView, format: ReadableMap?) {
    if (format != null) {
      val newFormat = CameraDeviceFormat.fromJSValue(format)
      view.format = newFormat
    } else {
      view.format = null
    }
  }

  @ReactProp(name = "resizeMode")
  override fun setResizeMode(view: CameraView, resizeMode: String?) {
    if (resizeMode != null) {
      val newMode = ResizeMode.fromUnionValue(resizeMode)
      view.resizeMode = newMode
    } else {
      view.resizeMode = ResizeMode.COVER
    }
  }

  @ReactProp(name = "androidPreviewViewType")
  override fun setAndroidPreviewViewType(view: CameraView, androidPreviewViewType: String?) {
    if (androidPreviewViewType != null) {
      val newMode = PreviewViewType.fromUnionValue(androidPreviewViewType)
      view.androidPreviewViewType = newMode
    } else {
      view.androidPreviewViewType = PreviewViewType.SURFACE_VIEW
    }
  }

  // TODO: Change when TurboModules release.
  // We're treating -1 as "null" here, because when I make the fps parameter
  // of type "Int?" the react bridge throws an error.
  @ReactProp(name = "fps", defaultInt = -1)
  override fun setFps(view: CameraView, fps: Int) {
    view.fps = if (fps > 0) fps else null
  }

  @ReactProp(name = "photoHdr")
  override fun setPhotoHdr(view: CameraView, photoHdr: Boolean) {
    view.photoHdr = photoHdr
  }

  @ReactProp(name = "photoQualityBalance")
  override fun setPhotoQualityBalance(view: CameraView, photoQualityBalance: String?) {
    if (photoQualityBalance != null) {
      val newMode = QualityBalance.fromUnionValue(photoQualityBalance)
      view.photoQualityBalance = newMode
    } else {
      view.photoQualityBalance = QualityBalance.BALANCED
    }
  }

  @ReactProp(name = "videoHdr")
  override fun setVideoHdr(view: CameraView, videoHdr: Boolean) {
    view.videoHdr = videoHdr
  }

  @ReactProp(name = "lowLightBoost")
  override fun setLowLightBoost(view: CameraView, lowLightBoost: Boolean) {
    view.lowLightBoost = lowLightBoost
  }

  @ReactProp(name = "isActive")
  override fun setIsActive(view: CameraView, isActive: Boolean) {
    view.isActive = isActive
  }

  @ReactProp(name = "torch")
  override fun setTorch(view: CameraView, torch: String?) {
    if (torch != null) {
      val newMode = Torch.fromUnionValue(torch)
      view.torch = newMode
    } else {
      view.torch = Torch.OFF
    }
  }

  @ReactProp(name = "zoom")
  override fun setZoom(view: CameraView, zoom: Double) {
    view.zoom = zoom.toFloat()
  }

  @ReactProp(name = "exposure")
  override fun setExposure(view: CameraView, exposure: Double) {
    view.exposure = exposure
  }

  @ReactProp(name = "orientation")
  override fun setOrientation(view: CameraView, orientation: String?) {
    if (orientation != null) {
      val newMode = Orientation.fromUnionValue(orientation)
      view.orientation = newMode
    } else {
      view.orientation = Orientation.PORTRAIT
    }
  }

  @ReactProp(name = "codeScannerOptions")
  override fun setCodeScannerOptions(view: CameraView, codeScannerOptions: ReadableMap?) {
    if (codeScannerOptions != null) {
      val newCodeScannerOptions = CodeScannerOptions.fromJSValue(codeScannerOptions)
      view.codeScannerOptions = newCodeScannerOptions
    } else {
      view.codeScannerOptions = null
    }
  }

  override fun setEnableBufferCompression(view: CameraView?, value: Boolean) {
    // ios only
  }
}
