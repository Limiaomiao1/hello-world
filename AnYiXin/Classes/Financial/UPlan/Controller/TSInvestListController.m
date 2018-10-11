//
//  TSInvestListController.m
//  TuanShang
//
//  Created by TuanShang on 16/8/1.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSInvestListController.h"

#import "TSInverListModel.h"

#import "TSTransListCell.h"

@interface TSInvestListController ()

@property (nonatomic, strong) TSInverListModel * inverListModel;

@property (nonatomic, strong) NSMutableArray * dataArr;

@end

@implementation TSInvestListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[TSTransListCell class] forCellReuseIdentifier:@"TSTransListCell"];
    
     self.tableView.tableFooterView = [[UIView alloc]init];
     self.tableView.separatorInset = UIEdgeInsetsMake(0,20, 0, 20);
     [self loadInfoData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadInfoData {
    
    [[TSNetwork shareNetwork] postRequestResult:@{@"id":@(self.ID)} url:@"transfer_invest_list" successBlock:^(id responseBody) {
        TSLog(@"%@",responseBody);
        int event = [responseBody[@"event"] intValue];
        if (event == 88) {       
            self.dataArr = [TSInverListModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
            [self.tableView reloadData];
            
        }else
        {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
        
    } failureBlock:^(NSString *error) {
        
    }];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWithMsg:@"暂无数据" ifNecessaryForRowCount:self.dataArr.count];
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TSTransListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSTransListCell" forIndexPath:indexPath];
    
    cell.tranListModel = self.dataArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc]init];
    
    UILabel * label1 = [[UILabel alloc]init];
    label1.text = @"投资时间";
    [label1 setFont:[UIFont systemFontOfSize:12]];
    label1.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [view addSubview:label1];
    
//    UILabel * label2 = [[UILabel alloc]init];
//    label2.text = @"投资类型";
//    [label2 setFont:[UIFont systemFontOfSize:12]];
//    label2.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
//    [view addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc]init];
    label3.text = @"投资金额";
    [label3 setFont:[UIFont systemFontOfSize:12]];
    label3.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [view addSubview:label3];
    
    UILabel * label4 = [[UILabel alloc]init];
    label4.text = @"投资用户";
    [label4 setFont:[UIFont systemFontOfSize:12]];
    label4.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [view addSubview:label4];
    
    
    [@[label1, label3, label4] autoAlignViewsToAxis:ALAxisHorizontal];
    NSArray *views = @[label1, label3, label4];
    
    // Match the widths of all the views
    [views autoMatchViewsDimension:ALDimensionWidth];
    [[views firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    UIView *previousView = nil;
    for (UIView *view in views) {
        if (previousView) {
            [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:previousView ];
            [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        }
        previousView = view;
    }
    [[views lastObject] autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    [view addSubview:line];
    
    [line autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [line autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [line autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [line autoSetDimension:(ALDimensionHeight) toSize:0.5];
    
    return view;
}

@end
