//
//  TSUtouziController.m
//  Shangdai
//
//  Created by tuanshang on 17/4/24.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSUtouziController.h"
#import "DZNavController.h"
#import "TSUrecoeredController.h"
#import "TSUrecoverViewController.h"

@interface TSUtouziController ()

@end

@implementation TSUtouziController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"优选理财投资记录";
    TSUrecoverViewController * waitVC = [[TSUrecoverViewController alloc]init];
    waitVC.title = @"回收中";
    TSUrecoeredController *finishVC = [[TSUrecoeredController alloc]init];
    finishVC.title = @"已回收";
    
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
