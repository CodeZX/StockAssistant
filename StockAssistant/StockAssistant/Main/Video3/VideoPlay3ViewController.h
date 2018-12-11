//
//  TJWebViewController.h
//  HKGoodColor
//
//  Created by 周峻觉 on 2018/5/3.
//  Copyright © 2018年 chenkaijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface VideoPlay3ViewController : UIViewController

@property(nonatomic, strong)VideoModel* videoModel;
@property(nonatomic, strong)NSString* contentType;  // "info"  "video" "company"

@end
