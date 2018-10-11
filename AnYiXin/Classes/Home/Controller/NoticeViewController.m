//
//  NoticeViewController.m
//  AnYiXin
//
//  Created by Mac on 17/7/26.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "NoticeViewController.h"

@interface NoticeViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *params = @{@"nid":_nid};
    [[TSNetwork shareNetwork] postRequestResult:params url:@"new_view" successBlock:^(id responseBody) {
        int event = [responseBody[@"event"] intValue];
        if (event == 88) {
            NSDictionary *content = responseBody[@"data"][@"content"];
          
            self.title = [content objectForKey:@"type_name"];
            [self.webview loadHTMLString:[content objectForKey:@"content"] baseURL:nil];
        }else
        {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
    } failureBlock:^(NSString *error) {
        
    }];
    
}
- (void)setNid:(NSString *)nid
{
    _nid = nid;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
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
