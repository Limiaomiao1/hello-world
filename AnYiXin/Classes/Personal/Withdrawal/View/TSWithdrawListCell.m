//
//  TSWithdrawListCell.m
//  TuanShang
//
//  Created by tuanshang on 16/9/3.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSWithdrawListCell.h"

#import "TSWithdrawModel.h"

@interface TSWithdrawListCell ()




@end

@implementation TSWithdrawListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithdrawModel:(TSWithdrawModel *)withdrawModel {
    
    _withdrawModel = withdrawModel;
    
    self.add_time.text = withdrawModel.add_time;
    self.withdraw_money.text = [NSString stringWithFormat:@"%.2f", withdrawModel.withdraw_money.doubleValue];
    self.withdraw_status.text = withdrawModel.withdraw_status;
    
}



@end
