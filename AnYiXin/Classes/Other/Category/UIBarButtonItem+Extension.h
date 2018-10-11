//
//  UIBarButtonItem+Extension.h
//  ZhongChou
//
//  Created by TuanShang on 16/4/9.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;

@end
