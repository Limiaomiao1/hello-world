//
//  TSHomeController.m
//  Shangdai
//
//  Created by tuanshang on 17/1/14.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSHomeController.h"
#import "TSLoginController.h"
#import "TSNavigationController.h"
#import "TSMyMessageController.h"
#import "UIBarButtonItem+Extension.h"
#import "TSHomeHeaderView.h"
#import "TSHomeViewCell.h"
#import "TSRecommendModel.h"
#import "TSLiCaiController.h"
#import "TSFuliController.h"
#import "TSCertificationController.h"
#import "TSWithdrawalController.h"
#import "TSBorDetailAllController.h"
#import "TSRealNameController.h"
#import "AddBankController.h"
#import "NoticeViewController.h"

@interface TSHomeController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 推荐项目 */
@property (nonatomic, strong) TSRecommendModel *recommendModel;


@end

@implementation TSHomeController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNav];
    [self setupTableView];
    [self setupRefresh];
    [self loadMainData];
}

//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化

- (void)setupNav {
    self.navigationItem.title = @"金钱袋";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(noticeButtonClick) image:@"nav_right" highImage:@"nav_right"];
}

- (void)setupTableView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, TSScreenW, TSScreenH - 64 - 49) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    CGFloat height1 = TSScreenW/4*0.8;
    self.tableView.rowHeight = TSScreenH - 160 - 64 - 49 - height1;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSHomeViewCell" bundle:nil] forCellReuseIdentifier:@"TSHomeViewCell"];
}

//=================================================================
//                         Http Request
//=================================================================
#pragma mark - Http Request

- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadWithInfoData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadMainData {
    [[TSNetwork shareNetwork] postRequestResult:nil url:TSAPI_MAIN_TENANACE successBlock:^(id responseBody) {
        if ([responseBody[@"event"] intValue] == 1) {
            NSString *msgstr = responseBody[@"msg"];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msgstr preferredStyle:UIAlertControllerStyleAlert];
           [self presentViewController:alert animated:YES completion:nil];


        } else if ([responseBody[@"event"] intValue] == 0){

        }

    } failureBlock:^(NSString *error) {
        
    }];
}
- (void)loadWithInfoData {
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:nil url:TSAPI_RECOMMEND_LIST successBlock:^(id responseBody) {
        [weakSelf.tableView.mj_header endRefreshing];
        if ([responseBody[@"event"] intValue] == 88) {
     
            if([self isNull:responseBody[@"data"][@"list"]] == NO) {
                
            } else {
                NSArray * arr = responseBody[@"data"][@"list"];
                weakSelf.recommendModel = [TSRecommendModel mj_objectWithKeyValues:arr[0]];
            }
        } else {
            weakSelf.recommendModel = nil;
        }
        [weakSelf.tableView reloadData];
    } failureBlock:^(NSString *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
}
//=================================================================
//                           事件处理
//=================================================================
#pragma mark - 事件处理
- (void)noticeButtonClick {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){
        TSMyMessageController *messageVC = [[TSMyMessageController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
    }else {
        TSLoginController *loginVC = [[TSLoginController alloc]init];
        TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:naVC animated:YES completion:nil];
    }
}

//=================================================================
//                       UITableViewDataSource
//=================================================================
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSHomeViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TSHomeViewCell" forIndexPath:indexPath];
    cell.recommendModel = self.recommendModel;
//购买
    cell.didGoBuyButton = ^ {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"islogin"] == YES) {
            if (self.recommendModel != nil) {
                TSBorDetailAllController * detailVC = [[TSBorDetailAllController alloc] init];
                detailVC.ID = self.recommendModel.ID.intValue;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        } else {
            TSLoginController *loginVC = [[TSLoginController alloc]init];
            TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
            [self presentViewController:naVC animated:YES completion:nil];
        }
    };
    return cell;
}

//=================================================================
//                       UITableViewDelegate
//=================================================================
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TSScreenW/4*0.8+170;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    TSHomeHeaderView *headerView = [[TSHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenW/4*0.8+170)];
    
    headerView.clickBlock = ^(NSString *nid){
        
        NSLog(@"sender %@",nid);
        NoticeViewController *vc = [[NoticeViewController alloc]init];
        vc.nid =nid;
        [self.navigationController pushViewController:vc animated:YES];
    };
    

    __block TSHomeHeaderView *header = headerView;
    TSWeakSelf;
    headerView.didTagAction = ^ {
        if ([header.buttonName isEqualToString:@"我的理财"]) {
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){
                TSLiCaiController * licaiVC = [[TSLiCaiController alloc] init];
                [weakSelf.navigationController pushViewController:licaiVC animated:YES];
            }else {
                TSLoginController *loginVC = [[TSLoginController alloc]init];
                TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
                [weakSelf presentViewController:naVC animated:YES completion:nil];
            }
            
        } else if ([header.buttonName isEqualToString:@"我的福利"]) {
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){
                TSFuliController * fucliVC = [[TSFuliController alloc] init];
                [weakSelf.navigationController pushViewController:fucliVC animated:YES];
            }else {
                TSLoginController *loginVC = [[TSLoginController alloc]init];
                TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
                [weakSelf presentViewController:naVC animated:YES completion:nil];
            }
        } else if ([header.buttonName isEqualToString:@"我的认证"]) {
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){
                TSCertificationController * addVC = [[TSCertificationController alloc] init];
                [weakSelf.navigationController pushViewController:addVC animated:YES];
                
            }else {
                    TSLoginController *loginVC = [[TSLoginController alloc]init];
                    TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
                    [weakSelf presentViewController:naVC animated:YES completion:nil];
            }
        } else if ([header.buttonName isEqualToString:@"我要提现"]) {
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"id_status"] isEqual:@1]){
                    
                    [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} url:@"check_bank_card" successBlock:^(id responseBody) {
                        int event = [responseBody[@"event"] intValue];
                        if (event == 88) {   //  该用户已经绑定了银行卡  － 跳转到提现
                            TSWithdrawalController * withdrawalVC = [[TSWithdrawalController alloc]init];
                            [self.navigationController pushViewController:withdrawalVC animated:YES];
                        } else {             // 没有绑定银行卡 － 跳转到添加银行卡
                            [DZStatusHud showToastWithTitle:@"请先绑定银行卡" complete:^{
                                AddBankController *add = [[AddBankController alloc] init];
                                [self.navigationController pushViewController:add animated:YES];
                            }];
                        }
                        
                    } failureBlock:^(NSString *error) {
                    }];
                }else {
                    [DZStatusHud showToastWithTitle:@"您还未实名认证" complete:^{
                        TSRealNameController * realVC = [[TSRealNameController alloc] init];
                        [self.navigationController pushViewController:realVC animated:YES];
                    }];
                }


            }else {
                    TSLoginController *loginVC = [[TSLoginController alloc]init];
                    TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
                    [weakSelf presentViewController:naVC animated:YES completion:nil];
            }
        }    
    };
    return headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  判断是否为空
 *
 */
- (BOOL)isNull:(id)object
{
    // 判断是否为空串
    if ([object isEqual:[NSNull null]]) {
        return NO;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if (object==nil){
        return NO;
    }
    return YES;
}

@end
