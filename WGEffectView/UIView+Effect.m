//
//  UIView+Effect.m
//  Test
//
//  Created by 赵宁 on 2018/12/22.
//  Copyright © 2018 赵宁. All rights reserved.
//

#import "UIView+Effect.h"
#import <objc/runtime.h>

static NSString *Key                  = @"key";
static NSString *fillKey              = @"fill";
static NSString *customKey            = @"custom";
static NSString *effectTypeKey        = @"effectType";
static NSString *borderWidthKey       = @"borderWidth";
static NSString *borderColorKey       = @"borderColor";
static NSString *cornerRadiusKey      = @"cornerRadius";
static NSString *aroundRadiusKey      = @"aroundRadius";
static NSString *topLeftRadiusKey     = @"topLeftRadius";
static NSString *topRightRadiusKey    = @"topRightRadius";
static NSString *bottomLeftRadiusKey  = @"bottomLeftRadius";
static NSString *bottomRightRadiusKey = @"bottomRightRadius";
static NSString *shadowColorKey       = @"shadowColor";
static NSString *shadowRadiusKey      = @"shadowRadius";
static NSString *shadowOpacityKey     = @"shadowOpacity";

@implementation UIView (Effect)

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.ZNEffectType > 0) {
        [self setNeedsDisplayInRect:self.bounds];
    }
}

- (void)setZNEffectType:(NSUInteger)ZNEffectType {
    objc_setAssociatedObject(self, &effectTypeKey, @(ZNEffectType),OBJC_ASSOCIATION_ASSIGN);
}
- (NSUInteger)ZNEffectType {
    NSNumber *value = objc_getAssociatedObject(self, &effectTypeKey);
    return value.unsignedIntegerValue;
}
- (void)setFill:(BOOL)fill {
    objc_setAssociatedObject(self, &fillKey, @(fill),OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)fill {
    NSNumber *value = objc_getAssociatedObject(self, &fillKey); return value.boolValue;
}
#pragma mark --- 系统圆角
/**
 *  设置边框宽度
 *
 *  @param borderWidth 可视化视图传入的值
 */
- (void)setBorderWidth:(float)borderWidth {
    if (self.ZNEffectType <= 0) {
        if (borderWidth < 0) return;
        self.layer.borderWidth = borderWidth;
    } else {
        objc_setAssociatedObject(self, &borderWidthKey, @(borderWidth),OBJC_ASSOCIATION_ASSIGN);
    }
}
- (float)borderWidth {
//    if (!self.isCustom) {
    if (self.ZNEffectType <= 0) {
        return self.layer.borderWidth;
    } else {
        NSNumber *value = objc_getAssociatedObject(self, &borderWidthKey); return value.floatValue;
    }
}

/**
 *  设置边框颜色
 *
 *  @param borderColor 可视化视图传入的值
 */
- (void)setBorderColor:(UIColor *)borderColor {
    if (self.ZNEffectType <= 0) {
        self.layer.borderColor = borderColor.CGColor;
    } else {
        objc_setAssociatedObject(self, &borderColorKey, borderColor,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (UIColor *)borderColor {
    if (self.ZNEffectType <= 0) {
        return [UIColor colorWithCGColor:self.layer.borderColor];
    } else {
        return objc_getAssociatedObject(self, &borderColorKey);
    }
}

/**
 *  设置圆角
 *
 *  @param cornerRadius 可视化视图传入的值
 */
- (void)setCornerRadius:(float)cornerRadius {
    if (self.ZNEffectType <= 0) {
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = (cornerRadius>0);
    } else {
        objc_setAssociatedObject(self, &cornerRadiusKey, @(cornerRadius),OBJC_ASSOCIATION_ASSIGN);
    }
}
- (float)cornerRadius {
    if (self.ZNEffectType <= 0) {
        return self.layer.cornerRadius;
    } else {
        NSNumber *value = objc_getAssociatedObject(self, &cornerRadiusKey); return value.floatValue;
    }
}

/**
 *  设置自定义圆角
 *
 *  @param topLeftRadius 可视化视图传入的值
 */
- (void)setTopLeftRadius:(BOOL)topLeftRadius {
    objc_setAssociatedObject(self, &topLeftRadiusKey, @(topLeftRadius),OBJC_ASSOCIATION_ASSIGN);
}
- (void)setTopRightRadius:(BOOL)topRightRadius {
    objc_setAssociatedObject(self, &topRightRadiusKey, @(topRightRadius),OBJC_ASSOCIATION_ASSIGN);
}
- (void)setBottomLeftRadius:(BOOL)bottomLeftRadius {
    objc_setAssociatedObject(self, &bottomLeftRadiusKey, @(bottomLeftRadius),OBJC_ASSOCIATION_ASSIGN);
}
- (void)setBottomRightRadius:(BOOL)bottomRightRadius {
    objc_setAssociatedObject(self, &bottomRightRadiusKey, @(bottomRightRadius),OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)topLeftRadius {
    NSNumber *value = objc_getAssociatedObject(self, &topLeftRadiusKey); return value.boolValue;
}
- (BOOL)topRightRadius {
    NSNumber *value = objc_getAssociatedObject(self, &topRightRadiusKey); return value.boolValue;
}
- (BOOL)bottomLeftRadius {
    NSNumber *value = objc_getAssociatedObject(self, &bottomLeftRadiusKey); return value.boolValue;
}
- (BOOL)bottomRightRadius {
    NSNumber *value = objc_getAssociatedObject(self, &bottomRightRadiusKey); return value.boolValue;
}

#pragma mark --- 自定义圆角
- (void)setNeedsDisplayInRect:(CGRect)rect {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(self.bottomLeftRadius?UIRectCornerBottomLeft:0)|(self.bottomRightRadius?UIRectCornerBottomRight:0)|(self.topLeftRadius?UIRectCornerTopLeft:0)|(self.topRightRadius?UIRectCornerTopRight:0) cornerRadii:CGSizeMake(self.cornerRadius, 0.f)];
    [self setupRadius:maskPath];
}

- (void)setupRadius:(UIBezierPath *)maskPath {
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    maskPath.lineWidth = self.borderWidth;
    switch (self.ZNEffectType) {
        case 1:
            UIGraphicsBeginImageContext(self.bounds.size);
            [self.borderColor setStroke];
            [maskPath stroke];
            UIGraphicsEndImageContext();
            break;
        case 2:
            UIGraphicsBeginImageContext(self.bounds.size);
            [self.borderColor setStroke];
            [maskPath stroke];
            UIGraphicsEndImageContext();
            break;
        default:
            break;
    }
   
    if (self.fill) {
        // 如果是实心圆，设置填充颜色
        [self.borderColor setFill];
        // 填充圆形
        [maskPath fill];
    }
}

#pragma mark --- 阴影

/**
 *  设置阴影半径
 *
 *  @param shadowRadius 可视化视图传入的值
 */
- (void)setShadowRadius:(float)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}
- (float)shadowRadius {
    return self.layer.shadowRadius;
}
/**
 *  设置阴影透明度
 *
 *  @param shadowOpacity 可视化视图传入的值
 */
- (void)setShadowOpacity:(float)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}
- (float)shadowOpacity {
    return self.layer.shadowOpacity;
}
/**
 *  设置阴影颜色
 *
 *  @param shadowColor 可视化视图传入的值
 */
- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}
- (UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

@end
