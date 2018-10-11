//
//  TSUserJiaxiController.h
//  ZhuoJin
//
//  Created by tuanshang on 17/2/2.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UJiaxiDelegate <NSObject>

- (void)getJiaxiIDDelegate:(NSString * )jiaxiID withBidmoney:(NSString *)money withpaymoney:(NSString *)paymoney;

@end

@class TSJiaxiModel;

@interface TSUserJiaxiController : UITableViewController

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) TSJiaxiModel *ujiaxiModel;
@property (nonatomic, assign) id<UJiaxiDelegate> delegate;
@end
