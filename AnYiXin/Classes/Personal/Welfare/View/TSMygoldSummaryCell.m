//
//  TSMygoldSummaryCell.m
//  Shangdai
//
//  Created by tuanshang on 17/4/25.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSMygoldSummaryCell.h"
#import "TSTqjSummaryModel.h"

@implementation TSMygoldSummaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setTqjSummaryModel:(TSTqjSummaryModel *)tqjSummaryModel {
    
    _tqjSummaryModel = tqjSummaryModel;
    self.earningLabel.text = [NSString stringWithFormat:@"收益金额：%.2f", tqjSummaryModel.earnings.doubleValue];
    self.getTimeLabel.text = [NSString stringWithFormat:@"发生日期：%@", [self timeDataWithTimeStr: tqjSummaryModel.get_time]];
    self.goldNameLabel.text = [NSString stringWithFormat:@"特权金标题：%@", tqjSummaryModel.title];
    self.tqjMoneyLabel.text = [NSString stringWithFormat:@"特权金金额：%.2f", tqjSummaryModel.tqj_money.doubleValue];
}

- (NSString *)timeDataWithTimeStr:(NSString *)timeData {
    NSDate *datea = [NSDate dateWithTimeIntervalSince1970:[timeData intValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * str = [formatter stringFromDate:datea];
    return str;
}


@end
