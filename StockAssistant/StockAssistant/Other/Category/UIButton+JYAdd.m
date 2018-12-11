//
//  UIButton+JYAdd.m
//  246News
//
//  Created by hcios on 2017/7/15.
//  Copyright © 2017年 徐冬苏. All rights reserved.
//

#import "UIButton+JYAdd.h"

@implementation UIButton (JYAdd)

// 设置button的titleLabel和imageView的布局样式，及间距
- (void)dong_layoutButtonWithEdgeInsetsStyle:(dong_ButtonEdgeInsetsStyle)dong_style
                           imageTitleSpace:(CGFloat)dong_space isSizeToFit:(BOOL)isSizeToFit{
    
    if (isSizeToFit == YES) {
        [self sizeToFit];

    }
    // 得到imageView和titleLabel的宽、高
    
    CGFloat dong_imageWidth  = 0.0;
    CGFloat dong_imageHeight = 0.0;
    
    CGFloat dong_labelWidth  = 0.0;
    CGFloat dong_labelHeight = 0.0;
    
    if (self.currentImage) {
        dong_imageWidth  = self.imageView.bounds.size.width;
        dong_imageHeight = self.imageView.bounds.size.height;
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        dong_labelWidth  = self.titleLabel.intrinsicContentSize.width;
        dong_labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        dong_labelWidth  = self.titleLabel.frame.size.width;
        dong_labelHeight = self.titleLabel.frame.size.height;
    }
    
    UIEdgeInsets dong_imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets dong_labelEdgeInsets = UIEdgeInsetsZero;
    
    // 根据dong_style和dong_space得到dong_imageEdgeInsets和dong_labelEdgeInsets的值
    switch (dong_style) {
        case dong_ButtonEdgeInsetsStyleTop:
            dong_imageEdgeInsets = UIEdgeInsetsMake(-dong_labelHeight-dong_space/2.0, 0, 0, -dong_labelWidth);
            dong_labelEdgeInsets = UIEdgeInsetsMake(0, -dong_imageWidth, -dong_imageHeight-dong_space/2.0, 0);
            break;
        case dong_ButtonEdgeInsetsStyleLeft:
            dong_imageEdgeInsets = UIEdgeInsetsMake(0, -dong_space/2.0, 0, dong_space/2.0);
            dong_labelEdgeInsets = UIEdgeInsetsMake(0, dong_space/2.0, 0, -dong_space/2.0);
            break;
        case dong_ButtonEdgeInsetsStyleBottom:
            dong_imageEdgeInsets = UIEdgeInsetsMake(0, 0, -dong_labelHeight-dong_space/2.0, -dong_labelWidth);
            dong_labelEdgeInsets = UIEdgeInsetsMake(-dong_imageHeight-dong_space/2.0, -dong_imageWidth, 0, 0);
            break;
        case dong_ButtonEdgeInsetsStyleRight:
            dong_imageEdgeInsets = UIEdgeInsetsMake(0, dong_labelWidth+dong_space/2.0, 0, -dong_labelWidth-dong_space/2.0);
            dong_labelEdgeInsets = UIEdgeInsetsMake(0, -dong_imageWidth-dong_space/2.0, 0, dong_imageWidth+dong_space/2.0);
            break;
        default:
            break;
    }
    self.titleEdgeInsets = dong_labelEdgeInsets;
    self.imageEdgeInsets = dong_imageEdgeInsets;
    if (isSizeToFit == YES) {
        [self sizeToFit];

    }
}

@end
