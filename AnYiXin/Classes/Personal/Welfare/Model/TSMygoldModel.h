//
//  TSMygoldModel.h
//  Shangdai
//
//  Created by tuanshang on 17/4/25.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSMygoldModel : NSObject

/** 状态 */
@property (nonatomic, copy) NSString *tqj_status;
/** 领取时间 */
@property (nonatomic, copy) NSString *get_time;
/** 结束时间 */
@property (nonatomic, copy) NSString *over_time;
/** 特权金标题 */
@property (nonatomic, copy) NSString *title;
/** 特权金额 */
@property (nonatomic, copy) NSString *tqj_money;
/** 特权金利率 */
@property (nonatomic, copy) NSString *tqj_rate;

@end
