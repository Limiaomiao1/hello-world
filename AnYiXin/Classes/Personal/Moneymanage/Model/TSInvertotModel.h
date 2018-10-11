//
//  TSInvertotModel.h
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSInvertotModel : NSObject
/** 投资时间 */
@property (nonatomic, copy) NSString *add_time;
/** 原始借款标号 */
@property (nonatomic, copy) NSString *borrow_id;
/** 原始借款名称	 */
@property (nonatomic, copy) NSString *borrow_name;
/** 投资编号	 */
@property (nonatomic, copy) NSString *ID;
/** 投资本金	 */
@property (nonatomic, copy) NSString *investor_capital;
/** 利息 */
@property (nonatomic, copy) NSString *investor_interest;
/** 投资用户uid	 */
@property (nonatomic, copy) NSString *investor_uid;
/** 是否自动投标	 */
@property (nonatomic, copy) NSString *is_auto;
/** 年化收益	 */
@property (nonatomic, copy) NSString *rate;
/** 已还本金	 */
@property (nonatomic, copy) NSString *receive_capital;
/** 已还利息	 */
@property (nonatomic, copy) NSString *receive_interest;

@end
