import Flutter
import UIKit

public class SwiftMdInstaFbSharePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "md_insta_fb_share", binaryMessenger: registrar.messenger())
    let instance = SwiftMdInstaFbSharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if (call.method == "share_insta_story") {
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
                  UIApplication.shared.openURL(urlScheme)
                  result(nil);
              }
          } else {
              result("Can not open insagram app");
          }
      } else if (call.method == "share_insta_feed") {
          let args = (call.arguments as! NSDictionary);
          let urlScheme = URL(string: "instagram-stories://app")!
          if (UIApplication.shared.canOpenURL(urlScheme)) {
              let backgroundImagePath = args["backgroundImage"] as! String;
            
              
              let fileManager = FileManager.default;
              
        
              let isBackgroundImageExist = fileManager.fileExists(atPath: backgroundImagePath);
              if (isBackgroundImageExist) {
                  postImageToInstagram(UIImage(contentsOfFile: backgroundImagePath)!);
                  result(nil);
              }
          } else {
              result("Can not open insagram app");
          }
      } else if (call.method == "share_FB_story") {
          let args = (call.arguments as! NSDictionary)
          let urlScheme = URL(string: "facebook-stories://share")!
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
              
              let facebookAppID = Bundle.main.object(forInfoDictionaryKey: "FacebookAppID") as? String;
              
              if (facebookAppID == nil) {
                  result("FacebookAppID not srecified in info.plist");
                  return;
              }
              
              let pasteboardItems = [
                "com.facebook.sharedSticker.appID": facebookAppID as! String,
                "com.facebook.sharedSticker.backgroundImage" : (backgroundImage ?? nil) as Any,
                "com.facebook.sharedSticker.stickerImage": (stickerImage ?? nil) as Any,
                "com.facebook.sharedSticker.backgroundTopColor": (backgroundTopColor ?? nil) as Any,
                "com.facebook.sharedSticker.backgroundBottomColor": (backgroundBottomColor ?? nil) as Any,
                "com.facebook.sharedSticker.contentURL": (contentURL ?? nil) as Any
              ] as [String : Any];
              
              if #available(iOS 10.0, *) {
                  let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate : NSDate().addingTimeInterval(60 * 5)]
                  UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                  UIApplication.shared.open(urlScheme, options: [:], completionHandler: { (success) in
                      result(nil);
                  })
              } else {
                  UIPasteboard.general.items = [pasteboardItems]
                  UIApplication.shared.openURL(urlScheme)
                  result(nil);
              }
          } else {
              result("Can not open FB app");
          }
      } else {
          result("Not implemeted");
      }
  }
    func postImageToInstagram(_ image: UIImage) {
        if UIApplication.shared.canOpenURL(URL(string: "instagram://app")!) {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                }
            }
        }
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error)
            return
        }
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if let lastAsset = fetchResult.firstObject {
            let localIdentifier = lastAsset.localIdentifier
            let u = "instagram://library?LocalIdentifier=" + localIdentifier
            let url = NSURL(string: u)!
            if UIApplication.shared.canOpenURL(url as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: u)!, options: [:], completionHandler: nil);
                } else {
                    UIApplication.shared.openURL(URL(string: u)!);
                }
            }
            else { print("Please install the Instagram application") }
        }
    }
}
