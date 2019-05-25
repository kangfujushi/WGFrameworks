//
//  BaseSlideViewController.m
//  SlideViewController
//
//  Created by 周智勇 on 17/2/27.
//  Copyright © 2017年 周智勇. All rights reserved.
//

#import "BaseSlideViewController.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define RGBColor(r,g,b) RGBAColor(r,g,b,1.0)
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
static CGFloat const titleH = 44;/** 文字高度  */

static CGFloat const MaxScale = 1.1;/** 选中文字放大  */

@interface BaseSlideViewController ()<UIScrollViewDelegate>

/** 控制器scrollView  */
@property (nonatomic, strong) UIScrollView *contentScrollView;
/** 标签文字  */
//@property (nonatomic ,strong) NSArray * titlesArr;
/** 标签按钮  */
@property (nonatomic, strong) NSMutableArray *buttons;
/** 选中的按钮  */
@property (nonatomic ,strong) UIButton * selectedBtn;
/** 选中的按钮背景图  */
@property (nonatomic ,strong) UIImageView * imageBackView;
/** 选中的按钮下边的线条  */
@property (nonatomic, strong)UIView * lineView;
/** 文字scrollView  */
@property (nonatomic, strong) UIScrollView *titleScrollView;

@end

@implementation BaseSlideViewController

#pragma mark lazy loading
- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)updateSuperTitleAry{
    //外部更新标签的时候，先要移除之前添加的控制器和视图
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromParentViewController];
    }];
    
    [self addChildViewController];    /** 添加子控制器视图  */
    
    [self setTitleScrollView];        /** 添加文字标签  */
    
    [self setContentScrollView];      /** 添加scrollView  */
    
    [self setupTitle];                /** 设置标签按钮 文字 背景图  */
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.contentScrollView.contentSize = CGSizeMake(self.titlesArr.count * ScreenW, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator  = NO;
    self.contentScrollView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - PRIVATE

-(void)addChildViewController{
    for (int i = 0; i<self.titlesArr.count; i++) {
        //添加子类。子类一定要重写该方法！具体添加哪个视图，外部自己处理
    }
}

-(void)setTitleScrollView{
    
    CGRect rect  = CGRectMake(0, kStatusBarAndNavigationBarHeight, ScreenW, titleH);
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:self.titleScrollView];
}

-(void)setContentScrollView{
    CGFloat y  = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect  = CGRectMake(0, y, ScreenW, ScreenH - titleH);
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:self.contentScrollView];
}

-(void)setupTitle{
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat x = 0;
    CGFloat w = ScreenW/self.titlesArr.count;
    if (w < Screen_Width/4) {
        w= Screen_Width/4;
    }
    CGFloat h = titleH;
    self.imageBackView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, w, titleH-10)];
    self.imageBackView.image = [UIImage imageNamed:@"b1"];
    self.imageBackView.backgroundColor = [UIColor whiteColor];
    self.imageBackView.userInteractionEnabled = YES;
    [self.titleScrollView addSubview:self.imageBackView];
    
    for (int i = 0; i < count; i++)
    {
        UIViewController *vc = self.childViewControllers[i];
        
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:RGBColor(153, 153, 153) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
        
        [self.buttons addObject:btn];
        [self.titleScrollView addSubview:btn];
        
        
        if (i == 0){
            [self click:btn];
        }
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    //增加下边的下划线（视具体情况可省略）
    UIView * covertView = [[UIView alloc] initWithFrame:CGRectMake(0, titleH - 1, self.titleScrollView.contentSize.width, 1)];
    [self.titleScrollView addSubview:covertView];
    
    if (self.titleScrollView.contentSize.width/self.titlesArr.count < 80) {
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleH - 2, 80, 2)];
    }else{
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleH - 2, self.titleScrollView.contentSize.width/self.titlesArr.count, 2)];
    }
    
    self.lineView.backgroundColor = BaseBlueColor;
    [self.titleScrollView addSubview:self.lineView];
    
    //中间竖线
    for (int i = 0; i < self.titlesArr.count; i++) {
        UIView * midLineView = [[UIView alloc] initWithFrame:CGRectMake(self.titleScrollView.contentSize.width/self.titlesArr.count * i, 7, 0.5, 30)];
        midLineView.backgroundColor = RGBColor(246, 246, 246);
        [self.titleScrollView addSubview:midLineView];
    }
}

-(void)click:(UIButton *)sender{
    
    [self selectTitleBtn:sender];
    NSInteger i = sender.tag;
    CGFloat x  = i *ScreenW;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
    [self setUpOneChildController:i];
    
}

-(void)selectTitleBtn:(UIButton *)btn{
    
    
    [self.selectedBtn setTitleColor:RGBColor(153, 153, 153) forState:UIControlStateNormal];
    self.selectedBtn.transform = CGAffineTransformIdentity;
    
    
    [btn setTitleColor:BaseBlueColor forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(MaxScale, MaxScale);
    self.selectedBtn = btn;
    
    [self setupTitleCenter:btn];
    
}

-(void)setupTitleCenter:(UIButton *)sender
{
    if (self.titleScrollView.contentSize.width <= ScreenW) {
        return;
    }
    //以上这一句代码保证数量较少时不会产生异常的偏移！！！！！！！！！
    CGFloat offset = sender.center.x - ScreenW * 0.5;
    if (offset < 0) {
        offset = 0;
    }
    CGFloat maxOffset  = self.titleScrollView.contentSize.width - ScreenW;
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

-(void)setUpOneChildController:(NSInteger)index{
    
    CGFloat x  = index * ScreenW;
    UIViewController *vc  =  self.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, ScreenW, ScreenH - self.contentScrollView.frame.origin.y);
    [self.contentScrollView addSubview:vc.view];
    
}
#pragma mark - UIScrollView  delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger i  = self.contentScrollView.contentOffset.x / ScreenW;
    [self selectTitleBtn:self.buttons[i]];
    [self setUpOneChildController:i];
    
    //如果需要检测视图滑动了，可以使用下边的通知。但是....
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewControllerSlided" object:nil userInfo:@{@"currentIndex":@(i)}];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetX  = scrollView.contentOffset.x;
    NSInteger leftIndex  = offsetX / ScreenW;
    NSInteger rightIdex  = leftIndex + 1;
    
    UIButton *leftButton = self.buttons[leftIndex];
    UIButton *rightButton  = nil;
    if (rightIdex < self.buttons.count) {
        rightButton  = self.buttons[rightIdex];
    }
    CGFloat scaleR  = offsetX / ScreenW - leftIndex;
    CGFloat scaleL  = 1 - scaleR;
    CGFloat transScale = MaxScale - 1;
    
    self.imageBackView.transform  = CGAffineTransformMakeTranslation((offsetX*(self.titleScrollView.contentSize.width / self.contentScrollView.contentSize.width)), 0);
    
    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);

    //修改下划线的frame
    self.lineView.transform  = CGAffineTransformMakeTranslation((offsetX*(self.titleScrollView.contentSize.width / self.contentScrollView.contentSize.width)), 0);
}

@end
