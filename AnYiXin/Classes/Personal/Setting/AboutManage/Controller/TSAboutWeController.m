//
//  TSAboutWeController.m
//  TuanShang
//
//  Created by TuanShang on 16/7/11.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSAboutWeController.h"

@interface TSAboutWeController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView * scrollview;
@property (nonatomic, strong)UIImageView * imageView;

@end

@implementation TSAboutWeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}

//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化

- (void)setupSubViews {
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollview = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollview.maximumZoomScale = 2.0;
    self.scrollview.minimumZoomScale = 1.0;
    self.scrollview.contentSize = CGSizeMake(self.view.width, self.view.height*2.0-120);
    self.scrollview.delegate = self;
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenH*2.0-120)];
    self.imageView.image = [UIImage imageNamed:@"platform.jpg"];
    [self.scrollview addSubview:self.imageView];
    [self.view addSubview:self.scrollview];
    self.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
    tap.numberOfTapsRequired=1;//单击
    tap.numberOfTouchesRequired=1;//单点触碰
    [self.imageView addGestureRecognizer:tap];
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired=2;//避免单击与双击冲突
    [tap requireGestureRecognizerToFail:doubleTap];
    [self.imageView addGestureRecognizer:doubleTap];
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//=================================================================
//                           事件处理
//=================================================================
#pragma mark - 事件处理

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView  //委托方法,必须设置  delegate
{
    return self.imageView;//要放大的视图
}

-(void)doubleTap:(id)sender
{
    self.scrollview.zoomScale=1.0;//双击放大到两倍
}

- (void)tapImage
{
    [self dismissViewControllerAnimated:YES completion:nil];//单击图像,关闭图片详情(当前图片页面)
}


@end
