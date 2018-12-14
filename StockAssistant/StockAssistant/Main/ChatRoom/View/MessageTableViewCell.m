//
//  MessageTableViewCell.m
//  demo
//
//  Created by tunjin on 2018/12/13.
//  Copyright © 2018 Awaken. All rights reserved.
//

#import "MessageTableViewCell.h"
#import <Masonry.h>

@implementation MessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setupSubViews
{
    [self addSubview:self.iconImgView];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.iconImgView.mas_top);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.subLabel];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.subLabel.mas_bottom).offset(10);
    }];
    
}

- (void)setConversation:(JMSGConversation *)conversation{
    _conversation = conversation;
    if (_conversation) {
        self.nameLabel.text =  [NSString stringWithFormat:@"%@",[conversation valueForKey:@"name"]];
        self.iconImgView.image = [UIImage imageNamed:@"icon_head"];
//        self.subLabel.text = conversation.latestMessage;
        
    }
}


#pragma mark - Lazy
- (UIImageView *)iconImgView
{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UILabel *)subLabel
{
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
    }
    return _subLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

@end
