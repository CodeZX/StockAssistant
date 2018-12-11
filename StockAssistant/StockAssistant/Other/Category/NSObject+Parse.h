//
//  NSObject+Parse.h
//  246News
//
//  Created by dong on 2018/2/7.
//  Copyright © 2018年 JY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"

@interface NSObject (Parse)<YYModel>
//JSON解析类
+ (id)Parse:(id)JSON;
@end
