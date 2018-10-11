//
//  TSAddMoneyController.m
//  Shangdai
//
//  Created by tuanshang on 17/2/27.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSAddMoneyController.h"
#import "NSString+Extensions.h"
#import "UIButton+CountDown.h"

@interface TSAddMoneyController ()
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (strong, nonatomic) IBOutlet UITextField *payPswTf;
@property (weak, nonatomic) IBOutlet UIView *btnview;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (nonatomic,strong)NSString *realid;
@property (nonatomic,strong)NSString *phoneStr;
/** 验证码 */
@property (nonatomic, copy) NSString *codeToken;

@end

@implementation TSAddMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账户充值";
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    
    // 请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = token;
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:params url:@"realbanklist" successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {
            NSArray *realArr = responseBody[@"data"][@"real_name_info"];
            NSDictionary *realDic = realArr[0];
            self.realid = [NSString stringWithFormat:@"%@",[realDic objectForKey:@"id"]];
            self.phoneStr = [NSString stringWithFormat:@"%@",[realDic objectForKey:@"user_phone"]];
  
           } else {
               [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];

            }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
    
    UIButton *codeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:10];
    codeButton.layer.cornerRadius = 5;
    codeButton.frame = CGRectMake(0, 0, _btnview.width, _btnview.height);
    codeButton.backgroundColor = COLOR_MainColor;
    [_btnview addSubview:codeButton];
    [codeButton addTarget:self action:@selector(getcode:) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)sure:(id)sender {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    params[@"t_money"]=self.moneyTF.text;
    params[@"real_name_id"]=_realid;
    params[@"password_pin"]=_payPswTf.text;
    params[@"phone_code"]=_codeTF.text;
    params[@"verify_code"] = self.codeToken;
    NSLog(@"%@",params);
    [[TSNetwork shareNetwork] postRequestResult:params url:@"realnamepay" successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        NSString * msgStr = [NSString stringWithFormat:@"%@",responseBody[@"msg"]];
        
        if ([eventStr isEqualToString:@"88"]) {
            [DZStatusHud showToastWithTitle:[NSString stringWithFormat:@"%@", msgStr] complete:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {

            [DZStatusHud showToastWithTitle:[NSString stringWithFormat:@"%@", msgStr] complete:nil];
        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];

}
- (void)getcode:(UIButton *)sender {
    UIButton *button = sender;

    NSDictionary *param = @{@"phone":_phoneStr,@"find":@"1"};
    [[TSNetwork shareNetwork] postRequestResult:param url:TSAPI_SEND_CODE successBlock:^(id responseBody) {
        if ([responseBody[@"event"] isEqual:@88]) {
            [button startWithTime:60 title:@"重新获取" countDownTitle:@"s" mainColor:COLOR_MainColor countColor:[UIColor colorWithWhite:0.800 alpha:1.000]];
            NSString * token = [NSString stringWithFormat:@"%@",responseBody[@"data"]];
            self.codeToken = token;
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];

        }else
        {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
