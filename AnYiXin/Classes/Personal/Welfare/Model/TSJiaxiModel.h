//
//  TSJiaxiModel.h
//  ZhuoJin
//
//  Created by tuanshang on 17/1/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    
    TSTopicUnser = 1,// 未使用
    TSTopicLock = 2, // 锁定中
    TSTopicExpired = 3,// 已过期
    TSTopicUsed = 4,// 已使用
 
} TSTopicType;


@interface TSJiaxiModel : NSObject

/** id */
@property (nonatomic, copy) NSString *ID;
/** 加息数 */
@property (nonatomic, copy) NSString *interest_rate;
/** 开始时间 */
@property (nonatomic, copy) NSString *online_time;
/** 最小投资金额 */
@property (nonatomic, copy) NSString *min_invest_money;
/** 投资期限范围-最小 */
@property (nonatomic, copy) NSString *min_duration;
/** 投资期限范围-最大	 */
@property (nonatomic, copy) NSString *max_duration;
/** 终止时间 */
@property (nonatomic, copy) NSString *deadline;
/** 加息券名称 */
@property (nonatomic, copy) NSString *title;

@end
