//
//  TSMyCodeView.h
//  ZhuoJin
//
//  Created by tuanshang on 16/11/30.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSMyCodeView : UIView

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
/** 图片URL */
@property (nonatomic, copy) NSString *imgURL;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;

- (void)setupSubViews;

@end
