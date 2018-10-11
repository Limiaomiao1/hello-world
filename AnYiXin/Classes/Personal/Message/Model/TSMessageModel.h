//
//  TSMessageModel.h
//  TuanShang
//
//  Created by tuanshang on 16/9/2.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSMessageModel : NSObject

@property (nonatomic , copy) NSString * ID;
@property (nonatomic , copy) NSString * msg;
@property (nonatomic , copy) NSString * send_time;
@property (nonatomic , copy) NSString * status;
@property (nonatomic , copy) NSString * title;

@end
