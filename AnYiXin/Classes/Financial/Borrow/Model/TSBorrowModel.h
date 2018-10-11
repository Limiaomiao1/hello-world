//
//  TSBorrowModel.h
//  TuanShang
//
//  Created by TuanShang on 16/7/11.
//  Copyright © 2016年 tuanshang. All rights reserved.
//
// 测试数据
//{
//    id : 4,
//    has_borrow : 6000,
//    borrow_duration : 14个月,
//    repayment_type : 按月分期还款,
//    credits : 20,
//    progress : 50,
//    level : HR,
//    borrow_money : 12000,
//    borrow_interest_rate : 10,
//    borrow_type : 信用标,
//    borrow_name : 新手标测试,
//    borrow_status : 2
//},

#import <Foundation/Foundation.h>

@interface TSBorrowModel : NSObject

@property (nonatomic , copy) NSString * borrow_duration;//借款期限
@property (nonatomic , strong) NSNumber * borrow_interest_rate;//年化利率
@property (nonatomic , strong) NSNumber * borrow_money;//借款金额
@property (nonatomic , copy) NSString * borrow_name;//借款标题
@property (nonatomic , assign) int borrow_status;//借款状态
@property (nonatomic , copy) NSString * borrow_type;//借款类型
@property (nonatomic , strong) NSNumber * credits;//借款人信用份数
@property (nonatomic , strong) NSNumber * has_borrow;//已投金额
@property (nonatomic , strong) NSNumber * ID;//标的id
@property (nonatomic , copy) NSString * level;//借款人信用等级
@property (nonatomic , strong) NSNumber * progress;//筹集进度
@property (nonatomic , copy) NSString * repayment_type;//还款方式
@property (nonatomic , copy) NSString * reward_num;// 奖励
@property (nonatomic , copy) NSString * has_pass;//是否有定向密码
/** 是否是新手标 */
@property (nonatomic, assign) int is_new;
/** 天标 */
@property (nonatomic, copy) NSString *repayment_types;
@end
