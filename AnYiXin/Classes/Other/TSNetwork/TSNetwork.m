//
//  TSNetwork.m
//  Shangdai
//
//  Created by tuanshang on 17/2/16.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSNetwork.h"

@implementation TSNetwork

+ (TSNetwork *)shareNetwork {
    static TSNetwork *sharedTSNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedTSNetworkSingleton = [[self alloc] init];
    });
    return sharedTSNetworkSingleton;
}

- (AFHTTPSessionManager *)baseHttpRequest {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    //header 设置
//        [manager.requestSerializer setValue:TSAPI_BASE_HTTP_PREFIX forHTTPHeaderField:@"Host"];
//        [manager.requestSerializer setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
//    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
//    [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
//    [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" forHTTPHeaderField:@"User-Agent"];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",  @"text/plain", nil]];
    return manager;
}

#pragma mark - 发送Post请求

- (void)postRequestResult:(NSDictionary *)param url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    
    AFHTTPSessionManager *manager = [self baseHttpRequest];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    //两种编码方式
    //    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSString *urlStr = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * urlStr = [TSAPI_Image_PREFIX stringByAppendingString:url];
    [manager POST:urlStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
        TSLog(@"\n请求URL: %@  \n请求参数: %@  \n请求成功: %@",urlStr,param,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
        TSLog(@"\n请求URL: %@  \n请求参数: %@  \n请求失败: %@",urlStr,param,error);
        
    }];
    
}

#pragma mark -  判断网络类型

+ (NetworkStates)getNetworkStates
{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    // 保存网络状态
    NetworkStates states = NetworkStatesNone;
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏码
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    states = NetworkStatesNone;
                    //无网模式
                    break;
                case 1:
                    states = NetworkStates2G;
                    break;
                case 2:
                    states = NetworkStates3G;
                    break;
                case 3:
                    states = NetworkStates4G;
                    break;
                case 5:
                {
                    states = NetworkStatesWIFI;
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return states;
}
@end
