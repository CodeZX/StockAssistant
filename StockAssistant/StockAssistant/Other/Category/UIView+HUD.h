//
//  UIView+HUD.h
//  246News
//
//  Created by dong on 2018/2/7.
//  Copyright © 2018年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HUD)
- (void)showHUD;

- (void)hideHUD;

- (void)showMessage:(NSString *)message;
@end
