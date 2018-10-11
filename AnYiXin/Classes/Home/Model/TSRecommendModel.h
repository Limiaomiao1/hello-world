//
//  TSRecommendModel.h
//  TuanShang
//
//  Created by tuanshang on 16/9/2.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSRecommendModel : NSObject

@property (nonatomic , copy) NSString * borrow_money;
@property (nonatomic , copy) NSString * borrow_name;
@property (nonatomic , copy) NSString * borrow_interest_rate;
@property (nonatomic , copy) NSString * ID;
@property (nonatomic , copy) NSString * type;
@property (nonatomic , copy) NSString * borrow_duration;
@property (nonatomic , copy) NSString * progress;
/** borrow_status */
@property (nonatomic, assign) int borrow_status;
/** 期限类型 */
@property (nonatomic, copy) NSString *repayment_type;

@end

//请求成功: {
//    event : 88,
//    msg : success,
//    data : {
//        page : ,
//        list : [
//                {
//                    uid : 37,
//                    danbao : 暂无担保机构,
//                    id : 234,
//                    first_verify_time : 1492592104,
//                    user_name : 14700000011,
//                    reward_num : 0.00,
//                    reward_type : 0,
//                    location : ,
//                    borrow_type : 3,
//                    need : 196900,
//                    has_vouch : 0.00,
//                    is_new : 1,
//                    repayment_type : 2,
//                    publishtime : 1492851292,
//                    borrow_use : 1,
//                    progress : 1.55,
//                    add_time : 1492592092,
//                    borrow_money : 200000.00,
//                    borrow_interest_rate : 5.00,
//                    area : 0,
//                    borrow_duration : 1,
//                    borrow_info : <p>123</p>,
//                    risk_control : ,
//                    vouch_progress : 0.00,
//                    borrow_name : zzzzzz,
//                    repaytime : 1495123200,
//                    borrow_status : 2,
//                    city : 0,
//                    borrow_times : 7,
//                    credits : 30,
//                    lefttime : 343430,
//                    collect_time : 1492937704,
//                    province : 0,
//                    borrow_min : 100,
//                    updata : N;,
//                    burl : /invest/234.html,
//                    biao : 7,
//                    is_tuijian : 0,
//                    has_borrow : 3100.00,
//                    password : ,
//                    customer_name : kefuzhang,
//                    leftdays : 4,
//                    bollprogress : 1.35,
//                    deadline : 0
//                }
//                ]
//    }
//}

