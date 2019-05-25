//
//  CollectionViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "CollectionCategoryModel.h"
#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) SubCategoryModel *model;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.width - 4)];
//        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
//        [self.contentView addSubview:self.imageV];
//
//        self.name = [[UILabel alloc] initWithFrame:CGRectMake(2, self.frame.size.width + 2, self.frame.size.width - 4, 20)];
//        self.name.font = [UIFont systemFontOfSize:13];
//        self.name.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:self.name];
        
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.width - 4)];
        self.button.layer.cornerRadius  = 5;
        self.button.layer.masksToBounds = YES;
        self.button.layer.borderWidth   = 1;
        self.button.layer.borderColor   = [CTB colorWithHexString:@"E2E2E2"].CGColor;
        self.button.titleLabel.numberOfLines = 2;
        self.button.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2 );
        [self.button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
        self.button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.button setTitleColor:RGB(88, 88, 88) forState:0];
        [self.button setTitleColor:[CTB colorWithHexString:@"3296FA"] forState:UIControlStateSelected];
        self.button.userInteractionEnabled = NO;
        [self.contentView addSubview:self.button];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)setModel:(SubCategoryModel *)model Selected:(BOOL)selected
{
    [self.button setTitle:model.menu_name forState:UIControlStateNormal];
//    [self.button setTitle:model.menu_name forState:UIControlStateSelected];
    self.button.selected = selected;
}

@end
