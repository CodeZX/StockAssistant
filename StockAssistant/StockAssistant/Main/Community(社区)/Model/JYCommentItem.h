//
//  JYCommentItem.h
//  246News
//
//  Created by tunjin on 2018/5/11.
//  Copyright © 2018年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYCommentItemy_retData;
@interface JYCommentItem : NSObject

@property (nonatomic,strong) NSString * msg;
@property (nonatomic,strong) NSString * code;
@property (nonatomic,strong) NSArray<JYCommentItemy_retData *> * retData;

@end

@interface JYCommentItemy_retData : NSObject

@property (nonatomic, strong) NSString * comment_id;///<评论唯一id
@property (nonatomic, strong) NSString * card_id;///<评论对应的帖子id
@property (nonatomic, strong) NSString * user_id;///<评论人id
@property (nonatomic, strong) NSString * text;///<评论内容
@property (nonatomic, strong) NSString * time;///<评论距离当前时间
@property (nonatomic, strong) NSString * user_pic;///<评论人头像
@property (nonatomic, strong) NSString * user_name;///<评论人名称


@end
