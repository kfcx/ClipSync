#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ClipboardManagerCompletion)(NSString * _Nullable text, NSError * _Nullable error);

typedef NS_ENUM(NSInteger, ClipboardManagerErrorCode) {
    ClipboardManagerErrorEmpty = 100,
};

static NSString * const ClipboardManagerErrorDomain = @"ClipboardManagerErrorDomain";
static NSString * const ClipboardManagerErrorEmptyDescription = @"剪贴板内容为空";

@interface ClipboardManager : NSObject
+ (void)pasteToNewTermFromClipboard:(ClipboardManagerCompletion)completion;
@end

@implementation ClipboardManager
+ (void)pasteToNewTermFromClipboard:(ClipboardManagerCompletion)completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString *clipboardText = pasteboard.string;
        if (clipboardText) {
            if (completion) {
                completion(clipboardText, nil);
            }
        } else {
            if (completion) {
                NSError *error = [NSError errorWithDomain:ClipboardManagerErrorDomain
                                                     code:ClipboardManagerErrorEmpty
                                                 userInfo:@{NSLocalizedDescriptionKey: ClipboardManagerErrorEmptyDescription}];
                completion(nil, error);
            }
        }
    });
}
@end

int main(int argc, char *argv[]) {
    @autoreleasepool {
        [ClipboardManager pasteToNewTermFromClipboard:^(NSString * _Nullable text, NSError * _Nullable error) {
            if (text) {
                printf("%s\n", [text UTF8String]);
                exit(0);
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
                exit(1);
            }
        }];
    }
    CFRunLoopRun();
}

// int main(int argc, char *argv[]) {
//     @autoreleasepool {
//         dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//         [ClipboardManager pasteToNewTermFromClipboard:^(NSString * _Nullable text, NSError * _Nullable error) {
//             if (text) {
//                 printf("%s\n", [text UTF8String]);
//                 exit(0);
//             } else {
//                 NSLog(@"Error: %@", error.localizedDescription);
//                 exit(1);
//             }
//             dispatch_semaphore_signal(semaphore);
//         }];
//         dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//     }
//     return 0;
// }
