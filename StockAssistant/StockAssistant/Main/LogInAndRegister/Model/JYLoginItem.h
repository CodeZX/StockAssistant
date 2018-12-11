//
//  JYLoginItem.h
//  246News
//
//  Created by tunjin on 2018/5/4.
//  Copyright © 2018年 JY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYLoginItem_retData;

@interface JYLoginItem : NSObject

@property (nonatomic,strong) NSString * msg;
@property (nonatomic,strong) NSString * code;
@property (nonatomic,strong) JYLoginItem_retData * retData;

@end

@interface JYLoginItem_retData : JYLoginItem
@property (nonatomic,strong) NSString * user_id;

@end
