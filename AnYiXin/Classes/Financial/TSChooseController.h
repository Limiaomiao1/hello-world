//
//  TSChooseController.h
//  Shangdai
//
//  Created by tuanshang on 17/2/28.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TSChooseControllerDelegate <NSObject>

- (void)getChooseResultDelegateWith:(NSString *)name with:(NSString *)name2 with:(NSString *)name3;

@end

@interface TSChooseController : UIViewController

@property (nonatomic, assign) id<TSChooseControllerDelegate> delegate;

/** 类型 */
@property (nonatomic, assign) int type;

@end
