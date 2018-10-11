//
//  TSCunGuanPSWViewController.m
//  AnYiXin
//
//  Created by Mac on 17/11/15.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSCunGuanPSWViewController.h"

#import "NSString+Extensions.h"
#import "UIButton+CountDown.h"

@interface TSCunGuanPSWViewController ()
@property (nonatomic , copy) NSString * codeToken;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UIButton *commitButton1;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;

@end

@implementation TSCunGuanPSWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"存管密码";
    [self setSubViewColor];
    
}
- (void)setSubViewColor {
    
    [self.line1 setBackgroundColor:COLOR_MainColor];
    [self.line2 setBackgroundColor:COLOR_MainColor];
    [self.line3 setBackgroundColor:COLOR_MainColor];
    [self.line3 setBackgroundColor:COLOR_MainColor];
    [self.line4 setBackgroundColor:COLOR_MainColor];

    [self.commitButton1 setBackgroundColor:COLOR_MainColor];
    [self.typeButton setBackgroundColor:COLOR_MainColor];
    self.typeButton.hidden = NO;
}

- (IBAction)didCommitButton:(UIButton *)button {
    if ( [self isCheckUserPassWord:self.newpasstwo.text] == NO) {
        [DZStatusHud showToastWithTitle:@"请输入6~16位新密码（数字,字母）" complete:nil];
    } else if (![self.newpasstwo.text isEqualToString:self.surePassTF.text]) {
        [DZStatusHud showToastWithTitle:@"两次新密码不一致，请重新输入" complete:nil];
    } else if (self.codeTF.text.length == 0) {
        [DZStatusHud showToastWithTitle:@"请输入验证码" complete:nil];
    } else   if ( [self isCheckUserPassWord:self.oldPassTF.text] == NO) {
        [DZStatusHud showToastWithTitle:@"请输入旧密码（数字,字母）" complete:nil];}
    else {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"code"] = self.codeTF.text;
        params[@"paypass"] = self.newpasstwo.text;
        params[@"paypass2"] = self.surePassTF.text ;
        params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        params[@"verify_code"] = self.codeToken;
        params[@"oldpaypass"] = self.oldPassTF.text;

        TSWeakSelf;
        [[TSNetwork shareNetwork] postRequestResult:params url:@"cgpwd" successBlock:^(id responseBody) {
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

// 密码健壮度检测
- (BOOL)isCheckUserPassWord:(NSString *)password {
    NSString * pattern = @"^[A-Za-z0-9]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:password];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.surePassTF||textField == self.newpasstwo) {
        if (textField.text.length > 5) return NO;
    }
    
    return YES;
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
