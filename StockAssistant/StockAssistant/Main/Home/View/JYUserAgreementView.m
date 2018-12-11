//
//  JYUserAgreementView.m
//  246News
//
//  Created by tunjin on 2018/5/22.
//  Copyright © 2018年 JY. All rights reserved.
//

#import "JYUserAgreementView.h"
#import "RCDCommonDefine.h"

@implementation JYUserAgreementView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.agreedButton.layer.cornerRadius = 25;

    
    [self loadDocument:@"用户协议.docx" inView:self.webView];
    self.webView.scrollView.bounces = NO;
}

-(void)loadDocument:(NSString *)documentName inView:(WKWebView *)webView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    if (path) {
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }
   
}

- (IBAction)closeAction:(UIButton *)sender {
//    [DEFAULTS objectForKey:@"ISFirst"]
    [DEFAULTS setObject:@"YES" forKey:@"ISFirst"];
    [self removeFromSuperview];
}

+ (instancetype)userAgreementView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];

}

@end
