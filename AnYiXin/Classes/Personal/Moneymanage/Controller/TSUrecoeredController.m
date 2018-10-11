//
//  TSUrecoeredController.m
//  Shangdai
//
//  Created by tuanshang on 17/4/24.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSUrecoeredController.h"
#import "TSUtendModel.h"
#import "TSUtendCell.h"

@interface TSUrecoeredController ()<UITableViewDelegate, UITableViewDataSource>
/** TableView */
@property (nonatomic, strong) UITableView *tableView;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *datasouce;

@end

@implementation TSUrecoeredController


- (NSMutableArray *)datasouce
{
    if(!_datasouce) {
        _datasouce = [[NSMutableArray alloc] init];
    }
    return _datasouce;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpTableView];
    [self setupRefresh];
    
}

- (void)setUpTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenH-64-50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 218;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0,10, 0, 10);        // 设置端距，这里表示separator离左边和右边均80像素
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSUtendCell" bundle:nil] forCellReuseIdentifier:@"TSUtendCell"];
}


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

    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:dic url:@"tenddone" successBlock:^(id responseBody) {
        [weakSelf.datasouce removeAllObjects];
        if ([responseBody[@"event"] intValue] == 88) {
            weakSelf.datasouce = [TSUtendModel mj_objectArrayWithKeyValuesArray:responseBody[@"msg"]];
        } else {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        [weakSelf.tableView reloadData];
    } failureBlock:^(NSString *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        [DZStatusHud showToastWithTitle:error complete:nil];
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
    TSUtendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TSUtendCell" forIndexPath:indexPath];
    cell.utendModel = self.datasouce[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//=================================================================
//                       UITableViewDelegate
//=================================================================
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
@end
