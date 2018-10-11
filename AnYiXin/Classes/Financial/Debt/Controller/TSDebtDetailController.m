//
//  TSDebtDetailController.m
//  TuanShang
//
//  Created by tuanshang on 16/9/13.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSDebtDetailController.h"
#import "TSDebtDetailModel.h"
#import "TSDebtDetailCell.h"
#import "TSDetbDetailCell.h"
#import "TSDebtUserCell.h"
#import "NSString+Extensions.h"

@interface TSDebtDetailController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *tableFooterButton;
@property (nonatomic, strong) TSDebtDetailModel * debtModel;
@property (nonatomic, copy) NSString * pinpass;

@end

@implementation TSDebtDetailController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubview];
    [self loadInfoData];
}


- (void)setupSubview {
    self.navigationItem.title = @"债权详情";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenH - 64) style:UITableViewStyleGrouped];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSDetbDetailCell" bundle:nil] forCellReuseIdentifier:@"TSDetbDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSDebtUserCell" bundle:nil] forCellReuseIdentifier:@"TSDebtUserCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSDebtDetailCell" bundle:nil] forCellReuseIdentifier:@"TSDebtDetailCell"];
}

- (void)loadInfoData {
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:@{@"debt_id":@(self.ID)} url:@"debt_detail" successBlock:^(id responseBody) {
        
        int event = [responseBody[@"event"] intValue];
        if (event == 88) {
            TSDebtDetailModel * model = [TSDebtDetailModel mj_objectWithKeyValues:responseBody[@"data"]];
            weakSelf.debtModel = model;
            [weakSelf.tableView reloadData];

        }else
        {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
    } failureBlock:^(NSString *error) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        TSDebtDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TSDebtDetailCell"];
        cell.debtDetailModel = self.debtModel;
        cell.debtModel = self.debbbbbModel;
        return cell;
        
    }  else if (indexPath.section == 1){
    
        TSDetbDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSDetbDetailCell" forIndexPath:indexPath];
        cell.debtDetailModel = self.debtModel;
        return cell;
        
    } else {
        TSDebtUserCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TSDebtUserCell" forIndexPath:indexPath];
        cell.debtDetailModel = self.debtModel;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 250;
    } else if (indexPath.section == 1){
        return 350;
    } else {
        return 310;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, 50)];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = view.frame;
        button.backgroundColor = COLOR_MainColor;
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [button setTitle:@"立即投资" forState:UIControlStateNormal];
        [view addSubview:button];
        if ([self.debtModel.status isEqualToString:@"4"]) {
            [button setTitle:@"债权已完成" forState:(UIControlStateNormal)];
            button.enabled = NO;
        } else {
            [button setTitle:@"立即投资" forState:(UIControlStateNormal)];
            button.enabled = YES;
        }
        [button addTarget:self action:@selector(didPayAciton:) forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    } return nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.pinpass = textField.text;
}

- (void)didPayAciton:(UIButton *)button {
    UIAlertController * con = [UIAlertController alertControllerWithTitle:@"输入支付密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [con addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.placeholder=@"请输入支付密码";
        textField.secureTextEntry = YES;
    }];
    [con addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [con dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.pinpass.length<6) {
            [DZStatusHud showToastWithTitle:@"请输入不少于6位的支付密码" complete:nil];
        } else {
            NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
            params[@"invest_id"] = self.debtModel.invest_id;
            params[@"pin"] = self.pinpass;
            params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
            [[TSNetwork shareNetwork] postRequestResult:params url:@"debt_invest_money" successBlock:^(id responseBody) {
                [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
                NSString * event = [NSString stringWithFormat:@"%@", responseBody[@"event"]];
                if ([event isEqualToString:@"88"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failureBlock:^(NSString *error) {
                [DZStatusHud showToastWithTitle:error complete:nil];
            }];
        }
    }];
    [con addAction:sureAction];
    [self presentViewController:con animated:YES completion:nil];
    
}

@end
