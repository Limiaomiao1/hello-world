//
//  TSWithdrawalController.m
//  Shangdai
//
//  Created by tuanshang on 17/2/27.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSWithdrawalController.h"
#import "TSWithdrawListController.h"
#import "MineBankController.h"
#import "TSSetPinController.h"
#import "NSString+Extensions.h"
#import "DeletBankTController.h"
#import "UIButton+CountDown.h"
#import "BankCardNewViewController.h"
#import "ErrorCode.h"

#import "BankCardWebVC.h"

@interface TSWithdrawalController () <UITextFieldDelegate,CFCASIPInputFieldDelegate>
@property (nonatomic, strong) NSMutableDictionary * dataDic;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankcard;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UILabel *myMoney;
@property (weak, nonatomic) IBOutlet UIScrollView *bgscroll;

/** 手续费 */
@property (nonatomic, copy) NSString *message;
/** 交易密码 */
@property (nonatomic, copy) NSString *pinpass;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIButton *lookListButoon;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIButton *getcodebtn;
@property (weak, nonatomic) IBOutlet UITextField *codetf;
@property (nonatomic , copy) NSString * codeToken;
@property (weak, nonatomic) IBOutlet UIView *commitView;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;

@property (nonatomic,strong)NSString *meng_bizFlow;

@property (nonatomic ,strong)NSString *pswEncode;//加密后的密码
@property (nonatomic ,strong)NSString *meng_sn;
@property (nonatomic ,strong)NSString *meng_random;

@end

@implementation TSWithdrawalController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"账户提现";

    [self.commitButton setBackgroundColor:COLOR_MainColor];
    [self.lookListButoon setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
    self.getcodebtn.layer.cornerRadius = 5;

    self.getcodebtn.backgroundColor = COLOR_MainColor;
    _phone.text = _phonestr;
    
    if (_lookListButoon.height+_lookListButoon.y+_commitView.y+20>TSScreenH) {
        
        _bgscroll.contentSize = CGSizeMake(TSScreenW, _lookListButoon.height+_lookListButoon.y+20+_commitView.y);
    }
    
    self.payTF.emSipKeyboardType = SIP_KEYBOARD_TYPE_STANDARD_DIGITAL;
    self.payTF.sipInputFieldDelegate = self;
    self.payTF.cipherType = SIP_KEYBOARD_CIPHER_TYPE_RSA;
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}
//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    
    if (_payTF.text.length>1) {
        NSInteger outputValueErrorCode = SIP_INPUT_FIELD_OK;
        NSInteger clientErrorCode = SIP_INPUT_FIELD_OK;
        NSMutableString *message = nil;
        NSString *encryptedData = nil;
        NSString *clientEncryptedData = nil;
        
        encryptedData = [self.payTF getEncryptedDataWithError:&outputValueErrorCode];
        clientEncryptedData = [self.payTF getEncryptedClientRandomWithError:&clientErrorCode];
        
        
        if (outputValueErrorCode == SIP_INPUT_FIELD_OK && clientErrorCode == SIP_INPUT_FIELD_OK) {
            message = [NSMutableString stringWithFormat:@"数据加密结果：%@\n客户端随机数加密结果：%@", encryptedData, clientEncryptedData];
        } else {
            if (outputValueErrorCode != SIP_INPUT_FIELD_OK && clientErrorCode != SIP_INPUT_FIELD_OK) {
                message = [NSMutableString stringWithFormat:@"获取加密内容失败，错误码:0x%08X\n获取客户端随机数加密失败，错误码:0x%08X", (int)outputValueErrorCode, (int)clientErrorCode];
            } else if (outputValueErrorCode != SIP_INPUT_FIELD_OK && clientErrorCode == SIP_INPUT_FIELD_OK) {
                message = [NSMutableString stringWithFormat:@"获取加密内容失败，错误码:0x%08X", (int)outputValueErrorCode];
            } else if (outputValueErrorCode == SIP_INPUT_FIELD_OK && clientErrorCode != SIP_INPUT_FIELD_OK) {
                message = [NSMutableString stringWithFormat:@"获取客户端随机数加密失败，错误码:0x%08X", (int)clientErrorCode];
            }
        }
        
        
        NSLog(@"message === %@",message);
        
        _pswEncode = [NSString stringWithFormat:@"%@ %@ 0",clientEncryptedData,encryptedData];
    }
}

- (void)setPhonestr:(NSString *)phonestr
{
    _phonestr = phonestr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self loadDataArr];
    [self loadMyMoneyNum];
    
}
//可提现金额
- (void)loadMyMoneyNum {
    
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} url:@"withdraw_info" successBlock:^(id responseBody) {
        int event = [responseBody[@"event"] intValue];
        if (event == 88) {
     
            double x2 = [responseBody[@"data"][@"money"] doubleValue];
            weakSelf.myMoney.text = [NSString stringWithFormat:@"可用余额：%.2f元", x2];
            _meng_sn = responseBody[@"data"][@"meng_sn"] ;
            _meng_random = responseBody[@"data"][@"meng_random"] ;
            self.payTF.strServerRandom = _meng_random;

            
        } else {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];

        }
    } failureBlock:^(NSString *error) {
        
    }];
}
- (IBAction)getcodeAct:(UIButton *)sender {
    
    
    sender.userInteractionEnabled = NO;
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //  params[@"phone"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"userphone"];
    params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    TSWeakSelf;
    
    [[TSNetwork shareNetwork] postRequestResult:params url:@"sendphonesms_cash" successBlock:^(id responseBody) {
        
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        NSString * msgStr = [NSString stringWithFormat:@"%@",responseBody[@"msg"]];
        [DZStatusHud showToastWithTitle:msgStr complete:nil];
        if ([eventStr isEqualToString:@"88"]) {
            [sender startWithTime:60 title:@"重新获取" countDownTitle:@"s" mainColor:COLOR_MainColor countColor:[UIColor colorWithWhite:0.800 alpha:1.000]];
            NSDictionary * data = responseBody[@"data"];
            _meng_bizFlow = [data objectForKey:@"meng_bizFlow"];
          //  weakSelf.codeToken = token;
        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];

    
}


- (void)loadDataArr {
    // 请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    // self的弱引用
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:params url:@"bank_card_info"  successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {
            weakSelf.dataDic = [responseBody[@"data"] mj_JSONObject];
            NSString *bankNumStr = [NSString stringWithFormat:@"%@", responseBody[@"data"][@"bank_num"]];

            if (bankNumStr.length == 16) {
                 weakSelf.bankName.text = [NSString stringWithFormat:@"银行名称: %@", [self.dataDic objectForKey:@"bank_name_str"]];
                NSString *str = [responseBody[@"data"][@"bank_num"] substringWithRange:NSMakeRange(0, 12)];
                weakSelf.bankcard.text = [responseBody[@"data"][@"bank_num"] stringByReplacingOccurrencesOfString:str withString:@"**** **** **** "];
                NSString *c = [NSString stringWithFormat:@"尾号：%@", [responseBody[@"data"][@"bank_num"]  substringFromIndex:12]];
                weakSelf.bankcard.text = c;
            } else if (bankNumStr.length == 17){
                weakSelf.bankName.text = [NSString stringWithFormat:@"银行名称: %@", [self.dataDic objectForKey:@"bank_name_str"]];
                NSString *str = [responseBody[@"data"][@"bank_num"] substringWithRange:NSMakeRange(0, 15)];
                weakSelf.bankcard.text = [responseBody[@"data"][@"bank_num"] stringByReplacingOccurrencesOfString:str withString:@"**** **** **** "];
                NSString *c = [NSString stringWithFormat:@"尾号：%@", [responseBody[@"data"][@"bank_num"]  substringFromIndex:13]];
                weakSelf.bankcard.text = c;
            } else if (bankNumStr.length == 18){
                weakSelf.bankName.text = [NSString stringWithFormat:@"银行名称: %@", [self.dataDic objectForKey:@"bank_name_str"]];
                NSString *str = [responseBody[@"data"][@"bank_num"] substringWithRange:NSMakeRange(0, 15)];
                weakSelf.bankcard.text = [responseBody[@"data"][@"bank_num"] stringByReplacingOccurrencesOfString:str withString:@"**** **** **** "];
                NSString *c = [NSString stringWithFormat:@"尾号：%@", [responseBody[@"data"][@"bank_num"]  substringFromIndex:14]];
                weakSelf.bankcard.text = c;

            } else if (bankNumStr.length == 19){
                weakSelf.bankName.text = [NSString stringWithFormat:@"银行名称: %@", [self.dataDic objectForKey:@"bank_name_str"]];
                NSString *str = [responseBody[@"data"][@"bank_num"] substringWithRange:NSMakeRange(0, 15)];
                weakSelf.bankcard.text = [responseBody[@"data"][@"bank_num"] stringByReplacingOccurrencesOfString:str withString:@"**** **** **** "];
                NSString *c = [NSString stringWithFormat:@"尾号：%@", [responseBody[@"data"][@"bank_num"]  substringFromIndex:15]];
                weakSelf.bankcard.text = c;
            }  else {
                weakSelf.bankName.text = @"银行名称：";
                weakSelf.bankcard.text = @"尾号：";
            }
        } else {
            weakSelf.bankName.text = @"银行名称：";
            weakSelf.bankcard.text = @"尾号：";
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];

        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)didWithdrawlButton:(id)sender {
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [[TSNetwork shareNetwork] postRequestResult:params url:@"check_pin_pass" successBlock:^(id responseBody) {
        NSString * event = [NSString stringWithFormat:@"%@", responseBody[@"event"]];
        if ([event isEqualToString:@"88"]) {
            
            double money = [[[NSUserDefaults standardUserDefaults] objectForKey:@"balance_money"] doubleValue];
            if (self.money.text.doubleValue<1) {
                [DZStatusHud showToastWithTitle:@"请输入不少于1元的金额" complete:nil];
            } else
                if ([self.money.text doubleValue] <= money ) {

                NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
                double fee = self.money.text.doubleValue;
                [[TSNetwork shareNetwork] postRequestResult:@{@"token":token, @"money":@(fee)} url:@"withdraw_fee" successBlock:^(id responseBody) {

                    if ([responseBody[@"event"] intValue] == 88) {
                        
                        self.message = [NSString stringWithFormat:@"%@", responseBody[@"data"][@"fee"]];
                        
                        _feeLab.text = [NSString stringWithFormat:@"手续费：%.2f", [responseBody[@"data"][@"fee"] doubleValue]];
                        
                        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                        NSString *token = [user objectForKey:@"token"];
                        
                        // 请求参数
                        NSMutableDictionary * params = [NSMutableDictionary dictionary];
                        
                        params[@"token"] = token;
                        params[@"money"] = self.money.text;
                        params[@"fee"] = self.message;
                        params[@"pin_pass"] = _pswEncode;;
                        params[@"verify_code"] = self.codeToken;
                        params[@"code"] = self.codetf.text;
                        params[@"meng_bizFlow"] = _meng_bizFlow;
                        params[@"meng_sn"] = _meng_sn;
                        
                        // self的弱引用
                        TSWeakSelf;
                        [[TSNetwork shareNetwork] postRequestResult:params url:@"withdraw" successBlock:^(id responseBody) {
                            
                            NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
                            
                            if ([eventStr isEqualToString:@"88"]) {
                                [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:^ {
                                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                }];
                            } else {
                                [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
                            }
                            
                        } failureBlock:^(NSString *error) {
                            
                        }];

                    }else
                    {
                        [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];

                    }
                    
                } failureBlock:^(NSString *error) {
                    
                }];
               
            } else {
                [DZStatusHud showToastWithTitle:@"余额不足，请您充值" complete:nil];
            }
            
        } else {
            [DZStatusHud showToastWithTitle:@"您还未设置支付密码" complete:^{
                TSSetPinController * setPinVC = [[TSSetPinController alloc] init];
                [self.navigationController pushViewController:setPinVC animated:YES];
            }];
        }
        
    } failureBlock:^(NSString *error) {
        
    }];

}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.pinpass = _payTF.text;
}

- (IBAction)didBankAction:(id)sender {
    //  该用户已经绑定了银行卡  － 跳转到详情
    BankCardWebVC *MV = [[BankCardWebVC alloc] init];
    [self.navigationController pushViewController:MV animated:YES];
}
- (IBAction)didLookWithdrawButton:(id)sender {
    TSWithdrawListController * withlistVC = [[TSWithdrawListController alloc] init];
    [self.navigationController pushViewController:withlistVC animated:YES];
}

#pragma mark SIPInputFieldDelegate

- (BOOL)onKeyDone:(CFCASIPInputField *)sip
{
    return YES;
}
- (void)onSIPInputFieldTextDidChanged:(CFCASIPInputField *)sipInputField withOperateType:(SIPOperateType)operateType
{
}



@end
