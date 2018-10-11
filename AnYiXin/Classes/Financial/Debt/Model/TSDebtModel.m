//
//  TSDebtModel.m
//  TuanShang
//
//  Created by tuanshang on 16/9/5.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSDebtModel.h"

@implementation TSDebtModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

@end
