//
//  TSBulletinModel.m
//  ZhuoJin
//
//  Created by tuanshang on 17/2/15.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSBulletinModel.h"

@implementation TSBulletinModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end
