//
//  JYCommitViewController.h
//  246News
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 Edgar_Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYCommitViewController : UIViewController

@property (nonatomic, strong) NSString * card_id;

@property (nonatomic, strong) NSString * eval_id;///<当前 发表人
@property (nonatomic, strong) NSString * eval_leval; ///<问问分类
@property (nonatomic, strong) NSString * reply_id;

@end
