//
//  SA_NewsModel.h
//  StockAssistant
//
//  Created by 周鑫 on 2018/12/12.
//  Copyright © 2018 TJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SA_NewsModel : NSObject
@property (nonatomic,strong) NSString *m_id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *img;
@end

NS_ASSUME_NONNULL_END
