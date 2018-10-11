//
//  TSAcitiviDetailController.m
//  ZhuoJin
//
//  Created by tuanshang on 16/11/30.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSAcitiviDetailController.h"
#import <WebKit/WebKit.h>

@interface TSAcitiviDetailController ()<WKNavigationDelegate,WKUIDelegate>

/** 加载地址 */
@property (nonatomic, copy) NSString *URL;
/** 网页视图 */
@property (nonatomic, strong) WKWebView *webView;
/** 进度 */
@property (strong, nonatomic) UIProgressView *progressView;
/** 分享图片 */
@property (nonatomic, copy) NSString *shareImg;
/** 分享标题 */
@property (nonatomic, copy) NSString *shareTitle;
/** 分享内容 */
@property (nonatomic, copy) NSString *shareInfo;
/** 分享的URL */
@property (nonatomic, copy) NSString *shareUrl;

@end

@implementation TSAcitiviDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavRightItem];
    [self loadWebInfo];
    [self setupWKWebView];
    [self initProgressView];
}

- (void)initNavRightItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon_rightnav_share"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_rightnav_share"] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(shareAciton) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)shareAciton {
    
    [DZStatusHud showAlertWithTitle:@"点击分享" message:@"分享成功" viewController:self complete:nil];
}


- (void)setupWKWebView {
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 30.0;
    configuration.preferences = preferences;
    //WKWebView框架
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)loadWebInfo {
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"id"] = self.ID;
    parame[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:parame url:TSAPI_EVENT_INFO successBlock:^(id responseBody) {
        if ([responseBody[@"event"] intValue] == 88) {
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:responseBody[@"data"][@"tpl"]]]];
            weakSelf.shareImg = responseBody[@"data"][@"share_img"];
            weakSelf.shareTitle = responseBody[@"data"][@"share_title"];
            weakSelf.shareUrl = responseBody[@"data"][@"share_url"];
            weakSelf.shareInfo = responseBody[@"data"][@"share_info"];
        }else
        {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:error complete:nil];
    }];
}

- (void)initProgressView
{
    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 2)];
    progressView.tintColor = COLOR_MainColor;
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
}
#pragma mark - KVO
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
            
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}



@end
