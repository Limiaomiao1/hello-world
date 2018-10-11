//
//  TSMygoldSummaryCell.h
//  Shangdai
//
//  Created by tuanshang on 17/4/25.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSTqjSummaryModel;

@interface TSMygoldSummaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *getTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tqjMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *earningLabel;

/** 特权金记录model */
@property (nonatomic, strong) TSTqjSummaryModel *tqjSummaryModel;


@end
