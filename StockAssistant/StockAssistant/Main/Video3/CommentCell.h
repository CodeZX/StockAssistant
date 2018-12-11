//
//  CommentCell.h
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/7.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property(nonatomic, strong)NSString* userName;
@property(nonatomic, strong)NSString* content;
@property(nonatomic, strong)NSString* timeString;

@end
