//
//  JYCommentCell.m
//  246News
//
//  Created by tunjin on 2018/5/11.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "JYCommentCell.h"

@implementation JYCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconImageView.layer.cornerRadius = 11;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contextLabel];
        [self.contentView addSubview:self.reportButton];
        [self.contentView addSubview:self.cutline];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(20, 20, 30, 30);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10, self.iconImageView.frame.origin.y, 150, 30);
    self.timeLabel.frame = CGRectMake(self.contentView.bounds.size.width-120, self.iconImageView.frame.origin.y, 100, 30);
    self.contextLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame), self.contentView.bounds.size.width-50, self.contentView.bounds.size.height-CGRectGetMaxY(self.iconImageView.frame));
    self.reportButton.frame = CGRectMake(self.contentView.bounds.size.width-90, self.contentView.bounds.size.height-40, 70, 30);
    self.cutline.frame = CGRectMake(20, self.contentView.bounds.size.height-0.4, self.contentView.bounds.size.width-40, 0.4);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

//举报
- (void)reportAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reportAction:)]) {
        [self.delegate reportAction:sender];
    }
}



+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 15;
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)contextLabel
{
    if (!_contextLabel) {
        _contextLabel = [[UILabel alloc] init];
        _contextLabel.textColor = [UIColor blackColor];
        _contextLabel.numberOfLines = 0;
    }
    return _contextLabel;
}

- (UIButton *)reportButton
{
    if (!_reportButton) {
        _reportButton = [[UIButton alloc] init];
        [_reportButton setImage:[UIImage imageNamed:@"icon_report2.png"] forState:UIControlStateNormal];
        [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
        [_reportButton addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
        [_reportButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_reportButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _reportButton;
}

- (UIView *)cutline
{
    if (!_cutline) {
        _cutline = [[UIView alloc] init];
        _cutline.backgroundColor = [UIColor lightGrayColor];
    }
    return _cutline;
}

@end
