//
//  TSInverstorLowCell.m
//  Shangdai
//
//  Created by tuanshang on 17/4/12.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSInverstorLowCell.h"
#import "TSInvertotModel.h"

@implementation TSInverstorLowCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setInversmodel:(TSInvertotModel *)inversmodel {
    _inversmodel = inversmodel;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@", inversmodel.add_time];
    self.titleLabel.text =  [NSString stringWithFormat:@"%@",inversmodel.borrow_name];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", inversmodel.investor_capital.doubleValue];
    
}

@end
