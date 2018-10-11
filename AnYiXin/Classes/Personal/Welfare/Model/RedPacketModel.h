//
//  RedPacketModel.h
//  AnYiXin
//
//  Created by Mac on 17/8/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    TSTopicUnsers = 1,// 未使用
    TSTopicLocks = 2, // 锁定中
    TSTopicExpireds = 3,// 已过期
    TSTopicUseds = 4,// 已使用
    
} TSTopicTypes;


@interface RedPacketModel : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
/** 加息数 */
@property (nonatomic, copy) NSString *rmoney;
/** 开始时间 */
@property (nonatomic, copy) NSString *online_time;
/** 最小投资金额 */
@property (nonatomic, copy) NSString *min_invest_money;
/** 终止时间 */
@property (nonatomic, copy) NSString *dead_time;
/** 加息券名称 */
@property (nonatomic, copy) NSString *title;
/** 投资期限范围-最小 */
@property (nonatomic, copy) NSString *min_duration;
/** 投资期限范围-最大	 */
@property (nonatomic, copy) NSString *max_duration;

@end
