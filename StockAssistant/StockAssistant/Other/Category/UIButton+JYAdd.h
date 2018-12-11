//
//  UIButton+JYAdd.h
//  246News
//
//  Created by hcios on 2017/7/15.
//  Copyright © 2017年 徐冬苏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, dong_ButtonEdgeInsetsStyle) {
    
    dong_ButtonEdgeInsetsStyleTop,    // image在上，title在下
    dong_ButtonEdgeInsetsStyleLeft,   // image在左，title在右
    dong_ButtonEdgeInsetsStyleBottom, // image在下，title在上
    dong_ButtonEdgeInsetsStyleRight   // image在右，title在左
};

@interface UIButton (JYAdd)

/**
 设置button的titleLabel和imageView的布局样式，及间距
 
 @param dong_style titleLabel和imageView的布局样式
 @param dong_space titleLabel和imageView的间距
 */
- (void)dong_layoutButtonWithEdgeInsetsStyle:(dong_ButtonEdgeInsetsStyle)dong_style
                           imageTitleSpace:(CGFloat)dong_space isSizeToFit:(BOOL)isSizeToFit;

@end
