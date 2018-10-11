//
//  ChooseBankController.m
//  CheZhongChou
//
//  Created by fjw on 16/5/4.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import "ChooseBankController.h"
#import "TSBankInfo.h"

@interface ChooseBankController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableDictionary * dic;

@end

@implementation ChooseBankController

#pragma mark - 懒加载

- (NSArray *)data {
    if (_data == nil) {
        _data = [NSArray array];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择银行";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc] init];
    self.tableview.rowHeight = 45;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self loadDataArr];
}

- (void)loadDataArr {
    //bank_list
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} url:@"bank_list" successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {
            weakSelf.data = [TSBankInfo mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
        } else {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
        [weakSelf.tableview reloadData];
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

        return cell;
    }
    
    TSBankInfo * bank = [[TSBankInfo alloc]init];
    bank = self.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = bank.bank_name;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.delegate respondsToSelector:@selector(getBankName:withBank:)]) {
        TSBankInfo * bank = [[TSBankInfo alloc]init];
        bank = self.data[indexPath.row];
        [self.delegate getBankName:bank.bank_name withBank:bank.bank];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
