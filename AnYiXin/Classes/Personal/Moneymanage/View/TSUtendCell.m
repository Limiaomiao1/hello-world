//
//  TSUtendCell.m
//  Shangdai
//
//  Created by tuanshang on 17/4/25.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSUtendCell.h"
#import "TSUtendModel.h"

@implementation TSUtendCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setUtendModel:(TSUtendModel *)utendModel {
    _utendModel = utendModel;
    
    self.UnameLabel.text = utendModel.borrow_name;
    self.UcapitalLabel.text = [NSString stringWithFormat:@"%.2f元", utendModel.investor_capital.doubleValue];
    self.UinterRateLabel.text = [NSString stringWithFormat:@"%.2f%%", utendModel.borrow_interest_rate.doubleValue];
    self.Udealinelabel.text = [NSString stringWithFormat:@"%@个月",  utendModel.transfer_month];
    self.UreceiveLabel.text = [NSString stringWithFormat:@"%.2f元", utendModel.investor_capital.doubleValue +utendModel.investor_interest.doubleValue];
    self.transferTimeLabel.text = [self timeDataWithTimeStr:utendModel.deadline];
    self.UaddTimeLabel.text = [self timeDataWithTimeStr:utendModel.add_time];
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
