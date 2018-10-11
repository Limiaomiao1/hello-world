//
//  TSPlatformTableViewController.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/2.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSPlatformTableViewController.h"
#import <UIImageView+WebCache.h>

@interface TSPlatformTableViewController ()
/** 微信 */
@property (nonatomic, copy) NSString *weixin;
/** 微博 */
@property (nonatomic, copy) NSString *weibo;
/** moreImg */
@property (nonatomic, copy) NSString *moreimg;

@end

@implementation TSPlatformTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    [self loadMoreInfo];
}
//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化
- (void)setupSubViews {
    self.navigationItem.title = @"关于团尚";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"aboutcell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

//=================================================================
//                         Http Request
//=================================================================
#pragma mark - Http Request
- (void)loadMoreInfo {
    
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:nil url:@"more" successBlock:^(id responseBody) {
        NSString * event = [NSString stringWithFormat:@"%@", responseBody[@"event"]];
        if ([event isEqualToString:@"88"]) {
            weakSelf.weixin = [NSString stringWithFormat:@"%@",responseBody[@"data"][@"weixin"]];
            weakSelf.weibo =  [NSString stringWithFormat:@"%@",responseBody[@"data"][@"weibo"]];
            weakSelf.moreimg = [NSString stringWithFormat:@"%@", responseBody[@"data"][@"more_img"]];
        } else {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
        [weakSelf.tableView reloadData];
    } failureBlock:^(NSString *error) {
        
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
#warning Incomplete implementation, return the number of rows
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    // 获取App的版本号
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"aboutcell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
    if (indexPath.row == 0) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TSScreenH/3)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.moreimg] placeholderImage:[UIImage imageNamed:@"more_background"]];
        [cell addSubview:imageView];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"官方微信:";
        cell.detailTextLabel.text = self.weixin;
    } else if(indexPath.row == 2) {
        cell.textLabel.text = @"官方微博:";
        cell.detailTextLabel.text = self.weibo;
    } else {
        cell.textLabel.text = @"版本:";
        cell.detailTextLabel.text = appVersion;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return TSScreenH/3;
    } else {
        return 50;
    }
}

@end
