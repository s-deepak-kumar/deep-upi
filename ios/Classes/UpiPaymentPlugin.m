#import "UpiPaymentPlugin.h"
#if __has_include(<deep_upi/deep_upi-Swift.h>)
#import <deep_upi/deep_upi-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "deep_upi-Swift.h"
#endif

@implementation UpiPaymentPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [UpiPaymentPlugin registerWithRegistrar:registrar];
}
@end