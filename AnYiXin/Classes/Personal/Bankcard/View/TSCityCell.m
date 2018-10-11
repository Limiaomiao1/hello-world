//
//  TSCityCell.m
//  CheZhongChou
//
//  Created by TuanShang on 16/5/5.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import "TSCityCell.h"
#import "TSCityModel.h"

@implementation TSCityCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setCityModel:(TSCityModel *)cityModel {
    _cityModel = cityModel;
    
    self.textLabel.text = cityModel.name;
    self.provinceID = cityModel.id;
    self.provinceName = cityModel.name;
}


@end
