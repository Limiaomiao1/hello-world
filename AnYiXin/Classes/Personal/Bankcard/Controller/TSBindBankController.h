//
//  TSBindBankController.h
//  CheZhongChou
//
//  Created by TuanShang on 16/5/5.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSBindBankController : UITableViewController

/**
 *  点击了哪个银行 （要绑定的银行）
 */
@property (nonatomic, copy) NSString *bankStr;
@property (nonatomic , assign) NSNumber* type;
@property (nonatomic,strong)NSString *realid;
@end
