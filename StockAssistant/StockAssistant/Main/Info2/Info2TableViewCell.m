//
//  VideoTableViewCell.m
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/4.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import "Info2TableViewCell.h"
#import "UIImageView+WebCache.h"

@interface Info2TableViewCell()

@property(nonatomic, strong)UIImageView* coverImageView;
@property(nonatomic, strong)UIImageView* playImageView;
@property(nonatomic, strong)UILabel* titLabel;
@property(nonatomic, strong)UILabel* playCountLabel;
@property(nonatomic, strong)UILabel* timeLabel;
//@property(nonatomic, strong)UIImageView* titBackgroudImageView;

@end

@implementation Info2TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.coverImageView];
        [self.coverImageView addSubview:self.playImageView];
        //[self.contentView addSubview:self.titBackgroudImageView];
        [self.contentView addSubview:self.titLabel];
        [self.contentView addSubview:self.playCountLabel];
        [self.contentView addSubview:self.timeLabel];
        
        if (_isVideo) {
            self.playImageView.hidden = NO;
        }else{
            self.playImageView.hidden = YES;
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat space = 10;
    CGFloat imageW = (self.contentView.bounds.size.width-3*space)*0.5;
    CGFloat imageH = self.contentView.bounds.size.height-2*space;
    
    CGFloat timeH = 30;
    
    CGFloat titleW = (self.contentView.bounds.size.width-3*space)*0.5;
    CGFloat titleH = imageH - timeH;
    
    self.coverImageView.frame = CGRectMake(space, space, imageW, imageH);
    //self.titBackgroudImageView.frame = CGRectMake(self.coverImageView.frame.origin.x, CGRectGetMaxY(self.coverImageView.frame)-70, self.coverImageView.bounds.size.width, 70);
    self.titLabel.frame = CGRectMake(CGRectGetMaxX(self.coverImageView.frame)+space, space, titleW, titleH);
    self.playImageView.frame = CGRectMake(0, 0, 30, 30);
    self.playImageView.center = CGPointMake(self.coverImageView.bounds.size.width*0.5, self.coverImageView.bounds.size.height*0.5);
    self.playCountLabel.frame = CGRectMake(CGRectGetMaxX(self.coverImageView.frame)+space, CGRectGetMaxY(self.coverImageView.frame)-timeH, 150, 30);
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame)-80, self.playCountLabel.frame.origin.y, 70, timeH);
}

- (void)setIsVideo:(BOOL)isVideo
{
    _isVideo = isVideo;
    if (_isVideo) {
        self.playImageView.hidden = NO;
    }else{
        self.playImageView.hidden = YES;
    }
}

- (void)setInfoModel:(InfoModel *)infoModel
{
    _infoModel = infoModel;
    
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:_infoModel.synopsisPic] placeholderImage:nil];
    [_titLabel setText:_infoModel.title];
    [_playCountLabel setText:[NSString stringWithFormat:@"%ld 人阅读", _infoModel.readNumber]];
    [_timeLabel setText:_infoModel.date];
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        //_coverImageView.layer.cornerRadius = 5;
        _coverImageView.layer.masksToBounds = YES;
    }
    return _coverImageView;
}

- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [[UILabel alloc] init];
        [_titLabel setTextColor:[UIColor blackColor]];
        _titLabel.font = [UIFont systemFontOfSize:18];
        _titLabel.numberOfLines = 0;
    }
    return _titLabel;
}

- (UIImageView *)playImageView
{
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc] init];
        _playImageView.contentMode = UIViewContentModeScaleAspectFit;
        _playImageView.image = [UIImage imageNamed:@"icon_play"];
    }
    return _playImageView;
}

- (UILabel *)playCountLabel
{
    if (!_playCountLabel) {
        _playCountLabel = [[UILabel alloc] init];
        [_playCountLabel setTextColor:[UIColor blackColor]];
        _playCountLabel.font = [UIFont systemFontOfSize:15];
    }
    return _playCountLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setTextColor:[UIColor blackColor]];
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _timeLabel;
}

//- (UIImageView *)titBackgroudImageView
//{
//    if (!_titBackgroudImageView) {
//        _titBackgroudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shade.png"]];
//    }
//    return _titBackgroudImageView;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
