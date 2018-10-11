//
//  TSTeGoldCell.h
//  Shangdai
//
//  Created by tuanshang on 17/4/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSTeGoldModel;

typedef void(^GetGoldAction)(void);


@interface TSTeGoldCell : UITableViewCell

/** block */
@property (nonatomic, copy) GetGoldAction didgetgoldAction;

@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *goldName;
@property (weak, nonatomic) IBOutlet UILabel *goldRate;
@property (weak, nonatomic) IBOutlet UILabel *shoujiTag;
@property (weak, nonatomic) IBOutlet UILabel *realNameTag;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailTag;
@property (weak, nonatomic) IBOutlet UILabel *daishouTag;

/** 特权金列表 */
@property (nonatomic, strong) TSTeGoldModel *tegoldModel;

@end
