//
//  TSDebtModel.h
//  TuanShang
//
//  Created by tuanshang on 16/9/5.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSDebtModel : NSObject

@property (nonatomic , copy) NSString * borrow_name;
@property (nonatomic , assign) int borrow_status;
@property (nonatomic , copy) NSString * money;
@property (nonatomic , copy) NSString * borrow_duration;
@property (nonatomic , copy) NSString * period;
@property (nonatomic , copy) NSString * valid;
@property (nonatomic , copy) NSString * credits;
@property (nonatomic , copy) NSString * level;
@property (nonatomic , copy) NSString * transfer_price;
@property (nonatomic , copy) NSString * total_period;
@property (nonatomic , copy) NSString * creditsb;
@property (nonatomic , copy) NSString * borrow_type;
@property (nonatomic , copy) NSString * borrow_interest_rate;
@property (nonatomic , copy) NSString * levelb;
@property (nonatomic , copy) NSString * debt_id;
@property (nonatomic , assign) int status;
@property (nonatomic , copy) NSString * deadline;


@end


//{
//    borrow_name : 担保标22,       借款标题
//    borrow_status : 7,           借款状态
//    money : 15131.52,            债券总金额
//    borrow_duration : 6个月,       借款期限
//    period : 6,                   转让期数
//    valid : 2016-08-06 09:18,     发布时间
//    credits : 10,                 转让人信用积分
//    level : HR,                   转让人信用等级
//    transfer_price : 5000,        转让金额
//    total_period : 6,             总期数
//    creditsb : 30,                借款人信用积分
//    borrow_type : 担保标,          借款类型
//    borrow_interest_rate : 3,      年化收益
//    levelb : E,                    借款人信用等级
//    debt_id : 1,                   债权id
//    status : 4,                    转让状态
//    deadline : 2017-01-29 23:59    截止时间
//}
