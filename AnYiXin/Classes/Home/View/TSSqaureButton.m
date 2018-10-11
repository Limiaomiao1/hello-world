//
//  TSSqaureButton.m
//  Shangdai
//
//  Created by tuanshang on 17/2/11.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSSqaureButton.h"
#import "TSSqaureModel.h"


@implementation TSSqaureButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setBackgroundColor:[UIColor whiteColor]];
        
    }
    return self;
}

- (void)setSqaure:(TSSqaureModel *)sqaure {
    
    _sqaure = sqaure;
    [self setTitle:sqaure.name forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:sqaure.icon] forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 图片
    self.imageView.y = self.height * 0.1;
    self.imageView.height = self.height * 0.45;
    self.imageView.width = self.imageView.height;
    self.imageView.centerX = self.width * 0.5;
    
    // 文字
    self.titleLabel.width = self.width;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.height = self.height - self.titleLabel.y;
    self.titleLabel.x = 0;
}

@end
