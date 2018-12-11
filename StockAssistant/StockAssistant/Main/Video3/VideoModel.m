//
//  VideoModel.m
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/4.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

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
        _vId = [value integerValue];
    }else if ([key isEqualToString:@"playPath"]){
        _playPath = value;
    }else if ([key isEqualToString:@"popularity"]){
        _popularity = [value integerValue];
        _readNumber = [value integerValue];
    }else if ([key isEqualToString:@"synopsisPic"]){
        _synopsisPic = value;
    }else if ([key isEqualToString:@"title"]){
         _title = value;
    }else if ([key isEqualToString:@"url"]){
        _urlString = value;
    }
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    
}

@end
