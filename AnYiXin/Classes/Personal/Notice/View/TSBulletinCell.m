//
//  TSBulletinCell.m
//  ZhuoJin
//
//  Created by tuanshang on 17/2/15.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSBulletinCell.h"
#import "TSBulletinModel.h"

@implementation TSBulletinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setBulletinModel:(TSBulletinModel *)bulletinModel {
    _bulletinModel = bulletinModel;
   
    self.timeLabel.text = bulletinModel.art_time;
    self.titleLabel.text = bulletinModel.title;
}



@end
