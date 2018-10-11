//
//  TSBorDetailWebController.m
//  AnYiXin
//
//  Created by lzq on 2018/4/23.
//  Copyright © 2018年 tuanshang. All rights reserved.
//

#import "TSBorDetailWebController.h"

@interface TSBorDetailWebController ()<UIWebViewDelegate>

@end

@implementation TSBorDetailWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"投标";
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenH)];
    [self.view addSubview:web];
    web.delegate = self;
    NSString * urlStr = [TSAPI_Image_PREFIX stringByAppendingString:@"invest_money"];
    
    NSString *bodyShare = [NSString stringWithFormat: @"token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSArray *keys = [_paramDic allKeys];
    NSMutableString *bodySharestr;
    for (int i = 0; i<keys.count; i++) {
        NSString *key = keys[i];
        if (i == 0) {
            bodySharestr = [NSMutableString stringWithFormat: @"%@&%@=%@", bodyShare,key,[_paramDic objectForKey:key]];
        }else {
            bodySharestr = [NSMutableString stringWithFormat: @"%@&%@=%@", bodySharestr,key,[_paramDic objectForKey:key]];
         }
    }
    NSLog(@"------%@",bodySharestr);
    NSMutableURLRequest * requestShare = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    [requestShare setHTTPMethod: @"POST"];
    if (bodySharestr.length>0) {
        [requestShare setHTTPBody: [bodySharestr dataUsingEncoding: NSUTF8StringEncoding]];
        [web loadRequest:requestShare];
    }

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
