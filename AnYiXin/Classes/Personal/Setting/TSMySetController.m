//
//  TSMySetController.m
//  TuanShang
//
//  Created by TuanShang on 16/7/5.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSMySetController.h"
#import "TSUserCell.h"
#import "TSPassWordController.h"
#import "TSAboutWeController.h"
#import "TSPersonInfoViewController.h"
#import "TSMyCodeView.h"
#import "UIView+TYAlertView.h"

@interface TSMySetController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
/** 客服电话 */
@property (nonatomic, copy) NSString *phone;
/** 客服工作时间 */
@property (nonatomic, copy) NSString *worktime;
/** 二维码 */
@property (nonatomic, copy) NSString *codeURL;

@end

@implementation TSMySetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 部署UI
    [self setupSubViews];
    // 加载更多数据
    [self loadMoreInfo];
}

//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化
- (void)setupSubViews {
    
    self.navigationItem.title = @"我的";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[TSUserCell class] forCellReuseIdentifier:@"TSUserCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView reloadData];
}
//=================================================================
//                         Http Request
//=================================================================
#pragma mark - Http Request
- (void)loadMoreInfo {
    TSWeakSelf;
   [[TSNetwork shareNetwork] postRequestResult:nil url:TSAPI_MORE successBlock:^(id responseBody) {
      
       NSString * event = [NSString stringWithFormat:@"%@", responseBody[@"event"]];
       if ([event isEqualToString:@"88"]) {
           weakSelf.phone = responseBody[@"data"][@"kefu"];
           weakSelf.worktime = responseBody[@"data"][@"kefu_time"];
           weakSelf.codeURL = responseBody[@"data"][@"erweima"];
       }else
       {
           [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
       }
       [weakSelf.tableView reloadData];
   } failureBlock:^(NSString *error) {
       [DZStatusHud showToastWithTitle:error complete:nil];
   }];
}
//=================================================================
//                           生命周期
//=================================================================
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

//=================================================================
//                       UITableViewDataSource
//=================================================================
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        TSUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSUserHeadCell"];
        if (!cell) {
            TSUserCell *cell = [[TSUserCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TSUserCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            cell.detailTextLabel.text = @"个人信息";
            return cell;
        }
      
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            return cell;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"密码安全";
        }
        return cell;
        
    }  else if (indexPath.section == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"二维码关注";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"客服服务时间";
            cell.detailTextLabel.text = self.worktime;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"客服电话";
            cell.detailTextLabel.text = self.phone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"关于我们";
        }
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = @"安全退出";
    cell.textLabel.textColor = COLOR_MainColor;
    return cell;
}
//=================================================================
//                       UITableViewDelegate
//=================================================================
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

//=================================================================
//                           事件处理
//=================================================================
#pragma mark - 事件处理

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TSPersonInfoViewController * personVC = [[TSPersonInfoViewController alloc]init];
        [self.navigationController pushViewController:personVC animated:YES];
    }else if (indexPath.section == 1) {
        TSPassWordController * passVC = [[TSPassWordController alloc]init];
        [self.navigationController pushViewController:passVC animated:YES];
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            TSMyCodeView *codeView = [TSMyCodeView createViewFromNib];
            codeView.imgURL = self.codeURL;
            // use UIView Category
            [codeView showInWindow];
        } else if (indexPath.row == 1) {
            
        } else if (indexPath.row == 2) {
            
            [DZStatusHud showToastWithTitle:@"马上开始拨打电话..." complete:nil];
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[self.phone stringByReplacingOccurrencesOfString:@"-" withString:@""]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];

        } else if (indexPath.row == 3) {
        
            // 平台介绍
            TSAboutWeController * weVC = [[TSAboutWeController alloc]init];
            [self.navigationController pushViewController:weVC animated:YES];
//            TSAboutMoreController * aboutMoreVC = [[TSAboutMoreController alloc]init];
//            [self.navigationController pushViewController:aboutMoreVC animated:YES];
        }
    } else {
        UIActionSheet * alerView = [[UIActionSheet alloc]initWithTitle:@"你确定要退出当前用户" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [user removeObjectForKey:@"token"];
        [user setBool:NO forKey:@"islogin"];
        [user synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
