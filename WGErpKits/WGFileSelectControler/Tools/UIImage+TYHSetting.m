//
//  UIImage+TYHSetting.m
//  TaiYangHua
//
//  Created by Lc on 15/12/25.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import "UIImage+TYHSetting.h"
#import "KsFileObjModel.h"


//定义图片后缀名
NSString *IMAGES_TYPES[IMAGES_TYPES_COUNT] =
    {@"png", @"PNG", @"jpg",@",JPG", @"jpeg", @"JPEG" ,@"gif", @"GIF"};
//定义文本后缀名
NSString *TEXT_TYPES[TEXT_TYPES_COUNT] =
    {@"txt", @"TXT", @"doc",@"DOC",@"docx",@"DOCX",@"xls",@"XLS", @"xlsx",@"XLSX", @"ppt",@"PPT",@"pdf",@"PDF"};
//定义音频后缀名
NSString *VIOCEVIDIO_TYPES[VIOCEVIDIO_COUNT] =
    {@"mp3",@"MP3",@"wav",@"WAV",@"CD",@"cd",@"ogg",@"OGG",@"midi",@"MIDE",@"vqf",@"VQF",@"amr",@"AMR"};
//定义视频后缀名
NSString *AV_TYPES[AV_COUNT] =
    {@"asf",@"ASF",@"wma",@"WMA",@"rm",@"RM",@"rmvb",@"RMVB",@"avi",@"AVI",@"mkv",@"MKV"};
//定义应用后缀名
NSString *Application_types[Application_count] = {@"apk",@"APK",@"ipa",@"IPA"};



@implementation UIImage (TYHSetting)

+ (UIImage *)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (UIImage *)imageWithFileModel:(KsFileObjModel *)model
{
    NSArray *textTypesArray = [NSArray arrayWithObjects: TEXT_TYPES count: TEXT_TYPES_COUNT];
    NSArray *viceViodeArray = [NSArray arrayWithObjects: VIOCEVIDIO_TYPES count: VIOCEVIDIO_COUNT];
    NSArray *appViodeArray = [NSArray arrayWithObjects: Application_types count: Application_count];
    NSArray *AVArray = [NSArray arrayWithObjects: AV_TYPES count: AV_COUNT];

    if([textTypesArray containsObject: [model.filePath pathExtension]]){
        model.fileType = MKFileTypeTxt;
    }else if([viceViodeArray containsObject: [model.filePath pathExtension]] || [AVArray containsObject:[model.filePath pathExtension]]){
        model.fileType = MKFileTypeAudioVidio;
        if ([viceViodeArray containsObject: [model.filePath pathExtension]]) {
            return[UIImage imageNamed:@"音乐"];
        }else{
            return [UIImage imageNamed:@"视频"];
        }
    }
    else if([appViodeArray containsObject: [model.filePath pathExtension]]){
        model.fileType = MKFileTypeApplication;
    }else{
        model.fileType = MKFileTypeUnknown;
    }
    
    if ([UIImage imageNamed:model.filePath.pathExtension]) {
        return [UIImage imageNamed:model.filePath.pathExtension.lowercaseString];
    } else {
        return [UIImage imageNamed:@"未知"];
    }
}
+ (UIImage *)imageWithFileModelOnCheck:(KsFileObjModel *)model
{

    NSArray *textTypesArray = [NSArray arrayWithObjects: TEXT_TYPES count: TEXT_TYPES_COUNT];
    NSArray *viceViodeArray = [NSArray arrayWithObjects: VIOCEVIDIO_TYPES count: VIOCEVIDIO_COUNT];
    NSArray *appViodeArray = [NSArray arrayWithObjects: Application_types count: Application_count];
    NSArray *AVArray = [NSArray arrayWithObjects: AV_TYPES count: AV_COUNT];

    if([textTypesArray containsObject: [model.fileUrl pathExtension]]){
        model.fileType = MKFileTypeTxt;
    }else if([viceViodeArray containsObject: [model.fileUrl pathExtension]] || [AVArray containsObject:[model.fileUrl pathExtension]]){
        model.fileType = MKFileTypeAudioVidio;
        if ([viceViodeArray containsObject: [model.fileUrl pathExtension]]) {
            return[UIImage imageNamed:@"音乐-文件详情"];
        }else{
            return [UIImage imageNamed:@"视频-文件详情"];
        }
    }
    else if([appViodeArray containsObject: [model.fileUrl pathExtension]]){
        model.fileType = MKFileTypeApplication;
    }else{
        model.fileType = MKFileTypeUnknown;
    }
    if ([UIImage imageNamed:model.filePath.pathExtension]) {
        return [UIImage imageNamed:model.filePath.pathExtension.lowercaseString];
    } else {
        return [UIImage imageNamed:@"未知"];
    }
}

@end
