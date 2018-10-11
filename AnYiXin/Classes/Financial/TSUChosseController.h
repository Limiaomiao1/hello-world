//
//  TSUChosseController.h
//  Shangdai
//
//  Created by tuanshang on 17/4/25.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TSUChooseControllerDelegate <NSObject>

- (void)getChooseResultDelegateWith:(NSString *)name with:(NSString *)name2 with:(NSString *)name;

@end

@interface TSUChosseController : UIViewController

@property (nonatomic, assign) id<TSUChooseControllerDelegate> delegate;

@end
