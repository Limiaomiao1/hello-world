//
//  TSOpenAccountVController.m
//  AnYiXin
//
//  Created by Mac on 17/10/16.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSOpenAccountVController.h"
#import "TSBingBankCell.h"
#import "UIButton+CountDown.h"
#import "BankCardNewViewController.h"
@interface TSOpenAccountVController ()<UITableViewDelegate,UITableViewDataSource,TSBingBankCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic , copy) NSString * code;
@property (nonatomic , copy) NSString * codeToken;
@property (nonatomic, strong) NSMutableDictionary *infoDict;

@property (nonatomic , copy) NSString * password;
@property (nonatomic , copy) NSString * email;

@end

@implementation TSOpenAccountVController
- (NSMutableDictionary *)infoDict {
    if (_infoDict == nil) {
        _infoDict = [NSMutableDictionary dictionary];
    }
    return _infoDict;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

    [self.tableview reloadData];
}
- (void)setRealid:(NSString *)realid
{
    _realid = realid;
}
- (void)setName:(NSString *)name
{
    _name = name;
}
- (void)setPhone:(NSString *)phone
{
    _phone = phone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"会员开户";
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    TSBingBankCell *cell = [[NSBundle mainBundle]loadNibNamed:@"TSBingBankCell" owner:self options:nil].lastObject;
    cell.delegate = self;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TSBingBankCell" forIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"会员姓名:";
        cell.detailTF.text = self.name;
        [cell.detailTF  setEnabled:NO];
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = @"开户密码:";
        cell.detailTF.placeholder = @"输入开户密码";
        cell.detailTF.secureTextEntry = YES;
        self.password = cell.detailTF.text;
    } else if (indexPath.row == 2) {
        cell.titleLabel.text = @"邮箱地址:";
        cell.detailTF.placeholder = @"输入邮箱地址";
        self.email = cell.detailTF.text;
    }
    else if (indexPath.row == 3) {
        cell.delegate =self;
        cell.titleLabel.text = @"验证码:";
        cell.detailTF.placeholder = @"请输入验证码";
        self.code = cell.detailTF.text;
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
    
    [codeButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [codeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [codeButton autoSetDimension:ALDimensionWidth toSize:70];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"开户" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.backgroundColor = COLOR_MainColor;
    [view addSubview:button];
    
    [button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:codeButton withOffset:15];
    [button autoSetDimension:ALDimensionHeight toSize:40];
    [button autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [button autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    
    [codeButton addTarget:self action:@selector(didCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [button addTarget:self  action:@selector(didCommitButtons) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

#pragma  mark - 按钮点击

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
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }else
        {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
}

- (void)didCommitButtons {
    
    [self.view endEditing:YES];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    
    // 请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = token;
    params[@"paypwd"] = self.password;
    params[@"email_sb"] = self.email;
    params[@"phone_code"] = self.code;
    params[@"verify_code"] = self.codeToken;

   
    TSWeakSelf;
    
    [[TSNetwork shareNetwork] postRequestResult:params url:@"account_form" successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {
            BankCardNewViewController *vc = [[BankCardNewViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
        }
        [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

# pragma mark - 实现代理

- (void)textViewCell:(TSBingBankCell *)cell didChangeText:(NSString *)text {
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    NSString *key = @(indexPath.row).stringValue;
    self.infoDict[key] = text;
    self.password = self.infoDict[@"1"];
    self.email = self.infoDict[@"2"];
    self.code = self.infoDict[@"3"];

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
