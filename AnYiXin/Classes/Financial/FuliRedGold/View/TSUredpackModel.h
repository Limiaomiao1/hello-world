//
//  TSUredpackModel.h
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSUredpackModel : NSObject
/** 名称name */
@property (nonatomic, copy) NSString *name;
/** 金额 */
@property (nonatomic, copy) NSString *money;
/** id */
@property (nonatomic, copy) NSString *ID;
/** 可投资标的期限	 */
@property (nonatomic, copy) NSString *duration;


@end
