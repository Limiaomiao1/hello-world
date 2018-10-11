//
//  RedPacketModel.m
//  AnYiXin
//
//  Created by Mac on 17/8/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "RedPacketModel.h"

@implementation RedPacketModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
