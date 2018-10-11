//
//  ChooseBankController.h
//  CheZhongChou
//
//  Created by fjw on 16/5/4.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

/**
 *  选择银行卡的控制器
 */
#import <UIKit/UIKit.h>

@protocol bankNameDelegate <NSObject>

- (void)getBankName:(NSString *)bankName withBank:(NSString *)bank;

@end

@interface ChooseBankController : UIViewController

@property (nonatomic, assign) id<bankNameDelegate> delegate;

@end
