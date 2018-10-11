//
//  DZStatusHud.m
//  Shangdai
//
//  Created by tuanshang on 17/2/16.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "DZStatusHud.h"
#import <MBProgressHUD.h>

/** 消失时间 */
#define hideDelayTime 1.2

@implementation DZStatusHud

+ (MBProgressHUD *)createHUDOnLastWindow
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    hud.labelFont = [UIFont boldSystemFontOfSize:14];
    return hud;
}

+ (void)showToastWithTitle:(NSString *)title complete:(void (^)())completeBlock
{
    MBProgressHUD *hud = [self createHUDOnLastWindow];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = title;
    hud.margin = 12.f;
    [hud show:YES];
    [hud hide:YES afterDelay:hideDelayTime];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;

    if (completeBlock) {
        hud.completionBlock = ^{
            completeBlock();
        };
    }
}

+ (void)showToastWithTitle:(NSString *)title yOffset:(float)yOffset complete:(void (^)())completeBlock
{
    MBProgressHUD *hud = [self createHUDOnLastWindow];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = title;
    hud.margin = 12.f;
    [hud show:YES];
    [hud hide:YES afterDelay:hideDelayTime];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.yOffset += yOffset;
    hud.userInteractionEnabled = NO;
    
    if (completeBlock) {
        hud.completionBlock = ^{
            completeBlock();
        };
    }
    
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController complete:(void (^)())completeBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completeBlock) {
            completeBlock();
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    if ([viewController isKindOfClass:[UIViewController class]] || [viewController isKindOfClass:[UITableViewController class]]) {
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
}
@end
