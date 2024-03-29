//
//  CameraView.swift
//  mrousavy
//
//  Created by Marc Rousavy on 09.11.20.
//  Copyright © 2020 mrousavy. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

// TODOs for the CameraView which are currently too hard to implement either because of AVFoundation's limitations, or my brain capacity
//
// CameraView+RecordVideo
// TODO: Better startRecording()/stopRecording() (promise + callback, wait for TurboModules/JSI)
//
// CameraView+TakePhoto
// TODO: Photo HDR

// MARK: - CameraView

public final class CameraView: UIView, CameraSessionDelegate {
  // pragma MARK: React Properties
  // props that require reconfiguring
  @objc public var cameraId: NSString?
  @objc public var enableDepthData = false
  @objc public var enablePortraitEffectsMatteDelivery = false
  @objc public var enableBufferCompression = false
  // use cases
  @objc public var photo = false
  @objc public var video = false
  @objc public var audio = false
  @objc public var enableFrameProcessor = false
  @objc public var codeScannerOptions: NSDictionary?
  @objc public var pixelFormat: NSString?
  @objc public var enableLocation = false
  // props that require format reconfiguring
  @objc public var format: NSDictionary?
  @objc public var fps: NSNumber?
  @objc public var videoHdr = false
  @objc public var photoHdr = false
  @objc public var photoQualityBalance: NSString?
  @objc public var lowLightBoost = false
  @objc public var orientation: NSString?
  // other props
  @objc public var isActive = false
  @objc public var torch = "off"
  @objc public var zoom: NSNumber = 1.0 // in "factor"
  @objc public var exposure: NSNumber = 1.0
  @objc public var enableFpsGraph = false
  @objc public var videoStabilizationMode: NSString?
  @objc public var resizeMode: NSString = "cover" {
    didSet {
      let parsed = try? ResizeMode(jsValue: resizeMode as String)
      previewView.resizeMode = parsed ?? .cover
    }
  }
#if RCT_NEW_ARCH_ENABLED
  @objc public var delegate: RNCameraViewDirectEventDelegate?
#else

  // events
  @objc var onInitialized: RCTDirectEventBlock?
  @objc var onError: RCTDirectEventBlock?
  @objc var onStarted: RCTDirectEventBlock?
  @objc var onStopped: RCTDirectEventBlock?
  @objc var onShutter: RCTDirectEventBlock?
  @objc var onViewReady: RCTDirectEventBlock?
  @objc var onCodeScanned: RCTDirectEventBlock?
#endif
  // zoom
  @objc public var enableZoomGesture = false {
    didSet {
      if enableZoomGesture {
        addPinchGestureRecognizer()
      } else {
        removePinchGestureRecognizer()
      }
    }
  }

  // pragma MARK: Internal Properties
  var cameraSession: CameraSession
  var isMounted = false
  var isReady = false
  #if VISION_CAMERA_ENABLE_FRAME_PROCESSORS
    @objc public var frameProcessor: FrameProcessor?
  #endif
  // CameraView+Zoom
  var pinchGestureRecognizer: UIPinchGestureRecognizer?
  var pinchScaleOffset: CGFloat = 1.0
  private var currentConfigureCall: DispatchTime?
  var snapshotOnFrameListeners: [(_: CMSampleBuffer) -> Void] = []

  var previewView: PreviewView
  #if DEBUG
    var fpsGraph: RCTFPSGraph?
  #endif

  // pragma MARK: Setup

  override public init(frame: CGRect) {
    // Create CameraSession
    cameraSession = CameraSession()
    previewView = cameraSession.createPreviewView(frame: frame)
    super.init(frame: frame)
    cameraSession.delegate = self

    addSubview(previewView)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) is not implemented.")
  }

  override public func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)

    if newSuperview != nil {
      if !isMounted {
        isMounted = true
#if RCT_NEW_ARCH_ENABLED
  guard let delegate = delegate else {
    return
  }
  delegate.onViewReady()
#else
  onViewReady?(nil)
#endif
      }
    }
  }

  override public func layoutSubviews() {
    previewView.frame = frame
    previewView.bounds = bounds
  }

  func getPixelFormat() -> PixelFormat {
    // TODO: Use ObjC RCT enum parser for this
    if let pixelFormat = pixelFormat as? String {
      do {
        return try PixelFormat(jsValue: pixelFormat)
      } catch {
        if let error = error as? CameraError {
          onError(error)
        } else {
          onError(.unknown(message: error.localizedDescription, cause: error as NSError))
        }
      }
    }
    return .native
  }

  func getTorch() -> Torch {
    // TODO: Use ObjC RCT enum parser for this
    if let torch = try? Torch(jsValue: torch) {
      return torch
    }
    return .off
  }

  func getPhotoQualityBalance() -> QualityBalance {
    if let photoQualityBalance = photoQualityBalance as? String,
       let balance = try? QualityBalance(jsValue: photoQualityBalance) {
      return balance
    }
    return .balanced
  }

  // pragma MARK: Props updating
  override public final func didSetProps(_ changedProps: [String]!) {
    ReactLogger.log(level: .info, message: "Updating \(changedProps.count) props: [\(changedProps.joined(separator: ", "))]")
    let now = DispatchTime.now()
    currentConfigureCall = now

    cameraSession.configure { [self] config in
      // Check if we're still the latest call to configure { ... }
      guard currentConfigureCall == now else {
        // configure waits for a lock, and if a new call to update() happens in the meantime we can drop this one.
        // this works similar to how React implemented concurrent rendering, the newer call to update() has higher priority.
        ReactLogger.log(level: .info, message: "A new configure { ... } call arrived, aborting this one...")
        return
      }

      // Input Camera Device
      config.cameraId = cameraId as? String

      // Photo
      if photo {
        config.photo = .enabled(config: CameraConfiguration.Photo(qualityBalance: getPhotoQualityBalance(),
                                                                  enableDepthData: enableDepthData,
                                                                  enablePortraitEffectsMatte: enablePortraitEffectsMatteDelivery))
      } else {
        config.photo = .disabled
      }

      // Video/Frame Processor
      if video || enableFrameProcessor {
        config.video = .enabled(config: CameraConfiguration.Video(pixelFormat: getPixelFormat(),
                                                                  enableBufferCompression: enableBufferCompression,
                                                                  enableHdr: videoHdr,
                                                                  enableFrameProcessor: enableFrameProcessor))
      } else {
        config.video = .disabled
      }

      // Audio
      if audio {
        config.audio = .enabled(config: CameraConfiguration.Audio())
      } else {
        config.audio = .disabled
      }

      // Code Scanner
      if let codeScannerOptions {
        let options = try CodeScannerOptions(fromJsValue: codeScannerOptions)
        config.codeScanner = .enabled(config: CameraConfiguration.CodeScanner(options: options))
      } else {
        config.codeScanner = .disabled
      }

      // Location tagging
      config.enableLocation = enableLocation && isActive

      // Video Stabilization
      if let jsVideoStabilizationMode = videoStabilizationMode as? String {
        let videoStabilizationMode = try VideoStabilizationMode(jsValue: jsVideoStabilizationMode)
        config.videoStabilizationMode = videoStabilizationMode
      } else {
        config.videoStabilizationMode = .off
      }

      // Orientation
      if let jsOrientation = orientation as? String {
        let orientation = try Orientation(jsValue: jsOrientation)
        config.orientation = orientation
      } else {
        config.orientation = .portrait
      }

      // Format
      if let jsFormat = format {
        let format = try CameraDeviceFormat(jsValue: jsFormat)
        config.format = format
      } else {
        config.format = nil
      }

      // Side-Props
      config.fps = fps?.int32Value
      config.enableLowLightBoost = lowLightBoost
      config.torch = try Torch(jsValue: torch)

      // Zoom
      config.zoom = zoom.doubleValue

      // Exposure
      config.exposure = exposure.floatValue

      // isActive
      config.isActive = isActive
    }

    // Store `zoom` offset for native pinch-gesture
    if changedProps.contains("zoom") {
      pinchScaleOffset = zoom.doubleValue
    }

    // Set up Debug FPS Graph
    if changedProps.contains("enableFpsGraph") {
      DispatchQueue.main.async {
        self.setupFpsGraph()
      }
    }

    // Prevent phone from going to sleep
    UIApplication.shared.isIdleTimerDisabled = isActive
  }

  func setupFpsGraph() {
    #if DEBUG
      if enableFpsGraph {
        if fpsGraph != nil { return }
        fpsGraph = RCTFPSGraph(frame: CGRect(x: 10, y: 54, width: 75, height: 45), color: .red)
        fpsGraph!.layer.zPosition = 9999.0
        addSubview(fpsGraph!)
      } else {
        fpsGraph?.removeFromSuperview()
        fpsGraph = nil
      }
    #endif
  }

  // pragma MARK: Event Invokers

  func onError(_ error: CameraError) {
    ReactLogger.log(level: .error, message: "Invoking onError(): \(error.message)")
    var causeDictionary: [String: Any]?
    if case let .unknown(_, cause) = error,
       let cause = cause {
      causeDictionary = [
        "code": cause.code,
        "domain": cause.domain,
        "message": cause.description,
        "details": cause.userInfo,
      ]
    }
#if RCT_NEW_ARCH_ENABLED
  guard let delegate = delegate else {
    return
  }
  delegate.onError(error:[
    "code": error.code,
    "message": error.message,
    "cause": causeDictionary ?? NSNull(),
  ])
#else
guard let onError = onError else { return }
    onError([
      "code": error.code,
      "message": error.message,
      "cause": causeDictionary ?? NSNull(),
    ])
#endif
  }

  func onSessionInitialized() {
    ReactLogger.log(level: .info, message: "Camera initialized!")
#if RCT_NEW_ARCH_ENABLED
  guard let delegate = delegate else {
    return
  }
  delegate.onInitialized()
#else
    guard let onInitialized = onInitialized else {
      return
    }
    onInitialized([:])
#endif
  }

  func onCameraStarted() {
    ReactLogger.log(level: .info, message: "Camera started!")
#if RCT_NEW_ARCH_ENABLED
  guard let delegate = delegate else {
    return
  }
  delegate.onStarted()
#else
    guard let onStarted = onStarted else {
      return
    }
    onStarted([:])
#endif
  }

  func onCameraStopped() {
    ReactLogger.log(level: .info, message: "Camera stopped!")
#if RCT_NEW_ARCH_ENABLED
  guard let delegate = delegate else {
    return
  }
  delegate.onStopped()
#else
    guard let onStopped = onStopped else {
      return
    }
    onStopped([:])
#endif
  }

  func onCaptureShutter(shutterType: ShutterType) {
#if RCT_NEW_ARCH_ENABLED
  guard let delegate = delegate else {
    return
  }
  delegate.onShutter(message:[
    "type": shutterType.jsValue,
  ])
#else
    guard let onShutter = onShutter else {
      return
    }
    onShutter([
      "type": shutterType.jsValue,
    ])
#endif
  }

  func onFrame(sampleBuffer: CMSampleBuffer) {
    #if VISION_CAMERA_ENABLE_FRAME_PROCESSORS
      if let frameProcessor = frameProcessor {
        // Call Frame Processor
        let frame = Frame(buffer: sampleBuffer, orientation: bufferOrientation)
        frameProcessor.call(frame)
      }
    #endif

    for callback in snapshotOnFrameListeners {
      callback(sampleBuffer)
    }
    snapshotOnFrameListeners.removeAll()

    #if DEBUG
      if let fpsGraph {
        DispatchQueue.main.async {
          fpsGraph.onTick(CACurrentMediaTime())
        }
      }
    #endif
  }

  func onCodeScanned(codes: [CameraSession.Code], scannerFrame: CameraSession.CodeScannerFrame) {
#if RCT_NEW_ARCH_ENABLED
  guard let delegate = delegate else {
    return
  }
  delegate.onCodeScanned(message:[
    "codes": codes.map { $0.toJSValue() },
    "frame": scannerFrame.toJSValue(),
  ])
#else
    guard let onCodeScanned = onCodeScanned else {
      return
    }
    onCodeScanned([
      "codes": codes.map { $0.toJSValue() },
      "frame": scannerFrame.toJSValue(),
    ])
#endif
  }

  /**
   Gets the orientation of the CameraView's images (CMSampleBuffers).
   */
  private var bufferOrientation: UIImage.Orientation {
    guard let cameraPosition = cameraSession.videoDeviceInput?.device.position else {
      return .up
    }
    let orientation = cameraSession.configuration?.orientation ?? .portrait

    // TODO: I think this is wrong.
    switch orientation {
    case .portrait:
      return cameraPosition == .front ? .leftMirrored : .right
    case .landscapeLeft:
      return cameraPosition == .front ? .downMirrored : .up
    case .portraitUpsideDown:
      return cameraPosition == .front ? .rightMirrored : .left
    case .landscapeRight:
      return cameraPosition == .front ? .upMirrored : .down
    }
  }
}

@objc public protocol RNCameraViewDirectEventDelegate: AnyObject { //TODO: Move to a separate file
    func onInitialized()
    func onError(error: NSDictionary)
    func onViewReady()
    func onStarted()
    func onStopped()
    func onShutter(message: NSDictionary)
    func onCodeScanned(message: NSDictionary)
}
