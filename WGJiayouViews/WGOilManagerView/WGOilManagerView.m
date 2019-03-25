//
//  WGOilManagerView.m
//  Jiayou
//
//  Created by 赵宁 on 2019/3/7.
//  Copyright © 2019 赵宁. All rights reserved.
//

#import "WGOilManagerView.h"
#import <Masonry/Masonry.h>

@interface WGOilManagerView ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *oil;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *freesize;
@property (weak, nonatomic) IBOutlet UIView *oilManagerView;

@property (nonatomic,strong) void (^block)(NSDictionary * info);

@end

@implementation WGOilManagerView

+ (void)showOilManagerView:(NSString *)title Index:(NSInteger)index Price:(NSString *)price Size:(NSString *)size Block:(void(^)(NSDictionary *info))block {
    WGOilManagerView *view = [[NSBundle bundleWithIdentifier:@"com.zhaoning.WGJiayouViews"] loadNibNamed:@"WGOilManagerView" owner:nil options:nil].firstObject;
    view.block = block;
    view.title.text = title;
    view.price.text = price;
    view.freesize.text = size;
    switch (index) {
        case 0: view.oil.text = @"92号汽油"; break;
        case 1: view.oil.text = @"95号汽油"; break;
        case 2: view.oil.text = @"98号汽油"; break;
        case 3: view.oil.text = @"0号柴油";  break;
        default:
            break;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [view.oilManagerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
        }];
        [view layoutIfNeeded];
    }];
}

- (BOOL)isNotNull {
    if (!self.price.text.length) {
        return NO;
    }
    if (!self.freesize.text.length) {
        return NO;
    }
    return YES;
}

#pragma mark --- Actions

- (IBAction)dismiss:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self.oilManagerView mas_updateConstraints:^(MASConstraintMaker *make) { make.centerY.equalTo(self).offset((self.bounds.size.height+self.oilManagerView.bounds.size.height)/2);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)confirmAction:(id)sender {
    if ([self isNotNull]) {
        if (self.block) self.block(@{@"price":self.price.text,@"size":self.freesize.text});
        [self dismiss:nil];
    }
}

@end
