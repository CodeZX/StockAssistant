//
//  ZFPlayerCell.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Video3TableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface Video3TableViewCell ()

@property (nonatomic, strong)UIButton* playBtn;
@property(nonatomic, strong)UILabel* titLabel;
@property(nonatomic, strong)UIView* cutLine;
@property(nonatomic, strong)UIImageView* titBackgroudImageView;
@property(nonatomic, strong)UIImageView* playImageView;
@property(nonatomic, strong)UILabel* playCountLabel;

@end

@implementation Video3TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 代码添加playerBtn到imageView上
        [self.picView addSubview:self.playBtn];
        [self.picView addSubview:self.titBackgroudImageView];
        [self.picView addSubview:self.titLabel];
        [self.picView addSubview:self.playImageView];
        [self.picView addSubview:self.playCountLabel];
        [self.contentView addSubview:self.picView];
        [self.contentView addSubview:self.cutLine];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.picView.frame = self.contentView.bounds;
    self.playBtn.frame = CGRectMake(0, 0, 50, 50);
    self.playBtn.center = CGPointMake(self.picView.frame.size.width/2, self.picView.frame.size.height/2);
    self.titBackgroudImageView.frame = CGRectMake(0, CGRectGetMaxY(self.picView.frame)-70, self.picView.bounds.size.width, 70);
    self.titLabel.frame = CGRectMake(20, self.picView.bounds.size.height-70, self.picView.bounds.size.width-40, 30);
    self.playImageView.frame = CGRectMake(self.titLabel.frame.origin.x, CGRectGetMaxY(self.picView.frame)-30, 30, 30);
    self.playCountLabel.frame = CGRectMake(CGRectGetMaxX(self.playImageView.frame), self.playImageView.frame.origin.y, 150, 30);
    self.cutLine.frame = CGRectMake(0, self.contentView.bounds.size.height-0.4, self.contentView.bounds.size.width, 0.4);
    
}

- (void)hidePlayButton:(BOOL)hide
{
    self.playBtn.hidden = hide;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCoverPath:(NSString *)coverPath
{
    _coverPath = coverPath;
    [self.picView sd_setImageWithURL:[NSURL URLWithString:_coverPath] placeholderImage:[UIImage imageNamed:@"ZFPlayer.bundle/ZFPlayer_loading_bgView.png"]];
}

- (void)setVideoTitle:(NSString *)videoTitle
{
    self.titLabel.text = videoTitle;
}

- (void)setReadNumber:(NSInteger)readNumber
{
    self.playCountLabel.text = [NSString stringWithFormat:@"%ld", readNumber];
}

- (void)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    } 
}

#pragma mark - 懒加载
- (UIImageView *)picView
{
    if (!_picView) {
        // 设置imageView的tag，在PlayerView中取（建议设置100以上）
        _picView = [[UIImageView alloc] init];
        _picView.tag = 101;
        _picView.userInteractionEnabled = YES;
        _picView.contentMode = UIViewContentModeScaleAspectFill;
        _picView.clipsToBounds = YES;
    }
    return _picView;
}

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_playBtn setImage:[UIImage imageNamed:@"ZFPlayer.bundle/ZFPlayer_play_btn.png"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIView *)cutLine
{
    if (!_cutLine) {
        _cutLine = [[UIView alloc] init];
        _cutLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _cutLine;
}

- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [[UILabel alloc] init];
        _titLabel.textColor = [UIColor whiteColor];
        _titLabel.font = [UIFont systemFontOfSize:18];
        _titLabel.adjustsFontSizeToFitWidth = YES;
        _titLabel.numberOfLines = 0;
    }
    return _titLabel;
}

- (UIImageView *)playImageView
{
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc] init];
        _playImageView.contentMode = UIViewContentModeLeft;
        _playImageView.image = [UIImage imageNamed:@"icon_eye拷贝"];
    }
    return _playImageView;
}

- (UILabel *)playCountLabel
{
    if (!_playCountLabel) {
        _playCountLabel = [[UILabel alloc] init];
        [_playCountLabel setTextColor:[UIColor whiteColor]];
        _playCountLabel.font = [UIFont systemFontOfSize:15];
    }
    return _playCountLabel;
}

- (UIImageView *)titBackgroudImageView
{
    if (!_titBackgroudImageView) {
        _titBackgroudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shade.png"]];
    }
    return _titBackgroudImageView;
}

@end
