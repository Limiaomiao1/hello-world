//
//  TSMoneyLogDetailController.m
//  Shangdai
//
//  Created by tuanshang on 17/4/12.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSMoneyLogDetailController.h"
#import "TSMoneyLogCell.h"

@interface TSMoneyLogDetailController ()

@end

@implementation TSMoneyLogDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}


//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化

- (void)setupSubViews {
    self.navigationItem.title = @"记录详情";
    self.tableView.rowHeight = TSScreenH-100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TSMoneyLogCell" bundle:nil] forCellReuseIdentifier:@"moneylogcell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSMoneyLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moneylogcell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.moneylogModel = self.logModel;
    return cell;
}

@end
