//
//  JYFindPassWordViewController.m
//  246News
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 徐冬苏. All rights reserved.
//  找回密码

#import "JYFindPassWordViewController.h"
#import "NSString+Verify.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "UIView+HUD.h"
//NSString+Verify#import "Const.h"
#import "NetManager.h"
#define KBlueColor RGB(0,165,234) //蓝色

@interface JYFindPassWordViewController ()<UITextFieldDelegate>
{
    int randNumber;
}
@property (strong, nonatomic) UIImageView * iconImageView; ///< icon图标
@property (strong, nonatomic) UITextField * phoneTextField; ///< 输入手机号
@property (strong, nonatomic) UITextField * passwordTextField; ///< 输入密码
@property (strong, nonatomic) UITextField * registerTextField; ///< 验证码
@property (strong, nonatomic) UIButton * loginButton; ///< 登录按钮
@property (strong, nonatomic) UIButton * closeButton;
//下划线
@property (strong, nonatomic) UIView * firstLineView; ///<下划线1
@property (strong, nonatomic) UIView * secondLineView; ///<下划线2
@property (strong, nonatomic) UIView * lastLineView; ///< 下划线3
@property (assign, nonatomic) NSInteger seconds;
@property (strong, nonatomic) UIButton * sendCodeBtn; ///<获取验证码
@end

@implementation JYFindPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self JY_setUI];
    
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
        make.top.equalTo(self.view.mas_top).offset(100);
        make.height.mas_equalTo(120);
        make.width.mas_equalTo(120);
    }];
    
    [self.view addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(90);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.height.mas_equalTo(60);
    }];
    
//    [self.view addSubview:self.firstLineView];
//    [self.firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(20);
//        make.right.equalTo(self.view.mas_right).offset(-20);
//        make.top.equalTo(self.phoneTextField.mas_bottom).offset(1);
//        make.height.mas_equalTo(1);
//    }];
    
    [self.view addSubview:self.registerTextField];
    [self.registerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTextField.mas_left);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(20);
        make.right.equalTo(self.phoneTextField.mas_right);
        make.height.mas_equalTo(60);
    }];

//    [self.view addSubview:self.secondLineView];
//    [self.secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.firstLineView.mas_left);
//        make.right.equalTo(self.firstLineView.mas_right);
//        make.top.equalTo(self.registerTextField.mas_bottom).offset(1);
//        make.height.mas_equalTo(1);
//    }];
    
    [self.view addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTextField.mas_left);
        make.top.equalTo(self.registerTextField.mas_bottom).offset(20);
        make.right.equalTo(self.phoneTextField.mas_right);
        make.height.mas_equalTo(60);
    }];
    
//    [self.view addSubview:self.lastLineView];
//    [self.lastLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.firstLineView.mas_left);
//        make.right.equalTo(self.firstLineView.mas_right);
//        make.top.equalTo(self.passwordTextField.mas_bottom).offset(1);
//        make.height.mas_equalTo(1);
//    }];
    
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


#pragma mark - 按钮点击事件
//注册
- (void)registerAction {
    [NetManager POSTRegisterPhone:self.phoneTextField.text pwd:self.passwordTextField.text completionHandler:^(JYRegisterItem *essences, NSError *error) {
        
        [self.view showMessage:essences.msg];
        
        if ([essences.code isEqualToString:@"0"]) {
            //[self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

//获取验证码
- (void)didRegisterAction {
    if (self.phoneTextField.text.length <= 0) {
        [self.view showMessage:@"请输入手机号码"];
        return;
    }
    if (![NSString isMobileNumber:self.phoneTextField.text]) {
        [self.view showMessage:@"请输入正确的手机号码"];

        return;
    }
    randNumber = arc4random()%899999+100000;
    NSUserDefaults *randCode = [NSUserDefaults standardUserDefaults];
    NSString *randStr = [NSString stringWithFormat:@"%d",randNumber];
    [randCode setObject:randStr forKey:@"randCode"];
    NSString * sms_content = [NSString stringWithFormat:@"%@是本次操作的手机验证码，如非本人操作，请忽略本短信。【天空资讯】",randStr];
    NSDictionary *dic = @{@"msisdn":self.phoneTextField.text,@"sms_content":sms_content, @"client_ip":@"127.0.0.1", @"company_id":@"CP2017021701",@"sms_type":@"1",@"priority":@"1",@"pre_process_time":@"0"};
    [self phoneRecvNumberByParam:dic];
    [self sentPhoneCodeTimeMethod];
}

-(void)sentPhoneCodeTimeMethod{
    //倒计时时间 - 60秒
    __block NSInteger timeOut = 59;
    //执行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //计时器 -> dispatch_source_set_timer自动生成
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            //主线程设置按钮样式->
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                [self.sendCodeBtn  setUserInteractionEnabled:YES];
            });
        }else{
            //开始计时
            //剩余秒数 seconds
            NSInteger seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.1ld", seconds];
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1.0];
                [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%@s后重新发送", strTime] forState:UIControlStateNormal];
                self.sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                [UIView commitAnimations];
                //计时器件不允许点击
                [self.sendCodeBtn  setUserInteractionEnabled:NO];
            });
            timeOut--;
        }
    });
    dispatch_resume(timer);
}


#pragma mark - 网络请求
//获取验证码
- (void)phoneRecvNumberByParam:(NSDictionary *)params{
    AFHTTPSessionManager *manager = manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    //https ipv6的设置
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST:@"http://smspay.api.365pays.cn/sms/send.do" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (NSDictionaryMatchAndCount(responseObject)) {
            NSDictionary *resDic = (NSDictionary *)responseObject;
            int state = [NonEmptyString(resDic[@"status"]) intValue];
            if ( state == 0 ) {
                [self.view showMessage:@"短信发送成功!"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view showMessage:@"网太弱,再试试咯!"];

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
        _passwordTextField.placeholder = @"请输入新密码";
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

- (UITextField *)registerTextField {
    if (!_registerTextField) {
        _registerTextField = [[UITextField alloc] init];
        _registerTextField.borderStyle = UITextBorderStyleRoundedRect;///<设置圆角
        _registerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;//输入框中是否有个叉号,用于一次性删除输入框中的内容
        _registerTextField.adjustsFontSizeToFitWidth = YES;//设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动
        _registerTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5, 10, 88, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleLabel.textAlignment = NSTextAlignmentRight;
        [button addTarget:self action:@selector(didRegisterAction) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:KBlueColor forState:UIControlStateNormal];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        button.layer.cornerRadius = 3.0f;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = KBlueColor.CGColor;
        button.layer.borderWidth = 1.0f;
        _registerTextField.rightView = button;///<设置右侧按钮
        _registerTextField.rightViewMode = UITextFieldViewModeAlways;///<一直显示
        
        _registerTextField.placeholder = @"请输入验证码";
        _registerTextField.textColor = [UIColor blackColor];
        _registerTextField.font = [UIFont systemFontOfSize:15];
        _registerTextField.returnKeyType = UIReturnKeyNext;//return键变成什么键
        _registerTextField.keyboardType = UIKeyboardTypeNumberPad;
        _registerTextField.delegate = self;
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_password"]];
        imageView.frame = CGRectMake(imageView.frame.origin.x,imageView.frame.origin.y, 30,30);
        imageView.contentMode = UIViewContentModeCenter;
        _registerTextField.leftView = imageView;
    }
    return _registerTextField;
}


- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"找回密码" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.backgroundColor = KBlueColor;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _loginButton.layer.cornerRadius = 5;
        _loginButton.clipsToBounds = YES;
        [_loginButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
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

- (UIView *)lastLineView {
    if (!_lastLineView) {
        _lastLineView = [[UIView alloc] init];
        _lastLineView.backgroundColor = [UIColor grayColor];
    }
    return _lastLineView;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeButton.backgroundColor = RGB(0,165,234);
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _closeButton.layer.cornerRadius = 5;
        [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeButton;
}

- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
