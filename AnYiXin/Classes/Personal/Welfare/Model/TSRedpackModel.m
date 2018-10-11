//
//  TSRedpackModel.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSRedpackModel.h"

@implementation TSRedpackModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end
