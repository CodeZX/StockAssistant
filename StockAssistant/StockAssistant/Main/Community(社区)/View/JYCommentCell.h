//
//  JYCommentCell.h
//  246News
//
//  Created by tunjin on 2018/5/11.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYCommentCellDelegate <NSObject>
@optional

- (void)reportAction:(UIButton *)button;

@end

@interface JYCommentCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *iconImageView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *contextLabel;
@property (strong, nonatomic)  UIButton *reportButton;
@property (strong, nonatomic) UIView* cutline;

@property (nonatomic, weak)id<JYCommentCellDelegate> delegate;


+ (UINib *)nib;


@end
