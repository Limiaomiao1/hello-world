//
//  TSBorrowDetailCell.m
//  TuanShang
//
//  Created by tuanshang on 16/9/12.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSBorrowDetailCell.h"
#import "TSBorrowDetailModel.h"

@implementation TSBorrowDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBorrowModel:(TSBorrowDetailModel *)borrowModel {
    _borrowModel = borrowModel;
    
    self.borrow_name.text = [NSString stringWithFormat:@"项目名称:%@",borrowModel.borrow_name];
    self.borrow_type.text = [NSString stringWithFormat:@"借款类型:%@",borrowModel.borrow_type];
    self.borrow_money.text = [NSString stringWithFormat:@"借款金额:%.2f元",borrowModel.borrow_money.doubleValue];
    self.borrow_status.text = [NSString stringWithFormat:@"标的状态:%@",borrowModel.borrow_status_str];
    self.borrow_times.text = [NSString stringWithFormat:@"投标次数:%@次", borrowModel.borrow_times];
    self.add_time.text = [NSString stringWithFormat:@"发布时间:%@", borrowModel.add_time];
    self.progress.text = [NSString stringWithFormat:@"筹集进度:%@%%", borrowModel.progress];
    self.reward_num.text = [NSString stringWithFormat:@"投标奖励:%.2f%%", borrowModel.reward_num.doubleValue];
    self.repayment_type.text = [NSString stringWithFormat:@"还款方式:%@", borrowModel.repayment_type];
    
}
- (IBAction)didDescribeAction:(id)sender {
    if (self.didDescribtn) {
        
        self.didDescribtn();
    }
    TSLog(@"描述");
    
}

@end
