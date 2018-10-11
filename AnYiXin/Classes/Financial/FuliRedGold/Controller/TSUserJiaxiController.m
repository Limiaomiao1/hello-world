//
//  TSUserJiaxiController.m
//  ZhuoJin
//
//  Created by tuanshang on 17/2/2.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSUserJiaxiController.h"
#import "TSJiaxiModel.h"


@interface TSUserJiaxiController ()

@end

@implementation TSUserJiaxiController
- (NSMutableArray *)dataArr
{
    if(!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = COLOR_MainColor;
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
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (self.dataArr.count == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = @"您无可使用加息劵";
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
    
    cell.contentView.backgroundColor = COLOR_MainColor;
    cell.textLabel.font = [UIFont systemFontOfSize:10.0];
    TSJiaxiModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@,加息:%@%%",model.title, model.interest_rate];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.textColor = COLOR_MainColor;
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = COLOR_MainColor;
    [cell.contentView addSubview:line];
    [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [line autoPinEdgeToSuperviewEdge:ALEdgeBottom ];
    [line autoSetDimension:ALDimensionHeight toSize:1];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [button setBackgroundColor:COLOR_MainColor];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button setTitle:@"取消加息劵" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didSelectRedBao) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)didSelectRedBao {
    
    [self.view removeFromSuperview] ;
    if ([self.delegate respondsToSelector:@selector(getJiaxiIDDelegate:withBidmoney:withpaymoney:)]) {
        [self.delegate getJiaxiIDDelegate:@"" withBidmoney:@"" withpaymoney:@""];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TSJiaxiModel *hongbao = self.dataArr[indexPath.row];
    
    [self.view removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(getJiaxiIDDelegate:withBidmoney:withpaymoney:)]) {
        [self.delegate getJiaxiIDDelegate:hongbao.ID withBidmoney:hongbao.title withpaymoney:hongbao.interest_rate];
    }
    
}

- (void)didSelectJiaxi {
    
    [self.view removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(getJiaxiIDDelegate:withBidmoney:withpaymoney:)]) {
        [self.delegate getJiaxiIDDelegate:@"" withBidmoney:@"" withpaymoney:@""];
    }
}

@end
