//
//  PosAddmoneyViewController.m
//  AnYiXin
//
//  Created by Mac on 17/8/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "PosAddmoneyViewController.h"
#import "NSString+Extensions.h"
#import "UIButton+CountDown.h"
#import "TSPosListViewController.h"
@interface PosAddmoneyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (nonatomic,strong)NSString *realid;
@property (nonatomic,strong)NSString *phoneStr;
/** 验证码 */
@property (nonatomic, copy) NSString *codeToken;

@property (weak, nonatomic) IBOutlet UILabel *balanceL;//余额
@end

@implementation PosAddmoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"POS充值";
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    // 请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = token;
    [[TSNetwork shareNetwork] postRequestResult:params url:@"poszf" successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {
            self.phoneStr = [NSString stringWithFormat:@"%@",responseBody[@"data"][@"user_phone"]];
            self.balanceL.text = [NSString stringWithFormat:@"账户余额（元）：%@",responseBody[@"data"][@"account_money"]];
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
    codeButton.frame = CGRectMake(0, 0, _btnView.width, _btnView.height);
    codeButton.backgroundColor = COLOR_MainColor;
    [_btnView addSubview:codeButton];
    [codeButton addTarget:self action:@selector(getcode:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (IBAction)sureAct:(id)sender {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    params[@"t_money"]=self.moneyTF.text;
    params[@"password_pin"]=_pswTF.text;
    params[@"phone_code"]=_codeTF.text;
    params[@"verify_code"] = self.codeToken;
    NSLog(@"%@",params);
    [[TSNetwork shareNetwork] postRequestResult:params url:@"poszfpay" successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        NSString * msgStr = [NSString stringWithFormat:@"%@",responseBody[@"msg"]];
        
        if ([eventStr isEqualToString:@"88"]) {
       //     [DZStatusHud showToastWithTitle:[NSString stringWithFormat:@"%@", msgStr] complete:nil];
            [DZStatusHud showToastWithTitle:@"生成订单成功" complete:nil];

            TSPosListViewController *vc = [[TSPosListViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            
            [DZStatusHud showToastWithTitle:[NSString stringWithFormat:@"%@", msgStr] complete:nil];
        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];

    
}
- (IBAction)posListAct:(id)sender {
    TSPosListViewController *vc = [[TSPosListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
