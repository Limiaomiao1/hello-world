//
//  NSString+Extensions.h
//  Shangdai
//
//  Created by tuanshang on 17/2/17.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

- (BOOL)isUserName; // 检测用户名

- (BOOL)isCheckPassword; // 检查密码强度

- (NSString *)timeDataWithTimeStr; //时间戳

- (NSString *)MD5String; // MD5加密

- (NSString *)isValiMobile; // 检测手机号正确性

- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font; // 根据内容及字体计算需要的空间

- (CGSize)getSizeWithFont:(UIFont *)font Width:(CGFloat)width; // 根据内容及字体计算需要的空间


@end
