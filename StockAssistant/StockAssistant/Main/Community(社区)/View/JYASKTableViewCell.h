//
//  JYASKTableViewCell.h
//  246News
//
//  Created by apple on 2018/1/30.
//  Copyright © 2018年 Edgar_Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYASKTableViewCellDelegate <NSObject>
@optional

- (void)likeButtonAction:(UIButton *)button;
- (void)reportButtonAction:(UIButton *)button;

@end

@interface JYASKTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHight;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *fileView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHight;

@property (weak, nonatomic) IBOutlet UILabel *contextLab;
@property (nonatomic, weak)id<JYASKTableViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *reportButton;///<举报

+ (UINib *)nib;

@end
