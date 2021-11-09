#import "FlutterThailandProvincesPlugin.h"
#if __has_include(<flutter_thailand_provinces/flutter_thailand_provinces-Swift.h>)
#import <flutter_thailand_provinces/flutter_thailand_provinces-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_thailand_provinces-Swift.h"
#endif

@implementation FlutterThailandProvincesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterThailandProvincesPlugin registerWithRegistrar:registrar];
}
@end
