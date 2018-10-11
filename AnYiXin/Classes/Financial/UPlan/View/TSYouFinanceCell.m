//
//  TSYouFinanceCell.m
//  Shangdai
//
//  Created by tuanshang on 17/2/18.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSYouFinanceCell.h"
#import "TSTransferModel.h"

@implementation TSYouFinanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setTransferModel:(TSTransferModel *)transferModel {
    _transferModel = transferModel;
    
    self.borrowName.text = [NSString stringWithFormat:@"【%@】",transferModel.borrow_name];
    self.interstRate.text =  [NSString stringWithFormat:@"%.2f%%",transferModel.borrow_interest_rate.doubleValue];
    self.dayDuration.text = transferModel.borrow_duration;
    if (transferModel.borrow_money.doubleValue >= 10000) {
        self.borrowMoney.text = [NSString stringWithFormat:@"项目总额:%.2f万", transferModel.borrow_money.doubleValue/10000];
    } else {
        self.borrowMoney.text = [NSString stringWithFormat:@"项目总额:%.2f", transferModel.borrow_money.doubleValue];
    }
    if (ScreenInch5S) {
        self.borrowMoney.font = FONT(11);
    } else {
        self.borrowMoney.font = FONT(12);
        
    }
    self.transOut.text =  [NSString stringWithFormat:@"已认购%@份",transferModel.transfer_out];
    
    if (transferModel.borrow_status.integerValue == 2) {
      
        if ([transferModel.progress isEqualToString:@"100"]) {
            self.borrowName.textColor = COLOR_Text_GrayColor;
            self.interstRate.textColor = COLOR_Text_GrayColor;
            self.dayDuration.textColor = COLOR_Text_GrayColor;
            self.statusTagImage.image = [UIImage imageNamed:@"icon_finance_gray"];
        } else {
            self.borrowName.textColor = [UIColor blackColor];
            self.interstRate.textColor = [UIColor redColor];
            self.dayDuration.textColor = [UIColor blackColor];
            self.statusTagImage.image = [UIImage imageNamed:@"icon_finance_orange"];
        }
    } else if (transferModel.borrow_status.integerValue == 7) {
        self.borrowName.textColor = COLOR_Text_GrayColor;
        self.interstRate.textColor = COLOR_Text_GrayColor;
        self.dayDuration.textColor = COLOR_Text_GrayColor;
        self.statusTagImage.image = [UIImage imageNamed:@"icon_finance_gray"];
    }else {
        self.borrowName.textColor = [UIColor blackColor];
        self.interstRate.textColor = [UIColor redColor];
        self.dayDuration.textColor = [UIColor blackColor];
        self.statusTagImage.image = [UIImage imageNamed:@"icon_finance_orange"];
    }
    if ([transferModel.online_type isEqualToString:@"1"]) {
        [self.uplanButton setTitle:@"即将上线" forState:UIControlStateNormal];
        [self.uplanButton setBackgroundColor:COLOR_MainColor];
    } else {
        if([transferModel.borrow_status isEqualToString:@"2"]){
            if ([transferModel.progress isEqualToString:@"100"]) {
                [self.uplanButton setTitle:@"还款中" forState:UIControlStateNormal];
                [self.uplanButton setBackgroundColor:COLOR_Text_GrayColor];
                
            } else {
                [self.uplanButton setTitle:@"立即加入" forState:UIControlStateNormal];
                [self.uplanButton setBackgroundColor:COLOR_MainColor];
            }
        } else if([transferModel.borrow_status isEqualToString:@"3"]){
            [self.uplanButton setTitle:@"流标" forState:UIControlStateNormal];
            [self.uplanButton setBackgroundColor:COLOR_Text_GrayColor];
            
        } else if([transferModel.borrow_status isEqualToString:@"7"]){
            [self.uplanButton setTitle:@"已完成" forState:UIControlStateNormal];
            [self.uplanButton setBackgroundColor:COLOR_Text_GrayColor];
        }
    }
}

- (IBAction)didTouziBtnAction:(id)sender {

    if (self.didTouziButtonAciton) {
        self.didTouziButtonAciton();
    }
}

@end
