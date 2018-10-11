//
//  TSOpenAccountNewVC.m
//  AnYiXin
//
//  Created by Mac on 18/3/1.
//  Copyright © 2018年 tuanshang. All rights reserved.
//

#import "TSOpenAccountNewVC.h"

@interface TSOpenAccountNewVC ()<UIWebViewDelegate>

@end

@implementation TSOpenAccountNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员开户";
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenH)];
    [self.view addSubview:web];
    web.delegate = self;
    NSString * urlStr = [TSAPI_Image_PREFIX stringByAppendingString:@"account"];

    NSString *bodyShare = [NSString stringWithFormat: @"token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSMutableURLRequest * requestShare = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    [requestShare setHTTPMethod: @"POST"];
    [requestShare setHTTPBody: [bodyShare dataUsingEncoding: NSUTF8StringEncoding]];
    [web loadRequest:requestShare];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    webView.scalesPageToFit = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
