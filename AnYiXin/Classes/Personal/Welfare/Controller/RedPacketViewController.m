//
//  RedPacketViewController.m
//  AnYiXin
//
//  Created by Mac on 17/8/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "RedPacketViewController.h"
#import "RedPacketTableViewCell.h"

@interface RedPacketViewController ()
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datasource;

@property (nonatomic, assign) int page;

@end

@implementation RedPacketViewController

- (TSTopicTypes)type {
    return 2;
}

- (NSMutableArray *)datasource
{
    if(!_datasource) {
        _datasource = [[NSMutableArray alloc] init];
    }
    return _datasource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self setupRefresh];
}
//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化

- (void)setupSubviews {
    
    self.navigationItem.title = @"我的红包";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"RedPacketTableViewCell" bundle:nil] forCellReuseIdentifier:@"redpackcell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 150;
    self.tableView.tableFooterView = [[UIView alloc]init];
}

//=================================================================
//                         Http Request
//=================================================================
#pragma mark - Http Request

- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataInfo)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}
- (void)loadDataInfo {
    self.page = 1;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    param[@"status"] = @(self.type);
    param[@"page"] = @1;
    param[@"pagesize"] = @7;
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:param url:@"redpacket_log" successBlock:^(id responseBody) {
        int event = [responseBody[@"event"] intValue];
        if (event == 0) {
            [weakSelf.datasource removeAllObjects];
            weakSelf.datasource = [RedPacketModel mj_objectArrayWithKeyValuesArray: responseBody[@"data"]];
            if (weakSelf.datasource.count < 7) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            [weakSelf.datasource removeAllObjects];
            weakSelf.datasource = nil;
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failureBlock:^(NSString *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
}

- (void)loadMoreTopics {
    self.page +=1;
    [self.tableView.mj_footer endRefreshing];
    //  请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    params[@"pagesize"] = @(7);
    params[@"status"] = @(self.type);
    params[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:params url:@"redpacket_log" successBlock:^(id responseBody) {
        int event = [responseBody[@"event"] intValue];
        if (event == 0) {
            NSArray *arr = [RedPacketModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
            if (arr.count < 7) {
                [weakSelf.datasource addObjectsFromArray:arr];
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                NSString * pagecount = responseBody[@"maxPage"];
                if (weakSelf.page > pagecount.intValue) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.datasource addObjectsFromArray:arr];
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
            }
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failureBlock:^(NSString *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        [DZStatusHud showToastWithTitle:@"网络出现问题" complete:nil];
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
    [tableView tableViewDisplayWithMsg:@"暂无红包" ifNecessaryForRowCount:self.datasource.count];
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RedPacketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"redpackcell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.redpackModel = self.datasource[indexPath.row];
    return cell;
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
