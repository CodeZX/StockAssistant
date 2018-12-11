//
//  VideoTableViewCell.m
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/4.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import "CompanyTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CompanyTableViewCell()

@property(nonatomic, strong)UIImageView* coverImageView;
@property(nonatomic, strong)UIImageView* titBackgroudImageView;
@property(nonatomic, strong)UILabel* titLabel;

@end

@implementation CompanyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titBackgroudImageView];
        [self.contentView addSubview:self.titLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.coverImageView.frame = CGRectMake(self.edgeInsets.left, self.edgeInsets.top, self.contentView.bounds.size.width-self.edgeInsets.left-self.edgeInsets.right, self.contentView.bounds.size.height-self.edgeInsets.top-self.edgeInsets.bottom);
    self.titBackgroudImageView.frame = CGRectMake(self.coverImageView.frame.origin.x, CGRectGetMaxY(self.coverImageView.frame)-70, self.coverImageView.bounds.size.width, 40);
    self.titLabel.frame = CGRectMake(self.coverImageView.frame.origin.x+20, CGRectGetMaxY(self.coverImageView.frame)-70, self.coverImageView.bounds.size.width-40, 40);
}

- (void)setName:(NSString *)name
{
    _titLabel.text = name;
}

- (void)setPicture:(NSString *)picture
{
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:picture] placeholderImage:nil];
    //_coverImageView.image = [UIImage imageNamed:picture];
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.layer.cornerRadius = 5;
        _coverImageView.layer.masksToBounds = YES;
    }
    return _coverImageView;
}

- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [[UILabel alloc] init];
        [_titLabel setTextColor:[UIColor whiteColor]];
        _titLabel.font = [UIFont systemFontOfSize:20];
        //_titLabel.backgroundColor = [UIColor lightGrayColor];
        _titLabel.numberOfLines = 0;
        _titLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titLabel;
}

- (UIImageView *)titBackgroudImageView
{
    if (!_titBackgroudImageView) {
        _titBackgroudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shade.png"]];
    }
    return _titBackgroudImageView;
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
