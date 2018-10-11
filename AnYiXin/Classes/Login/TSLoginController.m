//
//  TSLoginController.m
//  Shangdai
//
//  Created by tuanshang on 17/2/17.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSLoginController.h"
#import "TSRegisteredController.h"
#import "NSString+Extensions.h"
#import "AppDelegate.h"
#import "TSTabBarController.h"
#import "TSBackPassController.h"

@interface TSLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *currVertionLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *fogetButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;

@end

@implementation TSLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loginButton setBackgroundColor:COLOR_MainColor];
    [self.fogetButton setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
    [self.registButton setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
    [self.currVertionLabel setTextColor:COLOR_MainColor];
    // 获取系统当前版本号
    NSString *currVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.currVertionLabel.text = [NSString stringWithFormat:@"版本：%@", currVersion];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.view addGestureRecognizer:tap];
}

//=================================================================
//                           生命周期
//=================================================================
#pragma mark - 生命周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//=================================================================
//                           事件处理
//=================================================================
#pragma mark - 事件处理

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGes
{
    [self.view endEditing:YES];
}

- (IBAction)didRegButtonAction:(id)sender {
    [self.view endEditing:YES];
    TSRegisteredController *regVC = [[TSRegisteredController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
}

- (IBAction)didLoginButtonAction:(id)sender {
    
    if ([self.username.text isUserName] == NO) {
        [DZStatusHud showToastWithTitle:@"请输入用户名" complete:nil];
        return;
    } else {
        NSDictionary *param = @{@"user_name":self.username.text, @"pwd":self.password.text.MD5String,@"devicenumber":uuid};
        TSWeakSelf;
        [[TSNetwork shareNetwork] postRequestResult:param url:TSAPI_LOGIN successBlock:^(id responseBody) {
            
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] yOffset:TSScreenH/2-100 complete:^{
                
                if ([responseBody[@"event"] isEqual:@88]) {
                    // 持久化用户配置
                    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                    [user setObject:weakSelf.username.text forKey:@"userphone"];
                    [user setObject:weakSelf.password.text forKey:@"password"];
                    [user setObject:responseBody[@"data"] forKey:@"token"];
                    [user setBool:YES forKey:@"islogin"];
                    [user synchronize];
                    [weakSelf.view endEditing:YES];
                    if ([self.password.text isCheckPassword] == NO) {
                        [DZStatusHud showToastWithTitle:@"请输入6~16位新密码（数字和字母组合）老用户请重置密码" complete:nil];
                        
                        TSBackPassController *backVC = [[TSBackPassController alloc] init];
                        [self.navigationController pushViewController:backVC animated:YES];
                    
                    }else
                    {
                        [weakSelf dismissViewControllerAnimated:YES completion:^{
                            
                            
                            [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} url:TSAPI_MEMBER successBlock:^(id responseBody) {
                                int event = [responseBody[@"event"] intValue];
                                if (event == 88) {
                                    [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"id_status"] forKey:@"id_status"];
                                    [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"credit_lvl"] forKey:@"credit_lvl"];
                                    [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"email_status"] forKey:@"email_status"];
                                    [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"has_pin"] forKey:@"has_pin"];
                                    [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"invest_lvl"] forKey:@"invest_lvl"];
                                    [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"phone_status"] forKey:@"phone_status"];
                                    [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"user_name"] forKey:@"user_name"];
                                    [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"user_phone"] forKey:@"user_phone"];
                                    [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"balance_money"] forKey:@"balance_money"];
                                    [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"vip"] forKey:@"vip"];
                                    [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"header_img"] forKey:@"header_img"];
                                    [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"real_name"] forKey:@"real_name"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                }else{
                                    [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
                                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"islogin"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                }
                            } failureBlock:^(NSString *error) {
                                
                            }];
                            
                        }];
                    }
                }else
                {
                    [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
                }
                
            }];

        } failureBlock:^(NSString *error) {
            [DZStatusHud showToastWithTitle:error complete:nil];
        }];
        
    }
}

- (IBAction)didBackButtonAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)isCheckUserPassWord:(NSString *)password {
    
    NSString * pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:password];
}

- (IBAction)didForgetPassAction:(id)sender {
    [self.view endEditing:YES];
    TSBackPassController *backVC = [[TSBackPassController alloc] init];
    [self.navigationController pushViewController:backVC animated:YES];
}

@end
