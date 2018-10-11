//
//  RedPacketViewController.m
//  AnYiXin
//
//  Created by Mac on 17/8/18.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "RedPacketAllViewController.h"
#import "RedUnuseViewController.h"
#import "RedExpiredVController.h"
#import "RedUsedViewController.h"
#import "RedLockViewController.h"

@interface RedPacketAllViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *segmentArray;
@property (nonatomic, strong) UISegmentedControl * segment;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation RedPacketAllViewController
#pragma mark - 懒加载
- (NSArray *)segmentArray {
    if (_segmentArray == nil) {
        _segmentArray = [NSArray arrayWithObjects:@"未使用",@"使用中",@"已完成",@"已过期", nil];
    }
    return _segmentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];

    // Do any additional setup after loading the view.
}
//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化

- (void)setupSubviews {
    
    self.navigationItem.title = @"我的红包";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setSegment];
    [self setScrollview];
    [self setAllChirldVC];
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
    
}

- (void)setSegment {
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 70, TSScreenW-20, 40)];
    view.backgroundColor = [UIColor whiteColor];
    self.segment = [[UISegmentedControl alloc]initWithItems:self.segmentArray];
    self.segment.frame = view.bounds;
    self.segment.tintColor = COLOR_MainColor;
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    textAttrs[NSForegroundColorAttributeName] = COLOR_MainColor;
    [self.segment setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    self.segment.selectedSegmentIndex = 0;
    [self.segment addTarget:self action:@selector(didSegment) forControlEvents:UIControlEventValueChanged];
    [view addSubview:self.segment];
    [self.view addSubview:view];
    
}
- (void)setAllChirldVC {
    
    RedUnuseViewController * unuserVC = [[RedUnuseViewController alloc]init];
    [self addChildViewController:unuserVC];
    RedLockViewController * lockVC = [[RedLockViewController alloc]init];
    [self addChildViewController:lockVC];
    RedUsedViewController * usedVC = [[RedUsedViewController alloc] init];
    [self addChildViewController:usedVC];
    RedExpiredVController * expiredVC = [[RedExpiredVController alloc] init];
    [self addChildViewController:expiredVC];
    
    // 设置contentSize
    CGFloat contentW = self.childViewControllers.count * self.scrollView.width;
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
}

- (void)setScrollview {
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 116, TSScreenW, TSScreenH - 116)];
    self.scrollView .delegate = self;
    self.scrollView .pagingEnabled = YES;
    self.scrollView .showsVerticalScrollIndicator = NO;
    self.scrollView .showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
}

- (void)didSegment {
    
    // 让scrollView滚动到对应的位置(不要去修改contentOffset的y值)
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.segment.selectedSegmentIndex * self.scrollView.width;
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
/**
 *  滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    
    // 如果这个子控制器的view已经添加过了，就直接返回
    if (willShowChildVc.isViewLoaded) return;
    
    // 添加子控制器的view
    willShowChildVc.view.frame = scrollView.bounds;
    [scrollView addSubview:willShowChildVc.view];
}

/**
 *  滚动完毕就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / scrollView.width;
    
    self.segment.selectedSegmentIndex = index;
    // 添加子控制器的view
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
