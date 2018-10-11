//
//  TSTransferDetailModel.h
//  TuanShang
//
//  Created by TuanShang on 16/7/19.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSTransferDetailModel : NSObject

@property (nonatomic , copy) NSString * add_time;;
@property (nonatomic , copy) NSString * borrow_duration;
@property (nonatomic , copy) NSString * borrow_info;
@property (nonatomic , strong) NSNumber * borrow_interest_rate;
@property (nonatomic , strong) NSNumber * borrow_max;
@property (nonatomic , strong) NSNumber * borrow_min;
@property (nonatomic , strong) NSNumber * borrow_money;
@property (nonatomic , copy) NSString * borrow_name;
@property (nonatomic , strong) NSNumber * borrow_status;
@property (nonatomic , strong) NSNumber * ID;
@property (nonatomic , strong) NSNumber * is_show;
@property (nonatomic , copy) NSString * online_time;
@property (nonatomic , strong) NSNumber * per_transfer;
@property (nonatomic , strong) NSNumber * progress;
@property (nonatomic , strong) NSNumber * transfer_out;
@property (nonatomic , strong) NSNumber * transfer_total;
/** 即将上线 */
@property (nonatomic, assign) int immediately;

@end
//data : {
//    id : 1,
//    per_transfer : 100,
//    borrow_duration : 6个月,
//    transfer_out : 0,
//    borrow_max : 20,
//    progress : 0,
//    borrow_info : ,
//    transfer_total : 20,
//    is_show : 1,
//    borrow_money : 2000,
//    borrow_interest_rate : 10,
//    borrow_min : 1,
//    online_time : 2016-07-16 10:13,
//    borrow_name : U-00000001,
//    borrow_status : 2,
//    add_time : 2016-07-16 10:09
//}
