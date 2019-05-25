//
//  iCloudManager.m
//  fileOpen
//
//  Created by zzg on 2018/11/6.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import "iCloudManager.h"
#import "Document.h"

@implementation iCloudManager

+ (BOOL)iCloudEnable {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *url = [manager URLForUbiquityContainerIdentifier:nil];
    if (url != nil) {
        return YES;
    }
    return NO;
}

+ (void)downloadWithDocumentURL:(NSURL*)url callBack:(downloadBlock)block {
    Document *iCloudDoc = [[Document alloc]initWithFileURL:url];
    
    [iCloudDoc openWithCompletionHandler:^(BOOL success) {
        if (success) {
            
            [iCloudDoc closeWithCompletionHandler:^(BOOL success) {
                NSLog(@"关闭成功");
            }];
            
            if (block) {
                block(iCloudDoc.data);
            }
        }
    }];
}

@end
