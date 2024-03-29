// This guard prevent the code from being compiled in the old architecture
#ifdef RCT_NEW_ARCH_ENABLED
//#import "RNCameraView.h"
#import <React/RCTViewComponentView.h>

#import <react/renderer/components/RNVisionCameraSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNVisionCameraSpec/EventEmitters.h>
#import <react/renderer/components/RNVisionCameraSpec/Props.h>
#import <react/renderer/components/RNVisionCameraSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import <AVFoundation/AVCaptureAudioDataOutput.h>
#import <AVFoundation/AVCaptureVideoDataOutput.h>
#import <React/RCTViewManager.h>
#import <React/RCTConversions.h>
#import "VisionCamera-Swift.h"

@interface RNCameraView : RCTViewComponentView <RNCameraViewDirectEventDelegate>
@end


using namespace facebook::react;

@implementation RNCameraView {
    CameraView * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<CameraViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
if (self) {
    static const auto defaultProps = std::make_shared<const CameraViewProps>();
    _props = defaultProps;

    //The remaining part of the initializer is standard Objective-C code to create views and layout them with AutoLayout. Here we can change whatever we want to.
    _view = [[CameraView alloc] init];
    _view.delegate = self;    

    self.contentView = _view;
}

return self;
}

// why we need this func -> https://reactnative.dev/docs/next/the-new-architecture/pillars-fabric-components#write-the-native-ios-code
- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &newViewProps = *std::static_pointer_cast<CameraViewProps const>(props);
    const auto &oldViewProps = *std::static_pointer_cast<CameraViewProps const>(_props);
    
    NSMutableArray* changedProps = [[NSMutableArray alloc] init];
    
    if(oldViewProps.isActive != newViewProps.isActive){
        _view.isActive = newViewProps.isActive;
        [changedProps addObject:@"isActive"];
    }
    if(oldViewProps.cameraId != newViewProps.cameraId){
        _view.cameraId = RCTNSStringFromString(newViewProps.cameraId);
        [changedProps addObject:@"cameraId"];
    }
    if(oldViewProps.photoQualityBalance != newViewProps.photoQualityBalance){
        _view.photoQualityBalance = RCTNSStringFromString(newViewProps.photoQualityBalance);
        [changedProps addObject:@"photoQualityBalance"];
    }
    if(oldViewProps.enableDepthData != newViewProps.enableDepthData){
        _view.enableDepthData = newViewProps.enableDepthData;
        [changedProps addObject:@"enableDepthData"];
    }
    if(oldViewProps.enablePortraitEffectsMatteDelivery != newViewProps.enablePortraitEffectsMatteDelivery){
        _view.enablePortraitEffectsMatteDelivery = newViewProps.enablePortraitEffectsMatteDelivery;
        [changedProps addObject:@"enablePortraitEffectsMatteDelivery"];
    }
    if(oldViewProps.photo != newViewProps.photo){
        _view.photo = [NSNumber numberWithBool:newViewProps.photo];
        [changedProps addObject:@"photo"];
    }
    if(oldViewProps.video != newViewProps.video){
        _view.video = [NSNumber numberWithBool:newViewProps.video];
        [changedProps addObject:@"video"];
    }
    if(oldViewProps.audio != newViewProps.audio){
        _view.audio = [NSNumber numberWithBool:newViewProps.audio];
        [changedProps addObject:@"audio"];
    }
    if(oldViewProps.enableFrameProcessor != newViewProps.enableFrameProcessor){
        _view.enableFrameProcessor = newViewProps.enableFrameProcessor;
        [changedProps addObject:@"enableFrameProcessor"];
    }
    if(oldViewProps.enableLocation != newViewProps.enableLocation){
        _view.enableLocation = newViewProps.enableLocation;
        [changedProps addObject:@"enableLocation"];
    }
    if(oldViewProps.enableBufferCompression != newViewProps.enableBufferCompression){
        _view.enableBufferCompression = newViewProps.enableBufferCompression;
        [changedProps addObject:@"enableBufferCompression"];
    }
    if(oldViewProps.fps != newViewProps.fps){
        _view.fps = [NSNumber numberWithInt:newViewProps.fps];
        [changedProps addObject:@"fps"];
    }
    if(oldViewProps.videoHdr != newViewProps.videoHdr){
        _view.videoHdr = newViewProps.videoHdr;
        [changedProps addObject:@"videoHdr"];
    }
    if(oldViewProps.photoHdr != newViewProps.photoHdr){
        _view.photoHdr = newViewProps.photoHdr;
        [changedProps addObject:@"photoHdr"];
    }
    if(oldViewProps.lowLightBoost != newViewProps.lowLightBoost){
        _view.lowLightBoost = newViewProps.lowLightBoost;
        [changedProps addObject:@"lowLightBoost"];
    }
    if(oldViewProps.videoStabilizationMode != newViewProps.videoStabilizationMode){
        _view.videoStabilizationMode = RCTNSStringFromString(newViewProps.videoStabilizationMode);
        [changedProps addObject:@"videoStabilizationMode"];
    }
    if(oldViewProps.torch != newViewProps.torch){
        _view.torch = RCTNSStringFromString(newViewProps.torch);
        [changedProps addObject:@"torch"];
    }
    if(oldViewProps.orientation != newViewProps.orientation){
        _view.orientation = RCTNSStringFromString(newViewProps.orientation);
        [changedProps addObject:@"orientation"];
    }
    if(oldViewProps.resizeMode != newViewProps.resizeMode){
        _view.resizeMode = RCTNSStringFromString(newViewProps.resizeMode);
        [changedProps addObject:@"resizeMode"];
    }
    if(oldViewProps.pixelFormat != newViewProps.pixelFormat){
        _view.pixelFormat = RCTNSStringFromString(newViewProps.pixelFormat);
        [changedProps addObject:@"pixelFormat"];
    }
    if(oldViewProps.zoom != newViewProps.zoom){
        _view.zoom = [NSNumber numberWithDouble:newViewProps.zoom];
        [changedProps addObject:@"zoom"];
    }
    if(oldViewProps.exposure != newViewProps.exposure){
        _view.exposure = [NSNumber numberWithDouble:newViewProps.exposure];
        [changedProps addObject:@"exposure"];
    }
    if(oldViewProps.enableZoomGesture != newViewProps.enableZoomGesture){
        _view.enableZoomGesture = newViewProps.enableZoomGesture;
        [changedProps addObject:@"enableZoomGesture"];
    }
    if(oldViewProps.enableFpsGraph != newViewProps.enableFpsGraph){
        _view.enableFpsGraph = newViewProps.enableFpsGraph;
        [changedProps addObject:@"enableFpsGraph"];
    }
    
        
    if(_view.format == nil){
        _view.format =[ [NSMutableDictionary alloc] init];
    }
    

    //Checking format props, TODO: find cleaner way to do it
    if(oldViewProps.format.supportsDepthCapture != newViewProps.format.supportsDepthCapture){
        NSNumber* supportsDepthCapture = newViewProps.format.supportsDepthCapture ? @1 : @0;
        [_view.format setValue:supportsDepthCapture forKey:@"supportsDepthCapture"];
        [changedProps addObject:@"format"];
    }
    if(oldViewProps.format.autoFocusSystem != newViewProps.format.autoFocusSystem){
        [_view.format setValue:RCTNSStringFromString(newViewProps.format.autoFocusSystem) forKey:@"autoFocusSystem"];
        [changedProps addObject:@"format"];
    }
    if(oldViewProps.format.pixelFormats.size() != newViewProps.format.pixelFormats.size()){
        NSMutableArray* newPixelFormats = [[NSMutableArray alloc] init];
        for(int i = 0; i < newViewProps.format.pixelFormats.size(); i++){
            [newPixelFormats addObject:RCTNSStringFromString(newViewProps.format.pixelFormats.at(i))];
        }
        [_view.format setValue:newPixelFormats forKey:@"pixelFormats"];
        [changedProps addObject:@"format"];
    }
    
    if(oldViewProps.format.videoStabilizationModes.size() != newViewProps.format.videoStabilizationModes.size()){
        NSMutableArray* newVideoStabilizationModes = [[NSMutableArray alloc] init];
        for(int i = 0; i < newViewProps.format.videoStabilizationModes.size(); i++){
            [newVideoStabilizationModes addObject:RCTNSStringFromString(newViewProps.format.videoStabilizationModes.at(i))];
        }
        [_view.format setValue:newVideoStabilizationModes forKey:@"videoStabilizationModes"];
        [changedProps addObject:@"format"];
    }
    
    if(oldViewProps.format.photoHeight != newViewProps.format.photoHeight){
        [_view.format setValue:[NSNumber numberWithDouble:newViewProps.format.photoHeight] forKey:@"photoHeight"];
        [changedProps addObject:@"format"];
    }
    if(oldViewProps.format.photoWidth != newViewProps.format.photoWidth){
        [_view.format setValue:[NSNumber numberWithDouble:newViewProps.format.photoWidth] forKey:@"photoWidth"];
        [changedProps addObject:@"format"];
    }
    if(oldViewProps.format.videoHeight != newViewProps.format.videoHeight){
        [_view.format setValue:[NSNumber numberWithDouble:newViewProps.format.videoHeight] forKey:@"videoHeight"];
        [changedProps addObject:@"format"];
    }
    if(oldViewProps.format.videoWidth != newViewProps.format.videoWidth){
        [_view.format setValue:[NSNumber numberWithDouble:newViewProps.format.videoWidth] forKey:@"videoWidth"];
        [changedProps addObject:@"format"];
    }
    if(oldViewProps.format.maxISO != newViewProps.format.maxISO){
        [_view.format setValue:[NSNumber numberWithDouble:newViewProps.format.maxISO] forKey:@"maxISO"];
        [changedProps addObject:@"format"];
    }
    if(oldViewProps.format.minISO != newViewProps.format.minISO){
        [_view.format setValue:[NSNumber numberWithDouble:newViewProps.format.minISO] forKey:@"minISO"];
        [changedProps addObject:@"format"];
    }
    if(oldViewProps.format.maxFps != newViewProps.format.maxFps){
        [_view.format setValue:[NSNumber numberWithDouble:newViewProps.format.maxFps] forKey:@"maxFps"];
        [changedProps addObject:@"format"];
    }
    if(oldViewProps.format.minFps != newViewProps.format.minFps){
        [_view.format setValue:[NSNumber numberWithDouble:newViewProps.format.minFps] forKey:@"minFps"];
        [changedProps addObject:@"format"];
    }
    if(oldViewProps.format.fieldOfView != newViewProps.format.fieldOfView){
        [_view.format setValue:[NSNumber numberWithDouble:newViewProps.format.fieldOfView] forKey:@"fieldOfView"];
        [changedProps addObject:@"format"];
    }

    if(oldViewProps.format.supportsVideoHDR != newViewProps.format.supportsVideoHDR){
        NSNumber* supportsVideoHDR = newViewProps.format.supportsVideoHDR ? @1 : @0;
        [_view.format setValue:supportsVideoHDR forKey:@"supportsVideoHDR"];
        [changedProps addObject:@"format"];
    }
    if(oldViewProps.format.supportsPhotoHDR != newViewProps.format.supportsPhotoHDR){
        NSNumber* supportsPhotoHDR = newViewProps.format.supportsPhotoHDR ? @1 : @0;
        [_view.format setValue:supportsPhotoHDR forKey:@"supportsPhotoHDR"];
        [changedProps addObject:@"format"];
    }
    
    if (_view.format.count == 0) {
        _view.format = nil;
    }

    [_view didSetProps:changedProps];

    [super updateProps:props oldProps:oldProps];
}

- (void)onViewReady{
    if(_eventEmitter){
        std::dynamic_pointer_cast<const CameraViewEventEmitter>(_eventEmitter)
        ->onViewReady( CameraViewEventEmitter::OnViewReady{});
    }
}

- (void)onErrorWithError:(NSDictionary *)error{
    if(_eventEmitter){
        std::dynamic_pointer_cast<const CameraViewEventEmitter>(_eventEmitter)
        ->onError( CameraViewEventEmitter::OnError{
            .code = std::string([(error != nil ? [error objectForKey:@"code"] : @"") UTF8String]),
            .message = std::string([(error != nil ? [error objectForKey:@"message"] : @"") UTF8String]),
            .cause = {
                .code = std::string([(error != nil ? [[error objectForKey:@"cause"] objectForKey:@"code"] : @"") UTF8String]), // TODO: Further secure type safety to prevent crashes
                .domain = std::string([(error != nil ? [[error objectForKey:@"cause"] objectForKey:@"domain"]  : @"") UTF8String]),
                .message = std::string([(error != nil ? [[error objectForKey:@"cause"] objectForKey:@"message"]  : @"") UTF8String]),
                .details = std::string([(error != nil ? [[error objectForKey:@"cause"] objectForKey:@"details"]  : @"") UTF8String])
            }
        });
    }
}

- (void)onInitialized{
    if(_eventEmitter){
        std::dynamic_pointer_cast<const CameraViewEventEmitter>(_eventEmitter)
        ->onInitialized( CameraViewEventEmitter::OnInitialized{});
    }
}

- (void)onCodeScanned {
    
}


- (void)onShutterWithMessage:(NSDictionary *)message {
    if(_eventEmitter){
        std::dynamic_pointer_cast<const CameraViewEventEmitter>(_eventEmitter)
        ->onShutter( CameraViewEventEmitter::OnShutter{
            .type = std::string([(message != nil ? [message objectForKey:@"type"] : @"") UTF8String]),
        });
    }
}


- (void)onStarted {
    if(_eventEmitter){
        std::dynamic_pointer_cast<const CameraViewEventEmitter>(_eventEmitter)
        ->onStarted( CameraViewEventEmitter::OnStarted{});
    }
}


- (void)onStopped {
    if(_eventEmitter){
        std::dynamic_pointer_cast<const CameraViewEventEmitter>(_eventEmitter)
        ->onViewReady( CameraViewEventEmitter::OnViewReady{});
    }
}

Class<RCTComponentViewProtocol> CameraViewCls(void)
{
    return RNCameraView.class;
}

@end
#endif
