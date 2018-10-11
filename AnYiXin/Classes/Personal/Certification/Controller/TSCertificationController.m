//
//  TSCertificationController.m
//  Shangdai
//
//  Created by tuanshang on 17/2/18.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSCertificationController.h"
#import "TSRealNameController.h"

@interface TSCertificationController ()
/** 身份识别 */
@property (nonatomic, assign) NSInteger idStudus;
@end

@implementation TSCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubView];
    [self loadWithData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化
- (void)setupSubView {
    
    self.navigationItem.title = @"我的认证";
    self.navigationController.navigationBar.hidden = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

//=================================================================
//                         Http Request
//=================================================================
#pragma mark - 实名认证 Request
- (void)loadWithData {
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} url:TSAPI_CHECK_ID_STATUS successBlock:^(id responseBody) {
        
        weakSelf.idStudus = [responseBody[@"event"] integerValue];
        [weakSelf.tableView reloadData];
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:13.5f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        if (self.idStudus == 88) {
            cell.textLabel.text = @"实名已认证";
            cell.imageView.image = [UIImage imageNamed:@"approve_right"];
        } else if (self.idStudus == 90) {
            cell.textLabel.text = @"实名未认证";
            cell.imageView.image = [UIImage imageNamed:@"approve_no"];
        } else if (self.idStudus == 0) {
            cell.textLabel.text = @"实名待审核";
            cell.imageView.image = [UIImage imageNamed:@"approve_no"];
        } else if (self.idStudus == 2) {
            cell.textLabel.text = @"实名认证未通过";
            cell.imageView.image = [UIImage imageNamed:@"approve_no"];
        }
    } else {
        cell.textLabel.text = @"手机已认证";
        cell.imageView.image = [UIImage imageNamed:@"approve_right"];
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TSRealNameController * realNameVC = [[TSRealNameController alloc] init];
        [self.navigationController pushViewController:realNameVC animated:YES];
    } else {
        [DZStatusHud showAlertWithTitle:@"提示" message:@"暂时不能修改手机号，如果修改请联系客服人员" viewController:self complete:nil];
    }
}




@end
