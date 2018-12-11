//
//  TJWebViewController.h
//  HKGoodColor
//
//  Created by 周峻觉 on 2018/5/3.
//  Copyright © 2018年 chenkaijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJWebViewController : UIViewController

@property(nonatomic, strong)NSString* tit;
@property(nonatomic, assign)NSInteger cId;
@property(nonatomic, strong)NSString* urlString;

@property(nonatomic, strong)NSString* contentType;  // "info"  "video" "company"

@end
