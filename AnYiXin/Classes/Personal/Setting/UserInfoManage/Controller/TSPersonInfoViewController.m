//
//  TSPersonInfoViewController.m
//  TuanShang
//
//  Created by TuanShang on 16/7/16.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSPersonInfoViewController.h"
#import "TSUserHeadCell.h"
#import <UIImageView+WebCache.h>

@interface TSPersonInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;

@property (nonatomic, strong) NSMutableDictionary * dataDic;


@end

@implementation TSPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}
//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化
- (void)setupSubViews {
    self.navigationItem.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc] init];
    self.tableview.rowHeight = 45;
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"TSUserHeadCell" bundle:nil] forCellReuseIdentifier:@"TSUserHeadCell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - datasouse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        TSUserHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TSUserHeadCell"];
        cell.nameLabel.text = @"个人头像";
        [cell.headImage sd_setImageWithURL:[[NSUserDefaults standardUserDefaults] objectForKey:@"header_img"] placeholderImage:[UIImage imageNamed:@"icon_user"]];
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    if (indexPath.row == 1) {
        cell.textLabel.text = @"手机号";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"user_phone"]];
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"身份认证";
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"id_status"] isEqual:@1]) {
            cell.detailTextLabel.text = @"已认证";
        } else {
            cell.detailTextLabel.text = @"未认证";
        }
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"信用等级";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"credit_lvl"]];
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"投资等级";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"invest_lvl"]];
    }
    
    return cell;
}

//=================================================================
//                       UITableViewDelegate
//=================================================================
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    }return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


@end
