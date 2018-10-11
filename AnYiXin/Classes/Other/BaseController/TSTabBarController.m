//
//  TSTabBarController.m
//  ZhongChou
//
//  Created by TuanShang on 16/4/9.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import "TSTabBarController.h"
#import "TSNavigationController.h"
#import "TSHomeController.h"
#import "TSPersonalController.h"
#import "TSFinancialController.h"

@interface TSTabBarController ()

@end

@implementation TSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置所有item的文字属性
//    [self setupItemAttrs];
    
    // 添加子控制器
    [self setupAllChildVces];
    
    self.tabBar.tintColor = COLOR_MainColor;
    // 设置所有光标的颜色
    [[UITextField appearance] setTintColor:COLOR_MainColor];
}

/**
 *  设置所有item的属性
 */
- (void)setupItemAttrs
{
    // 通过appearance统一设置UITabBarItem的文字属性
    UITabBarItem *item = [UITabBarItem appearance];
    // 规律:后面带有UI_APPEARANCE_SELECTOR的方法,都可以通过appearance对象统一设置
    // 设置文字属性(UIControlStateNormal)
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    
    // 设置文字属性(UIControlStateSelected)
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = COLOR_MainColor;
    
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

/**
 *  添加子控制器
 */
- (void)setupAllChildVces
{
    
    [self setupChildVc:[[TSHomeController alloc] init]  image:@"tabbar_home" selectedImage:@"tabbar_home_select"];
    
    [self setupChildVc:[[TSFinancialController alloc] init]  image:@"tabbar_financial" selectedImage:@"tabbar_financial_select"];
    
    [self setupChildVc:[[TSPersonalController alloc] init]  image:@"tabbar_person" selectedImage:@"tabbar_person_select"];
    

}


/**
 *  初始化一个子控制器
 *
 *  @param vc            子控制器
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)setupChildVc:(UIViewController *)vc  image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 添加子控制器
    TSNavigationController *nav = [[TSNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
    // 设置图片居中, 这儿需要注意top和bottom必须绝对值一样大
    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    // 设置基本属性
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
//     设置导航栏为透明的
//        if ([childController isKindOfClass:[ProfileController class]]) {
//            [nav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//            nav.navigationBar.shadowImage = [[UIImage alloc] init];
//            nav.navigationBar.translucent = YES;
//        }
    
}

@end
