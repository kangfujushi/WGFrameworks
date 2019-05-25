//
//  WGSelectView.h
//  asd
//
//  Created by 卫宫巨侠欧尼酱 on 2019/4/26.
//  Copyright © 2019 卫宫巨侠欧尼酱. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGSelectView : UIView

+ (void)show:(NSString *)title Normal:(NSString *)normal Select:(NSString *)select Data:(NSArray *)array Block:(void(^)(NSInteger selectIndex))block;

+ (void)show:(NSString *)title Data:(NSArray *)array Block:(void(^)(NSInteger selectIndex))block;

@end

NS_ASSUME_NONNULL_END
