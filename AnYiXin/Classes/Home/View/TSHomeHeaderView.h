//
//  TSHomeHeaderView.h
//  Shangdai
//
//  Created by tuanshang on 17/2/11.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>
#import "LSMarqueeView.h"

typedef void(^DidTagButtonBlock) (void);

@interface TSHomeHeaderView : UIView <SDCycleScrollViewDelegate>
/** 轮播图 */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
/** 点击方法 */
@property (nonatomic, copy) DidTagButtonBlock didTagAction;
/** Banner */
@property (nonatomic, strong) NSMutableArray *imageArr;
/** 按钮名字 */
@property (nonatomic, copy) NSString *buttonName;
/** 公告*/
@property (nonatomic, strong) LSMarqueeView *marqueeView;

/**点击公告的id*/
@property(nonatomic,strong)void (^clickBlock)(NSString *nid);

@end
