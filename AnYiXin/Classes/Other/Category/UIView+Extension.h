//
//  UIView+Extension.h
//  ZhongChou
//
//  Created by TuanShang on 16/4/9.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

/**
 *  从Xib中加载一个控件出来（Xib的名字和类名一致）
 */
+ (instancetype)viewFromXib;

@end
