//
//  TSTransListCell.m
//  TuanShang
//
//  Created by tuanshang on 16/9/12.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSTransListCell.h"

#import "TSInverListModel.h"

@implementation TSTransListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setUpSubViews];
    }
    
    return self;
    
}

- (void)setUpSubViews {
    
    UILabel * label1 = [[UILabel alloc]init];
    label1.text = @"投资时间";
    label1.numberOfLines = 0;
    [label1 setFont:[UIFont systemFontOfSize:12]];
    label1.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [self.contentView addSubview:label1];
    self.addtime = label1;
    
//    UILabel * label2 = [[UILabel alloc]init];
//    label2.text = @"投资类型";
//    [label2 setFont:[UIFont systemFontOfSize:12]];
//    label2.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
//    [self.contentView addSubview:label2];
//    self.isauto = label2;
    
    UILabel * label3 = [[UILabel alloc]init];
    label3.text = @"投资金额";
    [label3 setFont:[UIFont systemFontOfSize:12]];
    label3.numberOfLines = 2;
    label3.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [self.contentView addSubview:label3];
    self.investorcapital = label3;
    
    UILabel * label4 = [[UILabel alloc]init];
    label4.text = @"投资用户";
    [label4 setFont:[UIFont systemFontOfSize:12]];
    label4.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [self.contentView addSubview:label4];
    self.username = label4;
    
    [@[label1, label3, label4] autoAlignViewsToAxis:ALAxisHorizontal];
    NSArray *views = @[label1, label3, label4];
    
    // Match the widths of all the views
    [views autoMatchViewsDimension:ALDimensionWidth];
    [[views firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    UIView *previousView = nil;
    for (UIView *view in views) {
        if (previousView) {
            [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:previousView ];
            [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        }
        previousView = view;
    }
    [[views lastObject] autoPinEdgeToSuperviewEdge:ALEdgeRight];

}

- (void)setTranListModel:(TSInverListModel *)tranListModel {
    
    _tranListModel = tranListModel;
    
    self.addtime.text = [NSString stringWithFormat:@"%@", tranListModel.add_time];
    self.isauto.text = [NSString stringWithFormat:@"%@", tranListModel.is_auto];
    double x1 = [tranListModel.investor_capital doubleValue];
    self.investorcapital.text = [NSString stringWithFormat:@"%.2f", x1];
    self.username.text = [NSString stringWithFormat:@"%@", tranListModel.user_name];

}

@end
