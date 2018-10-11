//
//  HetongViewController.m
//  AnYiXin
//
//  Created by Mac on 17/11/1.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "HetongViewController.h"

@interface HetongViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation HetongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"合同";
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    dic[@"id"] = self.touid;
    _webview.delegate = self;
    
    NSString * urlStr = [TSAPI_Image_PREFIX stringByAppendingString:@"contract_pdf_link"];
    
    NSString *bodyShare = [NSString stringWithFormat: @"token=%@&id=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],self.touid];
    NSMutableURLRequest * requestShare = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
    [requestShare setHTTPMethod: @"POST"];
    [requestShare setHTTPBody: [bodyShare dataUsingEncoding: NSUTF8StringEncoding]];
    [_webview loadRequest:requestShare];
    
    /*
     [[TSNetwork shareNetwork] postRequestResult:dic url:@"contract_pdf_jk" successBlock:^(id responseBody) {
        if ([responseBody[@"event"] intValue] == 88) {
            NSString *msg = [responseBody objectForKey:@"msg"];
            [self.webview loadHTMLString:msg baseURL:nil];
        } else {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
    } failureBlock:^(NSString *error) {
    }];
*/
    
    // Do any additional setup after loading the view from its nib.
}
- (void)setTouid:(NSString *)touid
{
    _touid = touid;
}

//这个知识点主要是自己最近在尝试写后台接口  在移动端展示的时候需要用到这个知识点,在webViewDidFinishLoad方法里面执行一段js代码  拿到各个图片  判断其宽度是否大于当前手机屏幕尺寸,是的话则调整为屏幕宽度显示,不是的话则原样显示

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    2、都有效果
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
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
