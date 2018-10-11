//
//  TSTransListCell.h
//  TuanShang
//
//  Created by tuanshang on 16/9/12.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSInverListModel;

@interface TSTransListCell : UITableViewCell

@property (nonatomic, strong)TSInverListModel * tranListModel;

@property (nonatomic, strong)UILabel * addtime;
@property (nonatomic, strong)UILabel * investorcapital;
@property (nonatomic, strong)UILabel * isauto;
@property (nonatomic, strong)UILabel * username;

@end
