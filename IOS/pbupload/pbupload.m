//
//  pbupload.m
//  pasteboard-utils
//
//  Created by quiprr on 12/25/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

int main (int argc, char* argv[], char* envp[]) {
    @autoreleasepool {
        if (argc == 2) {
            if (strcmp(argv[1], "--help")==0 || strcmp(argv[1], "-h")==0) {
                printf("用法：pbupload {--help|-h, --version|-v}\n");
                return 0;
            } else if (strcmp(argv[1], "--version")==0 || strcmp(argv[1], "-v")==0) {
                printf("pbupload version 1.0.0 Copyright (c) 2020-present quiprr\n");
                printf("Built with Apple clang %s\n", __clang_version__);
                return 0;
            } else {
                printf("未识别的参数。用法：pbupload {--help|-h, --version|-v}\n");
                return 1;
            }
        } else if (argc > 2) {
            printf("给出了太多的参数。预期 {--help|-h, --version|-v}.\n");
            return 1;
        }
        NSData *data = [[NSFileHandle fileHandleWithStandardInput] availableData];
        if (!data) return 1; // This will just hang if no data is in stdin/*data so is really useless at this point
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://pastebin.com/api/api_post.php"]];
        [request addValue:@"pbupload/1.0.0" forHTTPHeaderField:@"User-Agent"];
        NSString *boundary = [NSString stringWithFormat:@"pbupload-%@", [[NSUUID UUID] UUIDString]];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data, boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];

        NSDictionary *parameters = @{ @"api_dev_key": @"ktLvzDaXRCCVaqOAe8uddsBuASWE_Ftc",
                                      @"api_option": @"paste", 
                                      @"api_paste_code": dataString };
        NSMutableData *postData = [NSMutableData data];
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
            [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [postData appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
        }];

        [request setHTTPBody:postData];
        NSURLSession *session = [NSURLSession sharedSession];
        NSLog(@"Sending HTTP request to Pastebin.com");
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (httpResponse.statusCode == 200) {
                NSLog(@"Response has status 200. Link copied to clipboard.");
                NSLog(@"Link: %@", responseString);
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = responseString;
            } else {
                NSLog(@"Request seems to have failed, as it did not return status code 200.\nContact 'quiprr@ametrine.dev' or @quiprr on Twitter with a screenshot.");
                NSLog(@"Response: %@", responseString);
            }
            dispatch_semaphore_signal(sema);   
        }];
        [dataTask resume];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        NSLog(@"We done here.");
    }
    return 0;
}