import 'dart:async';

import 'package:flutter/services.dart';

class MdInstaFbShare {
  static const MethodChannel _channel = MethodChannel('md_insta_fb_share');

  static Future<String?> shareInstaStory(String backgroundImagePath) async {
    return await _channel.invokeMethod('share_insta_story', {
      "backgroundImage": backgroundImagePath,
    });
  }

  static Future<String?> shareInstaFeed(String backgroundImagePath) async {
    return await _channel.invokeMethod('share_insta_feed', {
      "backgroundImage": backgroundImagePath
    });
  }

  static Future<String?> shareFBStory(String backgroundImagePath) async {
    return await _channel.invokeMethod('share_FB_story', {
      "backgroundImage": backgroundImagePath
    });
  }

  static Future<String?> shareFBFeed(String backgroundImagePath) async {
    return await _channel.invokeMethod('share_FB_feed', {
      "backgroundImage": backgroundImagePath
    });
  }
}
