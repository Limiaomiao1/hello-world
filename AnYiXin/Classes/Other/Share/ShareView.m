//
//  ShareView.m
//  ShareV
//
//  Created by BOBO on 17/1/4.
//  Copyright © 2017年 BOBO. All rights reserved.
//

#import "ShareView.h"
#import "UIView+Extension.h"
#import "ShareButton.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#define iphone_w [UIScreen mainScreen].bounds.size.width
#define item_w iphone_w * 0.15
#define space (iphone_w-40-80*3)/2.0

@interface ShareView ()
//分享参数
@property(strong,nonatomic)NSMutableDictionary * parm;
@end
@implementation ShareView


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
        self.frame = [UIScreen mainScreen].bounds;
        self.hidden = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareTapaction)];
        [self addGestureRecognizer:tap];
        
        [self addScrollvData];

//        [self addSubview:_scrollv];
    }
    return self;
}
-(void)addScrollvData
{
    NSArray * imgArr = @[@"wx_share",@"wxquan",@"qq"];
    NSArray * titlesArr = @[@"微信",@"微信朋友圈",@"QQ好友"];

    for ( int i = 0; i<imgArr.count; i++) {
        
        ShareButton * btn = [[ShareButton alloc]initWithFrame:CGRectMake((20)+(80+space) * i, 15, (80), (104)) ImageName:imgArr[i] title:titlesArr[i]];
        btn.tag = 500 +i;
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollv addSubview:btn];
    }
    
}
-(void)shareshowSetupParmImg:(id)img
                            andText:(NSString *)text
                           andTitle:(NSString *)title
                          andUrlstr:(NSString*)urlstr
{
 
    //动作
   _parm = [NSMutableDictionary dictionary];
   [_parm SSDKSetupShareParamsByText:text images:img url:[NSURL URLWithString:urlstr] title:title type:SSDKContentTypeAuto];
}



-(void)shareTapaction
{
    [self dismiss:YES];
}
-(void)dismiss:(BOOL)animate
{
    if (!animate) {
//        [self removeFromSuperview];
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
//        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
//        self.alpha = 0.f;
        self.hidden = YES;
        _scrollv.y = TSScreenH;
    } completion:^(BOOL finished) {
        
//        [self removeFromSuperview];
    }];
}
-(void)shareBtnClick:(UIButton *)sender
{
    //  @[@"微信",@"微信朋友圈",@"QQ"];
    
    switch (sender.tag) {
       case 500:
            if ([ShareSDK isClientInstalled:SSDKPlatformTypeWechat ]) {
            
                [self shareSDKAction:SSDKPlatformSubTypeWechatSession andTitle:@"微信"];
            }else{
               NSLog(@"微信未安装");
            }
            
            break;
        case 501:
            if ([ShareSDK isClientInstalled:SSDKPlatformTypeWechat ]) {
                
                [self shareSDKAction:SSDKPlatformSubTypeWechatSession andTitle:@"微信朋友圈"];
            }else{
                NSLog(@"微信未安装");
            }
            [self shareSDKAction:SSDKPlatformSubTypeWechatTimeline andTitle:@"微信朋友圈"];
            break;
        case 502:
            if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ ]) {

           
                [self shareSDKAction:SSDKPlatformSubTypeQQFriend andTitle:@"QQ"];
            }else{
                NSLog(@"QQ未安装");
            }
            break;
        case 503:
            if ([ShareSDK isClientInstalled:SSDKPlatformSubTypeQQFriend]||[ShareSDK isClientInstalled:SSDKPlatformTypeQQ]) {
                [self shareSDKAction:SSDKPlatformSubTypeQZone andTitle:@"QQ空间"];
            }else{
               NSLog(@"QQ未安装");
            }
            
        default:
            break;
    }
    
    [self dismiss:YES];
}

-(void)shareSDKAction:(SSDKPlatformType)type andTitle:(NSString*)title
{
    [ShareSDK share:type parameters:_parm onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NSString * callback = [NSString stringWithFormat:@"%@分享成功",title];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:callback
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            case SSDKResponseStateCancel:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享取消"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;

            }
            default:
                break;
        }
    }];
}

-(UIScrollView *)scrollv
{
    if (!_scrollv) {
        _scrollv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TSScreenH,TSScreenW, (189))];
        _scrollv.backgroundColor = [UIColor whiteColor];
       // _scrollv.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
        _scrollv.showsVerticalScrollIndicator = NO;
        _scrollv.showsHorizontalScrollIndicator= NO;
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, (130), TSScreenW, (49));
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitle:@"取消" forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:(14)];
        [btn addTarget:self action:@selector(shareTapaction) forControlEvents:UIControlEventTouchUpInside];
        [_scrollv addSubview:btn];
        

    }
    return _scrollv;
}
@end
