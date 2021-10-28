import 'dart:async';

import 'package:flutter/services.dart';

enum ShareStatus {
  success, // 0
  appCanNotBeOpenedError, // 1
  imageNotFoundError, // 2
  galleryAccessError, // 3
  unknownError // other
}

ShareStatus _convertResponseToStatus(num? status) {
  switch(status) {
    case 0:
      return ShareStatus.success;
    case 1:
      return ShareStatus.appCanNotBeOpenedError;
    case 2:
      return ShareStatus.imageNotFoundError;
    case 3:
      return ShareStatus.galleryAccessError;
    default:
      return ShareStatus.unknownError;
  }
}

class MdInstaFbShare {

  MdInstaFbShare._();

  static const MethodChannel _channel = MethodChannel('md_insta_fb_share');

  static Future<ShareStatus> shareInstaStory(String backgroundImagePath) async {
    return _convertResponseToStatus(
      await _channel.invokeMethod('share_insta_story', { "backgroundImage": backgroundImagePath })
    );
  }

  static Future<ShareStatus> shareInstaFeed(String backgroundImagePath) async {
    return _convertResponseToStatus(
      await _channel.invokeMethod('share_insta_feed', { "backgroundImage": backgroundImagePath })
    );
  }

  static Future<ShareStatus> shareFBStory(String backgroundImagePath) async {
    return _convertResponseToStatus(
      await _channel.invokeMethod('share_FB_story', { "backgroundImage": backgroundImagePath })
    );
  }

  static Future<ShareStatus> shareFBFeed(String backgroundImagePath) async {
    return _convertResponseToStatus(
        await _channel.invokeMethod('share_FB_feed', {"backgroundImage": backgroundImagePath })
    );
  }

  static Future<bool> checkFBInstalled() async {
    final check = await _channel.invokeMethod('check_FB');
    if (check == null) {
      throw Exception("Platform error");
    }
    return check;
  }

  static Future<bool> checkInstaInstalled() async {
    final check = await _channel.invokeMethod('check_insta');
    if (check == null) {
      throw Exception("Platform error");
    }
    return check;
  }
}
