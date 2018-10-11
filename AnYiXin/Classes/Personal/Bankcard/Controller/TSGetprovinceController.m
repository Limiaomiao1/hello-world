//
//  TSGetprovinceController.m
//  CheZhongChou
//
//  Created by TuanShang on 16/5/5.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import "TSGetprovinceController.h"
#import "TSCityModel.h"
#import "TSCityCell.h"
#import "TSGetcityController.h"

@interface TSGetprovinceController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;
@property (nonatomic , copy) NSString * provinID;
@property (nonatomic , copy) NSString * provinName;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation TSGetprovinceController
#pragma mark - 懒加载

- (NSMutableArray *)data {
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubViews];
    [self loadDataArr];
    [self.tableview reloadData];
}

- (void)setupSubViews {
    self.title = @"选择城市";
    self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc] init];
    self.tableview.rowHeight = 45;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[TSCityCell class] forCellReuseIdentifier:@"TSCityCell"];
}


- (void)loadDataArr {

    // self的弱引用
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:nil url:@"get_province" successBlock:^(id responseBody) {
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {
            weakSelf.data = [TSCityModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
            [weakSelf.tableview reloadData];
        } else {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TSCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSCityCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.cityModel = self.data[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    TSGetcityController * tsCityVC = [[TSGetcityController alloc]init];
    TSCityModel * citymodel = [[TSCityModel alloc]init];
    citymodel = self.data[indexPath.row];
    tsCityVC.provinID = citymodel.id;
    tsCityVC.provinName = citymodel.name;
  
    [self.navigationController pushViewController:tsCityVC animated:YES];
    
}

@end
