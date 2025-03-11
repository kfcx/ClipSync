#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>

@interface ClipboardManager : NSObject
+ (void)copyToClipboardFromNewTerm;
@end

@implementation ClipboardManager
+ (void)copyToClipboardFromNewTerm {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSFileHandle *standardInput = [NSFileHandle fileHandleWithStandardInput];
    standardInput.readabilityHandler = ^(NSFileHandle *fileHandle) {
        NSData *data = [fileHandle availableData];
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (dataString && dataString.length > 0) {
            NSString *trimmedDataString = [dataString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            // 处理其他特殊字符...
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = trimmedDataString;
            pasteboard.string = trimmedDataString;
            printf("完成复制\n");
            dispatch_semaphore_signal(semaphore);
            exit(0);
        } else {
            NSLog(@"Error: Unable to read data from standard input.");
            dispatch_semaphore_signal(semaphore);
            exit(1);
        }
    };
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}
@end

int main (int argc, char* argv[]) {
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ClipboardManager copyToClipboardFromNewTerm];
        });
    }
    CFRunLoopRun();
}

// int main(int argc, char *argv[]) {
//     @autoreleasepool {
//         dispatch_async(dispatch_get_main_queue(), ^{
//             // 获取终端传输的字符串
//             NSData *data = [[NSFileHandle fileHandleWithStandardInput] availableData];
//             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//             if (dataString) {
//                 printf("填写内容：%s\n", [dataString UTF8String]);
//                 // 将字符串复制到剪贴板
//                 UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//                 pasteboard.string = dataString;
//                 pasteboard.string = dataString;
//             } else {
//                 printf("无法解析输入数据\n");
//             }
//             // 退出程序
//             exit(0);
//         });
//         // 运行主循环
//         [[NSRunLoop mainRunLoop] run];
//     }
//     return 0;
// }