//
//  FeedbackVC.m
//  sock
//
//  Created by 王浩祯 on 2018/3/9.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "FeedbackVC.h"
#import "AFNetworking.h"

#define SC_WIDTH [UIScreen mainScreen].bounds.size.width
#define SC_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusHeight                   [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight                   44
#define kStatusAndNavBarHeight          (kStatusHeight+kNavBarHeight)
#define kExtendedHeightAtIphoneXBottom  (kStatusHeight>20?34:0)

@interface FeedbackVC ()
{
    
}


@property(nonatomic, strong)UIImageView* navImageView;
@property(nonatomic, strong)UITextView* textView;
@property(nonatomic, strong)UIButton* submitBtn;
@property(nonatomic, strong)UIButton* backBtn;
@end

@implementation FeedbackVC

-(void)viewWillAppear:(BOOL)animated
{
    self.navImageView.frame = CGRectMake(0, kStatusHeight, kScreenWidth, kNavBarHeight);
    self.textView = [UITextView new];
    self.textView.frame = CGRectMake(15, CGRectGetMaxY(self.navImageView.frame), SC_WIDTH-30, SC_HEIGHT - 400);
    self.textView.font = [UIFont systemFontOfSize:20];
    self.textView.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:246/255.0 alpha:1.0];
    self.textView.layer.cornerRadius = 10;
    [self.view addSubview:self.textView];
    
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 67, 34)];
    [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"icon_submit"] forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitBtn];
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 67, 34)];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [self.backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    self.submitBtn.center = CGPointMake(kScreenWidth/3.0, CGRectGetMaxY(self.textView.frame)+60);
    self.backBtn.center = CGPointMake(kScreenWidth*2/3.0, CGRectGetMaxY(self.textView.frame)+60);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.navImageView];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)submitAction:(UIButton *)btn{
    
    if (self.textView.text == nil || self.textView.text.length == 0) {
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertController* vc = [UIAlertController alertControllerWithTitle:@"内容不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [vc addAction:action];
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.textView.text,@"content",
                         nil];
    NSString* postApi = @"http://47.93.28.161:8080/news/comment/feedback";
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml", @"image/*"]];
    
    [manager GET:postApi parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"提交成功");
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertController* vc = [UIAlertController alertControllerWithTitle:@"提交成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [vc addAction:action];
        [self presentViewController:vc animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"提交失败");
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //[self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertController* vc = [UIAlertController alertControllerWithTitle:@"提交失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [vc addAction:action];
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
    
}

- (void)backAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)navImageView
{
    if (!_navImageView) {
        _navImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_feedback"]];
        _navImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _navImageView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
