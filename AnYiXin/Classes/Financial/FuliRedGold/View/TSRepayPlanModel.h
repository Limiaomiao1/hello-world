//
//  TSRepayPlanModel.h
//  ZhuoJin
//
//  Created by tuanshang on 17/1/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSRepayPlanModel : NSObject

/** 时间 */
@property (nonatomic, copy) NSString *deadline;
/** 本金 */
@property (nonatomic, copy) NSString *capital;
/** 利息 */
@property (nonatomic, copy) NSString *interest;

@end
