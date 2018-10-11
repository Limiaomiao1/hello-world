//
//  JFDropdownMenu.m
//  ZJ
//
//  Created by  on 15/12/22.
//  Copyright © 2015年. All rights reserved.
//

#import "JFDropdownMenu.h"

@interface JFDropdownMenu ()
/*
 用来显示具体内容的容器
 */
@property (nonatomic,weak)UIImageView *containerView;

@end

@implementation JFDropdownMenu
- (UIImageView *)containerView{
    if (!_containerView) {
        //添加一个灰色图片控件
        UIImageView *containerView = [[UIImageView alloc] init];
        self.backgroundColor = RGBA(100, 100, 100, 0.5);
        containerView.userInteractionEnabled = YES;//开启交互功能
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    return _containerView; 
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //清除颜色
        self.backgroundColor = [UIColor clearColor];
        //self.view.window = [UIApplication sharedApplication].keyWindow;
        //建议使用[UIApplication sharedApplication].keyWindow获取窗口
        
    }
    return self;
}
+ (instancetype)menu{
    return [[self alloc]init];
}
- (void)setContent:(UIView *)content{
    _content = content;

    content.frame = self.containerView.frame;
    //调整内容的位置

    //添加内容到图片上
    [self.containerView addSubview:content];
}
- (void)setContentController:(UIViewController *)contentController{
    _contentController = contentController;
    self.content = contentController.view;
    
}
//显示
- (void)show{
    //1、获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    //2添加到自己的窗口上
    [window addSubview:self];
    //3设置尺寸
    self.frame = window.bounds;
    //4调整灰色图片的位置
    //默认情况下,frame是以父控件左上角为坐标原点
    //可以转换坐标系原点，改变frame的参照点
    [UIView animateWithDuration:0 animations:^{
        self.containerView.centerX = window.centerX;
        self.containerView.x = 50;
        self.containerView.y = window.height/3;
        self.containerView.height = window.height/3;
        self.containerView.width = window.width - 100;
    }];
      //通知外界，自己显示了
    if ([self.delagete respondsToSelector:@selector(dropDownMenuDidShow:)]) {
        [self.delagete dropDownMenuDidShow:self];
    }
}
//销毁
- (void)dismiss{
    [self removeFromSuperview];
    if ([self.delagete respondsToSelector:@selector(dropDownMenuDidDissmiss:)]) {
        [self.delagete dropDownMenuDidDissmiss:self];
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}
@end
