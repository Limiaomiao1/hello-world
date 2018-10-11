//
//  RedPacketTableViewCell.m
//  AnYiXin
//
//  Created by Mac on 17/8/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "RedPacketTableViewCell.h"
#import "RedPacketModel.h"
@implementation RedPacketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setRedpackModel:(RedPacketModel *)redpackModel
{
   _redpackModel = redpackModel;
    
    self.moneyLalel.text = [NSString stringWithFormat:@"%@",redpackModel.rmoney];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@", redpackModel.title];
    self.onlineLabel.text = [NSString stringWithFormat:@"开始时间:%@", [self timeDataWithTimeStr:redpackModel.online_time]];
    self.onlineLabel.text = [NSString stringWithFormat:@"投资期限范围:%@-%@个月", redpackModel.min_duration, redpackModel.max_duration];

    if([redpackModel.dead_time isEqualToString:@"2145888000"]) {
        self.deadlineLabel.text = @"截止时间:永久有效";
    } else {
        self.deadlineLabel.text = [NSString stringWithFormat:@"截止时间:%@", [self timeDataWithTimeStr:redpackModel.dead_time]];
    }
    self.minLabel.text = [NSString stringWithFormat:@"最小投资金额:%@元",redpackModel.min_invest_money];

}

- (NSString *)timeDataWithTimeStr:(NSString *)timeData {
    
    NSDate *datea = [NSDate dateWithTimeIntervalSince1970:[timeData intValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * str = [formatter stringFromDate:datea];
    return str;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
