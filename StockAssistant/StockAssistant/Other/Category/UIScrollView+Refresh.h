//
//  UIScrollView+Refresh.h
//  246News
//
//  Created by dong on 2018/2/7.
//  Copyright © 2018年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Refresh)
- (void)dong_addHeaderRefresh:(void(^)())block;
- (void)dong_endHeaderRefresh;
- (void)dong_beginHeaderRefresh;

- (void)dong_addFooterRefresh:(void(^)())block;
- (void)dong_endFooterRefresh;
- (void)dong_endFooterWithNoMore;
- (void)dong_resetFooter;

@end
