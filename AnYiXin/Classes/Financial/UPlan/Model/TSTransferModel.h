//
//  TSTransferModel.h
//  TuanShang
//
//  Created by TuanShang on 16/7/11.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSTransferModel : NSObject

@property (nonatomic , copy) NSString * borrow_duration; // 项目期限
@property (nonatomic , copy) NSString * borrow_interest_rate; //年化收益
@property (nonatomic , copy) NSString * borrow_money; // 项目金额
@property (nonatomic , copy) NSString * borrow_name; // 项目名称
@property (nonatomic , copy) NSString * borrow_status; // 状态
@property (nonatomic , copy) NSString * ID; //项目id
@property (nonatomic , copy) NSString * per_transfer; // 起投金额
@property (nonatomic , copy) NSString * progress; // 项目进度
@property (nonatomic , copy) NSString * transfer_out; // 售出份数
@property (nonatomic , copy) NSString * transfer_total; // 总份数
/** 即将上线 */
@property (nonatomic, copy) NSString *online_type;

@end
