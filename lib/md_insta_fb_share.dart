import 'dart:async';

import 'package:flutter/services.dart';

class MdInstaFbShare {

  MdInstaFbShare._();

  static const MethodChannel _channel = MethodChannel('md_insta_fb_share');

  static Future<String?> shareInstaStory(String backgroundImagePath) => _channel.invokeMethod('share_insta_story', {
    "backgroundImage": backgroundImagePath,
  });

  static Future<String?> shareInstaFeed(String backgroundImagePath) => _channel.invokeMethod('share_insta_feed', {
    "backgroundImage": backgroundImagePath
  });

  static Future<String?> shareFBStory(String backgroundImagePath) => _channel.invokeMethod('share_FB_story', {
    "backgroundImage": backgroundImagePath
  });

  static Future<String?> shareFBFeed(String backgroundImagePath) => _channel.invokeMethod('share_FB_feed', {
    "backgroundImage": backgroundImagePath
  });

  static Future<bool> checkFBInstalled() => _channel.invokeMethod('check_insta');

  static Future<bool> checkInstaInstalled() => _channel.invokeMethod('check_FB');
}
