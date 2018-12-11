//
//  VideoModel.m
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/4.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import "InfoModel.h"

@implementation InfoModel

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
        _iId = [value integerValue];
    }else if ([key isEqualToString:@"synopsisPic"]){
        _synopsisPic = value;
    }else if ([key isEqualToString:@"title"]){
         _title = value;
    }else if ([key isEqualToString:@"url"]){
        _urlString = value;
    }else if ([key isEqualToString:@"readNumber"]){
        _readNumber = [value integerValue];
    }else if ([key isEqualToString:@"pics"]){
        for (NSDictionary* dic in value) {
            [self.pictures addObject:dic[@"picPath"]];
        }
    }
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
    
}

- (NSMutableArray *)pictures
{
    if (!_pictures) {
        _pictures = [NSMutableArray array];
    }
    return _pictures;
}

@end
