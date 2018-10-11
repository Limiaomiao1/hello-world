//
//  TSAcitvitModel.h
//  ZhuoJin
//
//  Created by tuanshang on 16/11/30.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSAcitvitModel : NSObject
/** 活动详情 */
@property (nonatomic, copy) NSString *event_info;
/** 活动标题 */
@property (nonatomic, copy) NSString *event_title;
/** 活动id */
@property (nonatomic, copy) NSString *ID;
/** 图片地址 */
@property (nonatomic, copy) NSString *img_url;

@end
