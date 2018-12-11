//
//  JFSaveTool.h
//  246News
//
//  Created by FS on 2017/7/5.
//  Copyright © 2017年 JiFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface JFSaveTool : NSObject

/** 根据key取出数据 */
+ (nullable id)objectForKey:(NSString *)defaultName;

/** 保存数据 */
+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName;

@end
NS_ASSUME_NONNULL_END
