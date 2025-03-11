#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ClipboardManager : NSObject
@property (class, readonly) NSInteger changeCount;
@end

@implementation ClipboardManager
+ (NSInteger)changeCount {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSInteger changeCount = pasteboard.changeCount;
    return changeCount;
}
@end

int main (int argc, char* argv[]) {
    @autoreleasepool {
        NSInteger changeCount = ClipboardManager.changeCount;
        printf("%ld", (long)changeCount);
    }
    return 0;
}