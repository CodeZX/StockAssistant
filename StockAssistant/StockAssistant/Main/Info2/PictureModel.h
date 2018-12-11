//
//  PictureModel.h
//  LuckyBeautifulPictures
//
//  Created by 周峻觉 on 2018/1/5.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PictureModel : NSObject

@property(nonatomic, assign)NSInteger ID;
@property(nonatomic, strong)NSString* content;
@property(nonatomic, strong)NSString* title;
@property(nonatomic, strong)NSArray* pics;

@end
