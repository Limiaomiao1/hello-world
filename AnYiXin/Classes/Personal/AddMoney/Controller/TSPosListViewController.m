//
//  TSPosListViewController.m
//  AnYiXin
//
//  Created by Mac on 17/8/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSPosListViewController.h"
#import "POSlistTableViewCell.h"
#import "POSModel.h"
@interface TSPosListViewController ()<UITableViewDelegate, UITableViewDataSource>
/** 数据 */
@property (nonatomic, strong) NSMutableArray *datasouce;


@property (weak, nonatomic) IBOutlet UITableView *listView;
@end

@implementation TSPosListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"POS充值记录";
    [self.listView registerNib:[UINib nibWithNibName:@"POSlistTableViewCell" bundle:nil] forCellReuseIdentifier:@"rechargecell"];
    [self loadData];
}

- (NSMutableArray *)datasouce
{
    if(!_datasouce) {
        _datasouce = [[NSMutableArray alloc] init];
    }
    return _datasouce;
}
- (void)loadData {
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:param url:@"poszflist" successBlock:^(id responseBody) {
        int event = [responseBody[@"event"] intValue];
        if (event == 88) {
            weakSelf.datasouce = [POSModel mj_objectArrayWithKeyValuesArray: responseBody[@"data"]];
        } else {
            [weakSelf.datasouce removeAllObjects];
            weakSelf.datasouce = nil;
        }
        [weakSelf.listView reloadData];
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];

}
//=================================================================
//                       UITableViewDataSource
//=================================================================
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    POSlistTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"rechargecell" forIndexPath:indexPath];
    cell.posmodel = self.datasouce[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//=================================================================
//                       UITableViewDelegate
//=================================================================
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
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
