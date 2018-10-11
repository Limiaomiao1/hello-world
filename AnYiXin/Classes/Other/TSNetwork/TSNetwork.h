//
//  TSNetwork.h
//  Shangdai
//
//  Created by ts on 17/2/16.
//  Copyright © 2017年 ts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

//请求超时
#define TIMEOUT 10.f

typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSString *error);

typedef NS_ENUM(NSUInteger, NetworkStates) {
    NetworkStatesNone, // 没有网络
    NetworkStates2G, // 2G
    NetworkStates3G, // 3G
    NetworkStates4G, // 4G
    NetworkStatesWIFI // WIFI
};

@interface TSNetwork : NSObject

// 判断网络类型
+ (NetworkStates)getNetworkStates;
// 单例
+ (TSNetwork *)shareNetwork;
// 初始化
- (AFHTTPSessionManager *)baseHttpRequest;

/**
 *  通用接口
 *
 *  @param param  参数
 *  @param url 接口
 *  @param successBlock  成功回调
 *  @param failureBlock   失败回调
 */

- (void)postRequestResult:(NSDictionary *)param url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

@end
