# md_insta_fb_share
A new Flutter plugin was created while using the framework to develop [cross-platform apps at MobiDev](https://mobidev.biz/services/cross-platform-app-development)

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.io/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# MdInstaFbShare

A Flutter plugin that allows to share images to instagram or facebook

[Example](https://github.com/igorbaranovmd/md_insta_fb_share/blob/master/example/lib/main.dart)

To use this plugin :

- Add the dependency to your [pubspec.yaml](https://github.com/igorbaranovmd/md_insta_fb_share/blob/master/example/pubspec.yaml) file.

```yaml
  dependencies:
    flutter:
      sdk: flutter
    md_insta_fb_share:
```

### Example
## Share methods return `String` if error and `null` if success

```dart
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:md_insta_fb_share/md_insta_fb_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final dir = (await getTemporaryDirectory()).path;

                  final data = await rootBundle.load('assets/insta_big.png');
                  final buffer = data.buffer;
                  final fileName = 'insta_big-${DateTime.now().millisecondsSinceEpoch}.png';
                  final file = await File('$dir/$fileName').writeAsBytes(
                      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

                  MdInstaFbShare.shareInstaStory(file.path);
                },
                child: const Text('Test insta story share')
              ),
              ElevatedButton(
                  onPressed: () async {
                    final dir = (await getTemporaryDirectory()).path;

                    final data = await rootBundle.load('assets/insta_big.png');
                    final buffer = data.buffer;
                    final fileName =  'insta_big-${DateTime.now().millisecondsSinceEpoch}.png';
                    final file = await File('$dir/$fileName').writeAsBytes(
                        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

                    MdInstaFbShare.shareInstaFeed(file.path);
                  },
                  child: const Text('Test insta feed share')
              ),
              ElevatedButton(
                  onPressed: () async {
                    final dir = (await getTemporaryDirectory()).path;

                    final data = await rootBundle.load('assets/insta_big.png');
                    final buffer = data.buffer;
                    final fileName = 'insta_big-${DateTime.now().millisecondsSinceEpoch}.png';
                    final file = await File('$dir/$fileName').writeAsBytes(
                        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
                    MdInstaFbShare.shareFBStory(file.path);
                  },
                  child: const Text('Test FB story share')
              ),
              ElevatedButton(
                  onPressed: () async {
                    final dir = (await getTemporaryDirectory()).path;

                    final data = await rootBundle.load('assets/insta_big.png');
                    final buffer = data.buffer;
                    final fileName = 'insta_big-${DateTime.now().millisecondsSinceEpoch}.png';
                    final file = await File('$dir/$fileName').writeAsBytes(
                        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
                    MdInstaFbShare.shareFBFeed(file.path);
                  },
                  child: const Text('Test FB feed share')
              ),
              Image.asset('assets/insta_big.png', width: 150, fit: BoxFit.fitWidth),
              Row(
                children: [
                  const Text('FB App available: '),
                  FutureBuilder(
                    future: MdInstaFbShare.checkFBInstalled(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Text('${snapshot.data}');
                      }
                      return Container();
                    },
                  )
                ],
              ),
              Row(
                children: [
                  const Text('Insta App available: '),
                  FutureBuilder(
                    future: MdInstaFbShare.checkInstaInstalled(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Text('${snapshot.data}');
                      }
                      return Container();
                    },
                  )
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}
```

## iOS
```xml
<!--Info.plist-->
<key>FacebookAppID</key>
<string>{Your-FB-APP-ID}</string>
<key>CFBundleURLTypes</key>
<array>
<dict>
    <key>CFBundleURLSchemes</key>
    <array>
        <string>fb{Your-FB-APP-ID}</string>
    </array>
</dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
<string>instagram-stories</string>
<string>facebook-stories</string>
<string>facebook</string>
<string>instagram</string>
<string>fbauth2</string>
<string>fbauth2</string>
<string>fbapi</string>
<string>fbapi20130214</string>
<string>fbapi20130410</string>
<string>fbapi20130702</string>
<string>fbapi20131010</string>
<string>fbapi20131219</string>
<string>fbapi20140410</string>
<string>fbapi20140116</string>
<string>fbapi20150313</string>
<string>fbapi20150629</string>
<string>fbapi20160328</string>
<string>fbauth</string>
<string>fbauth2</string>
<string>fbshareextension</string>
</array>
<key>NSPhotoLibraryUsageDescription</key>
<string>Allow access to photo library</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Allow access to photo library</string>
```

```swift
// AppDelegate.swift
import UIKit
import Flutter
import FBSDKCoreKit <-- add this

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    ApplicationDelegate.shared.initializeSDK(); <-- add this
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

```

## Android
```xml
<!--inside /android/src/main/AndroidManifest.xml-->
<application>
<!--your code-->
<provider android:authorities="com.facebook.app.FacebookContentProvider{Your-FB-APP-ID}"
            android:name="com.facebook.FacebookContentProvider"
            android:exported="true"/>

<meta-data
        android:name="com.facebook.sdk.ApplicationId"
        android:value="@string/facebook_app_id" />
<!--your code-->
</application>
```

```xml
<!--app/src/main/res/values/strings.xml-->
<string name="facebook_app_id">{Your FB app ID}</string>
```

```xml
<!--app/src/main/build.gradle-->
dependencies {
    implementation 'com.facebook.android:facebook-share:latest.release'
}
```


## Getting Started

For help getting started with Flutter, view our online
[documentation](http://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).