//
//  BaseNetManager.h
//  246News
//
//  Created by dong on 2018/2/7.
//  Copyright © 2018年 JY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetManager : NSObject
//GET
+ (id)GET:(NSString *)path param:(NSDictionary *)param completionHandler:(void(^)(id obj, NSError *error))completionHandler;
//POST
+ (id)POST:(NSString *)path param:(NSDictionary *)param completionHandler:(void(^)(id obj, NSError *error))completionHandler;
@end
