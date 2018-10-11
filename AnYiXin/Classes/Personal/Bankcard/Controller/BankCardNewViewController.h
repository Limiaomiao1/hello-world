//
//  BankCardNewViewController.h
//  AnYiXin
//
//  Created by Mac on 17/10/16.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardNewViewController : UIViewController
/**
 *  点击了哪个银行 （要绑定的银行）
 */
@property (nonatomic, copy) NSString *bankStr;
@property (nonatomic , assign) NSNumber* type;
@property (nonatomic,strong)NSString *titles;

@end
