//
//  TSWithdrawalController.h
//  Shangdai
//
//  Created by tuanshang on 17/2/27.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAlertView.h"
#import "TYAlertController.h"
#import "CFCASIPInputField.h"

@interface TSWithdrawalController : UIViewController
@property (nonatomic,strong)NSString *phonestr;

@property (weak, nonatomic) IBOutlet CFCASIPInputField *payTF;

@end
