//
//  TSRealNameController.m
//  Shangdai
//
//  Created by tuanshang on 17/2/19.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSRealNameController.h"
#import "TSSetPinController.h"

@interface TSRealNameController ()

/** 身份识别 */
@property (nonatomic, assign) NSInteger idStudus;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userCard;
@property (weak, nonatomic) IBOutlet UIButton *realButton;

@end

@implementation TSRealNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"实名认证";
    [self.realButton setBackgroundColor:COLOR_MainColor];

    [self loadWithData];
    
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
//                         Http Request
//=================================================================
#pragma mark - 实名认证 Request
- (void)loadWithData {
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} url:TSAPI_CHECK_ID_STATUS successBlock:^(id responseBody) {
        weakSelf.idStudus = [responseBody[@"event"] integerValue];
        if (weakSelf.idStudus == 88) {
            weakSelf.realButton.alpha = 0.5;
            weakSelf.realButton.enabled = NO;
            weakSelf.userName.enabled = NO;
            weakSelf.userCard.enabled = NO;
            weakSelf.userName.text = responseBody[@"data"][@"real_name"];
            weakSelf.userCard.text = responseBody[@"data"][@"idNo"];
            [weakSelf.realButton setTitle:@"实名认证成功" forState:(UIControlStateNormal)];
        } else if (weakSelf.idStudus == 90) {
            weakSelf.realButton.alpha = 1;
            weakSelf.realButton.enabled = YES;
        } else if (weakSelf.idStudus == 0) {
            weakSelf.realButton.alpha = 0.5;
            weakSelf.realButton.enabled = NO;
            weakSelf.userName.enabled = NO;
            weakSelf.userCard.enabled = NO;
            weakSelf.userName.text = responseBody[@"data"][@"real_name"];
            weakSelf.userCard.text = responseBody[@"data"][@"idNo"];
            [weakSelf.realButton setTitle:@"待审核" forState:(UIControlStateNormal)];
        } else if (weakSelf.idStudus == 2) {
            weakSelf.realButton.alpha = 1;
            weakSelf.realButton.enabled = YES;
            [weakSelf.realButton setTitle:@"实名审核未通过，点击重新提交" forState:(UIControlStateNormal)];
        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//=================================================================
//                           事件处理
//=================================================================
#pragma mark - 事件处理

- (IBAction)didRealButton:(id)sender {

    [self.view endEditing:YES];
    if(self.userName.text.length <= 0) {
        [DZStatusHud showToastWithTitle:@"请填写真实姓名" complete:nil];
    } else if (self.userCard.text.length <= 0) {
        [DZStatusHud showToastWithTitle:@"请填写身份证号" complete:nil];
    } else {
        // 请求参数
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"real_name"] = self.userName.text;
        params[@"card_no"] = self.userCard.text;
        params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        TSWeakSelf;
        [[TSNetwork shareNetwork] postRequestResult:params url:TSAPI_VERIFY_ID_CARD successBlock:^(id responseBody) {
            NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
            NSString * msgStr = responseBody[@"msg"];
            
            if ([eventStr isEqualToString:@"88"] || [eventStr isEqualToString:@"87"]) {
                UIButton *button = sender;
                [button setEnabled:NO];
                button.alpha = 0.5;
                [DZStatusHud showToastWithTitle:msgStr complete:^{
                    
                    [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults]objectForKey:@"token"]} url:@"check_pin_pass" successBlock:^(id responseBody) {
                        
                        TSLog(@"%@",responseBody);
                        if ([responseBody[@"event"]  isEqual:@88]) {
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        } else {
                            
                            [DZStatusHud showToastWithTitle:@"你还未设置支付密码" complete:^{
                                [weakSelf.navigationController pushViewController:[[TSSetPinController alloc] init] animated:YES];
                            }];
                            
                        }
                        
                    } failureBlock:^(NSString *error) {
                        
                    }];
                }];

            } else {
                [DZStatusHud showToastWithTitle:msgStr complete:nil];
            }
        } failureBlock:^(NSString *error) {
            [DZStatusHud showToastWithTitle:error complete:nil];
        }];
    }
}


@end
