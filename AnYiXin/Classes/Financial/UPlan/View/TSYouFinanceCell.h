//
//  TSYouFinanceCell.h
//  Shangdai
//
//  Created by tuanshang on 17/2/18.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSTransferModel;
typedef void(^DidTouziButton)(void);
@interface TSYouFinanceCell : UITableViewCell

// 项目信息
@property (nonatomic, strong)TSTransferModel * transferModel;

/** block */
@property (nonatomic, copy) DidTouziButton didTouziButtonAciton;
@property (weak, nonatomic) IBOutlet UIImageView *statusTagImage;
@property (weak, nonatomic) IBOutlet UILabel *borrowMoney;
@property (weak, nonatomic) IBOutlet UILabel *interstRate;
@property (weak, nonatomic) IBOutlet UILabel *dayDuration;
@property (weak, nonatomic) IBOutlet UILabel *borrowName; 
@property (weak, nonatomic) IBOutlet UILabel *transOut; // 售出
@property (weak, nonatomic) IBOutlet UIButton *uplanButton;

@end
