//
//  AddBankController.m
//  CheZhongChou
//
//  Created by fjw on 16/5/4.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import "AddBankController.h"
#import "TSBindBankController.h"
#import "TSRealNameController.h"
#import "BankCardWebVC.h"
@interface AddBankController ()

@end

@implementation AddBankController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}
//=================================================================
//                           生命周期
//=================================================================
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化
- (void)setupSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"添加银行卡";
    UIButton * addCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCardButton setTitle:@"添加银行卡" forState:UIControlStateNormal];
    [addCardButton setBackgroundColor:COLOR_MainColor];
    [addCardButton addTarget:self action:@selector(addBankButton) forControlEvents:UIControlEventTouchUpInside];
    addCardButton.layer.cornerRadius = 5;
    addCardButton.layer.masksToBounds = YES;
    [self.view addSubview:addCardButton];
    [addCardButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:116];
    [addCardButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [addCardButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [addCardButton autoSetDimension:ALDimensionHeight toSize:44];
}
//=================================================================
//                           事件处理
//=================================================================
#pragma mark - 事件处理
- (void)addBankButton {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"id_status"] isEqual:@1]) {
        BankCardWebVC *CV = [[BankCardWebVC alloc] init];
        CV.navigationItem.title = @"绑定银行卡";
        [self.navigationController pushViewController:CV animated:YES];
    } else {
        [DZStatusHud showToastWithTitle:@"您还未实名认证" complete:^{
            TSRealNameController * realVC = [[TSRealNameController alloc] init];
            [self.navigationController pushViewController:realVC animated:YES];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
