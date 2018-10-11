//
//  TSDetbDetailCell.h
//  TuanShang
//
//  Created by tuanshang on 16/9/13.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSDebtDetailModel;

@interface TSDetbDetailCell : UITableViewCell

@property (nonatomic, strong)TSDebtDetailModel * debtDetailModel;

@property (weak, nonatomic) IBOutlet UILabel *borrow_info;
@property (weak, nonatomic) IBOutlet UILabel *debt_name;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *period;
@property (weak, nonatomic) IBOutlet UILabel *total_period;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *transfer_price;
@property (weak, nonatomic) IBOutlet UILabel *valid;
@property (weak, nonatomic) IBOutlet UILabel *borrow_user;



@end
