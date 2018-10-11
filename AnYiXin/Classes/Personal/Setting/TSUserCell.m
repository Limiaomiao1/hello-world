//
//  TSUserCell.m
//  TuanShang
//
//  Created by TuanShang on 16/7/16.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSUserCell.h"
#import <UIImageView+WebCache.h>

@implementation TSUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self setUpSubViews];
    }
    
    return self;
    
}

- (void)setUpSubViews {
    
    
    self.userImageView = [[UIImageView alloc]init];
    self.userImageView.layer.cornerRadius = 40;
    self.userImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.userImageView];

    self.userLabel = [[UILabel alloc]init];
    self.userLabel.font = [UIFont systemFontOfSize:15];
    self.userLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.userLabel];
  
    self.userphoneLabel = [[UILabel alloc]init];
    self.userphoneLabel.font = [UIFont systemFontOfSize:14];
    self.userphoneLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.userphoneLabel];
    
    [self.userImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.userImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [self.userImageView autoSetDimensionsToSize:CGSizeMake(80, 80)];
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"header_img"]] placeholderImage:[UIImage imageNamed:@"icon_user"]];
    
    [self.userLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userImageView withOffset:15];
    [self.userLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImageView withOffset:15];
    
    self.userLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_name"];
    
    [self.userphoneLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.userLabel];
    [self.userphoneLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userLabel withOffset:10];
    
    self.userphoneLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_phone"];
}

@end
