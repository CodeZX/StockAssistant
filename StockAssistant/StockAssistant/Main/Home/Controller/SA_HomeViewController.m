//
//  SA_HomeViewController.m
//  StockAssistant
//
//  Created by 周鑫 on 2018/12/11.
//  Copyright © 2018 TJ. All rights reserved.
//

#import "SA_HomeViewController.h"
#import "CountdownView.h"
#import "VideoModel.h"
#import "InfoModel.h"
#import "Info2ViewController.h"
#import "CompanyViewController.h"
#import "PictViewController.h"
#import "JYAskTableViewController.h"
#import "Info2TableViewCell.h"
#import "InfoDetailViewController.h"
#import "VideoPlay3ViewController.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusHeight                   [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight                   44
#define kStatusAndNavBarHeight          (kStatusHeight+kNavBarHeight)
#define kExtendedHeightAtIphoneXBottom  (kStatusHeight>20?34:0)
@interface SA_HomeViewController ()<UITableViewDelegate, UITableViewDataSource>


@property(nonatomic, strong)UITableView* tableView;

@property(nonatomic, strong)UILabel* leftLabel;
@property(nonatomic, strong)UILabel* rightLabel1;
@property(nonatomic, strong)UILabel* rightLabel2;
@property(nonatomic, strong)UIImageView* flyImageView;

@property(nonatomic, strong)UIView* container;

@property(nonatomic, strong)NSMutableArray* notices;

@property(nonatomic, strong)NSMutableArray* contents;

@end

@implementation SA_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    //    [self requestNotice];
    [self requestVideos];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self requestWeather];
    self.tableView.frame = self.view.bounds;
    
    /***********   **********/
    [self checkImage];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (go == 0) {
            go = 1;
            //            [self requestData];
        }
    });
    /***********   **********/
}

/***********   **********/
static int go = 0;
- (void)checkImage
{
    NSURL *url = [NSURL URLWithString: @"http://119.148.162.231:8080/appImg/20180504180941.png"];
    UIImage* image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    
    if (image) {
        //隐藏tab bar 和 nav bar
        [self.tabBarController.tabBar setHidden:YES];
        [self.navigationController.navigationBar setHidden:YES];
        
        UIImageView* imageView = [UIImageView new];
        imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        imageView.tag = 2222;
        imageView.image = image;
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
        
        //开始倒计时
        CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        
        CountdownView* countview = [[CountdownView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 60, statusHeight, 40, 40)];
        __weak typeof(countview) countviewWeak = countview;
        countview.blockTapAction = ^{
            
            if (go == 0) {
                go = 1;
                //                [self requestData];
            }
            
            NSLog(@"22222 %s", __func__);
            [UIView animateWithDuration:2 animations:^{
                imageView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [imageView removeFromSuperview];
                [countviewWeak removeFromSuperview];
            }];
        };
        [self.view addSubview:countview];
    }
}

//- (void)requestData {
//
//    NSDictionary *dic = @{@"appId":@"tj2_20180504007"};  //
//    NSString* postApi = @"http://119.148.162.231:8080/app/get_version";
//
//    //1.创建会话管理者
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml", @"image/*"]];
//
//    [manager POST:postApi parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //NSLog(@"class:%@", [responseObject class]);
//
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//
//        if([dic[@"code"] isEqualToString:@"0"]) {
//
//            NSDictionary* retDataDic = dic[@"retData"];
//            NSString* version = retDataDic[@"version"];
//
//            if ([version isEqualToString:@"2.0"]) {
//
//                NSString *urlStr = retDataDic[@"updata_url"];
//                if(urlStr &&  ![urlStr isEqualToString:@""]) {
//                    self.tabBarController.tabBar.hidden = YES;
//                    XTJWebNavigationViewController *Web = [XTJWebNavigationViewController new];
//                    Web.url = urlStr;
//                    [self addChildViewController:Web];
//                    [self.view addSubview:Web.view];
//                }
//            }else{
//
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error:%@",error);
//
//    }];
//}
/***********   **********/

//- (void)requestWeather
//{
//    double lat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lat"];
//    double lng = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lng"];
//
//    NSString *appcode = @"ca9814a36f8443d48a4095eb8016fee1";
//    NSString *host = @"http://jisutqybmf.market.alicloudapi.com";
//    NSString *path = @"/weather/query";
//    NSString *method = @"GET";
//    NSString *querys =  [NSString stringWithFormat:@"?location=%f,%f", lat,lng];
//    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
//    // *bodys = @"";
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  5];
//    request.HTTPMethod  =  method;
//    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
//    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
//                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                                                       //                                                       NSLog(@"Response object: %@" , response);
//                                                       //                                                       NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
//                                                       //
//                                                       //                                                       //打印应答中的body
//                                                       //                                                       NSLog(@"Response body: %@" , bodyString);
//
//                                                       if (body == nil) {
//                                                           return ;
//                                                       }
//                                                       NSDictionary* bodyDic = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingAllowFragments error:nil];
//                                                       //NSLog(@"%@", bodyDic);
//
//                                                       id result = bodyDic[@"result"];
//
//                                                       if (![result isKindOfClass:[NSDictionary class]] || result == nil) {
//                                                           return;
//                                                       }
//
//                                                       NSString* city = result[@"city"];
//                                                       NSString* week = result[@"week"];
//                                                       NSString* weather = result[@"weather"];
//                                                       NSString* templow = result[@"templow"];
//                                                       NSString* temphigh = result[@"temphigh"];
//                                                       NSString* winddirect = result[@"winddirect"];
//                                                       //weather = @"暴雨";
//
//                                                       dispatch_async(dispatch_get_main_queue(), ^{
//                                                           self.leftLabel.text = city;
//                                                           self.rightLabel1.text = [NSString stringWithFormat:@"%@ %@ %@\n\n",week,weather,winddirect];
//                                                           self.rightLabel2.text = [NSString stringWithFormat:@"%@°C - %@°C", templow, temphigh];
//
//                                                           if ([weather containsString:@"雨"] || [winddirect containsString:@"雨"]) {
//                                                               self.flyImageView.image = [UIImage imageNamed:@"不宜飞行"];
//                                                               CGRect frame = self.flyImageView.frame;
//                                                               CGPoint center = self.flyImageView.center;
//                                                               frame.size.width = 119;
//                                                               self.flyImageView.frame = frame;
//                                                               self.flyImageView.center = center;
//                                                           }else{
//                                                               self.flyImageView.image = [UIImage imageNamed:@"宜飞行"];
//                                                               CGRect frame = self.flyImageView.frame;
//                                                               CGPoint center = self.flyImageView.center;
//                                                               frame.size.width = 88;
//                                                               self.flyImageView.frame = frame;
//                                                               self.flyImageView.center = center;
//                                                           }
//                                                       });
//                                                   }];
//
//    [task resume];
//}

- (void)requestNotice
{
    NSDictionary *dic = @{@"number":@(2)};
    NSString* getApi = @"http://47.93.28.161:8080/news/notice/getbynumber";
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml", @"image/*"]];
    
    [manager GET:getApi parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dic:%@", dic);
        if ([dic[@"code"] integerValue] == 200) {
            self.notices = dic[@"result"];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)requestVideos
{
    NSDictionary *dic = @{@"number":@(5)};
    NSString* getApi = @"http://47.93.28.161:8080/news/video/getbynumber";
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml", @"image/*"]];
    
    [manager GET:getApi parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dic:%@", dic);
        if ([dic[@"code"] integerValue] == 200) {
            NSArray* array = dic[@"result"];
            for (NSDictionary* d in array) {
                VideoModel* model = [[VideoModel alloc] initWithDic:d];
                [self.contents addObject:model];
            }
            [self.tableView reloadData];
            
            [self requestInfos];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)requestInfos
{
    NSDictionary *dic = @{@"number":@(5)};
    NSString* getApi = @"http://47.93.28.161:8080/news/uav/getbynumber";
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml", @"image/*"]];
    
    [manager GET:getApi parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dic:%@", dic);
        if ([dic[@"code"] integerValue] == 200) {
            NSArray* array = dic[@"result"];
            for (NSDictionary* d in array) {
                InfoModel* model = [[InfoModel alloc] initWithDic:d];
                [self.contents addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)contentSelectAction:(UIButton *)btn
{
    if (btn.tag == 1000) {
        Info2ViewController* info2VC = [[Info2ViewController alloc] init];
        info2VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info2VC animated:YES];
    }else if (btn.tag == 2000){
        CompanyViewController* compVC = [[CompanyViewController alloc] init];
        compVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:compVC animated:YES];
    }else if (btn.tag == 3000){
        PictViewController *pictVC = [[PictViewController alloc] init];
        pictVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pictVC animated:YES];
    }else if (btn.tag == 4000){
        JYAskTableViewController *askVC = [[JYAskTableViewController alloc] init];
        askVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:askVC animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.contents.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellid_1 = @"cell_1";
    
    if (indexPath.section == 0) {
        UITableViewCell* cell_1 = [tableView dequeueReusableCellWithIdentifier:cellid_1];
        if (!cell_1) {
            cell_1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid_1];
            cell_1.backgroundColor = [UIColor clearColor];
            [cell_1 addSubview:self.container];
        }
        return cell_1;
    }else{
        static NSString* cellId = @"Info2TableViewCell";
        
        Info2TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[Info2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row < 5) {
            cell.isVideo = YES;
        }else{
            cell.isVideo = NO;
        }
        cell.infoModel = self.contents[indexPath.row];
        cell.edgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 5) {
        VideoModel* videoModel = self.contents[indexPath.row];
        
        VideoPlay3ViewController* playVC = [[VideoPlay3ViewController alloc] init];
        playVC.videoModel = videoModel;
        playVC.contentType = @"video";
        [self presentViewController:playVC animated:YES completion:^{
            
        }];
    }else{
        InfoModel* infoModel = self.contents[indexPath.row];
        
        InfoDetailViewController* vc = [[InfoDetailViewController alloc] init];
        vc.infoModel = infoModel;
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0.01)];
        return view;
    }else{
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0.3)];
        line.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:line];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 50)];
        label.text = @"每日十条";
        label.textColor = [UIColor lightGrayColor];
        [view addSubview:label];
        return view;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0.01)];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithRed:229/255.0 green:243/255.0 blue:253/255.0 alpha:1.0];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        CGFloat height = kScreenWidth*190.0/375;
        UIImageView* headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
        headerView.image = [UIImage imageNamed:@"image_weather"];
        
        [headerView addSubview:self.leftLabel];
        [headerView addSubview:self.rightLabel1];
        [headerView addSubview:self.rightLabel2];
        [headerView addSubview:self.flyImageView];
        
        self.leftLabel.frame = CGRectMake(0, 30, kScreenWidth*0.5, height/3.0);
        self.rightLabel1.frame = CGRectMake(0, height/3.0, kScreenWidth*0.5, height/3.0);
        self.rightLabel2.frame = CGRectMake(0, height*2/3.0-30, kScreenWidth*0.5, height/3.0);
        self.flyImageView.center = CGPointMake(kScreenWidth*3/4, headerView.frame.size.height*0.5);
        
        
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*0.5, 100)];
        //_leftLabel.text = @"天空";
        _leftLabel.textColor = [UIColor colorWithRed:31/255.0 green:53/255.0 blue:86/255.0 alpha:1.0];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.font = [UIFont systemFontOfSize:18 weight:1];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel1
{
    if (!_rightLabel1) {
        _rightLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*0.5, 0, kScreenWidth*0.5, 50)];
        //_rightLabel1.text = @"星期六 多云 静风";
        _rightLabel1.textColor = [UIColor colorWithRed:76/255 green:93/255 blue:120/255 alpha:1.0];
        _rightLabel1.textAlignment = NSTextAlignmentCenter;
        _rightLabel1.font = [UIFont systemFontOfSize:18];
    }
    return _rightLabel1;
}

- (UILabel *)rightLabel2
{
    if (!_rightLabel2) {
        _rightLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*0.5, 50, kScreenWidth*0.5, 50)];
        //_rightLabel2.text = @"20°C - 30°C";
        _rightLabel2.textColor = [UIColor colorWithRed:76/255 green:93/255 blue:120/255 alpha:1.0];
        _rightLabel2.textAlignment = NSTextAlignmentCenter;
        _rightLabel2.font = [UIFont systemFontOfSize:18];
    }
    return _rightLabel2;
}

- (UIImageView *)flyImageView
{
    if (!_flyImageView) {
        _flyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 88, 29)];
    }
    return _flyImageView;
}

- (UIView *)container
{
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 130)];
        _container.backgroundColor = [UIColor whiteColor];
        
        UIButton* infoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 89)];
        [infoBtn setImage:[UIImage imageNamed:@"icon_news"] forState:UIControlStateNormal];
        infoBtn.tag = 1000;
        [infoBtn addTarget:self action:@selector(contentSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* compBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 89)];
        [compBtn setImage:[UIImage imageNamed:@"icon_company"] forState:UIControlStateNormal];
        compBtn.tag = 2000;
        [compBtn addTarget:self action:@selector(contentSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* picBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 89)];
        [picBtn setImage:[UIImage imageNamed:@"icon_shot"] forState:UIControlStateNormal];
        picBtn.tag = 3000;
        [picBtn addTarget:self action:@selector(contentSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* topicBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 89)];
        [topicBtn setImage:[UIImage imageNamed:@"icon_topic-1"] forState:UIControlStateNormal];
        topicBtn.tag = 4000;
        [topicBtn addTarget:self action:@selector(contentSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat space = (_container.bounds.size.width-66*4)/5.0;
        infoBtn.center = CGPointMake(space+66*0.5, 65);
        compBtn.center = CGPointMake(space*2+66*1.5, 65);
        picBtn.center = CGPointMake(space*3+66*2.5, 65);
        topicBtn.center = CGPointMake(space*4+66*3.5, 65);
        
        [_container addSubview:infoBtn];
        [_container addSubview:compBtn];
        [_container addSubview:picBtn];
        [_container addSubview:topicBtn];
    }
    
    return _container;
}

- (NSMutableArray *)notices
{
    if (!_notices) {
        _notices = [[NSMutableArray alloc] init];
    }
    return _notices;
}

- (NSMutableArray *)contents
{
    if (!_contents) {
        _contents = [[NSMutableArray alloc] init];
    }
    return _contents;
}


@end
