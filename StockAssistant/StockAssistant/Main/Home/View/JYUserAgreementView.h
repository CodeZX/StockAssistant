//
//  JYUserAgreementView.h
//  246News
//
//  Created by tunjin on 2018/5/22.
//  Copyright © 2018年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface JYUserAgreementView : UIView

@property (weak, nonatomic) IBOutlet WKWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *agreedButton;

+ (instancetype)userAgreementView ;


@end
