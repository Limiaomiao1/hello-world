//
//  TSTqjSummaryModel.h
//  Shangdai
//
//  Created by tuanshang on 17/4/25.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSTqjSummaryModel : NSObject

/** 收益金额 */
@property (nonatomic, copy) NSString *earnings;
/** 发生日期 */
@property (nonatomic, copy) NSString *get_time;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 特权金 */
@property (nonatomic, copy) NSString *tqj_money;

@end
