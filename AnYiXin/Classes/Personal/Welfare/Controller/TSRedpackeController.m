//
//  TSRedpackeController.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSRedpackeController.h"
#import "TSTeGoldCell.h"   
#import "TSTeGoldModel.h"
#import "UIView+TYAlertView.h"

@interface TSRedpackeController ()

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation TSRedpackeController

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

- (void) setupSubviews {
    self.navigationItem.title = @"特权金列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSTeGoldCell" bundle:nil] forCellReuseIdentifier:@"TSTeGoldCell"];
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

}

- (void)loadDataInfo {
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"page"] = @1;
    param[@"pagesize"] = @9999;
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:param url:@"summary" successBlock:^(id responseBody) {
        [weakSelf.datasource removeAllObjects];
        if ([responseBody[@"event"] intValue] == 88) {
            weakSelf.datasource =  [TSTeGoldModel mj_objectArrayWithKeyValuesArray:responseBody[@"msg"]];
        } else {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failureBlock:^(NSString *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [DZStatusHud showToastWithTitle:error complete:nil];
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
    [tableView tableViewDisplayWithMsg:@"暂无特权金" ifNecessaryForRowCount:self.datasource.count];
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSTeGoldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSTeGoldCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TSTeGoldModel *model = [[TSTeGoldModel alloc] init];
    model = self.datasource[indexPath.row];
    cell.tegoldModel = self.datasource[indexPath.row];
    cell.didgetgoldAction = ^ {
      
        NSString * str = [NSString stringWithFormat:@"特权金额：%@  收益次数：%@\n您确定要领取吗", model.money, model.biggest];
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"消息提示" message:str];
        
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {
        }]];
        
        [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
            
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            param[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            param[@"tid"] = model.ID;
            TSWeakSelf;
            [[TSNetwork shareNetwork] postRequestResult:param url:@"sunmmary_get" successBlock:^(id responseBody) {
                if ([responseBody[@"event"] intValue] == 88) {
                    [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:^ {
                        if (weakSelf.tableView.mj_header.state == MJRefreshStateRefreshing) {
                        } else {
                            [weakSelf setupRefresh];
                        }
                    }];

                } else {
                    [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:^ {
                        if (weakSelf.tableView.mj_header.state == MJRefreshStateRefreshing) {
                        } else {
                            [weakSelf setupRefresh];
                        }
                    }];
                }
            } failureBlock:^(NSString *error) {
                [DZStatusHud showToastWithTitle:error complete:nil];
            }];

                        
        }]];
        
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
        alertController.alertViewOriginY = -60;
        [self presentViewController:alertController animated:YES completion:nil];

    };
    
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
