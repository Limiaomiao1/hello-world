//
//  TSBulletinModel.h
//  ZhuoJin
//
//  Created by tuanshang on 17/2/15.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSBulletinModel : NSObject
/** 缩略图 */
@property (nonatomic, copy) NSString *art_img;
/** 简介 */
@property (nonatomic, copy) NSString *art_info;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 添加时间 */
@property (nonatomic, copy) NSString *art_time;
/** ID */
@property (nonatomic, copy) NSString *ID;
@end
