import Flutter
import UIKit

public class SwiftMdInstaFbSharePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "md_insta_fb_share", binaryMessenger: registrar.messenger())
    let instance = SwiftMdInstaFbSharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if (call.method == "share_insta") {
          let args = (call.arguments as! NSDictionary)
          let urlScheme = URL(string: "instagram-stories://share")!
          if (UIApplication.shared.canOpenURL(urlScheme)) {
              let backgroundImagePath = args["backgroundImage"] as! String;
              let stickerImagePath = args["stickerImage"] as? String;
              let backgroundTopColor = args["backgroundTopColor"] as? String;
              let backgroundBottomColor = args["backgroundBottomColor"] as? String;
              let contentURL = args["contentURL"] as? String;
              
              var backgroundImage: UIImage? = nil;
              var stickerImage: UIImage? = nil;
              let fileManager = FileManager.default;
              
        
              let isBackgroundImageExist = fileManager.fileExists(atPath: backgroundImagePath);
              if (isBackgroundImageExist) {
                  backgroundImage = UIImage(contentsOfFile: backgroundImagePath)!;
              }
              
              if (stickerImagePath != nil) {
                  let isStickerExist = fileManager.fileExists(atPath: stickerImagePath!);
                  if (isStickerExist) {
                      stickerImage =  UIImage(contentsOfFile: stickerImagePath!)!;
                  }
              }
              
              let pasteboardItems = [
                "com.instagram.sharedSticker.backgroundImage" : (backgroundImage ?? nil) as Any,
                "com.instagram.sharedSticker.stickerImage": (stickerImage ?? nil) as Any,
                "com.instagram.sharedSticker.backgroundTopColor": (backgroundTopColor ?? nil) as Any,
                "com.instagram.sharedSticker.backgroundBottomColor": (backgroundBottomColor ?? nil) as Any,
                "com.instagram.sharedSticker.contentURL": (contentURL ?? nil) as Any
              ] as [String : Any];
              
              if #available(iOS 10.0, *) {
                  let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate : NSDate().addingTimeInterval(60 * 5)]
                  UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                  UIApplication.shared.open(urlScheme, options: [:], completionHandler: { (success) in
                      result(nil);
                  })
              } else {
                  UIPasteboard.general.items = [pasteboardItems]
                  UIApplication.shared.openURL(URL(fileURLWithPath: "instagram-stories://share"))
                  result(nil);
              }
          } else {
              result("Can not open insagram app");
          }
      } else {
          result("Not implemented");
      }
  }
}
