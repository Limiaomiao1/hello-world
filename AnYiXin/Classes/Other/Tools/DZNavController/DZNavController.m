//
//  DZNavController.m
//  Shangdai
//
//  Created by tuanshang on 17/2/22.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "DZNavController.h"

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DZNavController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *VCArr;
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, weak) UIScrollView *topBar;
@property (nonatomic, weak) UIButton *oldBtn;
@property (nonatomic, weak) UIView *slider;
@property (nonatomic, assign) CGFloat btnW ;

@end

@implementation DZNavController


- (UIColor *)sliderColor
{
    if(_sliderColor == nil)
    {
        _sliderColor = [UIColor purpleColor];
    }
    return  _sliderColor;
}
- (UIColor *)btnTextNomalColor
{
    if(_btnTextNomalColor == nil)
    {
        _btnTextNomalColor = [UIColor colorWithHue:0.00 saturation:0.00 brightness:0.48 alpha:1.00];
    }
    return _btnTextNomalColor;
}
- (UIColor *)btnTextSeletedColor
{
    if(_btnTextSeletedColor == nil)
    {
        _btnTextSeletedColor = COLOR_MainColor;
    }
    return _btnTextSeletedColor;
}
- (UIColor *)topBarColor
{
    if(_topBarColor == nil)
    {
        _topBarColor = [UIColor whiteColor];
    }
    return _topBarColor;
}
- (instancetype)initWithSubViewControllers:(NSArray *)subViewControllers
{
    if(self = [super init])
    {
        _VCArr = subViewControllers;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加上面的导航条
    [self addTopBar];
    
    //添加子控制器
    [self addVCView];
    
    //添加滑块
    //    [self addSliderView];
    
}
- (void)addSliderView
{
    if(self.VCArr.count == 0) return;
    UIView *slider = [[UIView alloc]initWithFrame:CGRectMake(0,41-64,self.btnW, 1)];
    slider.backgroundColor = COLOR_MainColor;
    [self.topBar addSubview:slider];
    self.slider = slider;
}
- (void)addTopBar
{
    if(self.VCArr.count == 0) return;
    NSUInteger count = self.VCArr.count;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, 44)];
    scrollView.backgroundColor = self.topBarColor;
    self.topBar = scrollView;
    self.topBar.bounces = NO;
    [self.view addSubview:self.topBar];
    
    if(count <= 5)
    {
        self.btnW = TSScreenW / count;
    }else
    {
        self.btnW = TSScreenW / 5.0;
    }
    //添加button
    for (int i=0; i<count; i++)
    {
        UIViewController *vc = self.VCArr[i];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*self.btnW, -64, self.btnW, 44)];
        btn.tag = 10000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:self.btnTextNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.btnTextSeletedColor forState:UIControlStateSelected];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.topBar addSubview:btn];
        UIView  *line = [[UIView alloc]initWithFrame:CGRectMake(self.btnW+(i * self.btnW+5), 15, 1, 12)];
        line.backgroundColor =UIColorFromRGB(0xE6E6E6);
        [self.view addSubview:line];
        if(i == 0)
        {
            btn.selected = YES;
            //默认one文字放大
            //            btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.oldBtn = btn;
        }
    }
    self.topBar.contentSize = CGSizeMake(self.btnW *count, -64);
}
-(void)addVCView
{
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0+44, TSScreenW, TSScreenH -44)];
    self.contentView = contentView;
    self.contentView.bounces = NO;
    contentView.delegate = self;
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    NSUInteger count = self.VCArr.count;
    for (int i=0; i<count; i++) {
        UIViewController *vc = self.VCArr[i];
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(i*TSScreenW, 0, TSScreenW, TSScreenH -44);
        [contentView addSubview:vc.view];
    }
    contentView.contentSize = CGSizeMake(count*TSScreenW, TSScreenH-44);
    contentView.pagingEnabled = YES;
}
- (void)click:(UIButton *)sender
{
    if(sender.selected) return;
    self.oldBtn.selected = NO;
    sender.selected = YES;
    self.contentView.contentOffset = CGPointMake((sender.tag - 10000)*TSScreenW, 0);
    [UIView animateWithDuration:0.3 animations:^{
        //        sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
    self.oldBtn.transform = CGAffineTransformIdentity;
    self.oldBtn = sender;
    
    //判断导航条是否需要移动
    CGFloat maxX = CGRectGetMaxX(self.slider.frame);
    if(maxX >=TSScreenW  && sender.tag != self.VCArr.count + 10000 - 1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.topBar.contentOffset = CGPointMake(maxX - TSScreenW + self.btnW, -64);
        }];
    }else if(maxX < TSScreenW)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.topBar.contentOffset = CGPointMake(0, -64);
        }];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滑动导航条
    self.slider.frame = CGRectMake(scrollView.contentOffset.x / TSScreenW *self.btnW , 41-64, self.btnW, 3);
}
//判断是否切换导航条按钮的状态
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offX =  scrollView.contentOffset.x;
    int tag = (int)(offX /TSScreenW + 0.5) + 10000;
    UIButton *btn = [self.view viewWithTag:tag];
    if(tag != self.oldBtn.tag)
    {
        [self click:btn];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
