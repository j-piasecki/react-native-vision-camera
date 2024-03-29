package com.mrousavy.camera

import com.facebook.react.TurboReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.model.ReactModuleInfo
import com.facebook.react.module.model.ReactModuleInfoProvider
import com.facebook.react.uimanager.ViewManager


class CameraPackage : TurboReactPackage() {
  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> =
    listOf(
      CameraViewModule(reactContext),
      CameraDevicesManager(reactContext)
    )

  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> = listOf(CameraViewManager())

  override fun getModule(name: String, context: ReactApplicationContext): NativeModule? {
    return when (name) {
      CameraViewModule.TAG -> CameraViewModule(context)
      CameraDevicesManager.TAG -> CameraDevicesManager(context)
      else -> null
    }
  }

  override fun getReactModuleInfoProvider(): ReactModuleInfoProvider {
    return ReactModuleInfoProvider {
      val moduleInfos: MutableMap<String, ReactModuleInfo> = HashMap()

      moduleInfos[CameraViewModule.TAG] = ReactModuleInfo(
        CameraViewModule.TAG,
        CameraViewModule.TAG,
        false,  // canOverrideExistingModule
        true,  // needsEagerInit
        true,  // hasConstants
        false,  // isCxxModule
        false // isTurboModule
      )

      moduleInfos[CameraDevicesManager.TAG] = ReactModuleInfo(
        CameraDevicesManager.TAG,
        CameraDevicesManager.TAG,
        false,  // canOverrideExistingModule
        true,  // needsEagerInit
        true,  // hasConstants
        false,  // isCxxModule
        false // isTurboModule
      )
      moduleInfos
    }
  }
}
