//
//  TSMessageCell.m
//  ZhuoJin
//
//  Created by tuanshang on 16/12/5.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSMessageCell.h"
#import "TSMessageModel.h"

@implementation TSMessageCell
// 初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubVies];
    }
    return self;
}
// 设置子视图
- (void)setupSubVies {

    
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    UIView * bigview = [[UIView alloc] init];
    bigview.backgroundColor = [UIColor whiteColor];
    bigview.layer.shadowColor=[[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor;
    
    bigview.layer.shadowOffset=CGSizeMake(1,1);
    
    bigview.layer.shadowOpacity=0.2;
    
    bigview.layer.shadowRadius=4;
    bigview.layer.cornerRadius =4;
     bigview.layer.masksToBounds = YES;
    [self.contentView addSubview:bigview];
    
    [bigview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [bigview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
    [bigview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
    [bigview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, TSScreenW-10, 50)];
    self.title.font = [UIFont systemFontOfSize:13];
    self.title.numberOfLines = 2;
    self.title.text = @"信息标题:";
    [self.contentView addSubview:self.title];
    
    self.messageInfo = [[UILabel alloc] init];
    self.messageInfo.font = [UIFont systemFontOfSize:13];
    self.messageInfo.numberOfLines = 0;
    [self.contentView addSubview:self.messageInfo];
    [self.messageInfo autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [self.messageInfo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.title withOffset:3];
    [self.messageInfo autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    
    self.timelabel = [[UILabel alloc] init];
    self.timelabel.textAlignment = NSTextAlignmentRight;
    self.timelabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.timelabel];
    [self.timelabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.messageInfo withOffset:3];
    [self.timelabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [self.timelabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];

}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setMessageModel:(TSMessageModel *)messageModel {
    _messageModel = messageModel;
    
    if ([messageModel.status isEqualToString:@"0"]) {
        self.title.text = [NSString stringWithFormat:@"(未读)消息标题：%@", messageModel.title];
        self.title.textColor = COLOR_Message_NOColor;
    } else if ([messageModel.status isEqualToString:@"1"]) {
        self.title.text = [NSString stringWithFormat:@"(已读)消息标题：%@", messageModel.title];
        self.title.textColor = [UIColor blackColor];
    }
    self.title.numberOfLines = 1;
    self.messageInfo.text = [NSString stringWithFormat:@" %@", messageModel.msg];
    self.timelabel.text = messageModel.send_time;
    
}

// 计算行高
+ (CGFloat)heightForTextCellWithNewsDic:(TSMessageModel *)messagemodel
{
    CGFloat titleHeight = 50;
    CGFloat detailHeight = [TSMessageCell heightForText:messagemodel.msg FontSize:12 width:TSScreenW-30];
    CGFloat height = 15 + titleHeight + detailHeight + 30 ;
    return height;
}


// 计算字符的高度
+ (CGFloat)heightForText:(NSString *)text FontSize:(CGFloat)fontSize width:(CGFloat)width
{
    
    // 字符绘制区域
    CGSize size = CGSizeMake(width, 1000);
    CGRect textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil];
    return textRect.size.height;
}

@end
