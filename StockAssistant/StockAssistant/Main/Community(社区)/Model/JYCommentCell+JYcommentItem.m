//
//  JYCommentCell+JYcommentItem.m
//  246News
//
//  Created by tunjin on 2018/5/11.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import "JYCommentCell+JYcommentItem.h"
#import "JYCommentItem.h"
#import "UIImageView+WebCache.h"
#import "UIButton+JYAdd.h"

@implementation JYCommentCell (JYcommentItem)


- (void)configCellWithModel:(id)model {
    
    JYCommentItemy_retData * item = (JYCommentItemy_retData *)model;

    self.nameLabel.text = item.user_name;
    self.contextLabel.text = item.text;
    self.timeLabel.text = item.time;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.user_pic] placeholderImage:[UIImage imageNamed:@"icon_head40"]];
    
    [self.reportButton dong_layoutButtonWithEdgeInsetsStyle:dong_ButtonEdgeInsetsStyleTop imageTitleSpace:8 isSizeToFit:YES];

}


@end
