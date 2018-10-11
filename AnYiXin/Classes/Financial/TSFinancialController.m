//
//  TSBorrowController.m
//  Shangdai
//
//  Created by tuanshang on 17/1/14.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSFinancialController.h"
#import "UIBarButtonItem+Extension.h"
#import "TSMyMessageController.h"
#import "TSNavigationController.h"
#import "TSLoginController.h"
#import "DZNavController.h"
#import "TSSanBiaoController.h"
#import "TSUPlanController.h"
#import "TSDebtController.h"

@interface TSFinancialController ()

@end

@implementation TSFinancialController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupSubViews];
}

//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化

- (void)setupSubViews {
    
    TSSanBiaoController * waitVC = [[TSSanBiaoController alloc]init];
    waitVC.title = @"智能理财";
    TSUPlanController *finishVC = [[TSUPlanController alloc]init];
    finishVC.title = @"优质项目";
//    TSDebtController *debtVC = [[TSDebtController alloc] init];
//    debtVC.title = @"债权转让";
    
    NSArray *subViewControllers = @[waitVC];
    
//    NSArray *subViewControllers = @[waitVC,finishVC];
    DZNavController *nav = [[DZNavController alloc]initWithSubViewControllers:subViewControllers];
    nav.view.frame = CGRectMake(0, 64, TSScreenW, TSScreenH - 64);
    [self.view addSubview:nav.view];
    [self addChildViewController:nav];
}

- (void)setupNav {
    self.navigationItem.title = @"理财";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(noticeButtonClick) image:@"nav_right" highImage:@"nav_right"];
}

#pragma mark - 通知按钮点击

- (void)noticeButtonClick {
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){
        TSMyMessageController *messageVC = [[TSMyMessageController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
    }else {
        TSLoginController *loginVC = [[TSLoginController alloc]init];
        TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:naVC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
