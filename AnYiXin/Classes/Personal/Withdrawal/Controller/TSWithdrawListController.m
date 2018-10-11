//
//  TSWithdrawListController.m
//  TuanShang
//
//  Created by tuanshang on 16/9/3.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSWithdrawListController.h"

#import "TSWithdrawListCell.h"

#import "TSWithdrawModel.h"

@interface TSWithdrawListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, assign) int page;

@end

@implementation TSWithdrawListController

- (NSMutableArray *)dataArr
{
    if(!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提现记录";
    self.page = 1;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];;
    [self.tableView registerNib:[UINib nibWithNibName:@"TSWithdrawListCell" bundle:nil] forCellReuseIdentifier:@"TSWithdrawListCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.rowHeight = 60;
    [self setupRefresh];

}


- (void)setupRefresh {
    // 下拉刷新
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    // 上拉刷新
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    
    self.page = 1;
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"token"];
    
    // 请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = token;
    params[@"page"] = @(self.page);
    params[@"pagesize"] = @(9999);
    
    // self的弱引用
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:params url:@"withdraw_list" successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];

        if ([eventStr isEqualToString:@"88"]) {
            NSArray *arr = [TSWithdrawModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:arr];
            TSLog(@"%@",  self.dataArr);
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            
        } else {
            
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
            [weakSelf.tableView.mj_header endRefreshing];
        }

    } failureBlock:^(NSString *error) {
        
    }];
    
}
- (void)loadMoreData {

    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self.tableView.mj_footer setHidden:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWithMsg:@"暂时没有提现记录" ifNecessaryForRowCount:self.dataArr.count];
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TSWithdrawListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TSWithdrawListCell" forIndexPath:indexPath];
    cell.withdrawModel = self.dataArr[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * label1 = [[UILabel alloc]init];
    label1.text = @"提现时间";
    [label1 setFont:[UIFont systemFontOfSize:14]];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [view addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc]init];
    label2.text = @"提现金额";
    [label2 setFont:[UIFont systemFontOfSize:14]];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [view addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc]init];
    label3.text = @"当前状态";
    [label3 setFont:[UIFont systemFontOfSize:14]];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [view addSubview:label3];
    
    [@[label1, label2, label3] autoAlignViewsToAxis:ALAxisHorizontal];
    NSArray *views = @[label1, label2, label3];
    
    // Match the widths of all the views
    [views autoMatchViewsDimension:ALDimensionWidth];
    [[views firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
    UIView *previousView = nil;
    for (UIView *view in views) {
        if (previousView) {
            [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:previousView ];
            [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        }
        previousView = view;
    }
    [[views lastObject] autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    [view addSubview:line];
    
    [line autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [line autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [line autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [line autoSetDimension:(ALDimensionHeight) toSize:0.5];
    
    return view;
}



@end
