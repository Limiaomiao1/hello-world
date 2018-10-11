//
//  TSMyGoldListCell.h
//  Shangdai
//
//  Created by tuanshang on 17/4/24.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSMygoldModel;

@interface TSMyGoldListCell : UITableViewCell

/** 我的特权金 */
@property (nonatomic, strong) TSMygoldModel *mygoldModel;

@property (weak, nonatomic) IBOutlet UILabel *tqjRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tqjTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tqjNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tqjMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tqjImageTag;

@end
