//
//  TSMoneyLogModel.h
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSMoneyLogModel : NSObject

/** 可用余额	 */
@property (nonatomic, copy) NSString *account_money;
/** 添加时间 */
@property (nonatomic, copy) NSString *add_time;
/**	变动金额 */
@property (nonatomic, copy) NSString *affect_money;
/** 回款 */
@property (nonatomic, copy) NSString *back_money;
/** 待收 */
@property (nonatomic, copy) NSString *collect_money;
/** 冻结 */
@property (nonatomic, copy) NSString *freeze_money;
/** id */
@property (nonatomic, copy) NSString *ID;
/** 说明 */
@property (nonatomic, copy) NSString *info;
/** 类型 */
@property (nonatomic, copy) NSString *type;

@end
