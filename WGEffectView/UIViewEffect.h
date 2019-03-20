//
//  UIViewEffect.h
//  Test
//
//  Created by 赵宁 on 2019/1/4.
//  Copyright © 2019 赵宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface UIViewEffect : UIView

//圆角
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable BOOL topLeftRadius;
@property (nonatomic, assign) IBInspectable BOOL topRightRadius;
@property (nonatomic, assign) IBInspectable BOOL bottomLeftRadius;
@property (nonatomic, assign) IBInspectable BOOL bottomRightRadius;

@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable BOOL fill;

//阴影
//@property (nonatomic, strong) IBInspectable UIColor *shadowColor;
//@property (nonatomic, assign) IBInspectable CGFloat shadowRadius;
//@property (nonatomic, assign) IBInspectable CGFloat shadowOpacity;
//@property (nonatomic, assign) IBInspectable CGFloat shadowWidth;

//@property (nonatomic, assign) IBInspectable CGFloat topShadow;
//@property (nonatomic, assign) IBInspectable CGFloat leftShadow;
//@property (nonatomic, assign) IBInspectable CGFloat rightShadow;
//@property (nonatomic, assign) IBInspectable CGFloat bottomShadow;

@end

NS_ASSUME_NONNULL_END
