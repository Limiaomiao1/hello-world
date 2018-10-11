//
//  TSBorrowDetailCell.h
//  TuanShang
//
//  Created by tuanshang on 16/9/12.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSBorrowDetailModel;

typedef void(^DescribeBtnBlock) (void);

@interface TSBorrowDetailCell : UITableViewCell

/** 点击 */
@property (nonatomic, copy) DescribeBtnBlock didDescribtn;

@property (nonatomic, strong)TSBorrowDetailModel * borrowModel;

@property (weak, nonatomic) IBOutlet UILabel *borrow_name;
@property (weak, nonatomic) IBOutlet UILabel *borrow_status;
@property (weak, nonatomic) IBOutlet UILabel *borrow_money;
@property (weak, nonatomic) IBOutlet UILabel *add_time;
@property (weak, nonatomic) IBOutlet UILabel *borrow_times;
@property (weak, nonatomic) IBOutlet UILabel *borrow_type;
@property (weak, nonatomic) IBOutlet UILabel *progress;
@property (weak, nonatomic) IBOutlet UILabel *repayment_type;
@property (weak, nonatomic) IBOutlet UILabel *reward_num;


@end
