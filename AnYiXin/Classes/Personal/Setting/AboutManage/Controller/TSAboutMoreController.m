//
//  TSAboutMoreController.m
//  TuanShang
//
//  Created by TuanShang on 16/7/11.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSAboutMoreController.h"
#import "TSAboutWeController.h"
#import "TSPlatformTableViewController.h"

@interface TSAboutMoreController ()

@end

@implementation TSAboutMoreController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"关于";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"moreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"平台介绍";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"关于团尚";
    }

    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        // 平台介绍
        TSAboutWeController * weVC = [[TSAboutWeController alloc]init];
        [self.navigationController pushViewController:weVC animated:YES];
    } else if (indexPath.row == 1) {
        // 关于
        TSPlatformTableViewController * platVC = [[TSPlatformTableViewController alloc] init];
        [self.navigationController pushViewController:platVC animated:YES];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return TSScreenH*0.25;
    }else {
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenH*0.25)];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, TSScreenW-40, view.height-40)];
        imageView.image = [UIImage imageNamed:@"more_background"];
        [view addSubview:imageView];
        return view;
    }else {
        return nil;
    }
    
}
@end
