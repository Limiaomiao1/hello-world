//
//  POSModel.h
//  AnYiXin
//
//  Created by Mac on 17/8/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POSModel : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
/** 状态 */
@property (nonatomic, copy) NSString *status;
/** 时间 */
@property (nonatomic, copy) NSString *add_time;
/** 金额 */
@property (nonatomic, copy) NSString *money;
/** 充值码 */
@property (nonatomic, copy) NSString *tran_id;

@end
