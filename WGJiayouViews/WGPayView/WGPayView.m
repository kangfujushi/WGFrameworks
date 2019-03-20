//
//  WGPayView.m
//  Jiayou
//
//  Created by 赵宁 on 2019/1/21.
//  Copyright © 2019 赵宁. All rights reserved.
//

#import "WGPayView.h"
#import <Masonry/Masonry.h>

@interface WGPayView ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *aliPay;
@property (weak, nonatomic) IBOutlet UIButton *wechatPay;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIImageView *aliImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wechatImageView;

@property (nonatomic,copy) void (^block)(NSInteger selectIndex);

@end

@implementation WGPayView

+ (void)showPayView:(NSString *)title Price:(CGFloat)price Block:(void(^)(NSInteger selectIndex))block {
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.zhaoning.WGJiayouViews"];
    WGPayView *view = [bundle loadNibNamed:@"WGPayView" owner:nil options:nil].firstObject;
    view.block = block;
    view.title.text = title;
    view.price.text = [NSString stringWithFormat:@"￥%.2f",price];
    view.payView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        view.payView.alpha = 1;
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [view.payView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
        }];
        [view layoutIfNeeded];
    }];
    
    NSURL *associateBundleURL = [bundle URLForResource:@"Resources" withExtension:@"bundle"];
    NSBundle *subBundle = [NSBundle bundleWithURL:associateBundleURL];
    
    view.aliImageView.image = [UIImage imageWithContentsOfFile:[subBundle pathForResource:@"zhifubao" ofType:@"png"]];
    view.wechatImageView.image = [UIImage imageWithContentsOfFile:[subBundle pathForResource:@"weixinzhifu" ofType:@"png"]];
    [view.aliPay setImage:[UIImage imageWithContentsOfFile:[subBundle pathForResource:@"choose_default" ofType:@"png"]] forState:UIControlStateNormal];
    [view.aliPay setImage:[UIImage imageWithContentsOfFile:[subBundle pathForResource:@"choose_checkbox_selected" ofType:@"png"]] forState:UIControlStateNormal];
    [view.aliPay setImage:[UIImage imageWithContentsOfFile:[subBundle pathForResource:@"choose_default" ofType:@"png"]] forState:UIControlStateNormal];
    [view.wechatPay setImage:[UIImage imageWithContentsOfFile:[subBundle pathForResource:@"choose_checkbox_selected" ofType:@"png"]] forState:UIControlStateNormal];
}

#pragma mark --- Actions

- (IBAction)dismiss:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self.payView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset((self.bounds.size.height+self.payView.bounds.size.height)/2);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)selecAction:(UIButton *)sender {
    self.aliPay.selected = sender==self.aliPay;
    self.wechatPay.selected = !self.aliPay.selected;
}

- (IBAction)confirmAction:(id)sender {
    if (self.block) self.block(self.wechatPay.selected);
    [self dismiss:nil];
}


@end
