//
//  TSInvertotModel.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSInvertotModel.h"

@implementation TSInvertotModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}


@end
