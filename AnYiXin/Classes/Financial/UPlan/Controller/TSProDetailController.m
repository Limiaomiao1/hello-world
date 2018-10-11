//
//  TSProDetailController.m
//  TuanShang
//
//  Created by TuanShang on 16/8/1.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSProDetailController.h"

#import "TSTransDetailCell.h"

#import "TSTransferDetailModel.h"

@interface TSProDetailController ()

@property (nonatomic, strong) TSTransferDetailModel * model;

@end

@implementation TSProDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenH - 64) style:UITableViewStylePlain];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TSTransDetailCell" bundle:nil] forCellReuseIdentifier:@"TSTransDetailCell"];
    
    self.tableView.rowHeight = 45;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadInfoData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadInfoData {
    
    [[TSNetwork shareNetwork] postRequestResult:@{@"id":@(self.ID)} url:@"transfer_detail" successBlock:^(id responseBody) {
        
        TSTransferDetailModel * model = [TSTransferDetailModel mj_objectWithKeyValues:responseBody[@"data"]];
        self.model = model;
        
        [self.tableView reloadData];
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TSTransDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSTransDetailCell" forIndexPath:indexPath];
    
    cell.transferModel = self.model;
    
    
    return cell;
}



@end
