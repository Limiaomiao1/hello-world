//
//  TSRegisteredController.m
//  Shangdai
//
//  Created by tuanshang on 17/2/17.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSRegisteredController.h"
#import "NSString+Extensions.h"
#import "UIButton+CountDown.h"
#import "TSRealNameController.h"

@interface TSRegisteredController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userphone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *surepass;
@property (weak, nonatomic) IBOutlet UITextField *invitecode;
@property (weak, nonatomic) IBOutlet UITextField *verifycode;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;

/** 验证码 */
@property (nonatomic, copy) NSString *codeToken;

@end

@implementation TSRegisteredController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
    [self.codeButton setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
    [self.registButton setBackgroundColor:COLOR_MainColor];

}

//=================================================================
//                           生命周期
//=================================================================
#pragma mark - 生命周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//=================================================================
//                           事件处理
//=================================================================
#pragma mark - 事件处理

- (IBAction)didGetCodeButton:(id)sender {
    if ([self.userphone.text isValiMobile]) {
        [DZStatusHud showToastWithTitle:@"请输入正确的手机号" complete:nil];
    } else {
        //TSAPI_SEND_CODE
        NSDictionary *param = @{@"phone":self.userphone.text};
        [[TSNetwork shareNetwork] postRequestResult:param url:TSAPI_SEND_CODE successBlock:^(id responseBody) {
            
            UIButton *button = sender;
            if ([responseBody[@"event"] isEqual:@88]) {
                [button startWithTime:60 title:@"重新获取" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
                NSString * token = [NSString stringWithFormat:@"%@",responseBody[@"data"]];
                self.codeToken = token;
            }
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        } failureBlock:^(NSString *error) {
            [DZStatusHud showToastWithTitle:error complete:nil];
        }];
    }
}

- (IBAction)didRegButton:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.userphone.text isValiMobile]) {
        [DZStatusHud showToastWithTitle:@"请输入正确的手机号" complete:nil];
    } else if ([self.password.text isCheckPassword] == NO) {
        [DZStatusHud showToastWithTitle:@"请输入6~16位新密码（数字和字母组合）" complete:nil];
    } else if (![self.password.text isEqualToString:self.surepass.text]) {
        [DZStatusHud showToastWithTitle:@"您两次密码输入不一致，请重新输入" complete:nil];
    } else if (self.verifycode.text.length <= 0) {
        [DZStatusHud showToastWithTitle:@"请输入验证码" complete:nil];
    } else {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"phone"] = self.userphone.text;
        params[@"code"] = self.verifycode.text;
        params[@"pwd"] = [self.password.text MD5String];
        params[@"verify_code"] = self.codeToken;
        params[@"invite_code"] = self.invitecode.text;
        [[TSNetwork shareNetwork] postRequestResult:params url:TSAPI_REG successBlock:^(id responseBody) {
           [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:^{
               if ([responseBody[@"event"] isEqual:@88]) {
                   [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"] forKey:@"token"];
                   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"islogin"];
                   [[NSUserDefaults standardUserDefaults] synchronize];
                   [self.navigationController pushViewController:[[TSRealNameController alloc] init] animated:YES ];
               }
           }];
        } failureBlock:^(NSString *error) {
            [DZStatusHud showToastWithTitle:error complete:nil];
        }];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.userphone]) {
        if (![textField.text isValiMobile]) {
            NSDictionary *param = @{@"user_name":self.userphone.text};
            [[TSNetwork shareNetwork] postRequestResult:param url:TSAPI_CHECK_NAME successBlock:^(id responseBody) {
                if (![responseBody[@"event"] isEqual:@88]) {
                    [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
                }
            } failureBlock:^(NSString *error) {
                [DZStatusHud showToastWithTitle:error complete:nil];
            }];
        } else {
            [DZStatusHud showToastWithTitle:@"请输入正确的手机号" complete:nil];
        }
    }
}

@end
