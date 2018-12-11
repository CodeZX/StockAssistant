//
//  JYASKTableViewCell.m
//  246News
//
//  Created by apple on 2018/1/30.
//  Copyright © 2018年 Edgar_Guan. All rights reserved.
//

#import "JYASKTableViewCell.h"

@implementation JYASKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.iconImage.layer.cornerRadius = 11;
    
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

//点赞按钮
- (IBAction)likeButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(likeButtonAction:)]) {
        [self.delegate likeButtonAction:sender];
    }
}

//举报按钮
- (IBAction)reportButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reportButtonAction:)]) {
        [self.delegate reportButtonAction:sender];
    }
}

@end
