//
//  TSMoneyLogCell.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/6.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSMoneyLogCell.h"
#import "TSMoneyLogModel.h"


@implementation TSMoneyLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMoneylogModel:(TSMoneyLogModel *)moneylogModel {
    _moneylogModel = moneylogModel;
    /** 余额 */
    double account = moneylogModel.account_money.doubleValue + moneylogModel.back_money.doubleValue;
    
    self.accountLabel.text = [NSString stringWithFormat:@"%.2f", account];
    self.addTime.text = [NSString stringWithFormat:@"%@", moneylogModel.add_time];
    if (moneylogModel.affect_money.doubleValue > 0) {
        self.affectLabel.textColor = [UIColor redColor];
        self.affectLabel.text = [NSString stringWithFormat:@"+%.2f", moneylogModel.affect_money.doubleValue];
    } else {
        self.affectLabel.textColor = [UIColor blackColor];
        self.affectLabel.text = [NSString stringWithFormat:@"%.2f", moneylogModel.affect_money.doubleValue];
    }
//    self.affectLabel.text = [NSString stringWithFormat:@"%@", moneylogModel.affect_money];
    self.backLabel.text = [NSString stringWithFormat:@"%@", moneylogModel.back_money];
    self.collectLabel.text = [NSString stringWithFormat:@"%@", moneylogModel.collect_money];
    self.freezeLabel.text = [NSString stringWithFormat:@"%@", moneylogModel.freeze_money];
    self.IDLabel.text = [NSString stringWithFormat:@"%@", moneylogModel.ID];
    self.infoView.text = [NSString stringWithFormat:@"%@", moneylogModel.info];
    self.typeLabel.text = [NSString stringWithFormat:@"%@", moneylogModel.type];
    
}

@end
