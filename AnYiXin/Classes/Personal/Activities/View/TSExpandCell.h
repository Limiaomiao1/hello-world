//
//  TSExpandCell.h
//  Shangdai
//
//  Created by tuanshang on 17/2/19.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSAcitvitModel;

@interface TSExpandCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *partImage;
@property (nonatomic, strong) TSAcitvitModel *acitvitModel;

@end
