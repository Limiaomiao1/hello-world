//
//  TSLoginPassController.m
//  TuanShang
//
//  Created by TuanShang on 16/7/15.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSLoginPassController.h"
#import "NSString+Extensions.h"
#import "UIButton+CountDown.h"

@interface TSLoginPassController ()

@property (nonatomic , copy) NSString * codeToken;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;
@property (weak, nonatomic) IBOutlet UIView *viewBack1;

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

@implementation TSLoginPassController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"登录密码";
    [self setSubViewColor];
    self.leftMargin.constant = -TSScreenW;
    self.viewBack1.hidden = YES;
    [self.view layoutIfNeeded];
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
    
}



- (IBAction)didSegmentButton:(UIButton *)button {
    
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

- (IBAction)oldpassCommitButton:(id)sender {
    
    [self.view endEditing:YES];
    if (self.oldpass.text.length == 0) {
        [DZStatusHud showToastWithTitle:@"请输入旧密码" complete:nil];
    } else if ([self.newpass.text isCheckPassword] == NO){
        [DZStatusHud showToastWithTitle:@"请输入6~16位新密码（数字和字母组合）" complete:nil];
    } else if (![self.newpass.text isEqualToString:self.aginnewpass.text]) {
       [DZStatusHud showToastWithTitle:@"两次密码输入不一致" complete:nil];
    } else {
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"old_pwd"] = [self.oldpass.text MD5String];
        params[@"pwd"] = [self.newpass.text MD5String];
        params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        TSWeakSelf;
        [[TSNetwork shareNetwork] postRequestResult:params url:TSAPI_CHANGE_PWD_BY_OLD successBlock:^(id responseBody) {
            
            NSString * msgStr = responseBody[@"msg"];
            NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
            [DZStatusHud showToastWithTitle:msgStr complete:nil];
            if ([eventStr isEqualToString:@"88"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } failureBlock:^(NSString *error) {
            [DZStatusHud showToastWithTitle:error complete:nil];
        }];
    }
    
}
- (IBAction)getCodeButton:(UIButton *)button {
    
    button.userInteractionEnabled = NO;
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
  //  params[@"phone"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"userphone"];
    params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    TSWeakSelf;
    
    [[TSNetwork shareNetwork] postRequestResult:params url:TSAPI_SEND_CODE successBlock:^(id responseBody) {
        
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        NSString * msgStr = [NSString stringWithFormat:@"%@",responseBody[@"msg"]];
        [DZStatusHud showToastWithTitle:msgStr complete:nil];
        if ([eventStr isEqualToString:@"88"]) {
            [button startWithTime:60 title:@"重新获取" countDownTitle:@"s" mainColor:COLOR_MainColor countColor:[UIColor colorWithWhite:0.800 alpha:1.000]];
            NSString * token = [NSString stringWithFormat:@"%@",responseBody[@"data"]];
            weakSelf.codeToken = token;

        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
}
- (IBAction)phonepassCommitButton:(id)sender {
    
    if ( [self isCheckUserPassWord:self.newphonepass.text] == NO) {
        [DZStatusHud showToastWithTitle: @"请输入6~16位新密码（数字和字母组合）" complete:nil];
    } else if (![self.newphonepass.text isEqualToString:self.newpasstwo.text]) {
        [DZStatusHud showToastWithTitle:@"两次新密码不一致，请重新输入" complete:nil];;
    } else if (self.codeTF.text.length == 0) {
        [DZStatusHud showToastWithTitle:@"请输入验证码" complete:nil];
    } else {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"code"] = self.codeTF.text;
        params[@"pwd"] = [self.newpasstwo.text MD5String];
        params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        params[@"verify_code"] = self.codeToken;
        TSWeakSelf;
        [[TSNetwork shareNetwork] postRequestResult:params url:TSAPI_CHANGE_PWD_BY_PHONE successBlock:^(id responseBody) {
            NSString * msgStr = responseBody[@"msg"];
            NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
            [DZStatusHud showToastWithTitle:msgStr complete:nil];
            if ([eventStr isEqualToString:@"88"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } failureBlock:^(NSString *error) {
            [DZStatusHud showToastWithTitle:error complete:nil];

        }];
    }
}
    
- (BOOL)isCheckUserPassWord:(NSString *)password {
    
    NSString * pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:password];
}

@end
