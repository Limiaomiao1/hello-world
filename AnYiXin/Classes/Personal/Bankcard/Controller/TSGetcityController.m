//
//  TSGetcityController.m
//  CheZhongChou
//
//  Created by TuanShang on 16/5/5.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import "TSGetcityController.h"
#import "TSCityModel.h"
#import "TSCityCell.h"
#import "TSBindBankController.h"


#import <AFNetworking.h>
#import <MJExtension.h>

@interface TSGetcityController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation TSGetcityController

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
    self.tableview.tableFooterView = [[UIView alloc]init];
}


- (void)loadDataArr {
    // 请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"id"] = self.provinID;
    // self的弱引用
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:params url:@"get_city" successBlock:^(id responseBody) {
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
    self.cityID = cell.cityModel.id;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.delegate = [self.navigationController.viewControllers objectAtIndex:1];
    
    if (self.delegate != nil &&[self.delegate respondsToSelector:@selector(getCityName:withCity:withProvinID:withCityID:)]) {
        TSCityModel * cityModel = [[TSCityModel alloc]init];
        cityModel = self.data[indexPath.row];
        [self.delegate getCityName:cityModel.name withCity:self.provinName withProvinID:self.provinID withCityID:cityModel.id];
    }
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

@end
