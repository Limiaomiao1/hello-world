//
//  TSTransDetailCell.m
//  TuanShang
//
//  Created by tuanshang on 16/9/12.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSTransDetailCell.h"

#import "TSTransferDetailModel.h"

@interface TSTransDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *borrowname;
@property (weak, nonatomic) IBOutlet UILabel *borrowstatus;
@property (weak, nonatomic) IBOutlet UILabel *borrowmoney;
@property (weak, nonatomic) IBOutlet UILabel *addtime;
@property (weak, nonatomic) IBOutlet UILabel *onlinetime;
@property (weak, nonatomic) IBOutlet UILabel *borrowprogress;
@property (weak, nonatomic) IBOutlet UILabel *transfertotal;


@end


@implementation TSTransDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}


- (void)setTransferModel:(TSTransferDetailModel *)transferModel {
    _transferModel = transferModel;
    
    self.borrowname.text = [NSString stringWithFormat:@"项目名称：%@ ", transferModel.borrow_name];
    self.borrowstatus.text = [NSString stringWithFormat:@"项目状态：%@ ", transferModel.borrow_status];
    self.borrowmoney.text = [NSString stringWithFormat:@"项目总额：%.2f ", transferModel.borrow_money.doubleValue];
    self.addtime.text = [NSString stringWithFormat:@"添加时间：%@ ", transferModel.add_time];
    self.onlinetime.text = [NSString stringWithFormat:@"项目上线时间：%@ ", transferModel.online_time];
    self.borrowprogress.text = [NSString stringWithFormat:@"项目进度：%@ %%", transferModel.progress];
    self.transfertotal.text = [NSString stringWithFormat:@"项目总份数：%@ 份", transferModel.transfer_total];
    if (transferModel.immediately == 1) {
        self.borrowstatus.text = [NSString stringWithFormat:@"项目状态：即将上线 "];
    } else {
        if([transferModel.borrow_status  isEqual: @2]){
            if ([transferModel.progress isEqual:@100]) {
                self.borrowstatus.text = [NSString stringWithFormat:@"项目状态：还款中 "];
            } else {
                self.borrowstatus.text = [NSString stringWithFormat:@"项目状态：投资中 "];
            }
        } else if([transferModel.borrow_status isEqual:@3]){
            self.borrowstatus.text = [NSString stringWithFormat:@"项目状态：已流标 "];
        } else if([transferModel.borrow_status isEqual:@7]){
            self.borrowstatus.text = [NSString stringWithFormat:@"项目状态：已完成 "];
            
        }
    }

    
}

@end
