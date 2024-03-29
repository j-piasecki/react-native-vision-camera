/* eslint-disable @typescript-eslint/ban-types */
import type { HostComponent, ViewProps } from 'react-native';
import type { DirectEventHandler, Double, Int32 } from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

export type VisionCameraComponentType = HostComponent<NativeProps>;

export interface NativeProps extends ViewProps {
  enableGpuBuffers: boolean;
  androidPreviewViewType?: string;
  cameraId: string;
  enableFrameProcessor: boolean;
  enableLocation: boolean;
  enableBufferCompression: boolean;
  photoQualityBalance: string;
  isActive: boolean;
  photo?: boolean;
  video?: boolean; 
  audio?: boolean;
  torch?: string;
  zoom?: Double;
  exposure?: Double;
  enableZoomGesture?: boolean;
  enableFpsGraph?: boolean;
  resizeMode?: string;
  format?: Readonly<{
    supportsDepthCapture?: boolean;
    photoHeight: Double;
    photoWidth: Double;
    videoHeight: Double;
    videoWidth: Double;
    maxISO: Double;
    minISO: Double;
    maxFps: Double;
    minFps: Double;
    fieldOfView: Double;
    supportsVideoHDR: boolean;
    supportsPhotoHDR: boolean;
    autoFocusSystem: string;
    videoStabilizationModes: string[];
    pixelFormats: string[];
  }>;
  pixelFormat: string;
  fps?: Int32;
  videoHdr?: boolean; // not sure why was int on native side
  photoHdr?: boolean; // not sure why was int on native side
  lowLightBoost?: boolean; // same
  videoStabilizationMode?: string;
  enableDepthData?: boolean;
  enablePortraitEffectsMatteDelivery?: boolean;
  orientation?: string;
  codeScannerOptions?: Readonly<{
    codeTypes?: string[];
    interval?: Double;
    regionOfInterest?: Readonly<{
      x?: Double,
      y?: Double,
      width?: Double,
      height?: Double,
    }>;
  }>;
  onCodeScanned?: DirectEventHandler<
    Readonly<{
      codes?: Readonly<{
        type?: string;
        value?: string;
        frame?: Readonly<{ x: Double, y: Double, width: Double, height: Double}>;
      }>;
      frame?: Readonly<{ width: Int32, height: Int32 }>;
      corners?: Readonly<{ x: Double, y: Double }>;
    }>
  >;
  onShutter?: DirectEventHandler<
    Readonly<{
      type: string;
    }>
  >;
  onStarted?: DirectEventHandler<Readonly<{}>>;
  onStopped?: DirectEventHandler<Readonly<{}>>;
  onInitialized?: DirectEventHandler<Readonly<{}>>;
  onError?: DirectEventHandler<
    Readonly<{
      code: string;
      message: string;
      cause: Readonly<{ code: string; domain: string; message: string; details: string }>;
    }>
  >;
  onViewReady: DirectEventHandler<Readonly<{}>>;
}

export default codegenNativeComponent<NativeProps>('CameraView');
