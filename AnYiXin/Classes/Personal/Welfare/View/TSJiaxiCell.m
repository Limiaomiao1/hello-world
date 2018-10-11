//
//  TSJiaxiCell.m
//  ZhuoJin
//
//  Created by tuanshang on 17/1/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSJiaxiCell.h"
#import "TSJiaxiModel.h"



@implementation TSJiaxiCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
//    self.backview.backgroundColor = COLOR_MainColor;
    self.backview.layer.shadowColor=[[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
    self.backview.layer.shadowOffset=CGSizeMake(1,1);
    self.backview.layer.shadowOpacity=0.2;
    self.backview.layer.shadowRadius=4;
    self.backview.layer.cornerRadius =4;
    self.backview.layer.masksToBounds = YES;
//    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.backview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];
//    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
//    maskLayer1.frame = self.backview.bounds;
//    maskLayer1.path = maskPath1.CGPath;
//    self.backview.layer.mask = maskLayer1;
//    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.smallBack.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.smallBack.bounds;
    maskLayer.path = maskPath.CGPath;
    self.smallBack.layer.mask = maskLayer;
    TSLog(@"%@", NSStringFromCGRect(self.smallBack.bounds));

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setJiaxiModel:(TSJiaxiModel *)jiaxiModel {
    _jiaxiModel = jiaxiModel;
    
    self.interestLalel.text = [NSString stringWithFormat:@"%@%%",jiaxiModel.interest_rate];
    self.nameLabel.text = [NSString stringWithFormat:@"%@", jiaxiModel.title];
    self.statusLabel.text = [NSString stringWithFormat:@"投资期限范围:%@-%@个月", jiaxiModel.min_duration, jiaxiModel.max_duration];
    if([jiaxiModel.deadline isEqualToString:@"2145888000"]) {
        self.deadlineLabel.text = @"截止时间:永久有效";
    } else {
        self.deadlineLabel.text = [NSString stringWithFormat:@"截止时间:%@", [self timeDataWithTimeStr:jiaxiModel.deadline]];
    }
    self.miaoshuLabel.text = [NSString stringWithFormat:@"最小投资金额:%@元",jiaxiModel.min_invest_money];
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



@end
