//
//  UIView+Effect.h
//  Test
//
//  Created by 赵宁 on 2018/12/22.
//  Copyright © 2018 赵宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Effect)

@property (nonatomic, assign) IBInspectable NSUInteger ZNEffectType;
@property (nonatomic, assign) IBInspectable float cornerRadius;

//自定义圆角
@property (nonatomic, assign) IBInspectable BOOL topLeftRadius;
@property (nonatomic, assign) IBInspectable BOOL topRightRadius;
@property (nonatomic, assign) IBInspectable BOOL bottomLeftRadius;
@property (nonatomic, assign) IBInspectable BOOL bottomRightRadius;

@property (nonatomic, assign) IBInspectable float borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable BOOL fill;

//阴影
@property (nonatomic, strong) IBInspectable UIColor *shadowColor;
@property (nonatomic, assign) IBInspectable float shadowRadius;
@property (nonatomic, assign) IBInspectable float shadowOpacity;

@end

NS_ASSUME_NONNULL_END
