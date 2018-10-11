//
//  DZNavController.h
//  Shangdai
//
//  Created by tuanshang on 17/2/22.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZNavController : UIViewController

- (instancetype)initWithSubViewControllers:(NSArray *)subViewControllers;

@property(nonatomic,copy)UIColor *btnTextNomalColor;
@property(nonatomic,copy)UIColor *btnTextSeletedColor;
@property(nonatomic,copy)UIColor *sliderColor;
@property(nonatomic,copy)UIColor *topBarColor;

@end
