//
//  TSModeyLogController.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSModeyLogController.h"
#import "TSMoneyLogLowCell.h"
#import "TSMoneyLogModel.h"
#import "TSMoneyLogDetailController.h"

@interface TSModeyLogController ()
/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation TSModeyLogController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    [self setupRefresh];
}

//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化

- (void)setupSubViews {
    self.navigationItem.title = @"资金记录";
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsMake(0,10, 0, 10);        // 设置端距，这里表示separator离左边和右边均80像素
    [self.tableView registerNib:[UINib nibWithNibName:@"TSMoneyLogLowCell" bundle:nil] forCellReuseIdentifier:@"TSMoneyLogLowCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

//=================================================================
//                         Http Request
//=================================================================
#pragma mark - Http Request

- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoneyLog)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoneyLog)];
}

- (void)loadMoneyLog{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    dic[@"page"] = @"1";
    dic[@"pagesize"] = @"9999";
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:dic url:@"money_log" successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@", responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {
            weakSelf.dataArr = [TSMoneyLogModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
        } else {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWithMsg:@"暂无数据" ifNecessaryForRowCount:self.dataArr.count];
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSMoneyLogLowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSMoneyLogLowCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.moneylogModel = self.dataArr[indexPath.row];
    return cell;
}

//=================================================================
//                       UITableViewDelegate
//=================================================================
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    TSMoneyLogDetailController * logVC = [[TSMoneyLogDetailController alloc] init];
    logVC.logModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:logVC animated:YES];
    
}


@end
