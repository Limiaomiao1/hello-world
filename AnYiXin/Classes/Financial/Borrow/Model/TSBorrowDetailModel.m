//
//  TSBorrowDetailModel.m
//  TuanShang
//
//  Created by tuanshang on 16/9/12.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSBorrowDetailModel.h"

@implementation TSBorrowDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

@end
