import 'dart:async';

import 'package:flutter/services.dart';

class MdInstaFbShare {
  static const MethodChannel _channel = MethodChannel('md_insta_fb_share');

  static Future<String?> shareInstaStory(String backgroundImage, {
    String? stickerImage,
    String? backgroundTopColor,
    String? backgroundBottomColor,
    String? contentURL
  }) async {
    return await _channel.invokeMethod('share_insta_story', {
      "backgroundImage": backgroundImage,
      "stickerImage": stickerImage,
      "backgroundTopColor": backgroundTopColor,
      "backgroundBottomColor": backgroundBottomColor,
      "contentURL": contentURL
    });
  }

  static Future<String?> shareInstaFeed(String backgroundImage) async {
    return await _channel.invokeMethod('share_insta_feed', {
      "backgroundImage": backgroundImage
    });
  }

  static Future<String?> shareFBStory(String backgroundImage, {
    String? stickerImage,
    String? backgroundTopColor,
    String? backgroundBottomColor,
    String? contentURL
  }) async {
    return await _channel.invokeMethod('share_FB_story', {
      "backgroundImage": backgroundImage,
      "stickerImage": stickerImage,
      "backgroundTopColor": backgroundTopColor,
      "backgroundBottomColor": backgroundBottomColor,
      "contentURL": contentURL
    });
  }

  static Future<String?> shareFBFeed(String image) async {
    return await _channel.invokeMethod('share_FB_feed', {
      "image": image
    });
  }
}
