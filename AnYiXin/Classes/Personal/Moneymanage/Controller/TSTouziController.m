//
//  TSTouziController.m
//  Shangdai
//
//  Created by tuanshang on 17/2/22.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSTouziController.h"
#import "TSWaitMoneyController.h"
#import "TSFinishMoneyLogController.h"
#import "DZNavController.h"

@interface TSTouziController ()

@end

@implementation TSTouziController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"投资记录";
    TSWaitMoneyController * waitVC = [[TSWaitMoneyController alloc]init];
    waitVC.title = @"待回款";
    TSFinishMoneyLogController *finishVC = [[TSFinishMoneyLogController alloc]init];
    finishVC.title = @"已完成";
    
    NSArray *subViewControllers = @[waitVC,finishVC];
    DZNavController *nav = [[DZNavController alloc]initWithSubViewControllers:subViewControllers];
    nav.view.frame = CGRectMake(0, 64, TSScreenW, TSScreenH - 64);
    [self.view addSubview:nav.view];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
