//
//  JYCommunity.h
//  246News
//
//  Created by tunjin on 2018/5/3.
//  Copyright © 2018年 JY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYCommunity_retData,JYCommunity_retData_pics;
@interface JYCommunity : NSObject

@property (nonatomic,strong) NSString * msg;
@property (nonatomic,strong) NSString * code;
@property (nonatomic,strong) NSArray<JYCommunity_retData *> * retData;

@end

@interface JYCommunity_retData : JYCommunity


@property (nonatomic, strong) NSString * post_id;///<帖子唯一id
@property (nonatomic, strong) NSString * card_id;///<帖子唯一id
@property (nonatomic, strong) NSString * user_id;///<用户id
@property (nonatomic, strong) NSString * user_pic;///<用户头像
@property (nonatomic, strong) NSString * user_name;///<用户名
@property (nonatomic, strong) NSString * title;///<标题
@property (nonatomic, strong) NSString * text;///<内容
@property (nonatomic, strong) NSString * pic; ///<图片
@property (nonatomic, strong) NSString * time;///<距离当前时间
@property (nonatomic, strong) NSString * date;///<发帖时间
@property (nonatomic, strong) NSString * status;///<状态，表示是否删除（举报）
@property (nonatomic, strong) NSString * like_num;///<点赞人数
@property (nonatomic, strong) NSString * is_like;///<是否被我点赞，1表示被点，0没被点
@property (nonatomic, strong) NSString * comment; ///<评论数
@property (nonatomic, strong) NSArray<JYCommunity_retData_pics *> * pics;

@end

@interface JYCommunity_retData_pics : JYCommunity_retData

@end

