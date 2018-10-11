//
//  BankCardNewViewController.m
//  AnYiXin
//
//  Created by Mac on 17/10/16.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "BankCardNewViewController.h"
#import "ChooseBankController.h"
#import "TSGetprovinceController.h"
#import "TSBingBankCell.h"
#import "TSGetcityController.h"
#import "UIButton+CountDown.h"
#import "TSBindBankController.h"
@interface BankCardNewViewController ()<bankNameDelegate, cityNameDelegate, TSBingBankCellDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic , copy) NSString * bankName;
@property (nonatomic , copy) NSString * holderName1;

@property (nonatomic , copy) NSString * trueStr;

@property (nonatomic , copy) NSString * bank;
@property (nonatomic , copy) NSString * cityName;
@property (nonatomic , copy) NSString * account1;
@property (nonatomic , copy) NSString * phone;
@property (nonatomic , copy) NSString * province;
@property (nonatomic , copy) NSString * city;
@property (nonatomic , copy) NSString * bank_branch;
@property (nonatomic , copy) NSString * code;
@property (nonatomic , copy) NSString * editcode;

@property (nonatomic , copy) NSString * codeToken;
@property (nonatomic, strong) NSMutableDictionary *infoDict;
@property (nonatomic,strong) UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic , copy) NSString * modify_type;
@property (nonatomic , copy) NSString * passednums;
@property (nonatomic , copy) NSString * applynums;



@end

@implementation BankCardNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定银行卡";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ids"] isEqualToString:@"0"]) {
        
    }
    [self setupSubViews];
    [self getBankData];

    // Do any additional setup after loading the view from its nib.
}
- (NSMutableDictionary *)infoDict {
    if (_infoDict == nil) {
        _infoDict = [NSMutableDictionary dictionary];
    }
    return _infoDict;
}
- (void)getBankData
{
    //cgbank
    
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} url:@"realbank" successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {
            NSDictionary *data = [responseBody objectForKey:@"data"];
            _dataDic = data;
            self.trueStr = [NSString stringWithFormat:@"%@",data[@"true"]];
            if ([self.trueStr isEqualToString:@"0"]) {
                self.navigationItem.title = @"绑定银行卡";

            }else if ([self.trueStr isEqualToString:@"1"]) {
                self.navigationItem.title = @"解绑银行卡";

                weakSelf.account1 = [NSString stringWithFormat:@"%@",data[@"real_name_info"][@"account"]];
                weakSelf.bankName = [NSString stringWithFormat:@"%@",data[@"real_name_info"][@"bank_name"]];
                weakSelf.cityName = [NSString stringWithFormat:@"%@",data[@"real_name_info"][@"pcity"]];

                weakSelf.phone = [NSString stringWithFormat:@"%@",data[@"real_name_info"][@"bank_mobile"]];
                weakSelf.bank_branch = [NSString stringWithFormat:@"%@",data[@"real_name_info"][@"bank_address"]];
                _modify_type = [NSString stringWithFormat:@"%@",_dataDic[@"modify_type"]];
                if ([_modify_type isEqualToString:@"1"]) {
                    _passednums = [NSString stringWithFormat:@"%@",_dataDic[@"passednums"]];
                    _applynums = [NSString stringWithFormat:@"%@",_dataDic[@"applynums"]];
                }
                /*
                 weakSelf.account1 = [NSString stringWithFormat:@"%@",data[@"cg_bank_info"][@"account"]];
                 weakSelf.bankName = [NSString stringWithFormat:@"%@",data[@"cg_bank_info"][@"bank_name"]];
                 weakSelf.cityName = [NSString stringWithFormat:@"%@",data[@"cg_bank_info"][@"pcity"]];
                 
                 weakSelf.phone = [NSString stringWithFormat:@"%@",data[@"cg_bank_info"][@"bank_mobile"]];
                 weakSelf.bank_branch = [NSString stringWithFormat:@"%@",data[@"cg_bank_info"][@"bank_address"]];
                 */
                
            }
            weakSelf.holderName1 = [NSString stringWithFormat:@"%@",data[@"real_name"]];

        } else {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
        [weakSelf.tableview reloadData];
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
    
}
- (void)setTitles:(NSString *)titles
{
    _titles = titles;
}
- (void)setupSubViews {

    [self.tableview registerNib:[UINib nibWithNibName:@"TSBingBankCell" bundle:nil] forCellReuseIdentifier:@"TSBingBankCell"];
}


#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"绑定银行卡";
    self.navigationController.navigationBar.hidden = NO;
    [self.tableview reloadData];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSBingBankCell *cell = [[NSBundle mainBundle]loadNibNamed:@"TSBingBankCell" owner:self options:nil].lastObject;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TSBingBankCell" forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([_applynums intValue]==0||[_applynums intValue]==1) {
        cell.detailTF.userInteractionEnabled = NO;
    }
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.titleLabel.text = @"银行名称:";
        cell.detailTF.text = self.bankName;
        [cell.detailTF  setEnabled:NO];
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = @"户主名称:";
        cell.detailTF.text = self.holderName1;
        //cell.detailTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"real_name"];
        [cell.detailTF setEnabled:NO];
    } else if (indexPath.row == 2) {
        cell.titleLabel.text = @"银行卡账号:";
        cell.detailTF.placeholder = @"输入绑定的银行卡号，暂不支持信用卡";
        cell.delegate = self;
        cell.detailTF.text = self.account1;
    } else if (indexPath.row == 3) {
        cell.titleLabel.text = @"手机号:";
        cell.detailTF.placeholder = @"请输入手机号";
        cell.delegate = self;
        cell.detailTF.text = self.phone;
    } else if (indexPath.row == 4) {
        cell.titleLabel.text = @"所在地:";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTF.text = self.cityName;
        [cell.detailTF  setEnabled:NO];
    } else if (indexPath.row == 5) {
        cell.delegate = self;
        cell.titleLabel.text = @"支行名称:";
        cell.detailTF.placeholder = @"请输入开户行";
        cell.detailTF.text = self.bank_branch;
        
    } else if (indexPath.row == 6) {
        cell.delegate =self;
        cell.titleLabel.text = @"验证码:";
        cell.detailTF.placeholder = @"请输入验证码";
        self.code = cell.detailTF.text;
    } else if (indexPath.row == 7) {
        cell.delegate =self;
        
        if ([_modify_type isEqualToString:@"1"]) {
            cell.titleLabel.text = @"修改码:";
            cell.detailTF.placeholder = @"请输入修改码";
            self.editcode = cell.detailTF.text;
        }else
        {
            cell.titleLabel.hidden = YES;
            cell.detailTF.hidden = YES;
        }

    }
    

    
    return cell;
}
#pragma mark - TableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, 80)];
    
    UIButton *codeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
     [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:10];
    codeButton.layer.cornerRadius = 5;
    codeButton.backgroundColor = COLOR_MainColor;
    [view addSubview:codeButton];
    [codeButton addTarget:self action:@selector(didCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [codeButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [codeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [codeButton autoSetDimension:ALDimensionWidth toSize:70];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"绑定" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    _commitBtn = button;

    button.backgroundColor = COLOR_MainColor;
    [view addSubview:button];
    if ([self.trueStr isEqualToString:@"1"]) {
        
        [_commitBtn setTitle:@"解绑" forState:UIControlStateNormal];
        
        if ([_modify_type isEqualToString:@"1"]) {
            if ([_passednums intValue]>0) {
                [_commitBtn setTitle:@"解绑" forState:UIControlStateNormal];
                [button addTarget:self  action:@selector(didCommitButton) forControlEvents:UIControlEventTouchUpInside];

            }else if ([_applynums intValue]==0) {
                [_commitBtn setTitle:@"申请修改" forState:UIControlStateNormal];
                [button addTarget:self  action:@selector(didEditSubmit) forControlEvents:UIControlEventTouchUpInside];
                codeButton.userInteractionEnabled = NO;
                codeButton.backgroundColor = COLOR_Text_GrayColor;
            }else if ([_applynums intValue]==1) {
                [_commitBtn setTitle:@"已申请，请等待审核" forState:UIControlStateNormal];
                _commitBtn.backgroundColor = COLOR_Text_GrayColor;
                codeButton.userInteractionEnabled = NO;
                codeButton.backgroundColor = COLOR_Text_GrayColor;
            }
        }else
        {
            [button addTarget:self  action:@selector(didCommitButton) forControlEvents:UIControlEventTouchUpInside];
        }
    }else
    {
        [button setTitle:@"绑定" forState:UIControlStateNormal];
        [button addTarget:self  action:@selector(didCommitButton) forControlEvents:UIControlEventTouchUpInside];

    }
    [button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:codeButton withOffset:15];
    [button autoSetDimension:ALDimensionHeight toSize:40];
    [button autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [button autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    
    
    return view;
}

#pragma  mark - 按钮点击
//获取验证码

- (void)didCodeButton:(UIButton *)button {
 
     NSMutableDictionary * params = [NSMutableDictionary dictionary];
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
         [DZStatusHud showToastWithTitle:error complete:nil];
     }];
 }
//申请修改
- (void)didEditSubmit
{
    [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} url:@"apply" successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {

            [self.navigationController popViewControllerAnimated:YES];
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        } else {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
    

}

//提交
- (void)didCommitButton {
    
    [self.view endEditing:YES];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    if (self.account1.length<16) {
        [DZStatusHud showToastWithTitle:@"请输入不少于16位卡号" complete:nil];
    }
    else {
        // 请求参数
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"token"] = token;
        params[@"account"] = self.account1;
        params[@"bank_mobile"] = self.phone;
        params[@"bankaddress"] = self.bank_branch;
        params[@"bank_id"] = self.bank;
        params[@"province"] = self.province;
        params[@"cityName"] = self.city;
        params[@"verify_code"] = self.codeToken;
        params[@"phone_code"] = self.code;
        
        if ([self.trueStr isEqualToString:@"0"]) {
            params[@"real_true"] = @"0";//绑定
        }else
        {
            params[@"real_true"] = @"1";//解绑
        }
        [[TSNetwork shareNetwork] postRequestResult:params url:@"cgbank_form" successBlock:^(id responseBody) {
            NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
            if ([eventStr isEqualToString:@"88"]) {
                
                if ([self.trueStr isEqualToString:@"0"]) {

                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                }else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }

                [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
                
            } else {
                [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
            }
            
        } failureBlock:^(NSString *error) {
            [DZStatusHud showToastWithTitle:error complete:nil];
        }];

    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_applynums intValue]==0||[_applynums intValue]==1) {
        
    }else {
        if (indexPath.row == 0) {
            ChooseBankController * chooseVC = [[ChooseBankController alloc]init];
            chooseVC.delegate = self;
            [self.navigationController pushViewController:chooseVC animated:YES];
        } else if (indexPath.row == 4) {
            TSGetprovinceController * provinVC = [[TSGetprovinceController alloc] init];
            [self.navigationController pushViewController:provinVC animated:YES];
        }
    }
}

# pragma mark - 实现代理

- (void)getBankName:(NSString *)bankName withBank:(NSString *)bank {
    self.bankName = bankName;
    self.bank = bank;
    
}

- (void)getCityName:(NSString *)city withCity:(NSString *)provin withProvinID:(NSString *)provinID withCityID:(NSString *)cityID{
    self.cityName = [NSString stringWithFormat:@"%@-%@", provin, city];
    self.city = cityID;
    self.province = provinID;
}

- (void)textViewCell:(TSBingBankCell *)cell didChangeText:(NSString *)text {
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    NSString *key = @(indexPath.row).stringValue;
    self.infoDict[key] = text;
    self.account1  = self.infoDict[@"2"];
    self.phone = self.infoDict[@"3"];
    self.bank_branch = self.infoDict[@"5"];
    self.code = self.infoDict[@"6"];
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
