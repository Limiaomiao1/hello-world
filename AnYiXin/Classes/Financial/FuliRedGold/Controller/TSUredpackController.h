//
//  TSUredpackController.h
//  ZhuoJin
//
//  Created by tuanshang on 16/12/7.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol URedpackDelegate <NSObject>

- (void)getHongBaoIDDelegate:(NSString * )hongID withBidmoney:(NSString *)money withpaymoney:(NSString *)paymoney;

@end

@class TSUredpackModel;

@interface TSUredpackController : UITableViewController

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) TSUredpackModel *uredpackModel;
@property (nonatomic, assign) id<URedpackDelegate> delegate;

@end
