//
//  TSBulletinCell.h
//  ZhuoJin
//
//  Created by tuanshang on 17/2/15.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSBulletinModel;

@interface TSBulletinCell : UITableViewCell

/** 公告 */
@property (nonatomic, strong) TSBulletinModel *bulletinModel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
