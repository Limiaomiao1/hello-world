//
//  TSPassWordController.m
//  TuanShang
//
//  Created by TuanShang on 16/7/11.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSPassWordController.h"
#import "TSPinPassController.h"
#import "TSLoginPassController.h"
#import "TSSetPinController.h"
#import "TSCunGuanPSWViewController.h"
#import "TSCunGuanPSWWebVC.h"
#import "TSResetCunGuanPswWebVC.h"
@interface TSPassWordController ()

@property (assign, nonatomic) BOOL pin_pass;


@end

@implementation TSPassWordController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadPersonPinPass];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"密码安全";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

}

//=================================================================
//                         Http Request
//=================================================================
#pragma mark - Http Request
- (void)loadPersonPinPass {
    [[TSNetwork shareNetwork] postRequestResult:@{@"token":[[NSUserDefaults standardUserDefaults]objectForKey:@"token"]} url:TSAPI_CHECK_PIN_PASS successBlock:^(id responseBody) {
        if ([responseBody[@"event"]  isEqual:@88]) {
            [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"has_pin"];
        } else {
            [[NSUserDefaults standardUserDefaults]setObject:@0 forKey:@"has_pin"];
        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"登录密码";
                    cell.detailTextLabel.text = @"修改";
                    break;
//                case 1:
//                    cell.textLabel.text = @"支付密码";
//                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"has_pin"] isEqual:@1]) {
//                        cell.detailTextLabel.text = @"修改";
//                    } else {
//                        cell.detailTextLabel.text = @"未设置";
//                    }
//                    break;
                case 1:
                    cell.textLabel.text = @"存管支付密码";
                    cell.detailTextLabel.text = @"修改";
                    break;
                case 2:
                    cell.textLabel.text = @"存管密码重置";
                    cell.detailTextLabel.text = @"修改";
                    break;
                    

                default:
                    break;
            }
            break;
            
        case 1:
            cell.textLabel.text = @"手势密码";
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    } else {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        if (indexPath.row == 0) {
            TSLoginPassController * loginVC = [[TSLoginPassController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
//        else if (indexPath.row == 1) {
//            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"has_pin"] isEqual:@1]) {
//                TSPinPassController *pinpassVC = [[TSPinPassController alloc]init];
//                [self.navigationController pushViewController:pinpassVC animated:YES];
//            } else {
//                TSSetPinController *setpin = [[TSSetPinController alloc]init];
//                [self.navigationController pushViewController:setpin animated:YES];
//
//            }
//
//        }
        else if (indexPath.row == 1)
        {
            TSCunGuanPSWWebVC * cunguanVC = [[TSCunGuanPSWWebVC alloc]init];
            [self.navigationController pushViewController:cunguanVC animated:YES];
        }else
        {
            TSResetCunGuanPswWebVC * cunguanVC = [[TSResetCunGuanPswWebVC alloc]init];
            [self.navigationController pushViewController:cunguanVC animated:YES];

        }
    } else if (indexPath.section == 1) {
    }
}


@end
