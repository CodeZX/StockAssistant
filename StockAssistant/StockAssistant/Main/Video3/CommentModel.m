//
//  VideoModel.m
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/4.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"content"]) {
        _content = value;
    }else if ([key isEqualToString:@"dateStr"]){
        _date = value;
    }else if ([key isEqualToString:@"id"]){
        _cId = [value integerValue];
    }else if ([key isEqualToString:@"newsId"]){
        _newsId = value;
    }else if ([key isEqualToString:@"username"]){
        _username = value;
    }
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    
}

@end
