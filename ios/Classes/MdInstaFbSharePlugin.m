#import "MdInstaFbSharePlugin.h"
#if __has_include(<md_insta_fb_share/md_insta_fb_share-Swift.h>)
#import <md_insta_fb_share/md_insta_fb_share-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "md_insta_fb_share-Swift.h"
#endif

@implementation MdInstaFbSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMdInstaFbSharePlugin registerWithRegistrar:registrar];
}
@end
