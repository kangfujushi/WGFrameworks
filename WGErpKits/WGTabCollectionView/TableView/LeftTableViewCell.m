//
//  LeftTableViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "LeftTableViewCell.h"

#define defaultColor [UIColor colorWithRed:59./255 green:153./255 blue:252./255 alpha:1]

@interface LeftTableViewCell ()

@property (nonatomic, strong) UIView *yellowView;

@end

@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
        [self.contentView addSubview:self.image];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, self.frame.size.width-45-16, 49)];
        self.name.numberOfLines = 0;
        self.name.font = [UIFont systemFontOfSize:14];
        self.name.textColor = [UIColor colorWithRed:88./255 green:88./255 blue:88./255 alpha:1];
        self.name.highlightedTextColor = defaultColor;
        [self.contentView addSubview:self.name];
        
        self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 49)];
        self.yellowView.backgroundColor = defaultColor;
        [self.contentView addSubview:self.yellowView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state

    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithRed:245./255 green:245./255 blue:245./255 alpha:1];
    self.image.tintColor = selected?defaultColor:[UIColor colorWithRed:88./255 green:88./255 blue:88./255 alpha:1];
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.yellowView.hidden = !selected;
}

@end
