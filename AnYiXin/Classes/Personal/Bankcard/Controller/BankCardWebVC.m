
//
//  BankCardWebVC.m
//  AnYiXin
//
//  Created by Mac on 18/3/2.
//  Copyright © 2018年 tuanshang. All rights reserved.
//

#import "BankCardWebVC.h"

@interface BankCardWebVC ()<UIWebViewDelegate>

@end

@implementation BankCardWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0,TSScreenW, TSScreenH)];
    [self.view addSubview:web];
    web.scalesPageToFit = YES;
    web.delegate = self;
    NSString * urlStr = [TSAPI_Image_PREFIX stringByAppendingString:@"cgbank"];
    
    NSString *bodyShare = [NSString stringWithFormat: @"token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSMutableURLRequest * requestShare = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    [requestShare setHTTPMethod: @"POST"];
    [requestShare setHTTPBody: [bodyShare dataUsingEncoding: NSUTF8StringEncoding]];
    [web loadRequest:requestShare];

    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"绑定银行卡";
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //定义JS字符串
    NSString *script = [NSString stringWithFormat: @"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.text = \"function ResizeImages() { "
                        "var myimg;"
                        "var maxwidth=%f;" //屏幕宽度
                        "for(i=0;i <document.images.length;i++){"
                        "myimg = document.images[i];"
                        "myimg.height = maxwidth / (myimg.width/myimg.height);"
                        "myimg.width = maxwidth;"
                        "}"
                        "}\";"
                        "document.getElementsByTagName('p')[0].appendChild(script);",TSScreenW];
    
    //添加JS
    [webView stringByEvaluatingJavaScriptFromString:script];
    
   
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
