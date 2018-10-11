//
//  TSTransferDetailModel.m
//  TuanShang
//
//  Created by TuanShang on 16/7/19.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSTransferDetailModel.h"

@implementation TSTransferDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

@end
