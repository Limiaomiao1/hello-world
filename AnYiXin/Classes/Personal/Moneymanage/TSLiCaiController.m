//
//  TSLiCaiController.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/6.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSLiCaiController.h"
#import "TSModeyLogController.h"
#import "TSTouziController.h"
#import "TSRealNameController.h"
#import "TSUtouziController.h"

@interface TSLiCaiController ()

@end

@implementation TSLiCaiController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的理财";

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"资金记录";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"投资记录";
    } else if (indexPath.section == 2) {
        cell.textLabel.text = @"优选理财投资记录";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        TSModeyLogController * moneyLogVC = [[TSModeyLogController alloc] init];
        [self.navigationController pushViewController:moneyLogVC animated:YES];
    } else if (indexPath.section == 1) {
        TSTouziController * touziVC = [[TSTouziController alloc] init];
        [self.navigationController pushViewController:touziVC animated:YES];
    } else if (indexPath.section == 2) {
        TSUtouziController * utouziVC = [[TSUtouziController alloc] init];
        [self.navigationController pushViewController:utouziVC animated:YES];
    }
}

@end
