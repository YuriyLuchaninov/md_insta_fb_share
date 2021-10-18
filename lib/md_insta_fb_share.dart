import 'dart:async';

import 'package:flutter/services.dart';

class MdInstaFbShare {
  static const MethodChannel _channel = MethodChannel('md_insta_fb_share');

  static Future<String?> shareInsta(String backgroundImage, {
    String? stickerImage,
    String? backgroundTopColor,
    String? backgroundBottomColor,
    String? contentURL
  }) async {
    return await _channel.invokeMethod('share_insta', {
      "backgroundImage": backgroundImage,
      "stickerImage": stickerImage,
      "backgroundTopColor": backgroundTopColor,
      "backgroundBottomColor": backgroundBottomColor,
      "contentURL": contentURL
    });
  }

  static Future<String?> shareFB(String stickerImage, {
    String? backgroundTopColor,
    String? backgroundBottomColor,
    String? contentURL,
    String? appID
  }) async {
    return await _channel.invokeMethod('share_FB', {
      "stickerImage": stickerImage,
      "backgroundTopColor": backgroundTopColor,
      "backgroundBottomColor": backgroundBottomColor,
      "contentURL": contentURL,
      "appID": appID
    });
  }
}
