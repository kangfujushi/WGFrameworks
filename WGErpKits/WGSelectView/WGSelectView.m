//
//  WGSelectView.m
//  asd
//
//  Created by 卫宫巨侠欧尼酱 on 2019/4/26.
//  Copyright © 2019 卫宫巨侠欧尼酱. All rights reserved.
//

#import "WGSelectView.h"
#import <Masonry/Masonry.h>

@interface WGSelectCell : UITableViewCell

@property (nonatomic ,strong) UIButton * selectBtn;
@property (nonatomic ,copy) void(^block)(void);

- (void)update:(NSString *)title Normal:(NSString *)normal Select:(NSString *)select Block:(void(^)(void))block;

@end

@implementation WGSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.selectBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.selectBtn addTarget:self action:@selector(select) forControlEvents:(UIControlEventTouchUpInside)];
    [self.selectBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
    [self.selectBtn setTitleColor:[UIColor colorWithRed:70./255 green:70./255 blue:70./255 alpha:1] forState:0];
    [self.contentView addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.selectBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 8);
    self.selectBtn.titleEdgeInsets   = UIEdgeInsetsMake(0, 20, 0, 0);
    return self;
}

- (void)update:(NSString *)title Normal:(NSString *)normal Select:(NSString *)select Block:(void(^)(void))block {
    [self.selectBtn setTitle:title forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:normal] forState:(UIControlStateNormal)];
    [self.selectBtn setImage:[UIImage imageNamed:select] forState:(UIControlStateSelected)];
    self.block = block;
}

- (void)select {
    if (self.block) self.block();
}

@end

@interface WGSelectView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) NSArray     * dataArray;
@property (nonatomic ,copy) NSString      * title;
@property (nonatomic ,copy) NSString      * normal;
@property (nonatomic ,copy) NSString      * select;
@property (nonatomic ,assign) NSInteger     index;
@property (nonatomic ,copy) void(^block)(NSInteger selectIndex);

@end

@implementation WGSelectView

+ (void)show:(NSString *)title Data:(NSArray *)array Block:(void(^)(NSInteger selectIndex))block {
    [self show:title Normal:@"未选中" Select:@"选中" Data:array Block:block];
}

+ (void)show:(NSString *)title Normal:(NSString *)normal Select:(NSString *)select Data:(NSArray *)array Block:(void(^)(NSInteger selectIndex))block {
    WGSelectView *view = [[WGSelectView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    view.block      = block;
    view.title      = title;
    view.normal     = normal;
    view.select     = select;
    view.dataArray  = array;
    [view.tableView reloadData];
    
    [view.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*0.8);
        make.height.mas_equalTo(((view.dataArray.count+2)*50 > [UIScreen mainScreen].bounds.size.height*0.8) ? [UIScreen mainScreen].bounds.size.height*0.8 : (view.dataArray.count+2)*50);
    }];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.8, ((self.dataArray.count+2)*50 > [UIScreen mainScreen].bounds.size.height*0.8) ? [UIScreen mainScreen].bounds.size.height*0.8 : (self.dataArray.count+2)*50) style:(UITableViewStylePlain)];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.allowsSelection= NO;
    tableView.bounces = NO;
    tableView.center = self.center;
    
    tableView.rowHeight = 50;
    
    [tableView registerClass:[WGSelectCell class] forCellReuseIdentifier:@"WGSelectCell"];
    
    [self addSubview:tableView];
    self.tableView = tableView;
    
    [tableView reloadData];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    
    return self;
}

#pragma mark TableView Delegate and DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width*0.8, 50)];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [header addSubview:label];
    label.text = self.title;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.8-160, 0, 80, 50)];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.8-80, 0, 80, 50)];
    [button1 setTitle:@"取消" forState:(UIControlStateNormal)];
    [button2 setTitle:@"确定" forState:(UIControlStateNormal)];
    [button1 setTitleColor:[UIColor colorWithRed:59./255 green:153./255 blue:252./255 alpha:1] forState:(UIControlStateNormal)];
    [button2 setTitleColor:[UIColor colorWithRed:59./255 green:153./255 blue:252./255 alpha:1] forState:(UIControlStateNormal)];
    [button1 addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:button1];
    [footer addSubview:button2];
    return footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WGSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WGSelectCell"];
    [cell update:self.dataArray[indexPath.row] Normal:self.normal Select:self.select Block:^{
        self.index = indexPath.row;
        [tableView reloadData];
    }];
    cell.selectBtn.selected = (indexPath.row==self.index);
    return cell;
}

- (void)dismiss:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if (self.block) self.block(self.index);
    }
    
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
