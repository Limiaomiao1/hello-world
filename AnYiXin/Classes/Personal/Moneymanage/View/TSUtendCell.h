//
//  TSUtendCell.h
//  Shangdai
//
//  Created by tuanshang on 17/4/25.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSUtendModel;

@interface TSUtendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *UnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *UcapitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *UinterRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *Udealinelabel;
@property (weak, nonatomic) IBOutlet UILabel *UreceiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *UaddTimeLabel;

/** UlistModel */
@property (nonatomic, strong) TSUtendModel *utendModel;

@end
