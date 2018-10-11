//
//  TSBindBankOneController.m
//  AnYiXin
//
//  Created by Mac on 17/7/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSBindBankOneController.h"
#import "ChooseBankController.h"
#import "TSGetprovinceController.h"
#import "TSBingBankCell.h"
#import "TSGetcityController.h"
#import "UIButton+CountDown.h"
#import "TSBindBankController.h"

@interface TSBindBankOneController ()<bankNameDelegate, cityNameDelegate, TSBingBankCellDelegate>

@property (nonatomic , copy) NSString * bankName;
@property (nonatomic , copy) NSString * holderName1;

@property (nonatomic , copy) NSString * bank;
@property (nonatomic , copy) NSString * cityName;
@property (nonatomic , copy) NSString * account1;
@property (nonatomic , copy) NSString * phone;
@property (nonatomic , copy) NSString * province;
@property (nonatomic , copy) NSString * city;
@property (nonatomic , copy) NSString * bank_branch;
@property (nonatomic , copy) NSString * code;
@property (nonatomic , copy) NSString * codeToken;
@property (nonatomic, strong) NSMutableDictionary *infoDict;


@end

@implementation TSBindBankOneController


- (NSMutableDictionary *)infoDict {
    if (_infoDict == nil) {
        _infoDict = [NSMutableDictionary dictionary];
    }
    return _infoDict;
}
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.title = @"绑定银行卡";
    self.navigationController.navigationBar.hidden = NO;

}
- (void)getBankData
{
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} url:@"realbank" successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {
            NSDictionary *data = [responseBody objectForKey:@"data"];
            self.holderName1 = [NSString stringWithFormat:@"%@",data[@"real_name"]];
        } else {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
        [weakSelf.tableView reloadData];
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ids"] isEqualToString:@"0"]) {
        
    }
    [self setupSubViews];
    [self getBankData];

}
- (void)setTitles:(NSString *)titles
{
    _titles = titles;
}
- (void)setupSubViews {
    self.tableView.rowHeight = 44;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenH - 64) style:UITableViewStyleGrouped];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSBingBankCell" bundle:nil] forCellReuseIdentifier:@"TSBingBankCell"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSBingBankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSBingBankCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        self.account1 = cell.detailTF.text;
    } else if (indexPath.row == 3) {
        cell.titleLabel.text = @"手机号:";
        cell.detailTF.placeholder = @"请输入手机号";
        cell.delegate = self;
        self.phone = cell.detailTF.text;
    } else if (indexPath.row == 4) {
        cell.titleLabel.text = @"所在地:";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTF.text = self.cityName;
        [cell.detailTF  setEnabled:NO];
    } else if (indexPath.row == 5) {
        cell.delegate = self;
        cell.titleLabel.text = @"支行名称:";
        cell.detailTF.placeholder = @"请输入开户行";
        self.bank_branch = cell.detailTF.text;
    
    } else if (indexPath.row == 6) {
        cell.delegate =self;
        cell.titleLabel.text = @"验证码:";
        cell.detailTF.placeholder = @"请输入验证码";
        self.code = cell.detailTF.text;
    }
    
    return cell;
}
#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, 80)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, TSScreenW-40, 80)];
    label.text = @"请尽量填写较大的银行(如农行、工行、建行、中国银行等), 避免填写那些比较少见的银行（如农村信用社，平安银行，恒丰银行等）。否则提现的资金很容易会被退票。";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithWhite:0.702 alpha:1.000];
    label.numberOfLines = 0;
    [view addSubview:label];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, 80)];
    
    UIButton *codeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
   // [codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:10];
    codeButton.layer.cornerRadius = 5;
  //  codeButton.backgroundColor = COLOR_MainColor;
    [view addSubview:codeButton];
    
    [codeButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [codeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [codeButton autoSetDimension:ALDimensionWidth toSize:70];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"提交更新" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.backgroundColor = COLOR_MainColor;
    [view addSubview:button];
    
    [button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:codeButton withOffset:15];
    [button autoSetDimension:ALDimensionHeight toSize:40];
    [button autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [button autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    
  //  [codeButton addTarget:self action:@selector(didCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [button addTarget:self  action:@selector(didCommitButton) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

#pragma  mark - 按钮点击
//获取验证码
/*
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
 */
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
        TSWeakSelf;
        
        [[TSNetwork shareNetwork] postRequestResult:params url:@"bindbank" successBlock:^(id responseBody) {
            NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
            if ([eventStr isEqualToString:@"88"]) {
                TSBindBankController *vc = [[TSBindBankController alloc]init];
                vc.navigationItem.title = @"绑定银行卡";
                NSString * realid = [NSString stringWithFormat:@"%@",responseBody[@"data"]];
                vc.realid =realid;
                [self.navigationController pushViewController:vc animated:YES];
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
    if (indexPath.row == 0) {
        ChooseBankController * chooseVC = [[ChooseBankController alloc]init];
        chooseVC.delegate = self;
        [self.navigationController pushViewController:chooseVC animated:YES];
    } else if (indexPath.row == 4) {
        TSGetprovinceController * provinVC = [[TSGetprovinceController alloc] init];
        [self.navigationController pushViewController:provinVC animated:YES];
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *key = @(indexPath.row).stringValue;
    self.infoDict[key] = text;
    self.account1  = self.infoDict[@"2"];
    self.phone = self.infoDict[@"3"];
    self.bank_branch = self.infoDict[@"5"];

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
