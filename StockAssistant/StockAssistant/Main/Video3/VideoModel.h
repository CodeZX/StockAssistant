//
//  VideoModel.h
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/4.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property(nonatomic, assign)NSInteger vId;
@property(nonatomic, strong)NSString* date;
@property(nonatomic, strong)NSString* playPath;
@property(nonatomic, assign)NSInteger popularity;
@property(nonatomic, strong)NSString* synopsisPic;
@property(nonatomic, strong)NSString* title;
@property(nonatomic, strong)NSString* urlString;
@property(nonatomic, strong)NSString* content;
@property(nonatomic, assign)NSInteger readNumber;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end




