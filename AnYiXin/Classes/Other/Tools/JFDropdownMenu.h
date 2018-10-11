//
//  JFDropdownMenu.h
//
//
//  Created by  on 15/12/22.
//  Copyright © 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>
@class JFDropdownMenu;

@protocol JFDropdownMenuDelegate <NSObject>
@optional
- (void)dropDownMenuDidDissmiss:(JFDropdownMenu *)menu;
- (void)dropDownMenuDidShow:(JFDropdownMenu *)menu;
@end

@interface JFDropdownMenu : UIView
@property (nonatomic,weak) id<JFDropdownMenuDelegate> delagete;

+ (instancetype)menu;
- (void)show;
- (void)dismiss;
//内容
@property (nonatomic,strong)UIView *content;
//内容控制器
@property (nonatomic,strong)UIViewController *contentController;
@end
