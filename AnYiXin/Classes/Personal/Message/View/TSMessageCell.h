//
//  TSMessageCell.h
//  ZhuoJin
//
//  Created by tuanshang on 16/12/5.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSMessageModel;

@interface TSMessageCell : UITableViewCell

/** 标题 */
@property (nonatomic, strong) UILabel *title;
/** 内容 */
@property (nonatomic, strong) UILabel *messageInfo;
/** 时间 */
@property (nonatomic, strong) UILabel *timelabel;
/** 模型 */
@property (nonatomic, strong) TSMessageModel *messageModel;
/** 类方法 */
+ (CGFloat)heightForTextCellWithNewsDic:(TSMessageModel *)messageModel;

@end
