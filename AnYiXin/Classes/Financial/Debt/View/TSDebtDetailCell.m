//
//  TSDebtDetailCell.m
//  Shangdai
//
//  Created by tuanshang on 17/2/28.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSDebtDetailCell.h"
#import "TSDebtDetailModel.h"
#import "TSDebtModel.h"

@implementation TSDebtDetailCell

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
    
    self.debtName.text = [NSString stringWithFormat:@"%@", debtDetailModel.debt_name];
    self.interestRateLabel.text = [NSString stringWithFormat:@"%@%%", debtDetailModel.rate];
    if([debtDetailModel.status isEqualToString:@"1"]) {
        self.yearRate.text = @"还款中";
    } else if ([debtDetailModel.status isEqualToString:@"2"]) {
        self.yearRate.text = @"可转让";
    } else if ([debtDetailModel.status isEqualToString:@"3"]) {
        self.yearRate.text = @"已流标";
    } else if ([debtDetailModel.status isEqualToString:@"4"]) {
        self.yearRate.text = @"已完成";
    }
    
}

- (void)setDebtModel:(TSDebtModel *)debtModel {
    _debtModel = debtModel;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", debtModel.transfer_price.doubleValue];
    self.daishouLabel.text = [NSString stringWithFormat:@"%.2f", debtModel.money.doubleValue];

}






@end
