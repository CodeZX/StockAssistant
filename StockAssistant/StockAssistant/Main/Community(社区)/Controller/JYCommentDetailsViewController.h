//
//  JYCommentDetailsViewController.h
//  246News
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 Edgar_Guan. All rights reserved.
//  评论详情页面

#import <UIKit/UIKit.h>

@interface JYCommentDetailsViewController : UIViewController

@property (nonatomic, strong) NSString * card_id;


@property (nonatomic, strong) NSString * eval_id;
@property (nonatomic, strong) NSString * ds_id;
@property (nonatomic, strong) NSString * layer;

@property (nonatomic, strong) NSString * iconImageURL;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * commentNum;

@property (nonatomic, strong) NSString * isPraise;

@end
