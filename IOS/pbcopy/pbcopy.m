//
//  pbcopy.m
//  pasteboard-utils
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// UIPasteboard用来记录剪贴板中放置的数据类型的函数
extern void _NSSetLogCStringFunction(void(*)(const char*, unsigned, BOOL));
static void noLog(const char* message, unsigned length, BOOL withSysLogBanner) { /* Empty */ }


@interface ClipboardManager : NSObject

+ (void)copyToClipboardFromNewTerm;
+ (void)pasteToNewTermFromClipboard;

@end


@implementation ClipboardManager

+ (void)copyToClipboardFromNewTerm {
    // 示例: 从 NewTerm 获取数据输入流，这里应该替换为实际获取的数据
    NSString *inputData = @"Data from NewTerm";
    
    // 将获取到的数据复制到剪贴板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = inputData;
}

+ (void)copyToClipboardFromNewTerm {
    UIApplication *application = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:backgroundTask];
    }];

    NSString *inputData = @"Data from NewTerm";
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = inputData;

    [application endBackgroundTask:backgroundTask];
}

+ (void)pasteToNewTermFromClipboard {
    // 从剪贴板获取数据
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *clipboardData = pasteboard.string;

    // 将剪贴板数据传递给 NewTerm
    // 注意：这里需要根据实际情况写入 NewTerm，以下代码仅为示例
    NSLog(@"Pasting data to NewTerm: %@", clipboardData);
}

@end


int main (int argc, char* argv[]) {
    @autoreleasepool {
        if (argc == 2) {
            if (strcmp(argv[1], "--help")==0 || strcmp(argv[1], "-h")==0) {
                printf("用法：pbcopy {--help|-h, --version|-v}\n");
                return 0;
            } else if (strcmp(argv[1], "--version")==0 || strcmp(argv[1], "-v")==0) {
                printf("pbpaste version 1.0.0 Copyright (c) 2020-present quiprr\n");
                printf("Built with Apple clang %s\n", __clang_version__);
                return 0;
            } else {
                printf("未识别的参数。用法：pbcopy {--help|-h, --version|-v}\n");
                return 1;
            }
        } else if (argc > 2) {
            printf("给出了太多的参数。预期 {--help|-h, --version|-v}.\n");
            return 1;
        }
        [ClipboardManager copyToClipboardFromNewTerm];
        printf("数据复制已到剪贴板。\n");
        [ClipboardManager pasteToNewTermFromClipboard];
    }
}