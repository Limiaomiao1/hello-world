//
//  TSAcitvitModel.m
//  ZhuoJin
//
//  Created by tuanshang on 16/11/30.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSAcitvitModel.h"

@implementation TSAcitvitModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"ID":@"id",
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
