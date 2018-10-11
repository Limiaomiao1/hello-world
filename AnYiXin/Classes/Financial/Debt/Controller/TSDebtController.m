//
//  TSDebtController.m
//  Shangdai
//
//  Created by tuanshang on 17/2/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSDebtController.h"
#import "TSSortButton.h"
#import "TSDebtCell.h"
#import "TSChooseController.h"
#import "TSDebtModel.h"
#import "TSNavigationController.h"
#import "TSLoginController.h"
#import "TSDebtDetailController.h"

@interface TSDebtController ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger k;
}

/** tableview */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (strong, nonatomic) NSMutableArray * arr;
/** 页数 */
@property (nonatomic, assign) int page;
/** 排序 */
@property (nonatomic, assign) int rank;
@end

@implementation TSDebtController

- (NSMutableArray *)arr
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
    k = 30000;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
    } else {
        [self setupRefresh];
    }}

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
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"默认",@"利率",@"期限",@"筛选",nil];
    for (int i = 0; i < 4; i++) {
        TSSortButton *btnTitle = [TSSortButton buttonWithType:UIButtonTypeCustom];
        btnTitle.frame = CGRectMake(i*TSScreenW/4, 0, TSScreenW/4, 30);
        btnTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnTitle setTitle:arrayTitle[i] forState:UIControlStateNormal];
        btnTitle.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnTitle setTitleColor:[UIColor colorWithHue:0.00 saturation:0.00 brightness:0.73 alpha:1.00] forState:UIControlStateNormal];
        btnTitle.tag = 30000+i;
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
        if (i == 3) {
            [btnTitle setImage:[UIImage imageNamed:@"icon_choose"] forState:UIControlStateNormal];
        }
        
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
    self.tableView.rowHeight = 130;
    self.tableView.separatorInset = UIEdgeInsetsMake(0,10, 0, 10);        // 设置端距，这里表示separator离左边和右边均80像素
    [self.tableView registerNib:[UINib nibWithNibName:@"TSDebtCell" bundle:nil] forCellReuseIdentifier:@"TSDebtCell"];
    [self.tableView reloadData];
}

//=================================================================
//                         Http Request
//=================================================================
#pragma mark - Http Request

- (void)setupRefresh {
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataArray];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
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
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:params url:TSAPI_DEBT_LIST successBlock:^(id responseBody) {
        [hud hide:YES];
        [weakSelf.arr removeAllObjects];
        int event = [responseBody[@"event"] intValue];
        if (event == 88) {
            weakSelf.arr = [TSDebtModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
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
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        [hud hide:YES];
    }];
}

- (void)loadMoreTopics {
    self.page +=1;
    //  请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.page);
    params[@"pagesize"] = @(7);
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:params url:TSAPI_DEBT_LIST successBlock:^(id responseBody) {
        int event = [responseBody[@"event"] intValue];
        if (event == 88) {
            NSArray *arr = [TSDebtModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
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
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:@"网络出现问题" complete:nil];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
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
    [tableView tableViewDisplayWithMsg:@"暂无数据" ifNecessaryForRowCount:self.arr.count];
    return self.arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSDebtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSDebtCell" forIndexPath:indexPath];
    cell.debtModel = self.arr[indexPath.row];
    return cell;
}

//=================================================================
//                           事件处理
//=================================================================
#pragma mark - 事件处理

- (void)titileBtnClick:(UIButton *)button {
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:k];
    [btn setTitleColor:[UIColor colorWithHue:0.00 saturation:0.00 brightness:0.73 alpha:1.00] forState:UIControlStateNormal];
    UIButton *btn2 = [self.view viewWithTag:30002];
    UIButton *btn1 = [self.view viewWithTag:30001];
    
    switch (button.tag) {
        case 30000:
        {
            [button setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
            k =    button.tag;
            [btn2 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn2.selected = NO;
            [btn1 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn1.selected = NO;
            self.rank = 0;
            if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            } else {
                [self setupRefresh];
            }
            TSLog(@"默认");
        }
            break;
        case 30001:
        {
            [btn2 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn2.selected = NO;
            if (button.selected) {
                button.selected = !button.selected;
                self.rank = 1;
                if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                } else {
                    [self setupRefresh];
                }                TSLog(@"升序");
            }else{
                button.selected = !button.selected;
                self.rank = 2;
                if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                } else {
                    [self setupRefresh];
                }                TSLog(@"降序");
            }
            [button setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_sort_top"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"icon_sort_down"] forState:UIControlStateSelected];
            k =    button.tag;
        }
            break;
        case 30002:
        {
            [btn1 setImage:[UIImage imageNamed:@"icon_sort_default"] forState:UIControlStateNormal];
            btn1.selected = NO;
            if (button.selected) {
                button.selected = !button.selected;
                self.rank = 3;
                if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                } else {
                    [self setupRefresh];
                }                TSLog(@"升序");
            }else{
                self.rank = 4;
                if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
                } else {
                    [self setupRefresh];
                }                button.selected = !button.selected;
                TSLog(@"降序");
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
            [self.navigationController pushViewController:chooseVC animated:YES];
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"islogin"] == YES) {
        TSDebtDetailController *detailVC = [[TSDebtDetailController alloc]init];
        TSDebtModel * debtModel = [[TSDebtModel alloc] init];
        debtModel = self.arr[indexPath.row];
        detailVC.ID = debtModel.debt_id.intValue;
        detailVC.debbbbbModel = debtModel;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        TSLoginController *loginVC = [[TSLoginController alloc]init];
        TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:naVC animated:YES completion:nil];
    }
}


@end
