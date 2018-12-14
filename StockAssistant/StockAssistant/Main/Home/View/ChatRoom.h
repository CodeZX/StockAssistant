//
//  ChatRoom.h
//  天空资讯
//
//  Created by 周峻觉 on 2018/6/4.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatRoom : NSObject

@property(nonatomic, strong)NSString* rID;
@property(nonatomic, strong)NSString* name;
@property(nonatomic, assign)NSUInteger count;

@end
