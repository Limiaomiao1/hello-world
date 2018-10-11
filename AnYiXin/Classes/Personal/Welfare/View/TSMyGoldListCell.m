//
//  TSMyGoldListCell.m
//  Shangdai
//
//  Created by tuanshang on 17/4/24.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSMyGoldListCell.h"
#import "TSMygoldModel.h"
#import "NSString+Extensions.h"

@implementation TSMyGoldListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setMygoldModel:(TSMygoldModel *)mygoldModel {
    _mygoldModel = mygoldModel;
    
    self.tqjNameLabel.text = mygoldModel.title;
    self.tqjTimeLabel.text = [NSString stringWithFormat:@"有效时间：%@至%@", [mygoldModel.get_time timeDataWithTimeStr], [mygoldModel.over_time timeDataWithTimeStr]];
    self.tqjMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",mygoldModel.tqj_money.doubleValue];
    if ([mygoldModel.tqj_status isEqualToString:@"1"]) {
        self.tqjImageTag.image = [UIImage imageNamed:@"tqj_tag_going"];
    } else {
        self.tqjImageTag.image = [UIImage imageNamed:@"tqj_tag_comp"];
    }
    self.tqjRateLabel.text = [NSString stringWithFormat:@"%@%%", mygoldModel.tqj_rate];
    
    if (ScreenInch5S) {
        self.tqjTimeLabel.font = FONT(10);
        self.tqjMoneyLabel.font = FONT(17);
    } else {
        self.tqjTimeLabel.font = FONT(12);
        self.tqjMoneyLabel.font = FONT(21);
    }
}


@end
