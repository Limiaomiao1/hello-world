//
//  TSBorrowDetailModel.h
//  TuanShang
//
//  Created by tuanshang on 16/9/12.
//  Copyright © 2016年 tuanshang. All rights reserved.
//
//data : {
//    reward_num : 0,
//    money_collect : 0,
//    borrow_status_str : 复审中,
//    borrow_interest_rate : 10,
//    collect_day : 3,
//    is_new : 0,
//    borrow_money : 10000,
//    borrow_type : 抵押标,
//    borrow_info : <p>1231</p>,
//    repayment_type : 按月分期还款,
//    has_pass : 0,
//    id : 113,
//    borrow_status : 4,
//    borrow_min : 100,
//    borrow_max : 0,
//    add_time : 2016-09-08 11:27,
//    borrow_duration : 3个月,
//    has_borrow : 5000,
//    progress : 50,
//    borrow_name : 测试mika,
//    updata : <null>,
//    borrow_times : 5
//}

#import <Foundation/Foundation.h>

@interface TSBorrowDetailModel : NSObject

@property (nonatomic , copy) NSString * add_time;//
@property (nonatomic , copy) NSString * borrow_duration;
@property (nonatomic , copy) NSString * borrow_info;
@property (nonatomic , copy) NSString * borrow_interest_rate;
@property (nonatomic , copy) NSString * borrow_max;
@property (nonatomic , copy) NSString * borrow_min;
@property (nonatomic , copy) NSString * borrow_money;
@property (nonatomic , copy) NSString * borrow_name;
@property (nonatomic , copy) NSString * borrow_status;
@property (nonatomic , copy) NSString * borrow_status_str;
@property (nonatomic , copy) NSString * borrow_times;
@property (nonatomic , copy) NSString * borrow_type;
@property (nonatomic , copy) NSString * borrow_bid;/**< 是否可用特权金 */
@property (nonatomic , copy) NSString * collect_day;


@property (nonatomic , copy) NSString * meng_key;//支付密码链接  孟
@property (nonatomic , copy) NSString * meng_sn;//  孟
@property (nonatomic , copy) NSString * meng_random;//  孟 加密随机数



/** 剩余天数 */
@property (nonatomic, copy) NSString *collect_time;
@property (nonatomic , copy) NSString * has_borrow;
@property (nonatomic , copy) NSString * has_pass;
@property (nonatomic , copy) NSString * ID;
@property (nonatomic , copy) NSString * is_new;
@property (nonatomic , copy) NSString * money_collect;
@property (nonatomic , copy) NSString * progress;
@property (nonatomic , copy) NSString * repayment_type;
@property (nonatomic , copy) NSString * reward_num;
@property (nonatomic , copy) NSString * redpacket;
@property (nonatomic , copy) NSString * can_interest;
@property (nonatomic , copy) NSString * can_tqj;

@property (nonatomic , strong) NSArray * updata;
@property (nonatomic , strong) NSDictionary * borrow_info_two;


@end
