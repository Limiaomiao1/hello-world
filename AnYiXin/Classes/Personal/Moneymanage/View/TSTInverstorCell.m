//
//  TSTInverstorCell.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSTInverstorCell.h"
#import "TSInvertotModel.h"

@implementation TSTInverstorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInversmodel:(TSInvertotModel *)inversmodel {
    _inversmodel = inversmodel;
    
    self.addTime.text = [NSString stringWithFormat:@"%@", inversmodel.add_time];
    self.borrowID.text =  [NSString stringWithFormat:@"%@	",inversmodel.borrow_id];
    self.borrow_name.text =  [NSString stringWithFormat:@"%@	",inversmodel.borrow_name];
    self.IDLabel.text = [NSString stringWithFormat:@"%@", inversmodel.borrow_id];
    self.investor_capital.text = [NSString stringWithFormat:@"%@", inversmodel.investor_capital];
    self.investor_interest.text = [NSString stringWithFormat:@"%@",inversmodel.investor_interest];
    
    if ([inversmodel.is_auto isEqualToString:@"0"]) {
        self.is_auto.text = @"否";
    } else {
        self.is_auto.text = @"是";
    }    
    self.rate.text = [NSString stringWithFormat:@"%@%%",inversmodel.rate];
    self.receive_capital.text = [NSString stringWithFormat:@"%@",inversmodel.receive_capital];
    self.receive_interest.text = [NSString stringWithFormat:@"%@",inversmodel.receive_interest];
    
}


@end
