//
//  TSWithdrawListCell.h
//  TuanShang
//
//  Created by tuanshang on 16/9/3.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSWithdrawModel;

@interface TSWithdrawListCell : UITableViewCell

@property (nonatomic, strong) TSWithdrawModel * withdrawModel;

@property (weak, nonatomic) IBOutlet UILabel *add_time;
@property (weak, nonatomic) IBOutlet UILabel *withdraw_money;
@property (weak, nonatomic) IBOutlet UILabel *withdraw_status;

@end
