//
//  MineBankController.m
//  CheZhongChou
//
//  Created by fjw on 16/5/4.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import "MineBankController.h"
#import "TSBankInfo.h"
#import "TSBindBankController.h"


#import <MJExtension.h>

@interface MineBankController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) NSMutableDictionary * dataDic;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

/** 银行卡号 */
@property (nonatomic, copy) NSString *banknum;

@end

@implementation MineBankController

#pragma mark - 懒加载

- (NSMutableDictionary *)dataDic {
    if (_dataDic == nil) {
        _dataDic = [NSMutableDictionary dictionary];
    }return _dataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的银行卡";
    self.tableview.scrollEnabled = NO;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.commitButton setBackgroundColor:COLOR_MainColor];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self loadDataArr];
}

- (void)loadDataArr {
    // 请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    // self的弱引用
    TSWeakSelf;
   [[TSNetwork shareNetwork] postRequestResult:params url:@"bank_card_info"  successBlock:^(id responseBody) {
       NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
       if ([eventStr isEqualToString:@"88"]) {
           weakSelf.dataDic = [responseBody[@"data"] mj_JSONObject];
           NSString *bankNum = [NSString stringWithFormat:@"%@", responseBody[@"data"][@"bank_num"]];
           if (bankNum.length == 16) {
               NSString *str = [responseBody[@"data"][@"bank_num"] substringWithRange:NSMakeRange(0, 12)];
               
               //字符串的替换
               NSString * b = [responseBody[@"data"][@"bank_num"] stringByReplacingOccurrencesOfString:str withString:@"**** **** **** "];
               self.banknum = b;
           } else  if (bankNum.length == 17){
               NSString *str = [responseBody[@"data"][@"bank_num"] substringWithRange:NSMakeRange(0, 13)];
               
               //字符串的替换
               NSString * b = [responseBody[@"data"][@"bank_num"] stringByReplacingOccurrencesOfString:str withString:@"**** **** **** "];
               self.banknum = b;

           } else  if (bankNum.length == 18){
               NSString *str = [responseBody[@"data"][@"bank_num"] substringWithRange:NSMakeRange(0, 14)];
               
               //字符串的替换
               NSString * b = [responseBody[@"data"][@"bank_num"] stringByReplacingOccurrencesOfString:str withString:@"**** **** **** "];
               self.banknum = b;
           } else  if (bankNum.length == 19){
               NSString *str = [responseBody[@"data"][@"bank_num"] substringWithRange:NSMakeRange(0, 15)];
               
               //字符串的替换
               NSString * b = [responseBody[@"data"][@"bank_num"] stringByReplacingOccurrencesOfString:str withString:@"**** **** **** "];
               self.banknum = b;

           } else {
               self.banknum = @"银行卡号查询失败";
           }
           [weakSelf.tableview reloadData];
       } else {
           [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
       }
   } failureBlock:^(NSString *error) {
       [DZStatusHud showToastWithTitle:error complete:nil];
   }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"户主姓名: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"real_name"]];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"银行名称 : %@", [self.dataDic objectForKey:@"bank_name_str"]];
    } else if (indexPath.row == 2) {
        cell.textLabel.text =[NSString stringWithFormat: @"卡号 : %@",self.banknum] ;
    }
    
    return cell;
    
}

- (IBAction)didChangeBank:(id)sender {
    
    TSBindBankController *CV = [[TSBindBankController alloc] init];
    CV.type = @(1);
    CV.navigationItem.title = @"修改银行卡";
    [self.navigationController pushViewController:CV animated:YES];
    
}


@end
