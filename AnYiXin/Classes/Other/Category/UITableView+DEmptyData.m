//
//  UITableView+XNEmptyData.m
//  NICHelper
//
//  Created by mac on 16/5/3.
//  Copyright © 2016年 YXD. All rights reserved.
//

#import "UITableView+DEmptyData.h"

@implementation UITableView (DEmptyData)


- (void)tableViewDisplayWithMsg:(NSString *)message ifNecessaryForRowCount:(NSUInteger)rowCount
{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        self.backgroundColor =  [UIColor whiteColor];
        UIView * view = [[UIView alloc]initWithFrame:self.bounds];
        UIImageView * backgroundView = [[UIImageView alloc]init];
        backgroundView.image = [UIImage imageNamed:@"icon_empty"];
        [view addSubview:backgroundView];

        UILabel *messageLabel = [UILabel new];
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        [view addSubview:messageLabel];
       
        [backgroundView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [backgroundView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:view.height*0.35];
        [backgroundView autoSetDimensionsToSize:CGSizeMake(150, 150)];

        [messageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:backgroundView withOffset:30];
        [messageLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];

        self.backgroundView = view;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

@end
