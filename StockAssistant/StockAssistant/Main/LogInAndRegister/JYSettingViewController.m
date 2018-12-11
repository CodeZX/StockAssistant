//
//  JYSettingViewController.m
//  246News
//
//  Created by tunjin on 2018/5/3.
//  Copyright © 2018年 JY. All rights reserved.
//

#import "JYSettingViewController.h"
#import "AppDelegate.h"
#import "Masonry.h"
//#import "Const.h"
#import "JFSaveTool.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusHeight                   [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight                   44
#define kStatusAndNavBarHeight          (kStatusHeight+kNavBarHeight)
#define kExtendedHeightAtIphoneXBottom  (kStatusHeight>20?34:0)

@interface JYSettingViewController ()

@property(nonatomic, strong)UIImageView* navImageView1;
@property(nonatomic, strong)UIButton* backButton;
@property (nonatomic, strong) UIButton * logoutButton;

@end

@implementation JYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navImageView1];
    self.navImageView1.frame = CGRectMake(0, kStatusHeight, kScreenWidth, kNavBarHeight);
    
    [self setFootView];
    
}

- (void)setFootView {
    [self.view addSubview:self.logoutButton];
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(DEVICE_SCREEN_WIDTH - 60);
    }];
    
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.logoutButton.mas_top).offset(-20);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(DEVICE_SCREEN_WIDTH - 60);
    }];
}


- (void)logoutButtonAction {
    
    [JFSaveTool setObject:@"" forKey:@"UserID"];
    [JFSaveTool setObject:@"" forKey:@"UserNameKey"];
    [JFSaveTool setObject:@"" forKey:@"UserImageUrlKey"];
    [JFSaveTool setObject:@"" forKey:@"PhoneNumberKey"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        _backButton.backgroundColor = RGB(0,165,234);
        _backButton.clipsToBounds = YES;
        _backButton.layer.cornerRadius = 10;
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)logoutButton {
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        _logoutButton.backgroundColor = RGB(0,165,234);
        _logoutButton.clipsToBounds = YES;
        _logoutButton.layer.cornerRadius = 10;
        [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logoutButton addTarget:self action:@selector(logoutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}

- (UIImageView *)navImageView1
{
    if (!_navImageView1) {
        _navImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"注销.png"]];
        _navImageView1.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _navImageView1;
}

@end
