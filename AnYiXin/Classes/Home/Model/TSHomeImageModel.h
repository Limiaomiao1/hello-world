//
//  TSHomeImageModel.h
//  Shangdai
//
//  Created by tuanshang on 17/4/8.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSHomeImageModel : NSObject
/** 图片URL */
@property (nonatomic, copy) NSString *img;
/** 链接 */
@property (nonatomic, copy) NSString *url;
/** 标题 */
@property (nonatomic, copy) NSString *info;
@end
