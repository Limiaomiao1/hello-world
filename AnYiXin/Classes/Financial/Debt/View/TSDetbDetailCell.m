//
//  TSDetbDetailCell.m
//  TuanShang
//
//  Created by tuanshang on 16/9/13.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSDetbDetailCell.h"
#import "TSDebtDetailModel.h"

@interface TSDetbDetailCell ()

@end

@implementation TSDetbDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDebtDetailModel:(TSDebtDetailModel *)debtDetailModel {
    
    _debtDetailModel = debtDetailModel;
    
    self.debt_name.text = [NSString stringWithFormat:@"债权标名称：%@", debtDetailModel.debt_name];
    double x2 = debtDetailModel.money.doubleValue;

    self.money.text = [NSString stringWithFormat:@"债权总金额：%.2f", x2];
    self.period.text = [NSString stringWithFormat:@"债权期数：%@期/%@期", debtDetailModel.period, debtDetailModel.total_period];
    
    if([debtDetailModel.status isEqualToString:@"1"]) {
        self.status.text = @"(还款中)";
    } else if ([debtDetailModel.status isEqualToString:@"2"]) {
        self.status.text = @"(可转让)";
    } else if ([debtDetailModel.status isEqualToString:@"3"]) {
        self.status.text = @"(已流标)";
    } else if ([debtDetailModel.status isEqualToString:@"4"]) {
        self.status.text = @"(已完成)";
    }
    
    self.rate.text = [NSString stringWithFormat:@"债权标利率：%@%%", debtDetailModel.rate];
    double x1 = debtDetailModel.transfer_price.doubleValue;
    self.transfer_price.text = [NSString stringWithFormat:@"债权标出售金额：%.2f", x1];
    self.valid.text = [NSString stringWithFormat:@"购买截止日期：%@", debtDetailModel.valid];
    self.borrow_user.text = [NSString stringWithFormat:@"债权标的原始借款人用户名：%@", debtDetailModel.borrow_user];
    
}


@end
