//
//  JFSaveTool.m
//  246News
//
//  Created by FS on 2017/7/5.
//  Copyright © 2017年 JiFeng. All rights reserved.
//

#import "JFSaveTool.h"

@implementation JFSaveTool

+ (nullable id)objectForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName {
    
    if (defaultName) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
