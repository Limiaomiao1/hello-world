//
//  TSInverstorLowCell.h
//  Shangdai
//
//  Created by tuanshang on 17/4/12.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSInvertotModel;

@interface TSInverstorLowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/** 模型 */
@property (nonatomic, strong) TSInvertotModel *inversmodel;
@end
