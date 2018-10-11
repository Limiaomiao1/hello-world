//
//  TSBorrowCell.h
//  Shangdai
//
//  Created by tuanshang on 17/2/28.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSBorrowModel;
typedef void(^ListButtonAction)(void);
@interface TSBorrowCell : UITableViewCell

@property (nonatomic, strong)TSBorrowModel *borrowModel;

/** block */
@property (nonatomic, copy) ListButtonAction didButtonblock;

@property (weak, nonatomic) IBOutlet UILabel *borrowMoney;
@property (weak, nonatomic) IBOutlet UILabel *interstRate;
@property (weak, nonatomic) IBOutlet UILabel *dayDuration;
@property (weak, nonatomic) IBOutlet UILabel *borrowName;
@property (weak, nonatomic) IBOutlet UILabel *hasBorrow; // 售出
@property (weak, nonatomic) IBOutlet UIButton *borrowButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgType;
@property (weak, nonatomic) IBOutlet UIImageView *imgDing;
@property (weak, nonatomic) IBOutlet UIImageView *imgNew;
@property (weak, nonatomic) IBOutlet UIImageView *imgJiang;
@property (weak, nonatomic) IBOutlet UIImageView *imgTian;
@property (weak, nonatomic) IBOutlet UILabel *jiangli;

@end
