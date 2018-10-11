//
//  TSCityCell.h
//  CheZhongChou
//
//  Created by TuanShang on 16/5/5.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSCityModel;

@interface TSCityCell : UITableViewCell

@property (nonatomic, strong) TSCityModel *cityModel;
@property (nonatomic, copy) NSString * provinceID;
@property (nonatomic, copy) NSString * provinceName;

@end
