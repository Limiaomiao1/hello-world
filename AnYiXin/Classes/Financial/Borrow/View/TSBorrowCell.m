//
//  TSBorrowCell.m
//  Shangdai
//
//  Created by tuanshang on 17/2/28.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSBorrowCell.h"
#import "TSBorrowModel.h"

@implementation TSBorrowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setBorrowModel:(TSBorrowModel *)borrowModel {
    _borrowModel = borrowModel;
    self.borrowName.text = [NSString stringWithFormat:@"【%@】", borrowModel.borrow_name];
    self.interstRate.text =  [NSString stringWithFormat:@"%.2f%%", borrowModel.borrow_interest_rate.doubleValue];
    self.dayDuration.text = borrowModel.borrow_duration;
    if ([borrowModel.reward_num integerValue]>0.00) {
        self.jiangli.text = [NSString stringWithFormat:@"+%@%%",borrowModel.reward_num];
    }
    if (borrowModel.borrow_money.doubleValue >= 10000) {
          self.borrowMoney.text = [NSString stringWithFormat:@"项目总额:%.2f万", borrowModel.borrow_money.doubleValue/10000];
    } else {
        self.borrowMoney.text = [NSString stringWithFormat:@"项目总额:%.2f", borrowModel.borrow_money.doubleValue];
    }
    if (ScreenInch5S) {
        self.borrowMoney.font = FONT(11);
    } else {
        self.borrowMoney.font = FONT(12);

    }
    
    
    
    self.hasBorrow.text =  [NSString stringWithFormat:@"已投金额:%.2f元", borrowModel.has_borrow.doubleValue];
   
    if ([borrowModel.borrow_type isEqualToString:@"信用标"]) {
        self.imgType.image = [UIImage imageNamed:@"ic_type_xin"];
    } else if ([borrowModel.borrow_type isEqualToString:@"担保标"]) {
        self.imgType.image = [UIImage imageNamed:@"ic_type_dan"];
    } else if ([borrowModel.borrow_type isEqualToString:@"抵押标"]) {
        self.imgType.image = [UIImage imageNamed:@"ic_type_ya"];
    } else if ([borrowModel.borrow_type isEqualToString:@"净值标"]) {
        self.imgType.image = [UIImage imageNamed:@"ic_type_jing"];
    } else if ([borrowModel.borrow_type isEqualToString:@"秒还标"]) {
        self.imgType.image = [UIImage imageNamed:@"ic_type_miao"];
    }
    
    if (borrowModel.is_new == 1) {
        self.imgNew.image = [UIImage imageNamed:@"ic_type_new"];
        if ([borrowModel.has_pass isEqualToString:@"1"]) {
            self.imgDing.image = [UIImage imageNamed:@"icon_lock"];
            if (borrowModel.reward_num.doubleValue>0) {
                self.imgJiang.image = [UIImage imageNamed:@"icon_jiang"];
                if ([borrowModel.repayment_types isEqualToString:@"1"]) {
                    self.imgTian.image = [UIImage imageNamed:@"ic_type_day"];
                } else {
                    self.imgTian.image =nil;
                }
            } else {
                if ([borrowModel.repayment_types isEqualToString:@"1"]) {
                    self.imgJiang.image = [UIImage imageNamed:@"ic_type_day"];
                } else {
                    self.imgJiang.image =nil;
                }
                self.imgTian.image = nil;
            }
        } else {
            if (borrowModel.reward_num.doubleValue>0) {
                self.imgDing.image = [UIImage imageNamed:@"icon_jiang"];
                if ([borrowModel.repayment_types isEqualToString:@"1"]) {
                    self.imgJiang.image = [UIImage imageNamed:@"ic_type_day"];
                } else {
                    self.imgJiang.image =nil;
                }
            } else {
                if ([borrowModel.repayment_types isEqualToString:@"1"]) {
                    self.imgDing.image = [UIImage imageNamed:@"ic_type_day"];
                } else {
                    self.imgDing.image =nil;
                }
                self.imgJiang.image = nil;
            }
            self.imgTian.image = nil;
        }
        
    } else {
        if ([borrowModel.has_pass isEqualToString:@"1"]) {
            self.imgNew.image = [UIImage imageNamed:@"icon_lock"];
            if (borrowModel.reward_num.doubleValue>0) {
                self.imgDing.image = [UIImage imageNamed:@"icon_jiang"];
                if ([borrowModel.repayment_types isEqualToString:@"1"]) {
                    self.imgJiang.image = [UIImage imageNamed:@"ic_type_day"];
                } else {
                    self.imgJiang.image =nil;
                }
            } else {
                if ([borrowModel.repayment_types isEqualToString:@"1"]) {
                    self.imgDing.image = [UIImage imageNamed:@"ic_type_day"];
                } else {
                    self.imgDing.image =nil;
                }
                self.imgJiang.image = nil;
            }
        } else {
            if (borrowModel.reward_num.doubleValue>0) {
                self.imgNew.image = [UIImage imageNamed:@"icon_jiang"];
                if ([borrowModel.repayment_types isEqualToString:@"1"]) {
                    self.imgDing.image = [UIImage imageNamed:@"ic_type_day"];
                } else {
                    self.imgDing.image =nil;
                }
            } else {
                if ([borrowModel.repayment_types isEqualToString:@"1"]) {
                    self.imgNew.image = [UIImage imageNamed:@"ic_type_day"];
                } else {
                    self.imgNew.image =nil;
                }
                self.imgDing.image =nil;
            }
            self.imgJiang.image = nil;
        }
        self.imgTian.image = nil;
    }

    
    
    if (borrowModel.borrow_status == 7) {
        self.borrowName.textColor = COLOR_Text_GrayColor;
        self.interstRate.textColor = COLOR_Text_GrayColor;
        self.dayDuration.textColor = COLOR_Text_GrayColor;
    } else if (borrowModel.borrow_status == 1) {
        self.borrowName.textColor = COLOR_Text_GrayColor;
        self.interstRate.textColor = COLOR_Text_GrayColor;
        self.dayDuration.textColor = COLOR_Text_GrayColor;
    } else if (borrowModel.borrow_status == 4) {
        self.dayDuration.textColor = COLOR_Text_GrayColor;
        self.borrowName.textColor = COLOR_Text_GrayColor;
        self.interstRate.textColor = COLOR_Text_GrayColor;
    } else if (borrowModel.borrow_status == 6) {
        self.borrowName.textColor = COLOR_Text_GrayColor;
        self.interstRate.textColor = COLOR_Text_GrayColor;
        self.dayDuration.textColor = COLOR_Text_GrayColor;
    }else {
        self.borrowName.textColor = [UIColor blackColor];
        self.interstRate.textColor = [UIColor redColor];
        self.dayDuration.textColor = [UIColor blackColor];
    }
    
    if (borrowModel.borrow_status == 0) {
        [self.borrowButton setTitle:@"初审待审核" forState:UIControlStateNormal];
        [self.borrowButton setBackgroundColor:COLOR_Text_GrayColor];
    } else if(borrowModel.borrow_status == 1){
        [self.borrowButton setTitle:@"初审未通过" forState:UIControlStateNormal];
        [self.borrowButton setBackgroundColor:COLOR_Text_GrayColor];
    } else if(borrowModel.borrow_status == 2){
        [self.borrowButton setTitle:@"立即加入" forState:UIControlStateNormal];
        [self.borrowButton setBackgroundColor:COLOR_MainColor];
    } else if(borrowModel.borrow_status == 3){
        [self.borrowButton setTitle:@"流标" forState:UIControlStateNormal];
        [self.borrowButton setBackgroundColor:COLOR_Text_GrayColor];

    } else if(borrowModel.borrow_status == 4){
        [self.borrowButton setTitle:@"复审中" forState:UIControlStateNormal];
        [self.borrowButton setBackgroundColor:COLOR_Text_GrayColor];

    } else if(borrowModel.borrow_status == 5){
        [self.borrowButton setTitle:@"复审未通过" forState:UIControlStateNormal];
        [self.borrowButton setBackgroundColor:COLOR_Text_GrayColor];

    } else if(borrowModel.borrow_status == 6){
        [self.borrowButton setTitle:@"还款中" forState:UIControlStateNormal];
        [self.borrowButton setBackgroundColor:COLOR_Text_GrayColor];

    } else if(borrowModel.borrow_status == 7){
        [self.borrowButton setTitle:@"已完成" forState:UIControlStateNormal];
        [self.borrowButton setBackgroundColor:COLOR_Text_GrayColor];

    } else if(borrowModel.borrow_status == 8){
        [self.borrowButton setTitle:@"已逾期" forState:UIControlStateNormal];
        [self.borrowButton setBackgroundColor:COLOR_Text_GrayColor];

    } else if(borrowModel.borrow_status == 9){
        [self.borrowButton setTitle:@"已完成" forState:UIControlStateNormal];
        [self.borrowButton setBackgroundColor:COLOR_Text_GrayColor];

    } else {
        [self.borrowButton setTitle:@"逾期还款" forState:UIControlStateNormal];
        [self.borrowButton setBackgroundColor:COLOR_Text_GrayColor];

    }
    
}

- (IBAction)didBorrowButtonAction:(id)sender {
    if (self.didButtonblock) {
        self.didButtonblock();
    }
}



@end
