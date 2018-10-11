//
//  TSRepaymentplanCell.m
//  ZhuoJin
//
//  Created by tuanshang on 17/1/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSRepaymentplanCell.h"
#import "TSRepayPlanModel.h"


@implementation TSRepaymentplanCell

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
    label1.text = @"2017-01-01";
    label1.numberOfLines = 0;
    label1.textAlignment = NSTextAlignmentCenter;
    [label1 setFont:[UIFont systemFontOfSize:12]];
    label1.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [self.contentView addSubview:label1];
    self.deadline = label1;
    
    UILabel * label2 = [[UILabel alloc]init];
    label2.text = @"200";
    [label2 setFont:[UIFont systemFontOfSize:12]];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [self.contentView addSubview:label2];
    self.capital = label2;
    
    UILabel * label3 = [[UILabel alloc]init];
    label3.text = @"200";
    [label3 setFont:[UIFont systemFontOfSize:12]];
    label3.numberOfLines = 2;
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    [self.contentView addSubview:label3];
    self.interest = label3;
    
    [@[label1, label2, label3] autoAlignViewsToAxis:ALAxisHorizontal];
    NSArray *views = @[label1, label2, label3];
    
    // Match the widths of all the views
    [views autoMatchViewsDimension:ALDimensionWidth];
    [[views firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft];
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

- (void)setPlanmodel:(TSRepayPlanModel *)planmodel {
    _planmodel = planmodel;
    
    self.capital.text = planmodel.capital;
    self.interest.text = planmodel.interest;
    self.deadline.text = planmodel.deadline;
    
    
}


@end
