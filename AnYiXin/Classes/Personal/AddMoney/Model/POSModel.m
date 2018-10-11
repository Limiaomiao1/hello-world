//
//  POSModel.m
//  AnYiXin
//
//  Created by Mac on 17/8/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "POSModel.h"

@implementation POSModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
