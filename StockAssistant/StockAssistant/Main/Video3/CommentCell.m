//
//  CommentCell.m
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/7.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell()

@property(nonatomic, strong)UILabel* userNameLabel;
@property(nonatomic, strong)UILabel* contentLabel;
@property(nonatomic, strong)UILabel* timeLabel;
@property(nonatomic, strong)UIView* cutline;

@end

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.cutline];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.userNameLabel.frame = CGRectMake(30, 0, self.contentView.bounds.size.width-60, 40);
    self.timeLabel.frame = CGRectMake(30, self.contentView.bounds.size.height-40, self.contentView.bounds.size.width-60, 40);
    self.contentLabel.frame = CGRectMake(30, CGRectGetMaxY(self.userNameLabel.frame), self.contentView.bounds.size.width-60, self.contentView.bounds.size.height-self.userNameLabel.bounds.size.height-self.timeLabel.bounds.size.height);
    
    self.cutline.frame = CGRectMake(30, self.contentView.frame.size.height-0.4, self.contentView.frame.size.width-30, 0.4);
    
}

- (void)setUserName:(NSString *)userName
{
    _userNameLabel.text = userName;
}

- (void)setContent:(NSString *)content
{
    _contentLabel.text = content;
}

- (void)setTimeString:(NSString *)timeString
{
    _timeLabel.text = timeString;
}

- (UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont systemFontOfSize:15 weight:0.2];
        _userNameLabel.textColor = [UIColor blackColor];
        //_userNameLabel.text = @"豹子头林聪";
    }
    return _userNameLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor blackColor];
        //_contentLabel.text = @"天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯天空资讯";
    }
    return _contentLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [UIColor lightGrayColor];
        //_timeLabel.text = @"2018-09-09 12:12:12";
    }
    return _timeLabel;
}

- (UIView *)cutline
{
    if (!_cutline) {
        _cutline = [[UIView alloc] init];
        _cutline.backgroundColor = [UIColor lightGrayColor];
    }
    return _cutline;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
