//
//  JYASKTableViewCell+CommunityItem.m
//  246News
//
//  Created by tunjin on 2018/5/3.
//  Copyright © 2018年 JY. All rights reserved.
//

#import "JYASKTableViewCell+CommunityItem.h"
#import "JYCommunity.h"
#import "DSAvatarBrowser.h"
#import "UIImageView+WebCache.h"
#import "UIButton+JYAdd.h"
//#import "Const.h"
#define PIC_WIDTH 70
#define PIC_HEIGHT 80
#define COL_COUNT 3

@implementation JYASKTableViewCell (CommunityItem)

- (void)configCellWithModel:(id)model {
    JYCommunity_retData * item = (JYCommunity_retData *)model;
    self.nameLabel.text = item.user_name;
    self.titleLabel.text = item.title;
    self.contextLab.text = item.text;
    self.timeLabel.text = item.time;
    [self.likeButton setTitle:item.like_num forState:UIControlStateNormal];
    [self.replyButton setTitle:item.comment forState:UIControlStateNormal];
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:item.user_pic] placeholderImage:[UIImage imageNamed:@"icon_head40"]];
    
    [self.reportButton dong_layoutButtonWithEdgeInsetsStyle:dong_ButtonEdgeInsetsStyleTop imageTitleSpace:8 isSizeToFit:YES];
    [self.likeButton dong_layoutButtonWithEdgeInsetsStyle:dong_ButtonEdgeInsetsStyleTop imageTitleSpace:8 isSizeToFit:YES];
    [self.replyButton dong_layoutButtonWithEdgeInsetsStyle:dong_ButtonEdgeInsetsStyleTop imageTitleSpace:8 isSizeToFit:YES];
    
    if ([item.is_like isEqualToString:@"1"]) {
        self.likeButton.selected = YES;
    }else {
        self.likeButton.selected = NO;
    }
    
    
    if ([item.pic isEqualToString:@""]) {
        self.imageHight.constant = 1;
        self.fileView.hidden = YES;
    }else {
        NSArray  *array = [item.pic componentsSeparatedByString:@","];
        self.fileView.hidden = NO;
        self.imageHight.constant = (10 + PIC_HEIGHT) * ((array.count - 1) / COL_COUNT + 1) + 10;
        [self ds_setfileImage:array andView:self.fileView];
    }
}

- (void)ds_setfileImage:(NSArray *)fileArray andView:(UIView *)fileView {
    for (NSInteger i = 0; i < fileArray.count; i++) {
        //所在行
        NSInteger row = i / COL_COUNT;
        //所在列
        NSInteger col = i % COL_COUNT;
        //间距
        CGFloat margin = (fileView.bounds.size.width - (PIC_WIDTH * COL_COUNT)) / (COL_COUNT + 1);
        CGFloat picX = margin + (PIC_WIDTH + margin) * col;
        CGFloat picY = 10 + (PIC_HEIGHT + 10) * row;

        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.layer.borderWidth = 2.0f;
        imageView.layer.borderColor = RGB(230, 230, 230).CGColor;
        [imageView sd_setImageWithURL:[NSURL URLWithString:fileArray[i]] placeholderImage:[UIImage imageNamed:@"logo"] options:SDWebImageCacheMemoryOnly];
        [fileView addSubview:imageView];
        //允许交互
        imageView.userInteractionEnabled = YES;
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        imageView.frame = CGRectMake(picX, picY, PIC_WIDTH, PIC_HEIGHT);
    }
}

////图片点击放大
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [DSAvatarBrowser showImage:(UIImageView *)tap.view];
}

@end
