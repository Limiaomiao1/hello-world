//
//  TSMyCodeView.m
//  ZhuoJin
//
//  Created by tuanshang on 16/11/30.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSMyCodeView.h"
#import "UIView+TYAlertView.h"
#import <UIImageView+WebCache.h>

@implementation TSMyCodeView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.sureButton setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
    [self setupSubViews];
}

- (void)setupSubViews {
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:nil url:TSAPI_MORE successBlock:^(id responseBody) {
        [weakSelf.codeImage sd_setImageWithURL:[NSURL URLWithString:responseBody[@"data"][@"erweima"]]];
    } failureBlock:^(NSString *error) {
        
    }];
}

- (IBAction)didCodeButtonAction:(id)sender {
    
    [self hideView];
}



@end
