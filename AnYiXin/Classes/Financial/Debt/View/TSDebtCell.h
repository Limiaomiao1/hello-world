//
//  TSDebtCell.h
//  Shangdai
//
//  Created by tuanshang on 17/2/28.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSDebtModel;

@interface TSDebtCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *borrowName;
@property (weak, nonatomic) IBOutlet UILabel *interestRate;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UILabel *debtMoney;

/** 债权模型 */
@property (nonatomic, strong)TSDebtModel * debtModel;

@end
