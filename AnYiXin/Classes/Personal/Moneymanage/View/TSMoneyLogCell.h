//
//  TSMoneyLogCell.h
//  ZhuoJin
//
//  Created by tuanshang on 16/12/6.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSMoneyLogModel;

@interface TSMoneyLogCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;/**< 可用余额 */
@property (weak, nonatomic) IBOutlet UILabel *addTime;/**< 添加时间 */
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;/**< 编号 */
@property (weak, nonatomic) IBOutlet UILabel *affectLabel;/**< 变动金额 */
@property (weak, nonatomic) IBOutlet UILabel *backLabel;/**< 回款金额 */
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;/**< 待收金额 */
@property (weak, nonatomic) IBOutlet UILabel *freezeLabel;/**< 冻结金额 */
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;/**< 类型 */
@property (weak, nonatomic) IBOutlet UITextView *infoView;/**< 资金记录 */

/** 模型 */
@property (nonatomic, strong) TSMoneyLogModel *moneylogModel;

@end
