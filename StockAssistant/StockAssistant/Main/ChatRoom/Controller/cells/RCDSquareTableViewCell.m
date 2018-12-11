//
//  RCDSquareTableViewCell.m
//  天空资讯
//
//  Created by 周峻觉 on 2018/6/5.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import "RCDSquareTableViewCell.h"
#import "Colors.h"

@interface RCDSquareTableViewCell()

@property(nonatomic, strong)UIView* container;
@property(nonatomic, strong)UIImageView* headImageView;
@property(nonatomic, strong)UILabel* headLabel;
@property(nonatomic, strong)UIImageView* thum_1_headImageView;
@property(nonatomic, strong)UIImageView* thum_2_headImageView;
@property(nonatomic, strong)UIImageView* thum_3_headImageView;
@property(nonatomic, strong)UILabel* titLabel;
@property(nonatomic, strong)UILabel* countLabel;

@end

@implementation RCDSquareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.container];
        [self.container addSubview:self.headImageView];
        [self.container addSubview:self.thum_1_headImageView];
        [self.container addSubview:self.thum_2_headImageView];
        [self.container addSubview:self.thum_3_headImageView];
        [self.container addSubview:self.titLabel];
        [self.container addSubview:self.countLabel];
        
        [self.headImageView addSubview:self.headLabel];
        
        [self setHeads];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat containerW = self.contentView.bounds.size.width-20;
    CGFloat containerH = self.contentView.bounds.size.height-10;
    
    self.container.frame = CGRectMake(10, 10, containerW, containerH);
    
    CGFloat headImageViewWH = self.container.bounds.size.height-30;
    self.headImageView.frame = CGRectMake(15, 15, headImageViewWH, headImageViewWH);
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2.0;
    
    self.headLabel.frame = self.headImageView.bounds;
    
    self.thum_3_headImageView.frame = CGRectMake(containerW-45, (containerH-30)*0.5, 30, 30);
    self.thum_3_headImageView.layer.cornerRadius = 15;
    self.thum_2_headImageView.frame = CGRectMake(self.thum_3_headImageView.frame.origin.x-25, (containerH-30)*0.5, 30, 30);
    self.thum_2_headImageView.layer.cornerRadius = 15;
    self.thum_1_headImageView.frame = CGRectMake(self.thum_2_headImageView.frame.origin.x-25, (containerH-30)*0.5, 30, 30);
    self.thum_1_headImageView.layer.cornerRadius = 15;
    
    self.titLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, 0, self.thum_1_headImageView.frame.origin.x-10-CGRectGetMaxX(self.headImageView.frame)-10, containerH*0.6);
    
    self.countLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, containerH*0.45, self.thum_1_headImageView.frame.origin.x-10-CGRectGetMaxX(self.headImageView.frame)-10, containerH*0.5);
    
}

- (void)setHeads
{
    self.thum_1_headImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"head%d.png", rand()%30+1]];
    self.thum_2_headImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"head%d.png", rand()%30+1]];
    self.thum_3_headImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"head%d.png", rand()%30+1]];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titLabel.text = title;
    self.headLabel.text = [title substringToIndex:1];
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld人在线", count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)container
{
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _container.layer.borderWidth = 0.5;
    }
    return _container;
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = [[Colors share] any];
    }
    return _headImageView;
}

- (UILabel *)headLabel
{
    if (!_headLabel) {
        _headLabel = [[UILabel alloc] init];
        _headLabel.font = [UIFont systemFontOfSize:25];
        _headLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headLabel;
}

- (UIImageView *)thum_1_headImageView
{
    if (!_thum_1_headImageView) {
        _thum_1_headImageView = [[UIImageView alloc] init];
        _thum_1_headImageView.backgroundColor = [UIColor grayColor];
    }
    return _thum_1_headImageView;
}

- (UIImageView *)thum_2_headImageView
{
    if (!_thum_2_headImageView) {
        _thum_2_headImageView = [[UIImageView alloc] init];
        _thum_2_headImageView.backgroundColor = [UIColor grayColor];
    }
    return _thum_2_headImageView;
}

- (UIImageView *)thum_3_headImageView
{
    if (!_thum_3_headImageView) {
        _thum_3_headImageView = [[UIImageView alloc] init];
        _thum_3_headImageView.backgroundColor = [UIColor grayColor];
    }
    return _thum_3_headImageView;
}

- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [[UILabel alloc] init];
        _titLabel.text = @"聊天室";
        _titLabel.textColor = [UIColor blackColor];
        _titLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.text = @"9999人在线";
        _countLabel.textColor = [UIColor grayColor];
        _countLabel.font = [UIFont systemFontOfSize:15];
    }
    return _countLabel;
}

@end
