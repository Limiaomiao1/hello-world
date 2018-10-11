//
//  TSDebtDetailCell.h
//  Shangdai
//
//  Created by tuanshang on 17/2/28.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSDebtDetailModel;
@class TSDebtModel;

@interface TSDebtDetailCell : UITableViewCell

@property (nonatomic, strong)TSDebtDetailModel * debtDetailModel;
/** 债权模型 */
@property (nonatomic, strong)TSDebtModel * debtModel;

@property (weak, nonatomic) IBOutlet UILabel *debtName;
@property (weak, nonatomic) IBOutlet UILabel *interestRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearRate;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *daishouLabel;

@end
