//
//  UseRedpackViewController.h
//  AnYiXin
//
//  Created by Mac on 17/8/21.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UseRedPacketDelegate <NSObject>

- (void)getHongbaoIDDelegate:(NSString * )hongbaoID withBidmoney:(NSString *)money withpaymoney:(NSString *)paymoney;

@end

@class RedPacketModel;

@interface UseRedpackViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) RedPacketModel *uhongbaoModel;
@property (nonatomic, assign) id<UseRedPacketDelegate> delegate;

@end
