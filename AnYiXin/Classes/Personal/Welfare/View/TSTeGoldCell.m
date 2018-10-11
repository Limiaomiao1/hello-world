//
//  TSTeGoldCell.m
//  Shangdai
//
//  Created by tuanshang on 17/4/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSTeGoldCell.h"
#import "TSTeGoldModel.h"

@implementation TSTeGoldCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setTegoldModel:(TSTeGoldModel *)tegoldModel {
    _tegoldModel = tegoldModel;
    
    self.goldName.text = tegoldModel.name;
    self.goldRate.text = [NSString stringWithFormat:@"%.2f", tegoldModel.rate.doubleValue];
    self.addTimeLabel.text = [NSString stringWithFormat:@"开始时间:%@", tegoldModel.begin_time];
    self.endTimeLabel.text = [NSString stringWithFormat:@"结束时间:%@", tegoldModel.over_time];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", tegoldModel.money.doubleValue];
    if ([tegoldModel.tqj_status isEqualToString:@"1"]) {
        [self.payButton setTitle:@"领取" forState:UIControlStateNormal];
        [self.payButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.payButton.enabled = YES;
    } else {
        [self.payButton setTitle:@"已结束" forState:UIControlStateNormal];
        [self.payButton setTitleColor:COLOR_Text_GrayColor forState:UIControlStateNormal];
        self.payButton.enabled = NO;
    }
    
    if (ScreenInch5S) {
        self.shoujiTag.font = FONT(9);
        self.realNameTag.font = FONT(9);
        self.emailTag.font = FONT(9);
    } else {
        self.shoujiTag.font = FONT(11);
        self.realNameTag.font = FONT(11);
        self.emailTag.font = FONT(11);
    }
    
    if (ScreenInch5S) {
        self.daishouTag.font = FONT(9);
        self.moneyLabel.font = FONT(13);
    } else {
        self.moneyLabel.font = FONT(14);
        self.daishouTag.font = FONT(11);
    }
    
    //=================================================================
    //                              三大认证分割线
    //=================================================================
    
    if ([tegoldModel.shouji isEqualToString:@"手机认证"]) {
        self.shoujiTag.hidden = NO;
        self.shoujiTag.text = @"手机认证";
        if ([tegoldModel.shiming isEqualToString:@"实名认证"]) {
            self.realNameTag.hidden = NO;
            self.realNameTag.text = @"实名认证";
            if([tegoldModel.youxiang isEqualToString:@"邮箱认证"]) {
                self.emailTag.hidden = NO;
                self.emailTag.text = @"邮箱认证";
            } else {
                self.emailTag.hidden = YES;
            }
        } else {
            self.emailTag.hidden = YES;
            if([tegoldModel.youxiang isEqualToString:@"邮箱认证"]) {
                self.realNameTag.hidden = NO;
                self.realNameTag.text = @"邮箱认证";
            } else {
                self.realNameTag.hidden = YES;
            }
        }
    } else {
        if ([tegoldModel.shiming isEqualToString:@"实名认证"]) {
            self.shoujiTag.text = @"实名认证";
            self.shoujiTag.hidden = NO;
            if([tegoldModel.youxiang isEqualToString:@"邮箱认证"]) {
                self.realNameTag.hidden = NO;
                self.realNameTag.text = @"邮箱认证";
            } else {
                self.realNameTag.hidden = YES;
            }
        } else {
            if([tegoldModel.youxiang isEqualToString:@"邮箱认证"]) {
                self.shoujiTag.hidden = NO;
                self.shoujiTag.text = @"邮箱认证";
            } else {
                self.shoujiTag.hidden = YES;
            }
            self.realNameTag.hidden = YES;
        }
        self.emailTag.hidden = YES;
    }
    //=================================================================
    //                            待收本金认证  分割线
    //=================================================================

    if ([tegoldModel.daishou isEqualToString:@"待收本金"]) {
        self.daishouTag.hidden = NO;
        self.daishouTag.text = [NSString stringWithFormat:@"待收：%@元",tegoldModel.status_due_money];
    } else {
        self.daishouTag.hidden = YES;
    }
    
    
    
}

- (IBAction)didgetGoldButton:(UIButton *)sender {
    if (self.didgetgoldAction) {
        self.didgetgoldAction();
    }
}

@end
