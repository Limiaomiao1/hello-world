//
//  TSRepayplanController.m
//  ZhuoJin
//
//  Created by tuanshang on 17/1/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSRepayplanController.h"
#import "TSRepaymentplanCell.h"
#import "TSRepayPlanModel.h"

@interface TSRepayplanController ()

@property (nonatomic, strong) NSMutableArray * dataArr;

@end

@implementation TSRepayplanController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[TSRepaymentplanCell class] forCellReuseIdentifier:@"TSRepaymentplanCell"];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0,20, 0, 20);
    [self loadInfoData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadInfoData {
    
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"borrow_id"] = @(self.ID);

    [[TSNetwork shareNetwork] postRequestResult:parame url:@"repayment_plan" successBlock:^(id responseBody) {
        TSLog(@"%@", responseBody);
        
        if ([responseBody[@"event"] integerValue] == 88) {
            
            self.dataArr = [TSRepayPlanModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
        } else {
            [DZStatusHud showToastWithTitle:@"暂无还款计划" complete:nil];
        }
        
        [self.tableView reloadData];
        
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
    
    TSRepaymentplanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSRepaymentplanCell" forIndexPath:indexPath];
    cell.planmodel = self.dataArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * label1 = [[UILabel alloc]init];
    label1.text = @"预期还款时间";
    [label1 setFont:[UIFont systemFontOfSize:12]];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [view addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc]init];
    label2.text = @"应还本金(元)";
    [label2 setFont:[UIFont systemFontOfSize:12]];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [view addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc]init];
    label3.text = @"应还利息(元)";
    [label3 setFont:[UIFont systemFontOfSize:12]];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [view addSubview:label3];
    
    
    [@[label1, label2, label3] autoAlignViewsToAxis:ALAxisHorizontal];
    NSArray *views = @[label1, label2, label3];
    
    [views autoMatchViewsDimension:ALDimensionWidth];
    [[views firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    UIView *previousView = nil;
    for (UIView *view in views) {
        if (previousView) {
            [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:previousView];
            [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        }
        previousView = view;
    }
    [[views lastObject] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    
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
