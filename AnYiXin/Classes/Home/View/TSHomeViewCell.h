//
//  TSHomeViewCell.h
//  Shangdai
//
//  Created by tuanshang on 17/2/13.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSRecommendModel;

typedef void(^DidGoBuyButtonBlock) (void);

@interface TSHomeViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *borrowName;
@property (weak, nonatomic) IBOutlet UILabel *borrowInterest;
@property (weak, nonatomic) IBOutlet UILabel *borrowDuration;
@property (weak, nonatomic) IBOutlet UILabel *borrowMoney;
@property (weak, nonatomic) IBOutlet UILabel *borrowProgress;
@property (weak, nonatomic) IBOutlet UIButton *goBuyButton;

@property (nonatomic, copy)  DidGoBuyButtonBlock didGoBuyButton;
@property (strong, nonatomic) TSRecommendModel * recommendModel;


@end
