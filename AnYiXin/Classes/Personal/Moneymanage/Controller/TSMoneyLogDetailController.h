//
//  TSMoneyLogDetailController.h
//  Shangdai
//
//  Created by tuanshang on 17/4/12.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMoneyLogModel.h"

@interface TSMoneyLogDetailController : UITableViewController

/** 资金记录 */
@property (nonatomic, strong) TSMoneyLogModel *logModel;

@end
