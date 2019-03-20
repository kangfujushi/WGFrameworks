//
//  UIViewEffect.m
//  Test
//
//  Created by 赵宁 on 2019/1/4.
//  Copyright © 2019 赵宁. All rights reserved.
//

#import "UIViewEffect.h"

@implementation UIViewEffect

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(self.bottomLeftRadius?UIRectCornerBottomLeft:0)|(self.bottomRightRadius?UIRectCornerBottomRight:0)|(self.topLeftRadius?UIRectCornerTopLeft:0)|(self.topRightRadius?UIRectCornerTopRight:0) cornerRadii:CGSizeMake(self.cornerRadius, 0.f)];
    [self setupRadius:maskPath];
}

- (void)setupRadius:(UIBezierPath *)maskPath {
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
   
    // 设置线条宽度
    maskPath.lineWidth = self.borderWidth*2;
    [self.borderColor setStroke];
    // 绘制线条
    [maskPath stroke];

    if (self.fill) {
        // 如果是实心圆，设置填充颜色
        [self.borderColor setFill];
        // 填充圆形
        [maskPath fill];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawRect:self.bounds];
     CGContextClosePath(context);
}

//- (void)setupShadow:(UIBezierPath *)maskPath {
//    if (self.shadowColor) {
//        self.layer.shadowColor = self.shadowColor.CGColor;//shadowColor阴影颜色
//        self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移
//        self.layer.shadowOpacity = self.shadowOpacity;//阴影透明度，默认0
//        self.layer.shadowRadius = self.shadowRadius;//阴影半径，默认3
//
//        //路径阴影
//
//        float width = self.bounds.size.width;
//        float height = self.bounds.size.height;
//        float x = self.bounds.origin.x;
//        float y = self.bounds.origin.y;
//        float addWH = self.shadowWidth;
//
//        CGPoint topLeft      = self.bounds.origin;
//        CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
//        CGPoint topRight     = CGPointMake(x+width,y);
//
//        CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
//
//        CGPoint bottomRight  = CGPointMake(x+width,y+height);
//        CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
//        CGPoint bottomLeft   = CGPointMake(x,y+height);
//
//
//        CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
//
//        [maskPath moveToPoint:topLeft];
//        //添加四个二元曲线
//        [maskPath addQuadCurveToPoint:topRight
//                         controlPoint:topMiddle];
//        [maskPath addQuadCurveToPoint:bottomRight
//                         controlPoint:rightMiddle];
//        [maskPath addQuadCurveToPoint:bottomLeft
//                         controlPoint:bottomMiddle];
//        [maskPath addQuadCurveToPoint:topLeft
//                         controlPoint:leftMiddle];
//        //设置阴影路径
//    }
//}


@end
