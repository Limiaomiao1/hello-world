//
//  UIBarButtonItem+Extension.m
//  ZhongChou
//
//  Created by TuanShang on 16/4/9.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"

@implementation UIBarButtonItem (Extension)

/**
 *  创建item
 *
 *  @param target    点击item 控制器
 *  @param action    点击item都调用的方法
 *  @param image     图片
 *  @param highImage 高亮图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage {
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片，尺寸
    [rightBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    rightBtn.size = rightBtn.currentBackgroundImage.size;
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    return barButtonItem;
}

@end
