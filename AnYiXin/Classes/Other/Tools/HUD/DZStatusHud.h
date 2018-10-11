//
//  DZStatusHud.h
//  Shangdai
//
//  Created by tuanshang on 17/2/16.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZStatusHud : NSObject

/**
 *  显示消息通知
 *
 *  @param title         内容
 *  @param completeBlock 完成回调
 */
+ (void)showToastWithTitle:(NSString *)title complete:(void (^)())completeBlock;

/**
 *  显示消息通知 (自定义位置)
 *
 *  @param title         内容
 *  @param yOffset       往上（下）偏移
 *  @param completeBlock 完成回调
 */
+ (void)showToastWithTitle:(NSString *)title yOffset:(float)yOffset complete:(void (^)())completeBlock;

/**
 *  显示提示框选择
 *
 *  @param title               标题
 *  @param message             内容
 *  @param viewController      控制器
 *  @param completeBlock       完成回调
 */
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController complete:(void (^)())completeBlock;


@end
