//
//  UIView+HUD.m
//  246News
//
//  Created by dong on 2018/2/7.
//  Copyright © 2018年 JY. All rights reserved.
//

#import "UIView+HUD.h"
#import "MBProgressHUD.h"

@implementation UIView (HUD)
- (void)showHUD
{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [hud hide:YES afterDelay:10];
}

- (void)hideHUD
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (void)showMessage:(NSString *)message
{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [hud hide:YES afterDelay:1];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
}
@end
