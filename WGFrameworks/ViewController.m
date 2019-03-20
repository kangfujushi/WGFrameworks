//
//  ViewController.m
//  WGFrameworks
//
//  Created by 赵宁 on 2019/3/19.
//  Copyright © 2019 赵宁. All rights reserved.
//

#import "ViewController.h"
#import <WGJiayouViews/WGPayView.h>
#import <WGCycleScrollView/WGCycleScrollView.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [WGPayView showPayView:@"油站支付" Price:1200.88 Block:^(NSInteger selectIndex) {
//    }];
    
    SDCycleScrollView *cyc = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, 414, 130) imageNamesGroup:@[]];
    [self.view addSubview:cyc];
    
}


@end
