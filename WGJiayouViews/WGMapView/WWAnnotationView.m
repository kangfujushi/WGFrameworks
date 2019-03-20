//
//  WWAnnotationView.m
//  WKMapViewDemo
//
//  Created by 莫晓卉 on 2018/5/1.
//  Copyright © 2018年 莫晓卉. All rights reserved.
//

#import "WWAnnotationView.h"
#import <Masonry/Masonry.h>

#define kMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define baseDistance 0.15
static const CGFloat kDefaultWidth = 80;

@interface WWView : UIView
@property (nonatomic, strong) UIButton *button;

//@property (nonatomic ,assign) CGFloat baseDistance;
@property (nonatomic ,assign) CGFloat newDistance;
@property (nonatomic ,assign) BOOL isOk;

@end

@implementation WWView {
    UIView *_view;
    CAShapeLayer *_shapeLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _view = [[UIView alloc] init];
        _view.layer.borderColor =  [UIColor blueColor].CGColor;
        _view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.1];
        _view.layer.cornerRadius = (kMaxWidth-20) * 0.5;
        _view.alpha = 0;
        [self addSubview:_view];
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
    }
    return self;
}

- (void)show {
    _view.layer.cornerRadius = (kMaxWidth-20) * 0.5;
    [UIView animateWithDuration:1 animations:^{
        _view.alpha = 1;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(kMaxWidth);
        }];
        [self.superview layoutIfNeeded];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isOk = YES;
    });
}

- (void)updateNewDistance:(CGFloat)newDistance {
    if (newDistance>0.01 && self.newDistance>0 && self.newDistance!=newDistance && self.isOk) {
        _view.layer.cornerRadius = (kMaxWidth*baseDistance/newDistance-20) * 0.5;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(kMaxWidth*baseDistance/newDistance);
        }];
    } else {
        self.newDistance = newDistance;
    }
}

//- (void)layoutSubviews {
//  [super layoutSubviews];
////  [self drawDashLine:_view lineLength:10 lineSpacing:5 lineColor:[UIColor orangeColor]];
//}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    if (_shapeLayer) {
        [_shapeLayer removeFromSuperlayer];
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:CGRectMake(0, 0, lineView.bounds.size.width, lineView.bounds.size.height)];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) * 0.5, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    // 设置虚线宽度
    [shapeLayer setLineWidth:3];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    // 设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetWidth(lineView.frame)*.5, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    // 把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
    _shapeLayer = shapeLayer;
}

@end


@implementation WWAnnotationView {
    WWView *_shawView;
    CGFloat _preWidth;
    CGFloat scale;
}

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.image = [UIImage imageNamed:@"icon_中心定位点"];
        _shawView = [[WWView alloc] init];
        [self addSubview:_shawView];
        [_shawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.mas_equalTo(kDefaultWidth);
        }];
    }
    return self;
}

- (void)show {
    [_shawView show];
}

- (void)updateNewDistance:(CGFloat)newDistance {
    [_shawView updateNewDistance:newDistance];
}

#pragma mark - 扩大点击范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    [self layoutIfNeeded];
    if (CGRectContainsPoint(_shawView.frame, point) || CGRectContainsPoint(self.frame, point)) {
        return YES;
    }
    return NO;
}

@end
