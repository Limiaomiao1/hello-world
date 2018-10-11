/**************************************************************************
 *FileName:    CFCASIPInputField.h
 *Author:      WJJ
 *Created:     9/5/16
 *Description: Implement all function of SIP input field
 *
 *Copyright (c) 2016 www.cfca.com.cn All rights reserved.
 **************************************************************************/

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    SIP_KEYBOARD_TYPE_COMPLETE = 0,
    SIP_KEYBOARD_TYPE_STANDARD_DIGITAL
}SIPKeyboardType;

typedef enum {
    OUTPUT_VALUE_TYPE_HASH_DATA = 1,
    OUTPUT_VALUE_TYPE_PLAIN_DATA = 2
}SIPOutputValueType;

typedef enum {
    SIP_KEYBOARD_CIPHER_TYPE_SM2 = 0,
    SIP_KEYBOARD_CIPHER_TYPE_RSA = 1
}SIPCipherType;

typedef enum {
    SIP_FULLKEYBOARDDISORDER_TYPE_NONE = 0,
    SIP_FULLKEYBOARDDISORDER_TYPE_DIGITAL_ONLY = 1,
    SIP_FULLKEYBOARDDISORDER_TYPE_ALL = 2
}SIPDisorderType;

typedef enum {
    SIP_INPUTFIELD_OPERATE_NONE = 0,
    SIP_INPUTFIELD_OPERATE_INSERT,
    SIP_INPUTFIELD_OPERATE_DELETE
} SIPOperateType;

@class CFCASIPInputField;
@protocol CFCASIPInputFieldDelegate <NSObject>

- (BOOL)onKeyDone:(CFCASIPInputField *)sipInputField;

- (void)onSIPInputFieldTextDidChanged:(CFCASIPInputField *)sipInputField withOperateType:(SIPOperateType)operateType;

@end

@interface CFCASIPInputField : UITextField

@property (nonatomic, assign) NSInteger nMinInputLength;
@property (nonatomic, assign) NSInteger nMaxInputLength;
@property (nonatomic, assign) BOOL bIsShowLastCharacter;
@property (nonatomic, assign) BOOL bIsNeedInputEncrypt;
@property (nonatomic, assign) SIPKeyboardType emSipKeyboardType;
@property (nonatomic, assign) BOOL bIsNeedKeyboardAnimation;
@property (nonatomic, assign) BOOL bHaveButtonClickSound;
@property (nonatomic, strong) NSString *strServerRandom;
@property (nonatomic, strong) NSString *strInputRegex;
@property (nonatomic, strong) NSString *strMatchRegex;
@property (nonatomic, assign) SIPOutputValueType emOutputValueType;
@property (nonatomic, assign) SIPCipherType cipherType;
@property (nonatomic, assign) SIPDisorderType disorderType;
@property (nonatomic, assign, readonly) NSInteger lastErrorCode;
@property (nonatomic, assign) id<CFCASIPInputFieldDelegate> sipInputFieldDelegate;

/*!
 @function
 @abstract   set image for Space Key ,eg. company Logo
 @param      [in]spaceImage : The image you want to set for Space Key ,default or set nil is CFCALogo,image should be size of
 @param      [out]errorCode : when an error occur,errorCode will be set
 @result     [BOOL]success : YES , fail : NO
 */
- (BOOL)setImageForSpaceKey:(UIImage *)spaceImage;

/*!
 @function
 @abstract   Check input value wether match matchRegex
 @param      [out]errorCode : when an error occur,errorCode will be set
 @result     [BOOL]match : YES , not match : NO
 */
- (BOOL)checkMatchRegexWithError:(NSInteger *)errorCode;

/*!
 @function
 @abstract   Check value of other SIPInputField's value wether match selfs
 @param      [out]errorCode : when an error occur,errorCode will be set
 @result     [BOOL]match : YES , not match : NO
 */
- (BOOL)checkInputValueEqual:(CFCASIPInputField *)otherSIPInputField
                   withError:(NSInteger *)errorCode;

/*!
 @function
 @abstract   get encrypted input data when needEncrypt is YES or plain data when needEncrypt is NO.
 @param      [out]errorCode : when an error occur,errorCode will be set
 @result     [NSString*]the encrypted data when needEncrypt is YES or plain data when needEncrypt is NO
 */
- (NSString *)getEncryptedDataWithError:(NSInteger *)errorCode;

/*!
 @function
 @abstract   get encrypted input data when needEncrypt is YES or plain data when needEncrypt is NO.
 @param      [out]errorCode : when an error occur,errorCode will be set
 @result     [NSString*]the encrypted data when needEncrypt is YES or plain data when needEncrypt is NO
 */
- (NSString *)getEncryptedClientRandomWithError:(NSInteger *)errorCode;

/*!
 @function
 @abstract   get length of input data
 @param      [out]errorCode : when an error occur,errorCode will be set
 @result     [NSInteger] length of input data
 */
- (NSInteger)getInputLengthWithError:(NSInteger *)errorCode;

/*!
 @function
 @abstract   get version of current app
 @result     [NSInteger] length of input data
 */
- (NSString *)getVersion;

/*!
 @function
 @abstract   clear all input data
 @result     [NSInteger] success:0, failed:error code
 */
- (NSInteger)clearAllInputCharacters;

@end


@interface CFCAGridSIPInputField : CFCASIPInputField

@property (nonatomic, assign)NSUInteger gridNumber;
@property (nonatomic, assign)int gridBorderWidth;
@property (nonatomic, assign)int gridTextSize;
@property (nonatomic, strong)UIColor *gridBorderColor;
@property (nonatomic, strong)UIColor *gridTextColor;

@end