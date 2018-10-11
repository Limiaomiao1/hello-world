//
//  TSInverstorController.m
//  Shangdai
//
//  Created by tuanshang on 17/4/12.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSInverstorController.h"
#import "TSTInverstorCell.h"
#import "HetongViewController.h"
@interface TSInverstorController ()<UITableViewDelegate, UITableViewDataSource>
/** 我是傻逼 */
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TSInverstorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];

}

//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化

- (void)setUpTableView {
    self.navigationItem.title = @"记录详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenH-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = TSScreenH-50;
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = COLOR_MainColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0,10, 0, 10);        // 设置端距，这里表示separator离左边和右边均80像素
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSTInverstorCell" bundle:nil] forCellReuseIdentifier:@"InverstorCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSTInverstorCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InverstorCell" forIndexPath:indexPath];
    cell.inversmodel = self.inverModel;
    [cell.hetongbtn addTarget:self action:@selector(hetongAct) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)hetongAct
{
    HetongViewController *inverVC = [[HetongViewController alloc] init];
    inverVC.touid = self.inverModel.ID;
    [self.navigationController pushViewController:inverVC animated:YES];

}
@end
