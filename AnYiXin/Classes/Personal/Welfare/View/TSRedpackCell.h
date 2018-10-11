//
//  TSRedpackCell.h
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSRedpackModel;

@interface TSRedpackCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *redStrLabel;
@property (weak, nonatomic) IBOutlet UILabel *reddeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *redTypeLabel;

/** 模型 */
@property (nonatomic, strong) TSRedpackModel *redpackmodel;

@end
