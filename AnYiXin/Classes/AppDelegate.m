//
//  AppDelegate.m
//  Shangdai
//
//  Created by tuanshang on 17/1/13.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "AppDelegate.h"
#import "TSTabBarController.h"
#import "TSPageController.h"
#import "Reachability.h"
//#import <PgyUpdate/PgyUpdateManager.h>


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (void)resgisterShare
{
    [ShareSDK registerApp:@"1fd4301ecbf01"
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeTencentWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             //                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                             
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx1fd9913f03a9cdf6"
                                            appSecret:@"f9f82fdecd190e5fe7eb9c2b29199669"];
                      break;
                  case SSDKPlatformTypeQQ://腾讯qq
                      [appInfo SSDKSetupQQByAppId:@"1106322024"
                                           appKey:@"REF07koVhVr0RIiq"
                                         authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];
    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 启动图片延时: 3秒
    [NSThread sleepForTimeInterval:3];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    TSTabBarController *tabVC = [[TSTabBarController alloc]init];
    // 状态栏白色
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    // 状态栏启动隐藏
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    // 监测网络状况
    [self reachabilityNetState];
    // 初始引导页
    TSPageController *pageVC = [[TSPageController alloc]init];
    pageVC.tab = tabVC;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"qidong"] isEqualToNumber:@1]) {
        self.window.rootViewController = tabVC;
    }else{
        self.window.rootViewController = pageVC;
    }
    
    // 检测更新
  //  [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"8141a22abfc299de238e65f5c8a76cc3"];
//    [[PgyUpdateManager sharedPgyManager] checkUpdate];

    [self resgisterShare];
    //向微信注册应用。
    [WXApi registerApp:@"" withDescription:@"wechat"];
    

    return YES;
}
// 如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面
- (void)onResp:(BaseResp *)resp
{
    NSLog(@"回调处理");
    // 处理 分享请求 回调
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"分享成功!"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
                
            default:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"分享失败!"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
        }
    }
}

#pragma mark 监测网络状况
-(void)reachabilityNetState
{
    Reachability* reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reach currentReachabilityStatus] == NotReachable) {
        TSLog(@"网络无连接");
    }
}

// 这个方法是用于从微信返回第三方App
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
