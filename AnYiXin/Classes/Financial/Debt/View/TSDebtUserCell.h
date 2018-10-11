//
//  TSDebtUserCell.h
//  TuanShang
//
//  Created by tuanshang on 16/9/13.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSDebtDetailModel;
@interface TSDebtUserCell : UITableViewCell

@property (nonatomic, strong)TSDebtDetailModel * debtDetailModel;

@property (weak, nonatomic) IBOutlet UILabel *invest_user;
@property (weak, nonatomic) IBOutlet UILabel *credits;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *email_status;
@property (weak, nonatomic) IBOutlet UILabel *id_status;
@property (weak, nonatomic) IBOutlet UILabel *phone_status;

@end
