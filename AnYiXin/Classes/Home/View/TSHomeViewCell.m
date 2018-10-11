//
//  TSHomeViewCell.m
//  Shangdai
//
//  Created by tuanshang on 17/2/13.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSHomeViewCell.h"
#import "TSRecommendModel.h"

@implementation TSHomeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.goBuyButton setBackgroundColor:COLOR_MainColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setRecommendModel:(TSRecommendModel *)recommendModel {
    _recommendModel = recommendModel;
    if (recommendModel != nil) {
        
        self.borrowInterest.text = [NSString stringWithFormat:@"%@",recommendModel.borrow_interest_rate];
        self.borrowName.text = [NSString stringWithFormat:@"%@", recommendModel.borrow_name];
        self.borrowMoney.text = [NSString stringWithFormat:@"投资总额:%@元",recommendModel.borrow_money];
        if (ScreenInch5S) {
            self.borrowMoney.font = FONT(10);
        } else {
            self.borrowMoney.font = FONT(11);
        }
        if ([recommendModel.repayment_type isEqualToString:@"1"]) {
            self.borrowDuration.text = [NSString stringWithFormat:@"投资期限:%@天", recommendModel.borrow_duration];

        } else {
            
            self.borrowDuration.text = [NSString stringWithFormat:@"投资期限:%@个月", recommendModel.borrow_duration];
        }
        self.borrowProgress.text = [NSString stringWithFormat:@"投资进度:%@%%", recommendModel.progress];
        self.goBuyButton.alpha = 1;
        self.goBuyButton.enabled = YES;
        if (recommendModel.borrow_status == 0) {//按钮状态
            [self.goBuyButton setTitle:@"初审待审核" forState:UIControlStateNormal];
            [self.goBuyButton setBackgroundColor:COLOR_Text_GrayColor];
        } else if(recommendModel.borrow_status == 1){
            [self.goBuyButton setTitle:@"初审未通过" forState:UIControlStateNormal];
            [self.goBuyButton setBackgroundColor:COLOR_Text_GrayColor];
        } else if(recommendModel.borrow_status == 2){
            [self.goBuyButton setTitle:@"立即加入" forState:UIControlStateNormal];
            [self.goBuyButton setBackgroundColor:COLOR_MainColor];
        } else if(recommendModel.borrow_status == 3){
            [self.goBuyButton setTitle:@"流标" forState:UIControlStateNormal];
            [self.goBuyButton setBackgroundColor:COLOR_Text_GrayColor];
        } else if(recommendModel.borrow_status == 4){
            [self.goBuyButton setTitle:@"复审中" forState:UIControlStateNormal];
            [self.goBuyButton setBackgroundColor:COLOR_Text_GrayColor];
        } else if(recommendModel.borrow_status == 5){
            [self.goBuyButton setTitle:@"复审未通过" forState:UIControlStateNormal];
            [self.goBuyButton setBackgroundColor:COLOR_Text_GrayColor];
        } else if(recommendModel.borrow_status == 6){
            [self.goBuyButton setTitle:@"还款中" forState:UIControlStateNormal];
            [self.goBuyButton setBackgroundColor:COLOR_Text_GrayColor];
        } else if(recommendModel.borrow_status == 7){
            [self.goBuyButton setTitle:@"已完成" forState:UIControlStateNormal];
            [self.goBuyButton setBackgroundColor:COLOR_Text_GrayColor];
        } else if(recommendModel.borrow_status == 8){
            [self.goBuyButton setTitle:@"已逾期" forState:UIControlStateNormal];
            [self.goBuyButton setBackgroundColor:COLOR_Text_GrayColor];
        } else if(recommendModel.borrow_status == 9){
            [self.goBuyButton setTitle:@"已完成" forState:UIControlStateNormal];
            [self.goBuyButton setBackgroundColor:COLOR_Text_GrayColor];
        } else {
            [self.goBuyButton setTitle:@"逾期还款" forState:UIControlStateNormal];
            [self.goBuyButton setBackgroundColor:COLOR_Text_GrayColor];
        }

    } else {
        self.borrowInterest.text = @"0.00";
        self.borrowName.text = @"暂无推荐项目";
        self.borrowMoney.text = @"投资总额:0.00元";
        self.borrowDuration.text = @"投资期限:0个月";
        self.borrowProgress.text = @"投资进度:0.00%";
        self.goBuyButton.alpha = 0.5;
        self.goBuyButton.enabled = NO;
    }
}

- (IBAction)didTouziAction:(id)sender {
    if(self.didGoBuyButton) {
        self.didGoBuyButton();
    }
}

@end
