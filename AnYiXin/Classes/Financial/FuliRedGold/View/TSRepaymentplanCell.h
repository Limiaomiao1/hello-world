//
//  TSRepaymentplanCell.h
//  ZhuoJin
//
//  Created by tuanshang on 17/1/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSRepayPlanModel;

@interface TSRepaymentplanCell : UITableViewCell

/** 还款模型 */
@property (nonatomic, strong) TSRepayPlanModel *planmodel;

@property (nonatomic, strong)UILabel * deadline;
@property (nonatomic, strong)UILabel * capital;
@property (nonatomic, strong)UILabel * interest;
@end
