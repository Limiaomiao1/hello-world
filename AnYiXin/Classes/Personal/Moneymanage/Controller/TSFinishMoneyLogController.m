//
//  TSFinishMoneyLogController.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSFinishMoneyLogController.h"
#import "TSInverstorLowCell.h"
#import "TSInvertotModel.h"
#import "TSInverstorController.h"

@interface TSFinishMoneyLogController ()<UITableViewDelegate, UITableViewDataSource>
/** 我是傻逼 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *datasouce;

@end

@implementation TSFinishMoneyLogController



- (NSMutableArray *)datasouce
{
    if(!_datasouce) {
        _datasouce = [[NSMutableArray alloc] init];
    }
    return _datasouce;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setupRefresh];
}

//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化

- (void)setUpTableView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenH-64-50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = COLOR_MainColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0,10, 0, 10);        // 设置端距，这里表示separator离左边和右边均80像素
    [self.tableView reloadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSInverstorLowCell" bundle:nil] forCellReuseIdentifier:@"TSInverstorLowCell"];
}

//=================================================================
//                         Http Request
//=================================================================
#pragma mark - Http Request

- (void)setupRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataArray)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    // 上拉刷新
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataArray)];
}

- (void)loadDataArray {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    dic[@"type"] = @2;
    dic[@"page"] = @1;
    dic[@"pagesize"] = @9999;
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:dic url:@"userinvestor" successBlock:^(id responseBody) {
        [weakSelf.datasouce removeAllObjects];
        if ([responseBody[@"event"] intValue] == 88) {
            weakSelf.datasouce = [TSInvertotModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
        } else {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        [weakSelf.tableView reloadData];
    } failureBlock:^(NSString *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//=================================================================
//                       UITableViewDataSource
//=================================================================
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWithMsg:@"暂无数据" ifNecessaryForRowCount:self.datasouce.count];
    return self.datasouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSInverstorLowCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TSInverstorLowCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.inversmodel = self.datasouce[indexPath.row];
    return cell;
}

//=================================================================
//                       UITableViewDelegate
//=================================================================
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TSInverstorController *inverVC = [[TSInverstorController alloc] init];
    inverVC.inverModel = self.datasouce[indexPath.row];
    [self.navigationController pushViewController:inverVC animated:YES];
}

@end
