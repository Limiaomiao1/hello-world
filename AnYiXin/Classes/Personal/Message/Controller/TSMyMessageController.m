//
//  TSMyMessageController.m
//  TuanShang
//
//  Created by TuanShang on 16/7/13.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSMyMessageController.h"
#import "TSMessageCell.h"
#import "TSMessageModel.h"

@interface TSMyMessageController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)NSMutableArray * arr;

@end

@implementation TSMyMessageController


- (NSMutableArray *)arr
{
    if(!_arr) {
        _arr = [[NSMutableArray alloc] init];
    }
    return _arr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"站内信";
    self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc] init];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor =  [UIColor colorWithWhite:0.95 alpha:1];

    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[TSMessageCell class] forCellReuseIdentifier:@"TSMessageCell"];
    [self setupRefresh];
}

- (void)setupRefresh {
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataInfo)];
    self.tableview.mj_header.automaticallyChangeAlpha = YES;
    [self.tableview.mj_header beginRefreshing];
    // 上拉刷新
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataInfo)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)loadDataInfo {

    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"page":@"1", @"pagesize":@"9999"} url:TSAPI_INNER_MSG_LIST successBlock:^(id responseBody) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
        if ([responseBody[@"event"] intValue] == 88) {
            weakSelf.arr = [TSMessageModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
        }else {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
        [weakSelf.tableview reloadData];
    } failureBlock:^(NSString *error) {
         [DZStatusHud showToastWithTitle:error complete:^{
             [weakSelf.tableview.mj_header endRefreshing];
             [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
         }];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView tableViewDisplayWithMsg:@"暂无站内信" ifNecessaryForRowCount:self.arr.count];
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TSMessageCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.messageModel = self.arr[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
       return [TSMessageCell heightForTextCellWithNewsDic:self.arr[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TSMessageModel * model =  self.arr[indexPath.row];
    [DZStatusHud showAlertWithTitle:model.title message:model.msg viewController:self complete:^{
        [[TSNetwork shareNetwork] postRequestResult:@{@"id": model.ID, @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} url:@"inner_msg_status" successBlock:^(id responseBody) {
            if ([[responseBody[@"event"] stringValue] isEqualToString:@"88"]) {
                [self setupRefresh];
                [self.tableview reloadData];
            } else if([responseBody[@"event"] intValue] == 0){
                [DZStatusHud showToastWithTitle:@"该信息已读取" complete:nil];
            } else {
                [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
            }
        } failureBlock:^(NSString *error) {
            [DZStatusHud showToastWithTitle:error complete:nil];
        }];
    }];
    
}


@end
