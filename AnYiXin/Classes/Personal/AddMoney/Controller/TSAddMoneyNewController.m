//
//  TSAddMoneyNewController.m
//  AnYiXin
//
//  Created by Mac on 17/10/16.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSAddMoneyNewController.h"
#import "NSString+Extensions.h"
#import "UIButton+CountDown.h"
#import "ErrorCode.h"

@interface TSAddMoneyNewController ()<CFCASIPInputFieldDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;

@property (weak, nonatomic) IBOutlet CFCASIPInputField *payPswTf;

@property (weak, nonatomic) IBOutlet UIView *btnview;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (nonatomic,strong)NSString *realid;
@property (nonatomic,strong)NSString *phoneStr;
/** 验证码 */
@property (nonatomic, copy) NSString *codeToken;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (nonatomic ,strong)NSString *meng_sn;
@property (nonatomic ,strong)NSString *pswEncode;//加密后的密码

@property (nonatomic,strong)NSString *meng_bizFlow;
@end

@implementation TSAddMoneyNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"账户充值";
    
    
    self.payPswTf.emSipKeyboardType = SIP_KEYBOARD_TYPE_STANDARD_DIGITAL;
    self.payPswTf.sipInputFieldDelegate = self;
    self.payPswTf.cipherType = SIP_KEYBOARD_CIPHER_TYPE_RSA;
    
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    

    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    
    // 请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = token;
    
    [[TSNetwork shareNetwork] postRequestResult:params url:@"cgrecharge" successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {
            self.amount.text = [NSString stringWithFormat:@"%@",[responseBody objectForKey:@"data"][@"account_money"]];
            _phoneStr = [NSString stringWithFormat:@"%@",[responseBody objectForKey:@"data"][@"cg_bank_info"][@"bank_mobile"]];
            
            //孟  demo新增接口参数
           // NSString *meng_key = [NSString stringWithFormat:@"%@",[responseBody objectForKey:@"data"][@"meng_key"]];
            
            _meng_sn = [NSString stringWithFormat:@"%@",[responseBody objectForKey:@"data"][@"meng_sn"]];

            self.payPswTf.strServerRandom =  [NSString stringWithFormat:@"%@",[responseBody objectForKey:@"data"][@"meng_random"]];
            
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

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{

    if (_payPswTf.text.length>1) {
        NSInteger outputValueErrorCode = SIP_INPUT_FIELD_OK;
        NSInteger clientErrorCode = SIP_INPUT_FIELD_OK;
        NSMutableString *message = nil;
        NSString *encryptedData = nil;
        NSString *clientEncryptedData = nil;
        
        encryptedData = [self.payPswTf getEncryptedDataWithError:&outputValueErrorCode];
        clientEncryptedData = [self.payPswTf getEncryptedClientRandomWithError:&clientErrorCode];
        
        
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


- (IBAction)sure:(id)sender {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    params[@"t_money"]=self.moneyTF.text;
    params[@"phone_code"]=_codeTF.text;
    params[@"verify_code"] = self.codeToken;

    //孟  充值接口 cgpay    password_pin 需要加密
    
    params[@"password_pin"] = _pswEncode;
    params[@"meng_sn"]=_meng_sn;
    params[@"meng_bizFlow"] = _meng_bizFlow;
    [[TSNetwork shareNetwork] postRequestResult:params url:@"cgpay" successBlock:^(id responseBody) {
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
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //NSDictionary *param = @{@"phone":_phoneStr,@"find":@"1"};
    params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];

    [[TSNetwork shareNetwork] postRequestResult:params url:@"sendphonesms_cgpay" successBlock:^(id responseBody) {
        if ([responseBody[@"event"] isEqual:@88]) {
            [button startWithTime:60 title:@"重新获取" countDownTitle:@"s" mainColor:COLOR_MainColor countColor:[UIColor colorWithWhite:0.800 alpha:1.000]];
            NSDictionary * data = responseBody[@"data"];
         //   self.codeToken = token;
            _meng_bizFlow = [data objectForKey:@"meng_bizFlow"];
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

#pragma mark SIPInputFieldDelegate

- (BOOL)onKeyDone:(CFCASIPInputField *)sip
{
    return YES;
}
- (void)onSIPInputFieldTextDidChanged:(CFCASIPInputField *)sipInputField withOperateType:(SIPOperateType)operateType
{
}


#pragma mark UITextFielDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
