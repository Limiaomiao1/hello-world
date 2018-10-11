//
//  TSDescribeController.m
//  ZhuoJin
//
//  Created by tuanshang on 17/2/15.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSDescribeController.h"
#import <WebKit/WebKit.h>

@interface TSDescribeController ()<WKNavigationDelegate,WKUIDelegate,UITableViewDelegate,UITableViewDataSource>
/** 网页视图 */
@property (nonatomic, strong) WKWebView *webView;
/** 进度 */
@property (strong, nonatomic) UIProgressView *progressView;

@property (strong,nonatomic)NSMutableArray *dataArr;
@end

@implementation TSDescribeController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"借款人信息";
    
    
    _dataArr = [NSMutableArray array];
    
    [_dataArr addObject:@"年          龄：保密"];
    [_dataArr addObject:[NSString stringWithFormat:@"性          别：%@",[self.borrow_info_two objectForKey:@"sex"]]];
    [_dataArr addObject:[NSString stringWithFormat:@"学          历：%@",[self.borrow_info_two objectForKey:@"education"]]];
    [_dataArr addObject:[NSString stringWithFormat:@"户籍所在地：%@",[self.borrow_info_two objectForKey:@"province"]]];
    [_dataArr addObject:[NSString stringWithFormat:@"婚姻状况：%@",[self.borrow_info_two objectForKey:@"marry"]]];
    
    [_dataArr addObject:[NSString stringWithFormat:@"职          业：%@",[self.borrow_info_two objectForKey:@"zy"]]];
    [_dataArr addObject:@"月收入（元）：保密"];
    
    [_dataArr addObject:@"借款人涉诉情况：无"];
    [_dataArr addObject:@"借款人负债情况：保密"];
    [_dataArr addObject:@"征信报告：保密"];
    [_dataArr addObject:@"借款人在其他平台借款情况：无"];
    [_dataArr addObject:@"风险等级：五星"];
    [_dataArr addObject:@"信用记录：信用极好"];
    [_dataArr addObject:@"信用能力：很强"];
    [_dataArr addObject:@"可能产生的风险结果：几乎无风险"];
    [_dataArr addObject:@"正常还款次数：0次"];
    [_dataArr addObject:@"逾期还款金额：0.00元"];
    [_dataArr addObject:@"逾期还款笔数：0笔"];
    [self initTableview];
    
    //  [self setupWKWebView];
    //   [self initProgressView];
    
}


- (void)initTableview
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    [tableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
    
}



/*
 - (void)setupWKWebView {
 
 self.view.backgroundColor = [UIColor yellowColor];
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
 self.webView.backgroundColor = [UIColor redColor];
 [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
 [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
 
 [self.webView loadHTMLString:self.httpStr baseURL:nil];
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
 [self.webView removeObserver:self forKeyPath:@"title"];
 [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
 }
 */
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
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以(@"document.getElementById(\"content\").offsetHeight;")，但如果是和我一样直接加载原站内容使用前者更合适
        //获取页面高度，并重置webview的frame
        CGFloat  webViewHeight = [result doubleValue];
        webView.height = webViewHeight;
        NSLog(@"%f",webViewHeight);
    }];
    
    NSLog(@"结束加载");
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"页面加载失败"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
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
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webView) {
            self.title = self.webView.title;
            
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            
        }
    }
    else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



@end
