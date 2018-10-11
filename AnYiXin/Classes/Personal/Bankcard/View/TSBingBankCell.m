//
//  TSBingBankCell.m
//  CheZhongChou
//
//  Created by TuanShang on 16/5/5.
//  Copyright © 2016年 TuanShang. All rights reserved.
//

#import "TSBingBankCell.h"

@interface  TSBingBankCell ()<UITextFieldDelegate>


@end

@implementation TSBingBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:)]) {
        [self.delegate textViewCell:self didChangeText:textField.text];
    }
    
}

@end
