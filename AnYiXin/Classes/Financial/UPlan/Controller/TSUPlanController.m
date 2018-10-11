//
//  TSUPlanController.m
//  Shangdai
//
//  Created by tuanshang on 17/2/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSUPlanController.h"
#import "TSSortButton.h"
#import "TSYouFinanceCell.h"
#import "TSTransferModel.h"
#import "TSChooseController.h"
#import "TSNavigationController.h"
#import "TSLoginController.h"
#import "TSUPlanDetailController.h"

@interface TSUPlanController ()<UITableViewDelegate, UITableViewDataSource, TSChooseControllerDelegate>{
    NSInteger k;
}

/** tableview */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (strong, nonatomic) NSMutableArray * dataArr;
/** 页数 */
@property (nonatomic, assign) int page;
/** 排序 */
@property (nonatomic, assign) int rank;
/** 期限 */
@property (nonatomic, copy) NSString *deadline;
/** 利率 */
@property (nonatomic, copy) NSString *interest_rate;
/** 最小投资金额 */
@property (nonatomic, copy) NSString *small_money;

@end

@implementation TSUPlanController

#pragma mark - 懒加载
- (NSMutableArray *)dataArr
{
    if(!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    [self setUpTableView];
    k = 20000;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
    } else {
        [self setupRefresh];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化

- (void)createUI
{
    UIView *viewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TSScreenW, 30)];
    viewContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewContainer];
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TSScreenW, 0.5)];
    topView.backgroundColor = [UIColor colorWithHue:0.00 saturation:0.00 brightness:0.73 alpha:1.00];
    [self.view addSubview:topView];
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"默认",@"利率",@"期限",nil];
 //   NSArray *arrayTitle = [NSArray arrayWithObjects:@"默认",@"利率",@"期限",@"筛选",nil];

    for (int i = 0; i < 3; i++) {
        TSSortButton *btnTitle = [TSSortButton buttonWithType:UIButtonTypeCustom];
        btnTitle.frame = CGRectMake(i*TSScreenW/3, 0, TSScreenW/3, 30);
        btnTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnTitle setTitle:arrayTitle[i] forState:UIControlStateNormal];
        btnTitle.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnTitle setTitleColor:[UIColor colorWithHue:0.00 saturation:0.00 brightness:0.73 alpha:1.00] forState:UIControlStateNormal];
        btnTitle.tag = 20000+i;
        [btnTitle addTarget:self action:@selector(titileBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [viewContainer addSubview:btnTitle];
        if (i != 0) {
            UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(i*TSScreenW/4, 114+5, 1, 30)];
            viewLine.backgroundColor = COLOR_SeparaterColor;
            [self.view addSubview:viewLine];
        }
        if (i == 0) {
            [btnTitle setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
        }
        if (i == 1) {
            [btnTitle setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
        }
        if (i == 2) {
            [btnTitle setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
        }
     //   if (i == 3) {
       //     [btnTitle setImage:[UIImage imageNamed:@"icon_choose"] forState:UIControlStateNormal];
        //}
        
    }
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0+29.5, TSScreenW, 0.5)];
    bottomView.backgroundColor = [UIColor colorWithHue:0.00 saturation:0.00 brightness:0.73 alpha:1.00];
    [self.view addSubview:bottomView];
}

- (void)setUpTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,30, TSScreenW, TSScreenH-64-44-80) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = COLOR_SeparaterColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.rowHeight = 150;
    self.tableView.separatorInset = UIEdgeInsetsMake(0,10, 0, 10);        // 设置端距，这里表示separator离左边和右边均80像素
    [self.tableView registerNib:[UINib nibWithNibName:@"TSYouFinanceCell" bundle:nil] forCellReuseIdentifier:@"UFinanceCell"];
    [self.tableView reloadData];
}

//=================================================================
//                         Http Request
//=================================================================
#pragma mark - Http Request

- (void)setupRefresh {
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataArray)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

- (void)loadMoreTopics {
    self.page +=1;
    
    //  请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    params[@"pagesize"] = @(7);
    if (self.rank == 0) {
        params[@"deadline"] = self.deadline;
        params[@"interest_rate"] = self.interest_rate;
        params[@"small_money"] = self.small_money;
    } else {
        params[@"rank"] = @(self.rank);
    }
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:params url:@"transfer_list" successBlock:^(id responseBody) {
        
        int event = [responseBody[@"event"] intValue];
        if (event == 88) {
            NSArray *arr = [TSTransferModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
            if (arr.count < 7) {
                [weakSelf.dataArr addObjectsFromArray:arr];
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                
                NSString * pagecount = responseBody[@"maxPage"];
                if (weakSelf.page > pagecount.intValue) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.dataArr addObjectsFromArray:arr];
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
            }
            
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadDataArray {
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    self.page = 1;
    //  请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    params[@"pagesize"] = @(7);
    if (self.rank == 0) {
        params[@"deadline"] = self.deadline;
        params[@"interest_rate"] = self.interest_rate;
        params[@"small_money"] = self.small_money;
    } else {
        params[@"rank"] = @(self.rank);
    }
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:params url:@"transfer_list" successBlock:^(id responseBody) {
        [hud hide:YES];
        [self.dataArr removeAllObjects];
        int event = [responseBody[@"event"] intValue];
        if (event == 88) {
            weakSelf.dataArr = [TSTransferModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
            if (weakSelf.dataArr.count < 7) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        } else {
            weakSelf.dataArr = nil;
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSString *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        [hud hide:YES];

    }];
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
    TSYouFinanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UFinanceCell" forIndexPath:indexPath];
    cell.transferModel = self.dataArr[indexPath.row];
    cell.didTouziButtonAciton = ^ {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"islogin"] == YES) {
            TSUPlanDetailController *detailVC = [[TSUPlanDetailController alloc]init];
            TSTransferModel * borrowModel = [[TSTransferModel alloc] init];
            borrowModel = self.dataArr[indexPath.row];
            detailVC.ID = borrowModel.ID.intValue;
            [self.navigationController pushViewController:detailVC animated:YES];
        } else {
            TSLoginController *loginVC = [[TSLoginController alloc]init];
            TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
            [self presentViewController:naVC animated:YES completion:nil];
        }
    };
    return cell;
}

//=================================================================
//                           事件处理
//=================================================================
#pragma mark - 事件处理

- (void)titileBtnClick:(UIButton *)button {
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:k];
    [btn setTitleColor:[UIColor colorWithHue:0.00 saturation:0.00 brightness:0.73 alpha:1.00] forState:UIControlStateNormal];
    UIButton *btn2 = [self.view viewWithTag:20002];
    UIButton *btn1 = [self.view viewWithTag:20001];
    
    switch (button.tag) {
        case 20000:
        {
            [button setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
            k =    button.tag;
            [btn2 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn2.selected = NO;
            [btn1 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn1.selected = NO;
            self.rank = 10;
            if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            } else {
                [self setupRefresh];
            }
            TSLog(@"默认");
        }
            break;
        case 20001:
        {
            [btn2 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn2.selected = NO;
            if (button.selected) {
                button.selected = !button.selected;
                self.rank = 1;
                if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                } else {
                    [self setupRefresh];
                }
                TSLog(@"升序");
            }else{
                button.selected = !button.selected;
                self.rank = 2;
                if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                } else {
                    [self setupRefresh];
                }
                TSLog(@"降序");
            }
            [button setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_sort_top"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_sort_down"] forState:UIControlStateSelected];
            k =    button.tag;
        }
            break;
        case 20002:
        {
            [btn1 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn1.selected = NO;
            if (button.selected) {
                button.selected = !button.selected;
                self.rank = 3;
                if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                } else {
                    [self setupRefresh];
                }
                TSLog(@"升序");
            }else{
                button.selected = !button.selected;
                self.rank = 4;
                if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                } else {
                    [self setupRefresh];
                }
                TSLog(@"降序");
            }
            [button setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_sort_top"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_sort_down"] forState:UIControlStateSelected];
            k =    button.tag;
        }
            break;
        default:{
            
            self.rank = 0;

            [button setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
            k =    button.tag;
            [btn2 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn2.selected = NO;
            [btn1 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn1.selected = NO;
            TSChooseController *chooseVC = [[TSChooseController alloc] init];
            chooseVC.delegate = self;
            chooseVC.type = 0;
            [self.navigationController pushViewController:chooseVC animated:YES];
        }
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"islogin"] == YES) {
        TSUPlanDetailController *detailVC = [[TSUPlanDetailController alloc]init];
        TSTransferModel * borrowModel = [[TSTransferModel alloc] init];
        borrowModel = self.dataArr[indexPath.row];
        detailVC.ID = borrowModel.ID.intValue;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        TSLoginController *loginVC = [[TSLoginController alloc]init];
        TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:naVC animated:YES completion:nil];
    }
}

- (void)getChooseResultDelegateWith:(NSString *)name with:(NSString *)name2 with:(NSString *)name3 {
 
    self.rank = 0;
    
    if ([name isEqualToString:@"3%"]) {
        self.interest_rate = @"3";
    } else if([name isEqualToString:@"4%"]) {
        self.interest_rate = @"4";
    } else if([name isEqualToString:@"5%"]) {
        self.interest_rate = @"5";
    } else if([name isEqualToString:@"6%"]) {
        self.interest_rate = @"6";
    } else if([name isEqualToString:@"7%"]) {
        self.interest_rate = @"7";
    } else if([name isEqualToString:@"8%"]) {
        self.interest_rate = @"8";
    } else if([name isEqualToString:@"9%"]) {
        self.interest_rate = @"9";
    } else if([name isEqualToString:@"10%"]) {
        self.interest_rate = @"10";
    } else if([name isEqualToString:@"11%"]) {
        self.interest_rate = @"11";
    } else if([name isEqualToString:@"12%"]) {
        self.interest_rate = @"12";
    } else if([name isEqualToString:@"12%以上"]) {
        self.interest_rate = @"max";
    }
    
    if ([name2 isEqualToString:@"天标"]) {
        self.deadline = @"t";
    } else if([name2 isEqualToString:@"1个月"]) {
        self.deadline = @"1";
    } else if([name2 isEqualToString:@"2个月"]) {
        self.deadline = @"2";
    } else if([name2 isEqualToString:@"3个月"]) {
        self.deadline = @"3";
    } else if([name2 isEqualToString:@"4个月"]) {
        self.deadline = @"4";
    } else if([name2 isEqualToString:@"5个月"]) {
        self.deadline = @"5";
    } else if([name2 isEqualToString:@"6个月"]) {
        self.deadline = @"6";
    } else if([name2 isEqualToString:@"7个月"]) {
        self.deadline = @"7";
    } else if([name2 isEqualToString:@"8个月"]) {
        self.deadline = @"8";
    } else if([name2 isEqualToString:@"9个月"]) {
        self.deadline = @"9";
    } else if([name2 isEqualToString:@"10个月"]) {
        self.deadline = @"10";
    } else if([name2 isEqualToString:@"11个月"]) {
        self.deadline = @"11";
    } else if([name2 isEqualToString:@"12个月"]) {
        self.deadline = @"12";
    }
    if ([name3 isEqualToString:@"100以上"]) {
        self.small_money = @"max";
    } else {
        self.small_money = name3;
    }
}


@end
