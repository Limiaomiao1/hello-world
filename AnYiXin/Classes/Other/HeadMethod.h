//
//  HeadMethod.h
//  Shangdai
//
//  Created by tuanshang on 17/2/10.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#ifndef HeadMethod_h
#define HeadMethod_h

/** 判断机型 */
//iPhone4 4s机型
#define ScreenInch4S (TSScreenH < 568)
//iPhone4 5s机型
#define ScreenInch5S (TSScreenH == 568)
//iPhone6 6s机型
#define ScreenInch6S (TSScreenH < 668 && TSScreenH > 666)

/** 屏幕尺寸 */
#define TSScreenW [UIScreen mainScreen].bounds.size.width
#define TSScreenH [UIScreen mainScreen].bounds.size.height

/** 字体大小 */
#define FONT(a) [UIFont systemFontOfSize:a]

/** 控件高度 **/
#define navigationHeight 64
#define tabbarHeight 49
#define BottomH 44.0
#define TopTabBarH 44.0
#define NaviBarH 64.0

























#endif /* HeadMethod_h */
