//
//  TSJiaxiCell.h
//  ZhuoJin
//
//  Created by tuanshang on 17/1/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSJiaxiModel;

@interface TSJiaxiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UIView *smallBack;
/** 模型 */
@property (nonatomic, strong) TSJiaxiModel *jiaxiModel;

@property (weak, nonatomic) IBOutlet UILabel *interestLalel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *miaoshuLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
