//
//  TSAcitvitController.m
//  ZhuoJin
//
//  Created by tuanshang on 16/11/30.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSAcitvitController.h"
#import "TSAcitvitModel.h"
#import "TSExpandCell.h"
#import "TSAcitiviDetailController.h"

@interface TSAcitvitController ()
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * arr;

@end

@implementation TSAcitvitController

#pragma mark - 懒加载

- (NSMutableArray *)arr
{
    if(!_arr) {
        _arr = [[NSMutableArray alloc] init];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    [self setupRefresh];

}

- (void)setupSubViews {
    
    self.navigationItem.title = @"活动中心";
    self.tableView.rowHeight = 120;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSExpandCell" bundle:nil] forCellReuseIdentifier:@"TSExpandCell"];
}

- (void)setupRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataInfo)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadDataInfo {
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:nil url:@"events" successBlock:^(id responseBody) {
        [weakSelf.tableView.mj_header endRefreshing];
        NSString * event = [NSString stringWithFormat:@"%@", responseBody[@"event"]];
        if ([event isEqualToString:@"88"]) {
            _arr = [TSAcitvitModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
        } else {
            _arr = nil;
        }
        [weakSelf.tableView reloadData];
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:^ {
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWithMsg:@"暂无数据" ifNecessaryForRowCount:self.arr.count];
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSExpandCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.acitvitModel = self.arr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, TSScreenW*0.3, 39)];
    title.font = [UIFont systemFontOfSize:15.0];
    title.text = @"活动列表";
    title.textColor = COLOR_MainColor;
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    UIView *longline = [[UIView alloc]initWithFrame:CGRectMake(5, 39, TSScreenW-10, 1)];
    longline.backgroundColor =  COLOR_SeparaterColor;
    [view addSubview:longline];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 39, TSScreenW*0.3, 1)];
    line.backgroundColor = COLOR_MainColor;
    [view addSubview:line];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TSAcitiviDetailController * activitDetailVC = [[TSAcitiviDetailController alloc] init];
    TSAcitvitModel * activit = self.arr[indexPath.row];
    activitDetailVC.title = activit.event_title;
    activitDetailVC.ID = activit.ID;
    [self.navigationController pushViewController:activitDetailVC animated:YES];
}


@end
