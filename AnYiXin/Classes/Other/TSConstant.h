//
//  TSConstant.h
//  Shangdai
//
//  Created by tuanshang on 17/1/14.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#ifndef TSConstant_h
#define TSConstant_h

/** 颜色 **/
#define RGBA(r, g, b, a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)  RGBA(r, g, b, 1.0f)

#define COLOR_MainColor [UIColor colorWithHexString:@"ec9521"]
#define COLOR_SeparaterColor RGB(236, 236, 236)
#define COLOR_Message_NOColor [UIColor orangeColor]
#define COLOR_Text_GrayColor [UIColor colorWithHue:0.00 saturation:0.00 brightness:0.73 alpha:1.00]

#endif /* TSConstant_h */
