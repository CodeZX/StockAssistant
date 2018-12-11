//
//  InformationViewController.m
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/8.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import "CompanyViewController.h"
#import "CompanyTableViewCell.h"
#import "TJWebViewController.h"
#import "AFNetworking.h"
#import "InfoModel.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusHeight                   [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight                   44
#define kStatusAndNavBarHeight          (kStatusHeight+kNavBarHeight)
#define kExtendedHeightAtIphoneXBottom  (kStatusHeight>20?34:0)

@interface CompanyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UIImageView* navImageView;
@property(nonatomic, strong)UIButton* backBtn;
@property(nonatomic, strong)UITableView* tableView;

@property(nonatomic, strong)NSArray* companys;

@end

@implementation CompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navImageView];
    [self.view addSubview:self.tableView];
    
    self.navImageView.frame = CGRectMake(0, kStatusHeight, kScreenWidth, kNavBarHeight);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navImageView.frame), kScreenWidth, kScreenHeight-kStatusAndNavBarHeight);

    
    //NSString* file = [[NSBundle mainBundle] pathForResource:@"companys" ofType:@"plist"];
    //_companys = [NSArray arrayWithContentsOfFile:file];
    [self requestCompanys];
    NSLog(@"%@", _companys);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)requestCompanys
{
    NSString* getApi = @"http://568tj.cn:8080/news/business/get";
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml", @"image/*"]];
    
    [manager GET:getApi parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"dic:%@", dic);
        if ([dic[@"code"] integerValue] == 200) {
            self.companys = dic[@"result"];
            
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)backAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.companys) {
        return self.companys.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"CompanyTableViewCell";
    
    NSDictionary* dic = self.companys[indexPath.row];
    
    CompanyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CompanyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.name = dic[@"name"];
    cell.picture = dic[@"picture"];
    cell.edgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary* dic = self.companys[indexPath.row];
    
    
    NSString* urlString = dic[@"url"];
    TJWebViewController* webVC = [[TJWebViewController alloc] init];
    webVC.cId = [dic[@"id"] integerValue];
    webVC.tit = dic[@"name"];
    webVC.urlString = urlString;
    webVC.contentType = @"company";
    [self presentViewController:webVC animated:YES completion:^{
        
    }];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    label.text = @"* 到底了 *";
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}



- (UIImageView *)navImageView
{
    if (!_navImageView) {
        _navImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_company"]];
        _navImageView.contentMode = UIViewContentModeScaleAspectFill;
        _navImageView.userInteractionEnabled = YES;
        
        self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_backBtn setImage:[UIImage imageNamed:@"icon_return-1"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [_navImageView addSubview:_backBtn];
    }
    return _navImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
