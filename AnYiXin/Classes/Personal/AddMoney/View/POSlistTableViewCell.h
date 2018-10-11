//
//  POSlistTableViewCell.h
//  AnYiXin
//
//  Created by Mac on 17/8/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POSModel.h"
@interface POSlistTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *MONETL;

@property (weak, nonatomic) IBOutlet UILabel *codel;
@property (nonatomic,strong)POSModel *posmodel;




@end
