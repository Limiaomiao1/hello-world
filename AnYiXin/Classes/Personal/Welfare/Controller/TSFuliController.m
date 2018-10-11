//
//  TSFuliController.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/6.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSFuliController.h"
#import "TSRedpackeController.h"
#import "TSJiaXiAllController.h"
#import "TSMyGoldListController.h"
#import "RedPacketAllViewController.h"
@interface TSFuliController ()

@end

@implementation TSFuliController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的福利";
    
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
#warning Incomplete implementation, return the number of rows
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"我的加息劵";
    }else if (indexPath.section == 1) {
        cell.textLabel.text = @"我的红包";
    }
    /*
    else if (indexPath.section == 1) {
        cell.textLabel.text = @"我的特权金";
    } else if (indexPath.section == 2) {
        cell.textLabel.text = @"特权金列表";
    } else if (indexPath.section == 3) {
        cell.textLabel.text = @"特权金明细";
    }
     */
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
        TSJiaxiAllController *jiaxiVC = [[TSJiaxiAllController alloc] init];
        [self.navigationController pushViewController:jiaxiVC animated:YES];
    }
    else if (indexPath.section == 1) {
        RedPacketAllViewController *mygoldListVC = [[RedPacketAllViewController alloc] init];
        [self.navigationController pushViewController:mygoldListVC animated:YES];
    }
    /*
    else if (indexPath.section == 1) {
        TSMyGoldListController *mygoldListVC = [[TSMyGoldListController alloc] init];
        [self.navigationController pushViewController:mygoldListVC animated:YES];
    } else if (indexPath.section == 2) {
        TSRedpackeController *teGoldVC = [[TSRedpackeController alloc] init];
        [self.navigationController pushViewController:teGoldVC animated:YES];
    } else if (indexPath.section == 3) {
//        TSTqjSummaryController *tqjSummarVC = [[TSTqjSummaryController  alloc] init];
//        [self.navigationController pushViewController:tqjSummarVC animated:YES];
        
    }
      */
}


@end
