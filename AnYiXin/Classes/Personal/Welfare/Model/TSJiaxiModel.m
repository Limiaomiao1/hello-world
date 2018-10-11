//
//  TSJiaxiModel.m
//  ZhuoJin
//
//  Created by tuanshang on 17/1/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSJiaxiModel.h"

@implementation TSJiaxiModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
