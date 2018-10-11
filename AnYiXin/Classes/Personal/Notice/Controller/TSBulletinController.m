//
//  TSBulletinController.m
//  ZhuoJin
//
//  Created by tuanshang on 17/2/15.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSBulletinController.h"
#import "TSBulletinModel.h"
#import "TSBulletinCell.h"
#import "TSWebDetailController.h"
@interface TSBulletinController ()
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * arr;
@end

@implementation TSBulletinController

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
//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化
- (void) setupSubViews {
    self.navigationItem.title = @"我的公告";
    self.tableView.rowHeight = 80;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSBulletinCell" bundle:nil] forCellReuseIdentifier:@"TSBulletinCell"];
    
}

//=================================================================
//                         Http Request
//=================================================================
#pragma mark - Http Request

- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataInfo)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadDataInfo {
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:nil url:TSAPI_GONGGAOS successBlock:^(id responseBody) {
        [weakSelf.tableView.mj_header endRefreshing];
        NSString * event = [NSString stringWithFormat:@"%@", responseBody[@"event"]];
        if ([event isEqualToString:@"88"]) {
            _arr = [TSBulletinModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
        } else {
            _arr = nil;
        }
        [weakSelf.tableView reloadData];
    } failureBlock:^(NSString *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [DZStatusHud showToastWithTitle:error complete:nil];
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
    TSBulletinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSBulletinCell" forIndexPath:indexPath];
    cell.bulletinModel = self.arr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    title.text = @"公告列表";
    title.textColor = COLOR_MainColor;
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    UIView *longline = [[UIView alloc]initWithFrame:CGRectMake(5, 39, TSScreenW-10, 1)];
    longline.backgroundColor = COLOR_SeparaterColor;
    [view addSubview:longline];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 39, TSScreenW*0.3, 1)];
    line.backgroundColor = COLOR_MainColor;
    [view addSubview:line];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TSWebDetailController * webVC = [[TSWebDetailController alloc] init];
    TSBulletinModel * activit = self.arr[indexPath.row];
    webVC.ID = activit.ID;
    webVC.navigationItem.title = activit.title;
    [self.navigationController pushViewController:webVC animated:YES];
}


@end
