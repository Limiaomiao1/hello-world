//
//  TSTeGoldModel.h
//  Shangdai
//
//  Created by tuanshang on 17/4/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSTeGoldModel : NSObject
/** 开始时间 */
@property (nonatomic, copy) NSString *begin_time;
/** 代收本金（领取条件） */
@property (nonatomic, copy) NSString *daishou;
/** 特权金id */
@property (nonatomic, copy) NSString *ID;
/** 特权金额 */
@property (nonatomic, copy) NSString *money;
/** 特权金名字 */
@property (nonatomic, copy) NSString *name;
/** 结束时间 */
@property (nonatomic, copy) NSString *over_time;
/** 年利率 */
@property (nonatomic, copy) NSString *rate;
/** 实名认证领取条件 */
@property (nonatomic, copy) NSString *shiming;
/** 手机领取条件 */
@property (nonatomic, copy) NSString *shouji;
/** 收益状态 */
@property (nonatomic, copy) NSString *tqj_status;
/** 邮箱认证 */
@property (nonatomic, copy) NSString *youxiang;
/** 收益次数 */
@property (nonatomic, copy) NSString *biggest;
/** 待收金额 */
@property (nonatomic, copy) NSString *status_due_money;
@end
