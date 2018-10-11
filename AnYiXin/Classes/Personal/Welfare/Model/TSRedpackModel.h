//
//  TSRedpackModel.h
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSRedpackModel : NSObject

/** 截止日期 */
@property (nonatomic, copy) NSString *deadline;
/** 期限 */
@property (nonatomic, copy) NSString *duration;
/** ID */
@property (nonatomic, copy) NSString *ID;
/** 金额 */
@property (nonatomic, copy) NSString *money;
/** 限制金额 */
@property (nonatomic, copy) NSString *multiple_money;
/** 红包名称 */
@property (nonatomic, copy) NSString *name;
/** 状态 */
@property (nonatomic, copy) NSString *status;
/** 描述 */
@property (nonatomic, copy) NSString *str;
/** 红包类型 */
@property (nonatomic, copy) NSString *type;


@end
