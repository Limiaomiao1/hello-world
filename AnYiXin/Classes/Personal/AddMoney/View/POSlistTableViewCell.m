//
//  POSlistTableViewCell.m
//  AnYiXin
//
//  Created by Mac on 17/8/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//
 #import "POSlistTableViewCell.h"

@implementation POSlistTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setPosmodel:(POSModel *)posmodel
{
    _posmodel = posmodel;
    _timeL.text = _posmodel.add_time;
    _statusL.text = [NSString stringWithFormat:@"充值状态：%@",_posmodel.status];
    _MONETL.text = [NSString stringWithFormat:@"金额：%@",_posmodel.money];
    _codel.text = [NSString stringWithFormat:@"充值码：%@",_posmodel.tran_id];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
