//
//  TSTransferModel.m
//  TuanShang
//
//  Created by TuanShang on 16/7/11.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSTransferModel.h"

@implementation TSTransferModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}


@end
