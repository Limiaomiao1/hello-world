//
//  TSUtendModel.h
//  Shangdai
//
//  Created by tuanshang on 17/4/25.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSUtendModel : NSObject

/** 投资时间 */
@property (nonatomic, copy) NSString *add_time;
/** 借款标号	*/
@property (nonatomic, copy) NSString *borrow_id;
/** 年化利率	*/
@property (nonatomic, copy) NSString *borrow_interest_rate;
/** 借入人 */
@property (nonatomic, copy) NSString *borrow_user;
/** 回收时间 */
@property (nonatomic, copy) NSString *deadline;
/** 投资金额 */
@property (nonatomic, copy) NSString *investor_capital;
/** 已收本息 */
@property (nonatomic, copy) NSString *receive;
/** 投资期限 */
@property (nonatomic, copy) NSString *transfer_month;
/** 代收利息 */
@property (nonatomic, copy) NSString *investor_interest;
/** 名字 */
@property (nonatomic, copy) NSString *borrow_name;


@end
