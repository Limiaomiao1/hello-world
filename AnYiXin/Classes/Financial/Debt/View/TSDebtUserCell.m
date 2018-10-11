//
//  TSDebtUserCell.m
//  TuanShang
//
//  Created by tuanshang on 16/9/13.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSDebtUserCell.h"
#import "TSDebtDetailModel.h"


@implementation TSDebtUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

-(void)setDebtDetailModel:(TSDebtDetailModel *)debtDetailModel {
    
    self.invest_user.text = [NSString stringWithFormat:@"发布人用户名：%@", debtDetailModel.invest_user];
    self.credits.text = [NSString stringWithFormat:@"发布人信用积分：%@", debtDetailModel.credits];
    self.level.text = [NSString stringWithFormat:@"发布人的信用等级：%@", debtDetailModel.level];
  
    if ([debtDetailModel.email_status isEqualToString:@"1"]) {
        self.email_status.text = @"发布人的邮箱认证状态：已认证";
    } else {
        self.email_status.text = @"发布人的邮箱认证状态：未认证";
    }
    
    if ([debtDetailModel.id_status isEqualToString:@"1"]) {
        self.id_status.text = @"发布人的身份认证状态：已认证";
    } else {
        self.id_status.text = @"发布人的身份认证状态：未认证";
    }
    
    if ([debtDetailModel.phone_status isEqualToString:@"1"]) {
        self.phone_status.text = @"发布人的手机认证状态：已认证";
    } else {
        self.phone_status.text = @"发布人的手机认证状态：未认证";
    }

}

@end
