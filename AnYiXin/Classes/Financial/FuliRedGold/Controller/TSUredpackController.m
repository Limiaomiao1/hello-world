//
//  TSUredpackController.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSUredpackController.h"
#import "TSUredpackModel.h"

@interface TSUredpackController ()

@end

@implementation TSUredpackController

- (NSMutableArray *)dataArr
{
    if(!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 30;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"uredCell"];
    
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
    if (self.dataArr.count == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = @"您无可使用特权金";
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
    } else {
        self.tableView.backgroundView = nil;
    }

    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"uredCell" forIndexPath:indexPath];

    cell.contentView.backgroundColor = [UIColor redColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    TSUredpackModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@,特权金金额:%@",model.name, model.money];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.textColor = [UIColor redColor];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:line];
    [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [line autoPinEdgeToSuperviewEdge:ALEdgeBottom ];
    [line autoSetDimension:ALDimensionHeight toSize:1];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel * headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 30)];
    headView.backgroundColor = [UIColor redColor];
    headView.textAlignment = NSTextAlignmentCenter;
    headView.font = [UIFont systemFontOfSize:14];
    headView.text = @"我的可用特权金";
    headView.textColor = [UIColor whiteColor];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    TSUredpackModel *hongbao = self.dataArr[indexPath.row];
    
    [self.view removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(getHongBaoIDDelegate:withBidmoney:withpaymoney:)]) {
        [self.delegate getHongBaoIDDelegate:hongbao.ID withBidmoney:hongbao.name withpaymoney:hongbao.money];
    }
}

- (void)didSelectRedBao {
    
    [self.view removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(getHongBaoIDDelegate:withBidmoney:withpaymoney:)]) {
        [self.delegate getHongBaoIDDelegate:@"" withBidmoney:@"" withpaymoney:@""];
    }
}
@end
