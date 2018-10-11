//
//  TSMoneyLogLowCell.h
//  Shangdai
//
//  Created by tuanshang on 17/4/12.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSMoneyLogModel;

@interface TSMoneyLogLowCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

/** 模型 */
@property (nonatomic, strong) TSMoneyLogModel *moneylogModel;

@end
