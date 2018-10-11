//
//  UseRedpackViewController.m
//  AnYiXin
//
//  Created by Mac on 17/8/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "UseRedpackViewController.h"
#import "RedPacketModel.h"
@interface UseRedpackViewController ()

@end

@implementation UseRedpackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = COLOR_MainColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 30;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"uredCell"];
}
- (NSMutableArray *)dataArr
{
    if(!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
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
        
        messageLabel.text = @"您无可使用红包";
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
    RedPacketModel *model = self.dataArr[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@,金额：%@",model.title, model.rmoney];
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
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [button setBackgroundColor:COLOR_MainColor];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitle:@"取消红包" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didSelectRedBao) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)didSelectRedBao {
    
    [self.view removeFromSuperview] ;
    if ([self.delegate respondsToSelector:@selector(getHongbaoIDDelegate:withBidmoney:withpaymoney:)]) {
        [self.delegate getHongbaoIDDelegate:@"" withBidmoney:@"" withpaymoney:@""];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RedPacketModel *hongbao = self.dataArr[indexPath.row];
    
    [self.view removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(getHongbaoIDDelegate:withBidmoney:withpaymoney:)]) {
        [self.delegate getHongbaoIDDelegate:hongbao.ID withBidmoney:hongbao.title withpaymoney:hongbao.rmoney];
    }
    
}

- (void)didSelectJiaxi {
    
    [self.view removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(getHongbaoIDDelegate:withBidmoney:withpaymoney:)]) {
        [self.delegate getHongbaoIDDelegate:@"" withBidmoney:@"" withpaymoney:@""];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
