//
//  CollectionViewHeaderView.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "CollectionViewHeaderView.h"

@implementation CollectionViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = rgba(245, 245, 245, 1);
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, SCREEN_WIDTH*0.66-24, 20)];
        self.title.font = [UIFont systemFontOfSize:13];
        self.title.textColor = [UIColor colorWithRed:147./255 green:147./255 blue:147./255 alpha:1];
//        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
    }
    return self;
}

@end
