//
//  JYLoginViewController.m
//  246News
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 徐冬苏. All rights reserved.
//  登录

#import "JYLoginViewController.h"
#import "AppDelegate.h"
#import "JYRegisterViewController.h"
#import "JYFindPassWordViewController.h"
#import "Masonry.h"
#import "UIView+HUD.h"
#import "NetManager.h"
#import "JFSaveTool.h"
//#import "Const.h"
#import "AFNetworking.h"
//#import <RongIMKit/RongIMKit.h>
//#import "RCDCommonDefine.h"

@interface JYLoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView * iconImageView; ///< icon图标
@property (strong, nonatomic) UITextField * phoneTextField; ///< 输入手机号
@property (strong, nonatomic) UITextField * passwordTextField; ///< 输入密码
@property (strong, nonatomic) UIButton * registerButton; ///< 立即注册按钮
@property (strong, nonatomic) UIButton * forgetPsdButton; ///< 忘记密码按钮
@property (strong, nonatomic) UIButton * loginButton; ///< 登录按钮
@property (strong, nonatomic) UIButton * closeButton;
//下划线
@property (strong, nonatomic) UIView * firstLineView; ///<下划线1
@property (strong, nonatomic) UIView * secondLineView; ///<下划线2


@end

@implementation JYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setHidden:YES];
    [self JY_setUI];
    [self.view addSubview:self.closeButton];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)gestureAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

#pragma mark - UI设置
- (void)JY_setUI {
    //创建icon
    [self.view addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(80);
        make.height.mas_equalTo(120);
        make.width.mas_equalTo(120);
    }];
    
    [self.view addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(60);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTextField.mas_left);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(10);
        make.right.equalTo(self.phoneTextField.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordTextField.mas_left);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.view addSubview:self.forgetPsdButton];
    [self.forgetPsdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.passwordTextField.mas_right);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordTextField.mas_left);
        make.right.equalTo(self.passwordTextField.mas_right);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(60);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordTextField.mas_left);
        make.right.equalTo(self.passwordTextField.mas_right);
        make.top.equalTo(self.loginButton.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - button点击事件
//立即注册
- (void)registerAction {
    JYRegisterViewController * vc = [[JYRegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//忘记密码
- (void)forgetPsdAction {
    JYFindPassWordViewController * vc = [[JYFindPassWordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//登录
- (void)loginAction {
    
    [self.passwordTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    
    if (self.phoneTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        [self.view showMessage:@"请输入账号或密码"];
        return;
    }
    
    [self JY_loginNetWorking];
}

- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 网络请求
// 登录接口
- (void)JY_loginNetWorking {
    
    [NetManager POSTloginPhone:self.phoneTextField.text pwd:self.passwordTextField.text completionHandler:^(JYLoginItem *essences, NSError *error) {
        
        [self.view showMessage:essences.msg];
        
        if ([essences.code isEqualToString:@"0"]) {
            [JFSaveTool setObject:essences.retData.user_id forKey:@"UserID"];  //张诗磊服务器返回的ID
            [self createUser];
        }
    }];
}

- (void)createUser {
    
    NSDictionary *dic = @{@"name":self.phoneTextField.text};  //
    NSString* postApi = @"http://47.93.28.161:8080/news/chatroom/user/create";
    
    
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml", @"image/*"]];
    [manager GET:postApi parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        [DEFAULTS setObject:self.phoneTextField.text forKey:@"userName"];
        [DEFAULTS setObject:@"987654321" forKey:@"userPwd"];
        [DEFAULTS setObject:@"未设置" forKey:@"userNickName"];
        [DEFAULTS setObject:dic[@"token"] forKey:@"userToken"];
        [DEFAULTS setObject:dic[@"userId"] forKey:@"userId"];   //张恒服务器返回的ID
        [DEFAULTS setObject:dic[@"portrait"] forKey:@"userPortraitUri"];
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [app setLogin];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
}


#pragma mark - 懒加载
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"login_icon_head"];
    }
    return _iconImageView;
}

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] init];
        _phoneTextField.borderStyle = UITextBorderStyleRoundedRect;///<设置圆角
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;//输入框中是否有个叉号,用于一次性删除输入框中的内容
        _phoneTextField.adjustsFontSizeToFitWidth = YES;//设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动
        
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextField.placeholder = @"请输入手机号";
        _phoneTextField.textColor = [UIColor blackColor];
        _phoneTextField.font = [UIFont systemFontOfSize:15];
        _phoneTextField.returnKeyType = UIReturnKeyNext;//return键变成什么键
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.delegate = self;
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_person"]];
        imageView.frame = CGRectMake(imageView.frame.origin.x,imageView.frame.origin.y, 30,30);
        imageView.contentMode = UIViewContentModeCenter;
        _phoneTextField.leftView = imageView;
        
    }
    return _phoneTextField;
}


- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;///<设置圆角
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;//输入框中是否有个叉号,用于一次性删除输入框中的内容
        _passwordTextField.adjustsFontSizeToFitWidth = YES;//设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        _passwordTextField.textColor = [UIColor blackColor];
        _passwordTextField.font = [UIFont systemFontOfSize:15];
        _passwordTextField.keyboardType = UIKeyboardTypeDefault;
        _passwordTextField.delegate = self;
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_password"]];
        imageView.frame = CGRectMake(imageView.frame.origin.x,imageView.frame.origin.y, 30,30);
        imageView.contentMode = UIViewContentModeCenter;
        _passwordTextField.leftView = imageView;
    }
    return _passwordTextField;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIButton *)forgetPsdButton {
    if (!_forgetPsdButton) {
        _forgetPsdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPsdButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPsdButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _forgetPsdButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_forgetPsdButton addTarget:self action:@selector(forgetPsdAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPsdButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.backgroundColor = RGB(0,165,234);
        _loginButton.layer.cornerRadius = 5;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"暂不登录" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeButton.backgroundColor = RGB(0,165,234);
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _closeButton.layer.cornerRadius = 5;
        [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeButton;
}

- (UIView *)firstLineView {
    if (!_firstLineView) {
        _firstLineView = [[UIView alloc] init];
        _firstLineView.backgroundColor = [UIColor grayColor];
    }
    return _firstLineView;
}

- (UIView *)secondLineView {
    if (!_secondLineView) {
        _secondLineView = [[UIView alloc] init];
        _secondLineView.backgroundColor = [UIColor grayColor];
    }
    return _secondLineView;
}
@end
