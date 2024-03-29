/* eslint-disable @typescript-eslint/no-empty-interface */
import type { HostComponent, ViewProps } from 'react-native'
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent'
import { Double, Int32, WithDefault } from 'react-native/Libraries/Types/CodegenTypes'

interface FormatOptions {}
interface CodeScannerOptions {}

export interface NativeProps extends ViewProps {
  cameraId: string
  photo: boolean
  video: boolean
  audio: boolean
  enableLocation: boolean
  enableFrameProcessor: boolean
  pixelFormat?: string
  enableDepthData: boolean
  enableZoomGesture: boolean
  enableFpsGraph: boolean
  enableGpuBuffers: boolean
  videoStabilizationMode?: string
  enablePortraitEffectsMatteDelivery: boolean
  format: FormatOptions
  resizeMode?: string
  androidPreviewViewType?: string
  fps?: WithDefault<Int32, -1>
  photoHdr: boolean
  photoQualityBalance?: string
  videoHdr: boolean
  lowLightBoost: boolean
  isActive: boolean
  torch?: string
  zoom: Double
  exposure: Double
  orientation?: string
  codeScannerOptions: CodeScannerOptions
}

export default codegenNativeComponent<NativeProps>('CameraView') as HostComponent<NativeProps>
