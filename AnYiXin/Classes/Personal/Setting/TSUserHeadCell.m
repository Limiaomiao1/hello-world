//
//  TSUserHeadCell.m
//  CheZhongChou
//
//  Created by TuanShang on 16/5/6.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import "TSUserHeadCell.h"

@implementation TSUserHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
