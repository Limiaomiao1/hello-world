//
//  TSRedpackCell.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSRedpackCell.h"
#import "TSRedpackModel.h"

@implementation TSRedpackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setRedpackmodel:(TSRedpackModel *)redpackmodel {
    _redpackmodel = redpackmodel;

    self.moneyLabel.text = [NSString stringWithFormat:@"￥ %@",redpackmodel.money];
    self.typeLabel.text = [NSString stringWithFormat:@"来源:%@", redpackmodel.name];
    if ([redpackmodel.status isEqualToString:@"1"]) {
        self.redTypeLabel.text = [NSString stringWithFormat:@"特权金状态:可用"];
        self.backView.backgroundColor = COLOR_MainColor;
    } else if ([redpackmodel.status isEqualToString:@"2"]) {
        self.backView.backgroundColor = [UIColor brownColor];
        self.redTypeLabel.text = [NSString stringWithFormat:@"特权金状态:锁定"];
    } else if ([redpackmodel.status isEqualToString:@"3"]) {
        self.backView.backgroundColor = [UIColor brownColor];
        self.redTypeLabel.text = [NSString stringWithFormat:@"特权金状态:已过期"];
    } else if ([redpackmodel.status isEqualToString:@"4"]) {
        self.backView.backgroundColor = [UIColor brownColor];
        self.redTypeLabel.text = [NSString stringWithFormat:@"特权金状态:已使用"];
    }
    
  
    self.redStrLabel.text = [NSString stringWithFormat:@"投资%@元以上可用, %@",redpackmodel.multiple_money, redpackmodel.str];
    self.reddeadlineLabel.text = [NSString stringWithFormat:@"截止日期:%@",redpackmodel.deadline];

}




@end
