//
//  BaseSlideViewController.h
//  SlideViewController
//
//  Created by 周智勇 on 17/2/27.
//  Copyright © 2017年 周智勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseSlideViewController : UIViewController

/** 标签文字数组*/
@property (nonatomic ,strong) NSArray * titlesArr;

-(void)addChildViewController;

- (void)updateSuperTitleAry;

@end
