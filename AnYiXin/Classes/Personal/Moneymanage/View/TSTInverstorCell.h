//
//  TSTInverstorCell.h
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSInvertotModel;

@interface TSTInverstorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTime;
@property (weak, nonatomic) IBOutlet UILabel *borrowID;
@property (weak, nonatomic) IBOutlet UILabel *investor_capital;
@property (weak, nonatomic) IBOutlet UILabel *is_auto;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *receive_capital;
@property (weak, nonatomic) IBOutlet UILabel *receive_interest;
@property (weak, nonatomic) IBOutlet UILabel *borrow_name;
@property (weak, nonatomic) IBOutlet UILabel *investor_interest;
@property (weak, nonatomic) IBOutlet UIButton *hetongbtn;

/** 模型 */
@property (nonatomic, strong) TSInvertotModel *inversmodel;

@end
