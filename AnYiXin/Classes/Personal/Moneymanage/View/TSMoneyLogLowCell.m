//
//  TSMoneyLogLowCell.m
//  Shangdai
//
//  Created by tuanshang on 17/4/12.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSMoneyLogLowCell.h"
#import "TSMoneyLogModel.h"

@implementation TSMoneyLogLowCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)setMoneylogModel:(TSMoneyLogModel *)moneylogModel {
    _moneylogModel = moneylogModel;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@", moneylogModel.add_time];
    
    if (moneylogModel.affect_money.doubleValue > 0) {
        self.moneyLabel.textColor = [UIColor redColor];
        self.moneyLabel.text = [NSString stringWithFormat:@"+%.2f", moneylogModel.affect_money.doubleValue];
    } else {
        self.moneyLabel.textColor = [UIColor blackColor];
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", moneylogModel.affect_money.doubleValue];
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@", moneylogModel.type];
    
}

@end
