//
//  TSExpandCell.m
//  Shangdai
//
//  Created by tuanshang on 17/2/19.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSExpandCell.h"
#import "TSAcitvitModel.h"

@implementation TSExpandCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAcitvitModel:(TSAcitvitModel *)acitvitModel {
    if (!_acitvitModel) {
        _acitvitModel = acitvitModel;
    }
    self.title.text = [NSString stringWithFormat:@"活动主题:%@",acitvitModel.event_title];
    self.content.text = [NSString stringWithFormat:@"%@", acitvitModel.event_info];
    [self.partImage sd_setImageWithURL:[NSURL URLWithString:acitvitModel.img_url] placeholderImage:[UIImage imageNamed:@"null_default"]];
}


@end
