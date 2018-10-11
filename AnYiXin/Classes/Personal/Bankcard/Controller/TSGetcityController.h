//
//  TSGetcityController.h
//  CheZhongChou
//
//  Created by TuanShang on 16/5/5.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cityNameDelegate <NSObject>

- (void )getCityName:(NSString *)provin withCity:(NSString *)city withProvinID:(NSString *)provinID withCityID:(NSString *)cityID;

@end

@interface TSGetcityController : UIViewController

@property (nonatomic, copy) NSString * provinID;
@property (nonatomic, copy) NSString * provinName;
@property (nonatomic , copy) NSString * cityID;

@property (nonatomic, assign) id<cityNameDelegate> delegate;

@end
