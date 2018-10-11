//
//  TSSetPinController.m
//  Shangdai
//
//  Created by tuanshang on 17/3/1.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSSetPinController.h"
#import "NSString+Extensions.h"
#import "TSLoginController.h"

@interface TSSetPinController ()

@property (weak, nonatomic) IBOutlet UITextField *pinpassTF;
@property (weak, nonatomic) IBOutlet UITextField *surepinTF;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation TSSetPinController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"设置支付密码";
    [self.commitButton setBackgroundColor:COLOR_MainColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didSetButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    if ([self isCheckUserPassWord:self.pinpassTF.text] == NO) {
        [DZStatusHud showToastWithTitle:@"请输入6~16位支付密码（数字,字母）" complete:nil];
    } else if ([self isCheckUserPassWord:self.surepinTF.text] == NO){
        [DZStatusHud showToastWithTitle:@"请输入6~16位支付密码（数字,字母）" complete:nil];
    } else if (![self.pinpassTF.text isEqualToString:self.surepinTF.text]) {
        [DZStatusHud showToastWithTitle:@"两次的密码不一致，请重新输入。" complete:nil];
    } else {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"pin_pass_new"] = [self.surepinTF.text MD5String];
        params[@"type"] = @1;
        params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        TSWeakSelf;
        [[TSNetwork shareNetwork] postRequestResult:params url:TSAPI_SET_PIN_PASS successBlock:^(id responseBody) {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
            NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
            if ([eventStr isEqualToString:@"88"]) {
                TSLoginController *homeVC = [[TSLoginController alloc] init];
                UIViewController *target = nil;
                for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
                    if ([controller isKindOfClass:[homeVC class]]) { //这里判断是否为你想要跳转的页面
                        target = controller;
                    } else {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }
                if (target) {
                    [weakSelf.navigationController popToViewController:target animated:YES]; //跳转
                    [target dismissViewControllerAnimated:YES completion:nil];
                }

            } else {
                
            }
        } failureBlock:^(NSString *error) {
            [DZStatusHud showToastWithTitle:@"网络错误，请重试" complete:nil];
        }];
    }
}

- (BOOL)isCheckUserPassWord:(NSString *)password {
    
    NSString * pattern = @"^[A-Za-z0-9]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:password];
}



@end
