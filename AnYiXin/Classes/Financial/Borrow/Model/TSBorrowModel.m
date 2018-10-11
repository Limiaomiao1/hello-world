//
//  TSBorrowModel.m
//  TuanShang
//
//  Created by TuanShang on 16/7/11.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSBorrowModel.h"

@implementation TSBorrowModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

@end
