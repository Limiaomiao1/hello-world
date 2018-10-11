//
//  TSMoneyLogModel.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSMoneyLogModel.h"

@implementation TSMoneyLogModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id",
             };
}

@end
