//
//  MessageTableViewCell.h
//  demo
//
//  Created by tunjin on 2018/12/13.
//  Copyright © 2018 Awaken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>


NS_ASSUME_NONNULL_BEGIN

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * iconImgView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * subLabel;

@property (nonatomic, strong) UIView * lineView;


@property(strong, nonatomic) JMSGConversation *conversation;

@end

NS_ASSUME_NONNULL_END
