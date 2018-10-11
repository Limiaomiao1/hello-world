//
//  TSDebtCell.m
//  Shangdai
//
//  Created by tuanshang on 17/2/28.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSDebtCell.h"
#import "TSDebtModel.h"

@implementation TSDebtCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setDebtModel:(TSDebtModel *)debtModel {
    _debtModel = debtModel;
    
    self.borrowName.text = [NSString stringWithFormat:@"【%@】", debtModel.borrow_name];
    self.interestRate.text = [NSString stringWithFormat:@"%.2f%%", debtModel.borrow_interest_rate.doubleValue];
    self.periodLabel.text = [NSString stringWithFormat:@"%@期/%@期", debtModel.period, debtModel.total_period];
    self.debtMoney.text = [NSString stringWithFormat:@"%.2f", debtModel.money.doubleValue];
    if (debtModel.status == 1) {
        self.debtMoney.textColor = COLOR_Text_GrayColor;
        self.borrowName.textColor = COLOR_Text_GrayColor;
        self.interestRate.textColor = COLOR_Text_GrayColor;
        self.periodLabel.textColor = COLOR_Text_GrayColor;
    } else if (debtModel.status == 3) {
        self.debtMoney.textColor = COLOR_Text_GrayColor;
        self.borrowName.textColor = COLOR_Text_GrayColor;
        self.interestRate.textColor = COLOR_Text_GrayColor;
        self.periodLabel.textColor = COLOR_Text_GrayColor;
    } else if (debtModel.status == 4) {
        self.debtMoney.textColor = COLOR_Text_GrayColor;
        self.borrowName.textColor = COLOR_Text_GrayColor;
        self.interestRate.textColor = COLOR_Text_GrayColor;
        self.periodLabel.textColor = COLOR_Text_GrayColor;
    } else if (debtModel.status == 2) {
        self.debtMoney.textColor = [UIColor blackColor];
        self.borrowName.textColor = [UIColor blackColor];
        self.interestRate.textColor = [UIColor redColor];
        self.periodLabel.textColor = [UIColor blackColor];
    }
}


@end
