//
//  RedPacketTableViewCell.h
//  AnYiXin
//
//  Created by Mac on 17/8/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RedPacketModel;
@interface RedPacketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UIView *smallBack;

/** 模型 */
@property (nonatomic, strong) RedPacketModel *redpackModel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLalel;//红包金额
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;//开始时间
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;//截止时间
@property (weak, nonatomic) IBOutlet UILabel *minLabel;//最下投资金额
@end
