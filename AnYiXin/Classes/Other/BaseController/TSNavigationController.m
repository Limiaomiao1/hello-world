//
//  TSNavigationController.m
//  ZhongChou
//
//  Created by TuanShang on 16/4/9.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import "TSNavigationController.h"
#import "TSConstant.h"

@interface TSNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation TSNavigationController

+ (void)initialize
{
    // 设置导航栏背景
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = COLOR_MainColor;
//    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    // 设置导航栏中间的标题属性
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    barAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    barAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [bar setTitleTextAttributes:barAttrs];
    
    // 设置item的属性
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemNormalAttrs = [NSMutableDictionary dictionary];
    itemNormalAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    itemNormalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:itemNormalAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 清空手势代理, 然后就会重新出现手势移除控制器的功能
    self.interactivePopGestureRecognizer.delegate = self;
}

/**
 *  拦截导航控制器push进来的所有子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    // viewController不是导航控制器的第1个子控制器
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置viewController左上角的按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateHighlighted];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        // 相当于让按钮的内容往左边偏移20
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    // super的push方法最好放在最后面调用
    // 一旦调用pushViewController:animated:方法,就会开始创建viewController的view,也就是调用viewController的viewDidLoad方法
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}


#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 如果只有一个子控制器, 就禁止掉pop手势
    //    if (self.childViewControllers.count == 1) return NO;
    //    return YES;
    return self.childViewControllers.count > 1;
}
@end
