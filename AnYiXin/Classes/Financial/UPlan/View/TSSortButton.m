//
//  TSSortButton.m
//  Shangdai
//
//  Created by tuanshang on 17/2/23.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSSortButton.h"

@implementation TSSortButton



- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat inteval = CGRectGetHeight(contentRect)/6;
    //设置图片的宽高为button高度的3/4;
    
    CGRect rect = CGRectMake(inteval, inteval, CGRectGetWidth(contentRect) *0.6, CGRectGetHeight(contentRect) - 2*inteval);
    
    return rect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    //设置图片的宽高为button高度的1/5;
    CGFloat imageH = CGRectGetHeight(contentRect) *0.2;
    
    CGRect rect = CGRectMake(CGRectGetWidth(contentRect)*0.6, 8, imageH,CGRectGetHeight(contentRect)/2 );
    
    return rect;
}

@end
