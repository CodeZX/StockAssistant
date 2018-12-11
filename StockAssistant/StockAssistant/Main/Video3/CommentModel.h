//
//  VideoModel.h
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/4.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property(nonatomic, assign)NSInteger cId;
@property(nonatomic, strong)NSString* date;
@property(nonatomic, strong)NSString* newsId;
@property(nonatomic, strong)NSString* username;
@property(nonatomic, strong)NSString* content;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
