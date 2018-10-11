//
//  TSPinPassController.m
//  TuanShang
//
//  Created by TuanShang on 16/7/14.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSPinPassController.h"
#import "NSString+Extensions.h"
#import "UIButton+CountDown.h"

@interface TSPinPassController ()
@property (nonatomic , copy) NSString * codeToken;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UIButton *commitButton1;
@property (weak, nonatomic) IBOutlet UIView *line4;
@property (weak, nonatomic) IBOutlet UIView *line5;
@property (weak, nonatomic) IBOutlet UIView *line6;
@property (weak, nonatomic) IBOutlet UIButton *commitButton2;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@end

@implementation TSPinPassController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"支付密码";
    
    [self setSubViewColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)setSubViewColor {
    
    [self.line1 setBackgroundColor:COLOR_MainColor];
    [self.line2 setBackgroundColor:COLOR_MainColor];
    [self.line3 setBackgroundColor:COLOR_MainColor];
    [self.line4 setBackgroundColor:COLOR_MainColor];
    [self.line5 setBackgroundColor:COLOR_MainColor];
    [self.line6 setBackgroundColor:COLOR_MainColor];
    
    [self.codeButton setBackgroundColor:COLOR_MainColor];
    [self.commitButton1 setBackgroundColor:COLOR_MainColor];
    [self.commitButton2 setBackgroundColor:COLOR_MainColor];
    [self.typeButton setBackgroundColor:COLOR_MainColor];
    
    self.leftMargin.constant =  - TSScreenW;
    self.viewBack1.hidden = YES;
    
}


- (IBAction)didCommitButton:(UIButton *)button {
    [self.view endEditing:YES];
    if (self.leftMargin.constant) {
        self.leftMargin.constant = 0;
        self.viewBack1.hidden = NO;
        button.selected = NO;
    } else {
        self.leftMargin.constant =  - self.view.width;
        self.viewBack1.hidden = YES;
        button.selected = YES;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)didSureButton:(id)sender {
    if (self.oldTF.text.length == 0) {
        [DZStatusHud showToastWithTitle:@"请输入旧密码" complete:nil];
    } else if ([self isCheckUserPassWord:self.newpassone.text] == NO){
       [DZStatusHud showToastWithTitle:@"请输入6~16位新密码（数字,字母）" complete:nil];
    } else if (![self.newpass.text isEqualToString:self.newpassone.text]) {
        [DZStatusHud showToastWithTitle:@"两次密码输入不一致" complete:nil];
    } else {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"pin_pass"] = [self.oldTF.text MD5String];
        params[@"pin_pass_new"] = [self.newpass.text MD5String];
        params[@"type"] = @2;
        params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        TSWeakSelf;
        [[TSNetwork shareNetwork] postRequestResult:params url:TSAPI_SET_PIN_PASS successBlock:^(id responseBody) {
            NSString * msgStr = responseBody[@"msg"];
            [DZStatusHud showToastWithTitle:msgStr complete:nil];
            NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
            if ([eventStr isEqualToString:@"88"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } failureBlock:^(NSString *error) {
            
        }];
    }
}
- (IBAction)getCodeButton:(UIButton *)button {
    
    button.userInteractionEnabled = NO;
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
  //  params[@"phone"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"userphone"];
    params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:params url:@"send_code" successBlock:^(id responseBody) {
        
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        NSString * msgStr = [NSString stringWithFormat:@"%@",responseBody[@"msg"]];
        [DZStatusHud showToastWithTitle:[NSString stringWithFormat:@"%@", msgStr] complete:nil];
        if ([eventStr isEqualToString:@"88"]) {
            [button startWithTime:60 title:@"重新获取" countDownTitle:@"s" mainColor:COLOR_MainColor countColor:[UIColor colorWithWhite:0.800 alpha:1.000]];
            NSString * token = [NSString stringWithFormat:@"%@",responseBody[@"data"]];
            weakSelf.codeToken = token;
        }
        
    } failureBlock:^(NSString *error) {
        
    }];
}
- (IBAction)surePhonePassButton:(id)sender {
    
    if ( [self isCheckUserPassWord:self.newpasstwo.text] == NO) {
        [DZStatusHud showToastWithTitle:@"请输入6~16位新密码（数字,字母）" complete:nil];
    } else if (![self.newpasstwo.text isEqualToString:self.surePassTF.text]) {
        [DZStatusHud showToastWithTitle:@"两次新密码不一致，请重新输入" complete:nil];
    } else if (self.codeTF.text.length == 0) {
        [DZStatusHud showToastWithTitle:@"请输入验证码" complete:nil];
    } else {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"code"] = self.codeTF.text;
        params[@"pin_pass_new"] = [self.newpasstwo.text MD5String];
        params[@"type"] = @3;
        params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        params[@"verify_code"] = self.codeToken;
        TSWeakSelf;
        [[TSNetwork shareNetwork] postRequestResult:params url:TSAPI_SET_PIN_PASS successBlock:^(id responseBody) {
            NSString * msgStr = responseBody[@"msg"];
            [DZStatusHud showToastWithTitle:msgStr complete:nil];
            NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
            if ([eventStr isEqualToString:@"88"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } failureBlock:^(NSString *error) {
            
        }];
    }
}

// 密码健壮度检测
- (BOOL)isCheckUserPassWord:(NSString *)password {
    NSString * pattern = @"^[A-Za-z0-9]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:password];
}

@end
