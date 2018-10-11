//
//  NSString+Extensions.m
//  Shangdai
//
//  Created by tuanshang on 17/2/17.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "NSString+Extensions.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation NSString (Extensions)

// 判断用户名
- (BOOL)isUserName
{
    if(self.length <= 0 || self.length > 20){
        return NO;
    }
    return YES;
}

// 判断密码强度

- (BOOL)isCheckPassword
{
    
    NSString * pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    return [pred evaluateWithObject:self];
}

// 时间戳
- (NSString *)timeDataWithTimeStr {
    NSDate *datea = [NSDate dateWithTimeIntervalSince1970:[self intValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * str = [formatter stringFromDate:datea];
    return str;
}


// 判断手机号是否正确
- (NSString *)isValiMobile
{
    if (self.length < 11)
    {
        return @"请输入11位正确的手机号码";
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:self];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:self];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:self];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return nil;
        }else{
            return @"请输入正确的手机号码";
        }
    }
    return nil;
}

// MD5加密
- (NSString *)MD5String
{
    /**
     *  创建容器数组
     */
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    /**
     *  MD5加密
     */
    CC_MD5(self.UTF8String, (CC_LONG)self.length, result);
    /**
     *  创建容器字符串
     */
    NSMutableString * string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [string appendFormat:@"%02x", result[i]];
    }
    
    return string;
}

// 根据内容及字体计算需要的空间
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGSize retSize = [self boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
}

// 根据内容及字体计算需要的空间
- (CGSize)getSizeWithFont:(UIFont *)font Width:(CGFloat)width
{
    CGSize size;
    CGSize constrainSize = CGSizeMake(width,2000);
    size = [self boundingRectWithSize:constrainSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return size;
}

@end
