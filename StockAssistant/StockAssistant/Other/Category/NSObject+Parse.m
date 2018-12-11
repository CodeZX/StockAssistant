//
//  NSObject+Parse.m
//  246News
//
//  Created by dong on 2018/2/7.
//  Copyright © 2018年 JY. All rights reserved.
//

#import "NSObject+Parse.h"
#import "YYKit.h"

@implementation NSObject (Parse)
+ (id)Parse:(id)JSON
{
    if ([JSON isKindOfClass:[NSArray class]]) {
        return [NSArray modelArrayWithClass:[self class] json:JSON];
    }
    if ([JSON isKindOfClass:[NSDictionary class]]) {
        return [self modelWithJSON:JSON];
    }
    return JSON;
}
@end
