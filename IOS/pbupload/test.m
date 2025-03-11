#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Example : NSObject
+ (const char *)exampleFunction;
@end

@implementation Example
+ (const char *)exampleFunction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *clipboardText = pasteboard.string;
    printf("%s\n", [clipboardText UTF8String]);
    return clipboardText ? [clipboardText UTF8String] : "空";
}
@end
x
const char *exampleFunctionWrapper() {
    return [Example exampleFunction];
}