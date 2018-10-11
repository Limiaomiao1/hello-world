//
//  TSSanBiaoController.m
//  Shangdai
//
//  Created by tuanshang on 17/2/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSSanBiaoController.h"
#import "TSSortButton.h"
#import "TSBorrowCell.h"
#import "TSChooseController.h"
#import "TSBorrowModel.h"
#import "TSNavigationController.h"
#import "TSLoginController.h"
#import "TSBorDetailAllController.h"
#import "ProgressHUD.h"

@interface TSSanBiaoController ()<UITableViewDelegate, UITableViewDataSource,TSChooseControllerDelegate> {
    NSInteger k;
}

/** tableview */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (strong, nonatomic) NSMutableArray * arr;
/** 页数 */
@property (nonatomic, assign) int page;
/** 期限 */
@property (nonatomic, copy) NSString *deadline;
/** 利率 */
@property (nonatomic, copy) NSString *interest_rate;
/** 最小投资金额 */
@property (nonatomic, copy) NSString *small_money;

@end

@implementation TSSanBiaoController

- (NSMutableArray *) arr
{
    if(!_arr) {
        _arr = [[NSMutableArray alloc] init];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self setUpTableView];
    k = 10000;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
    } else {
        
        [self setupRefresh];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
   // NSArray *arrayTitle = [NSArray arrayWithObjects:@"默认",@"利率",@"期限",@"筛选",nil];
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"默认",@"利率",@"期限",nil];

    for (int i = 0; i < 3; i++) {
        TSSortButton *btnTitle = [TSSortButton buttonWithType:UIButtonTypeCustom];
        btnTitle.frame = CGRectMake(i*TSScreenW/3, 0, TSScreenW/3, 30);
        btnTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnTitle setTitle:arrayTitle[i] forState:UIControlStateNormal];
        btnTitle.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnTitle setTitleColor:[UIColor colorWithHue:0.00 saturation:0.00 brightness:0.73 alpha:1.00] forState:UIControlStateNormal];
        btnTitle.tag = 10000+i;
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
       // if (i == 3) {
         //   [btnTitle setImage:[UIImage imageNamed:@"icon_choose"] forState:UIControlStateNormal];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"TSBorrowCell" bundle:nil] forCellReuseIdentifier:@"TSBorrowCell"];
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
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

- (void)loadMoreTopics {
    self.page +=1;
    [self.tableView.mj_footer endRefreshing];
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
    [[TSNetwork shareNetwork] postRequestResult:params url:TSAPI_BORROW_LIST successBlock:^(id responseBody) {
        int event = [responseBody[@"event"] intValue];
        if (event == 88) {
            NSArray *arr = [TSBorrowModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
            if (arr.count < 7) {
                [weakSelf.arr addObjectsFromArray:arr];
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                NSString * pagecount = responseBody[@"maxPage"];
                if (weakSelf.page > pagecount.intValue) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.arr addObjectsFromArray:arr];
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

- (void)loadDataArray {
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    
    self.page = 1;
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
    [[TSNetwork shareNetwork] postRequestResult:params url:TSAPI_BORROW_LIST successBlock:^(id responseBody) {
        [hud hide:YES];
        int event = [responseBody[@"event"] intValue];
        if (event == 88) {
            [weakSelf.arr removeAllObjects];
            weakSelf.arr = [TSBorrowModel mj_objectArrayWithKeyValuesArray: responseBody[@"data"]];
            if (weakSelf.arr.count < 7) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        } else {
            weakSelf.arr = nil;
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failureBlock:^(NSString *error) {
        [hud hide:YES];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }];
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
    TSBorrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSBorrowCell" forIndexPath:indexPath];
    cell.borrowModel = self.arr[indexPath.row];
    cell.didButtonblock = ^ {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"islogin"] == YES) {
            TSBorDetailAllController *detailVC = [[TSBorDetailAllController alloc]init];
            TSBorrowModel * borrowModel = [[TSBorrowModel alloc] init];
            borrowModel = self.arr[indexPath.row];
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
    UIButton *btn2 = [self.view viewWithTag:10002];
    UIButton *btn1 = [self.view viewWithTag:10001];
    
    switch (button.tag) {
        case 10000:
        {
            [button setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
            k =    button.tag;
            [btn2 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn2.selected = NO;
            [btn1 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn1.selected = NO;
            self.rank = 10;
            TSLog(@"默认");
            if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            } else {
                [self setupRefresh];
            }
        }
            break;
        case 10001:
        {
            [btn2 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn2.selected = NO;
            if (button.selected) {
                button.selected = !button.selected;
                TSLog(@"升序");
                self.rank = 1;
                if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                } else {
                    [self setupRefresh];
                }
            }else{
                button.selected = !button.selected;
                self.rank = 2;
                TSLog(@"降序");
                if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                } else {
                    [self setupRefresh];
                }
            }
            [button setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_sort_top"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_sort_down"] forState:UIControlStateSelected];
            k =    button.tag;
        }
            break;
        case 10002:
        {
            [btn1 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn1.selected = NO;
            if (button.selected) {
                button.selected = !button.selected;
                TSLog(@"升序");
                self.rank = 3;
                if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                } else {
                    [self setupRefresh];
                }
            }else{
                button.selected = !button.selected;
                TSLog(@"降序");
                self.rank = 4;
                if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                } else {
                    [self setupRefresh];
                }
            }
            [button setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_sort_top"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_sort_down"] forState:UIControlStateSelected];
            k =    button.tag;
        }
            break;
        default:{
            [button setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
            k =    button.tag;
            [btn2 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn2.selected = NO;
            [btn1 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn1.selected = NO;
            TSChooseController *chooseVC = [[TSChooseController alloc] init];
            chooseVC.delegate = self;
            chooseVC.type = 1;
            [self.navigationController pushViewController:chooseVC animated:YES];
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"islogin"] == YES) {
        TSBorDetailAllController *detailVC = [[TSBorDetailAllController alloc]init];
        TSBorrowModel * borrowModel = [[TSBorrowModel alloc] init];
        borrowModel = self.arr[indexPath.row];
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
