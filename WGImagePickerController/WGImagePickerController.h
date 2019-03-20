//
//  WGImagePickerController.h
//  asd
//
//  Created by 赵宁 on 2019/2/15.
//  Copyright © 2019 赵宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WGImagePickerManyBlock)(NSArray *images);
typedef void(^WGImagePickerSingleBlock)(UIImage *image);
typedef void(^WGImagePickerViewBlock)(UIView *view);

@interface WGImagePickerController : UIViewController

@property (assign ,nonatomic) NSInteger maxCount;  ///< 最大照片数

+ (void)manyImagePicker:(UIViewController *)vc Count:(NSInteger)count ScrollDirection:(UICollectionViewScrollDirection)scrollDirection Layout:(WGImagePickerViewBlock)layout Block:(WGImagePickerManyBlock)block; ///多张

+ (void)singleImagePicker:(UIViewController *)vc Crop:(BOOL)crop Circle:(BOOL)circle Radius:(CGFloat)radius Block:(WGImagePickerSingleBlock)block; ///单张、头像

+ (void)manyImagePicker:(UIViewController *)vc Count:(NSInteger)count Block:(WGImagePickerManyBlock)block; ///多张

@end

NS_ASSUME_NONNULL_END
