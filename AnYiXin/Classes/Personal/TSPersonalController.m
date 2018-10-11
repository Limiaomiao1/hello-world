//
//  TSPersonalController.m
//  Shangdai
//
//  Created by tuanshang on 17/2/10.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSPersonalController.h"
#import "UIBarButtonItem+Extension.h"
#import "TSNavigationController.h"
#import "TSLoginController.h"
#import "TSCertificationController.h"
#import "TSAcitvitController.h"
#import "TSBulletinController.h"
#import "TSMyMessageController.h"
#import "TSMySetController.h"
#import "MineBankController.h"
#import "AddBankController.h"
#import "TSRealNameController.h"
#import "TSLiCaiController.h"
#import "TSFuliController.h"
#import "TSAddMoneyController.h"
#import "TSAddMoneyNewController.h"
#import "TSWithdrawalController.h"
#import "TSBindBankController.h"
#import "TSBindBankOneController.h"
#import "DeletBankTController.h"
#import "PosAddmoneyViewController.h"
#import "TSOpenAccountVController.h"
#import "BankCardNewViewController.h"
#import "ShareView.h"
#import "TSOpenAccountNewVC.h"
#import "BankCardWebVC.h"
#import "TSAddMoneyWebController.h"
#import "TSWithdrawWebController.h"
@interface TSPersonalController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 用户头像 */
@property (nonatomic, strong) UIImageView *userImage;
/** 用户名 */
@property (nonatomic, strong) UILabel *userLabel;
/** 资产总额 */
@property (nonatomic, strong) UILabel *all_moneylabel;
/** 可用余额 */
@property (nonatomic, strong) UILabel *balance_money;
/** 待收本息 */
@property (nonatomic, strong) UILabel *collect_interestlabel;
/** 冻结金额 */
@property (nonatomic, strong) UILabel *freeze_moneylabel;
/** 邀请码 */
@property (nonatomic, copy) NSString *insCode;
/**分享*/
@property(strong,nonatomic)ShareView * shareV;
@property (nonatomic,strong)NSString *user_phone;
@end

@implementation TSPersonalController

//=================================================================
//                           生命周期
//=================================================================

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
    } else {
        [self setupRefresh];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化

- (void)setupSubViews {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenH-49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [self setupHeaderView];
    
    
    _shareV = [[ShareView alloc]init];
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:_shareV];
    [window addSubview:_shareV.scrollv];
    
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

- (void)loadWithInfoData {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token.length>0) {
        TSWeakSelf;
        [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} url:TSAPI_MEMBER successBlock:^(id responseBody) {
            [weakSelf.tableView.mj_header endRefreshing];
            int event = [responseBody[@"event"] intValue];
            if (event == 88) {
                
                weakSelf.insCode = responseBody[@"data"][@"invite_code"];
                _userLabel.text = [NSString stringWithFormat:@"%@",responseBody[@"data"][@"user_name"]];
                _user_phone = [NSString stringWithFormat:@"%@",responseBody[@"data"][@"user_name"]];
                NSString *urlstr = [NSString stringWithFormat:@"http://www.51jqd.com/m/pub/invitation/spread/%@",responseBody[@"data"][@"user_name"]];
                
                [_shareV shareshowSetupParmImg:[UIImage imageNamed:@"LOGO"] andText:@"邀请好友" andTitle:@"金钱袋" andUrlstr:urlstr];

                double x1 = [responseBody[@"data"][@"all_money"] doubleValue];
                _all_moneylabel.text = [NSString stringWithFormat:@"￥%.2f", x1];
                double x2 = [responseBody[@"data"][@"balance_money"] doubleValue];
                _balance_money.text = [NSString stringWithFormat:@"￥%.2f", x2];
                double x3 = [responseBody[@"data"][@"collect_interest"] doubleValue];
                _collect_interestlabel.text = [NSString stringWithFormat:@"￥%.2f", x3];
                double x4 = [responseBody[@"data"][@"freeze_money"] doubleValue];
                _freeze_moneylabel.text = [NSString stringWithFormat:@"￥%.2f", x4];
               // [_all_moneylabel sizeToFit];
//                [[SDImageCache sharedImageCache] clearDisk];
                [_userImage sd_setImageWithURL:[NSURL URLWithString:responseBody[@"data"][@"header_img"]] placeholderImage:[UIImage imageNamed:@"icon_user_default"]];
                
                [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"id_status"] forKey:@"id_status"];
                [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"credit_lvl"] forKey:@"credit_lvl"];
                [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"email_status"] forKey:@"email_status"];
                [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"has_pin"] forKey:@"has_pin"];
                [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"invest_lvl"] forKey:@"invest_lvl"];
                [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"phone_status"] forKey:@"phone_status"];
                [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"user_name"] forKey:@"user_name"];
                [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"user_phone"] forKey:@"user_phone"];
                [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"balance_money"] forKey:@"balance_money"];
                [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"vip"] forKey:@"vip"];
                [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"header_img"] forKey:@"header_img"];
                [[NSUserDefaults standardUserDefaults] setObject:responseBody[@"data"][@"real_name"] forKey:@"real_name"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            } else {
                if (event == 99)//另一台设备已经登录
                {
                    TSLoginController *loginVC = [[TSLoginController alloc]init];
                    TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
                    [self presentViewController:naVC animated:YES completion:nil];
                }
                _userLabel.text = @"未登录";
                _all_moneylabel.text = @"0.00";
                _balance_money.text = @"￥0.00";
                _collect_interestlabel.text = @"￥0.00";
                _freeze_moneylabel.text = @"￥0.00";
                weakSelf.insCode = @"";
                _userImage.image = [UIImage imageNamed:@"icon_user_default"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"islogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];

            }
            [weakSelf.tableView reloadData];
        } failureBlock:^(NSString *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            _userLabel.text = @"未登录";
            weakSelf.insCode = @"";
            _all_moneylabel.text = @"0.00";
            _balance_money.text = @"￥0.00";
            _collect_interestlabel.text = @"￥0.00";
            _freeze_moneylabel.text = @"￥0.00";
            _userImage.image = [UIImage imageNamed:@"icon_user_default"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"islogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }];
    } else {
        _userLabel.text = @"未登录";
        _all_moneylabel.text = @"0.00";
        _balance_money.text = @"￥0.00";
        _collect_interestlabel.text = @"￥0.00";
        _freeze_moneylabel.text = @"￥0.00";
        _userImage.image = [UIImage imageNamed:@"icon_user_default"];
        self.insCode = @"";
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"islogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//=================================================================
//                       UITableViewDataSource
//=================================================================
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }   return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:13.5f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"充值";
            cell.imageView.image = [UIImage imageNamed:@"icon_recharge"];
            
        } else if (indexPath.row == 1) {
       //     cell.textLabel.text = @"POS充值";
       //     cell.imageView.image = [UIImage imageNamed:@"icon_recharge"];
            cell.textLabel.text = @"提现";
            cell.imageView.image = [UIImage imageNamed:@"icon_cash"];
        }
        //else {
          //  cell.textLabel.text = @"提现";
           // cell.imageView.image = [UIImage imageNamed:@"icon_cash"];

        //}
    } else if (indexPath.section == 1) {
//            cell.textLabel.text = @"我的邀请码";
//            cell.imageView.image = [UIImage imageNamed:@"icon_invite_code"];
//            cell.detailTextLabel.text = self.insCode;
 
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的理财";
            cell.imageView.image = [UIImage imageNamed:@"icon_manage"];

        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"我的银行卡";
            cell.imageView.image = [UIImage imageNamed:@"icon_bank"];

        }else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"会员开户";
            cell.imageView.image = [UIImage imageNamed:@"icon_cash"];
        }
        else if (indexPath.row == 3) {
            cell.textLabel.text = @"我的认证";
            cell.imageView.image = [UIImage imageNamed:@"icon_approve"];

        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"我的福利";
            cell.imageView.image = [UIImage imageNamed:@"icon_welfare"];

        } else if (indexPath.row == 5) {
            cell.textLabel.text = @"我的邀请";
            cell.imageView.image = [UIImage imageNamed:@"icon_invite_code"];
        }

    }
    return cell;
}

//=================================================================
//                       UITableViewDelegate
//=================================================================
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){//已登录
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"id_status"] isEqual:@1]){
                
                [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} url:@"check_bank_card" successBlock:^(id responseBody) {
                    int event = [responseBody[@"event"] intValue];
                    if (event == 88) {   //  该用户已经绑定了银行卡  － 跳转到提现
                        if (indexPath.row == 0) {
                            
                            TSAddMoneyWebController *vc = [[TSAddMoneyWebController alloc]init];
                            [self.navigationController pushViewController:vc animated:YES];
                        }else if (indexPath.row == 1)
                        {
                           // PosAddmoneyViewController *vc = [[PosAddmoneyViewController alloc]init];
                          //  [self.navigationController pushViewController:vc animated:YES];
                            
                            TSWithdrawWebController * withdrawalVC = [[TSWithdrawWebController alloc]init];
                          //  withdrawalVC.phonestr = _user_phone;
                            [self.navigationController pushViewController:withdrawalVC animated:YES];
                        }
                    } else {             // 没有绑定银行卡 － 跳转到添加银行卡
                        [DZStatusHud showToastWithTitle:@"请先绑定银行卡" complete:^{
                          //  TSBindBankOneController *add = [[TSBindBankOneController alloc] init];
                          //  [self.navigationController pushViewController:add animated:YES];
                            BankCardWebVC *CV = [[BankCardWebVC alloc] init];
                            [self.navigationController pushViewController:CV animated:YES];
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
            [self presentViewController:naVC animated:YES completion:nil];
        }

    } else if (indexPath.section == 1){

        if (indexPath.row == 0){
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){
                TSLiCaiController * licaiVC = [[TSLiCaiController alloc] init];
                [self.navigationController pushViewController:licaiVC animated:YES];
            }else {
                TSLoginController *loginVC = [[TSLoginController alloc]init];
                TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
                [self presentViewController:naVC animated:YES completion:nil];
            }
        }
        else if (indexPath.row == 1){
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){//已登录
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"id_status"] isEqual:@1]){
                    BankCardWebVC *CV = [[BankCardWebVC alloc] init];
                    [self.navigationController pushViewController:CV animated:YES];
                }else {//实名认证
                    [DZStatusHud showToastWithTitle:@"您还未实名认证" complete:^{
                        TSRealNameController * realVC = [[TSRealNameController alloc] init];
                        [self.navigationController pushViewController:realVC animated:YES];
                    }];
                }
            }else {
                TSLoginController *loginVC = [[TSLoginController alloc]init];
                TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
                [self presentViewController:naVC animated:YES completion:nil];
            }
        }else if (indexPath.row == 2){
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){//开户
                //  开户
                TSOpenAccountNewVC *VC = [[TSOpenAccountNewVC alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
                /*
                [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} url:@"account" successBlock:^(id responseBody) {
                    int event = [responseBody[@"event"] intValue];
                    
                    if (event == 88) {
                        //  开户
                        TSOpenAccountVController *VC = [[TSOpenAccountVController alloc] init];
                        NSDictionary *data = responseBody[@"data"];
                        VC.name = data[@"real_name"];
                        VC.phone = data[@"user_phone"];
                        [self.navigationController pushViewController:VC animated:YES];
                    }else if (event == 1)
                    {//实名认证
                        TSRealNameController *certiVC = [[TSRealNameController alloc] init];
                        [self.navigationController pushViewController:certiVC animated:YES];
                    }else if (event == 0){
                        // 没有绑定银行卡 － 跳转到添加银行卡
                        BankCardNewViewController *CV = [[BankCardNewViewController alloc] init];
                        [self.navigationController pushViewController:CV animated:YES];
                        [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];

                    }
                    
                } failureBlock:^(NSString *error) {
                    [DZStatusHud showToastWithTitle:error complete:nil];
                }];
                
                */

            }else {
                TSLoginController *loginVC = [[TSLoginController alloc]init];
                TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
                [self presentViewController:naVC animated:YES completion:nil];
            }
            
        }
        else if (indexPath.row == 3){
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){
                TSCertificationController *certiVC = [[TSCertificationController alloc] init];
                [self.navigationController pushViewController:certiVC animated:YES];
            }else {
                TSLoginController *loginVC = [[TSLoginController alloc]init];
                TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
                [self presentViewController:naVC animated:YES completion:nil];
            }

        } else if (indexPath.row == 4){
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){
                TSFuliController *fuliVC = [[TSFuliController alloc] init];
                [self.navigationController pushViewController:fuliVC animated:YES];
            }else {
                TSLoginController *loginVC = [[TSLoginController alloc]init];
                TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
                [self presentViewController:naVC animated:YES completion:nil];
            }
        }else if (indexPath.row == 5)
        {
            [UIView animateWithDuration:0.3f animations:^{
                self.shareV.hidden = NO;
                self.shareV.scrollv.y = TSScreenH-179;
                
            } completion:^(BOOL finished) {
                
            }];

        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.5;
    } return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*--------------------------TABLEVIEW头视图-------------------------*/

- (UIView *)setupHeaderView {
    
    UIView * bigback = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, 250)];
    bigback.backgroundColor = COLOR_MainColor;
    [self.view addSubview:bigback];
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"icon_user_default"];
    imageView.layer.cornerRadius = 15;
    imageView.layer.masksToBounds = YES;
    _userImage = imageView;
    [bigback addSubview:_userImage];
    UILabel  * userlabel = [[UILabel alloc]init];
    [userlabel setFont:[UIFont systemFontOfSize:13]];
    userlabel.text = @"未登录";
    userlabel.textColor = [UIColor whiteColor];
    [bigback addSubview:userlabel];
    _userLabel = userlabel;
    
    UILabel  * aboutlabel = [[UILabel alloc]init];
    [aboutlabel setFont:[UIFont systemFontOfSize:9]];
    aboutlabel.text = @"";
    aboutlabel.textColor = [UIColor whiteColor];
    [bigback addSubview:aboutlabel];
    
    UIButton * userbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bigback addSubview:userbutton];
    [userbutton addTarget:self action:@selector(didUserButton) forControlEvents:UIControlEventTouchUpInside];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"nav_right"] forState:UIControlStateNormal];
    [bigback addSubview:button];
    [button addTarget:self action:@selector(didMessageButton) forControlEvents:UIControlEventTouchUpInside];
    UIView * view1 = [[UIView alloc]init];
    [bigback addSubview:view1];
    UILabel * label1 = [[UILabel alloc]init];
    label1.text = @"待收本息";
    [label1 setFont:[UIFont systemFontOfSize:13]];
    label1.textColor = [UIColor whiteColor];
    [view1 addSubview:label1];
    UILabel * label11 = [[UILabel alloc]init];
    label11.text = @"￥0.00";
    label11.numberOfLines = 2;
    label11.textAlignment = NSTextAlignmentCenter;
    [label11 setFont:[UIFont systemFontOfSize:13]];
    label11.textColor = [UIColor whiteColor];
    _collect_interestlabel = label11;
    [view1 addSubview:_collect_interestlabel];
    UIView * lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = [UIColor whiteColor];
    [bigback addSubview:lineView1];
    UIView * view2 = [[UIView alloc]init];
    [bigback addSubview:view2];
    UILabel * label2 = [[UILabel alloc]init];
    label2.text = @"可用余额";
    [label2 setFont:[UIFont systemFontOfSize:13]];
    label2.textColor = [UIColor whiteColor];
    [view2 addSubview:label2];
    UILabel * label22 = [[UILabel alloc]init];
    label22.text = @"￥0.00";
    label22.numberOfLines = 2;
    label22.textAlignment = NSTextAlignmentCenter;
    [label22 setFont:[UIFont systemFontOfSize:13]];
    label22.textColor = [UIColor whiteColor];
    _balance_money = label22;
    [view2 addSubview:_balance_money];
    UIView * lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [UIColor whiteColor];
    [bigback addSubview:lineView2];
    UIView * view3 = [[UIView alloc]init];
    [bigback addSubview:view3];
    UILabel * label3 = [[UILabel alloc]init];
    label3.text = @"冻结金额";
    label3.textColor = [UIColor whiteColor];
    [label3 setFont:[UIFont systemFontOfSize:13]];
    [view3 addSubview:label3];
    UILabel * label33 = [[UILabel alloc]init];
    label33.text = @"￥0.00";
    label33.numberOfLines = 2;
    label33.textAlignment = NSTextAlignmentCenter;
    [label33 setFont:[UIFont systemFontOfSize:13]];
    label33.textColor = [UIColor whiteColor];
    _freeze_moneylabel = label33;
    [view3 addSubview:_freeze_moneylabel];
    UILabel * alllabel = [[UILabel alloc]init];
    alllabel.text= @"资产总额(元)";
    alllabel.textColor = [UIColor whiteColor];
    [bigback addSubview:alllabel];
    UILabel * alllabel1 = [[UILabel alloc]init];
    alllabel1.numberOfLines = 1;
    alllabel1.textAlignment = NSTextAlignmentCenter;
    [alllabel1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    alllabel1.textColor = [UIColor whiteColor];
    alllabel1.text = @"￥0.00";
    _all_moneylabel = alllabel1;
    [bigback addSubview:_all_moneylabel];
    
    [imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [imageView autoSetDimensionsToSize:CGSizeMake(30, 30)];
    [userlabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:10];
    [userlabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:imageView];
//    [@[imageView, userlabel] autoAlignViewsToAxis:ALAxisHorizontal];
    [aboutlabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:userlabel withOffset:0];
    [aboutlabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:userlabel];
    [button autoSetDimensionsToSize:CGSizeMake(30, 30)];
    [button autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [button autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:20];
    [userbutton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:imageView];
    [userbutton autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:imageView];
    [userbutton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:imageView];
    [userbutton autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:userlabel];
    [alllabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageView withOffset:30];
    [alllabel autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [alllabel1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:alllabel withOffset:10];
    [alllabel1 autoAlignAxis:ALAxisVertical toSameAxisOfView:alllabel];
    [alllabel1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [alllabel1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [view1 autoSetDimensionsToSize:CGSizeMake(TSScreenW/3-2, 60)];
    [view1 autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [view1 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [label1 autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [label1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [label2 autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [label2 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [label3 autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [label3 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [label11 autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [label11 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [label11 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:lineView1 withOffset:3];
    [label22 autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [label22 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [label22 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lineView1 withOffset:3];
    [label33 autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [label33 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [label33 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lineView2];
    [lineView1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:view1];
    [lineView1 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [lineView1 autoSetDimensionsToSize:CGSizeMake(1, 40)];
    [view2 autoSetDimensionsToSize:CGSizeMake(TSScreenW/3, 60)];
    [view2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lineView1];
    [view2 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    [lineView2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:view2];
    [lineView2 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [lineView2 autoSetDimensionsToSize:CGSizeMake(1, 40)];
    [view3 autoSetDimensionsToSize:CGSizeMake(TSScreenW/3, 60)];
    [view3 autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [view3 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    UIView * herline = [[UIView alloc] init];
    herline.backgroundColor = [UIColor whiteColor];
    [bigback addSubview:herline];
    [herline autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:label1];
    [herline autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:label3];
    [herline autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:alllabel1];
    [herline autoSetDimension:(ALDimensionHeight) toSize:0.5];
    
    return bigback;
}

//=================================================================
//                           事件处理
//=================================================================
#pragma mark - 事件处理

- (void)didUserButton {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){
        TSMySetController *mysetVC = [[TSMySetController alloc]init];
        [self.navigationController pushViewController:mysetVC animated:YES];
    }else {
        TSLoginController *loginVC = [[TSLoginController alloc]init];
        TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:naVC animated:YES completion:nil];
    }
}

- (void)didMessageButton {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"] == YES){
        TSMyMessageController *messageVC = [[TSMyMessageController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
    }else {
        TSLoginController *loginVC = [[TSLoginController alloc]init];
        TSNavigationController *naVC = [[TSNavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:naVC animated:YES completion:nil];
    }
}


@end
