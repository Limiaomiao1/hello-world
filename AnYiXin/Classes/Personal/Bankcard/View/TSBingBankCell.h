//
//  TSBingBankCell.h
//  CheZhongChou
//
//  Created by TuanShang on 16/5/5.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSBingBankCell;

@protocol TSBingBankCellDelegate <NSObject>

/** textFile的代理 */
- (void)textViewCell:(TSBingBankCell *)cell didChangeText:(NSString *)text;

@end

@interface TSBingBankCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTF;

@property (nonatomic, weak) id<TSBingBankCellDelegate> delegate;


@end
