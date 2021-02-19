# Vison Camera playground

## Overview

This is a demo application featuring some of the many features of the Vision Camera:

* Photo capture
* Video capture
* Device filtering (ultra-wide-angle, wide-angle, telephoto, or even combined virtual multi-cameras)
* Format filtering (targeting 60 FPS, best capture size, best matching aspect ratio, etc.)
* Zooming using [react-native-gesture-handler](https://github.com/software-mansion/react-native-gesture-handler) and [react-native-reanimated](https://github.com/software-mansion/react-native-reanimated)
* HDR mode
* Night mode
* Flash for photo capture
* Flash for video capture
* Activating/Pausing the Camera but keeping it "warm"

## Get started

To try the playground out for yourself, run the following commands:

```sh
git clone https://github.com/mrousavy/react-native-vision-camera
cd react-native-vision-camera
yarn bootstrap
```

### iOS

1. Open the `example/ios/VisionCameraExample.xcworkspace` file with Xcode
2. Change signing configuration to your developer account
3. Select your device in the devices drop-down
4. Hit run

### Android

1. Open the `example/android/` folder with Android Studio
2. Select your device in the devices drop-down
3. Hit run