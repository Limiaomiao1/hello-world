//
//  TSPageController.m
//  TuanShang
//
//  Created by TuanShang on 16/6/25.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSPageController.h"
#import "TSTabBarController.h"

@interface TSPageController ()<UIScrollViewAccessibilityDelegate>

//按页滚动的scrollView
@property(nonatomic,retain)UIScrollView *scrollView;
//pageControl
@property(nonatomic,retain)UIPageControl *pageControl;

@end

@implementation TSPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    //   先设置  UIScrollView
    [self layoutScrollView];
    //    后设置  pageControl
    [self layoutPageControl];
}

//实现方法  layoutScrollView
- (void)layoutScrollView
{
    //    1.创建scrollView与屏幕大小一致
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    //    2.设置contentSize高度与屏幕相同,宽度是屏幕宽度的4倍
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 4, self.view.bounds.size.height);
    //       设置可以按页翻滚  UIScrollView  的  pageEnabled 属性
    self.scrollView.pagingEnabled = YES;
    //    3.设置  UIScrollView  代理
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //    4.循环创建  UIImageView,添加到  scrollView
    
    for (int i = 1; i <= 4; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"guide%d.png",i];
        //        创建图片对象
        UIImage *image = [UIImage imageNamed:imageName];
        //        创建ImageView,位置依次向右
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * (i - 1), 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        //        设置imageView展示的图片对象
        imageView.image = image;
        //        添加到scrollView
        [self.scrollView addSubview:imageView];
        //        scrollView添加到父视图上
        [self.view addSubview:self.scrollView];
        if (i == 4) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(120, self.view.frame.size.height - 110, (self.view.frame.size.width - 240), 35);
            button.backgroundColor = [UIColor clearColor];
            [button setTitle:@"开始体验" forState:UIControlStateNormal];
            [button setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
            [imageView addSubview:button];
            imageView.userInteractionEnabled = YES;
            [button addTarget:self action:@selector(ciickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
#pragma mark ---- 引导页的按钮实现
- (void)ciickButtonAction:(UIBarButtonItem *)barButtonItem
{
    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"qidong"];
    [UIApplication sharedApplication].keyWindow.rootViewController = self.tab;
}

#pragma mark----UIScrollViewDelegate
//实现代理方法

//动画效果结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    滑动scrollView后,改变pageControl当前点
    self.pageControl.currentPage = scrollView.contentOffset.x/self.view.bounds.size.width;
}


//实现方法  layoutPageControl
- (void)layoutPageControl
{  //  1.创建UIPageControl
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, self.view.frame.size.height - 80, self.view.frame.size.width-200, 47)];
    // 2.设置

    //    设置pageControl页的总数
    self.pageControl.numberOfPages = 4;
    
    //    设置当前选中页数
    self.pageControl.currentPage = 0;
    
    //    设置选中的点的颜色
    self.pageControl.currentPageIndicatorTintColor = COLOR_MainColor;
    
    //    设置其它点得颜色
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    //    3.添加到父视图
    [self.view addSubview:self.pageControl];
    
    //    4.添加target action
    [self.pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
}


//实现  pageControlAction  方法
- (void)pageControlAction:(UIPageControl *)pageControl
{
    //    改变self.scrollView的contentOffset
    [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width * pageControl.currentPage,0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
