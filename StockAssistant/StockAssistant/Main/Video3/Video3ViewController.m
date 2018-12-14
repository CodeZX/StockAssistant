//
//  ViewController.m
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/4.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import "Video3ViewController.h"
#import "AFNetworking.h"
#import "VideoModel.h"
#import "Video3TableViewCell.h"
//#import "TJWebViewController.h"

#import "ZFPlayer.h"
#import "MJRefresh.h"
#import "VideoPlay3ViewController.h"

#import "JYUserAgreementView.h"
#import "RCDCommonDefine.h"
//#import "Const.h"
#import "SA_VideoModel.h"

//#import "MoLocationManager.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusHeight                   [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight                   44
#define kStatusAndNavBarHeight          (kStatusHeight+kNavBarHeight)
#define kExtendedHeightAtIphoneXBottom  (kStatusHeight>20?34:0)

@interface Video3ViewController ()<UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate>

@property(nonatomic, strong)UIImageView* navImageView1;
@property(nonatomic, strong)UITableView* tableView;

@property(nonatomic, strong)NSMutableArray* todayPlayArray;

@property(nonatomic, strong)ZFPlayerView* playerView;

@property(nonatomic, assign)NSInteger pageNum;

@property(nonatomic, strong)UILabel* leftLabel;
@property(nonatomic, strong)UILabel* rightLabel1;
@property(nonatomic, strong)UILabel* rightLabel2;
@property(nonatomic, strong)UIImageView* flyImageView;

@end

@implementation Video3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //只获取一次
//    __block  BOOL isOnece = YES;
//    [MoLocationManager getMoLocationWithSuccess:^(double lat, double lng){
//        isOnece = NO;
//        //只打印一次经纬度
//        NSLog(@"lat lng (%f, %f)", lat, lng);
//
//        [[NSUserDefaults standardUserDefaults] setDouble:lat forKey:@"lat"];
//        [[NSUserDefaults standardUserDefaults] setDouble:lng forKey:@"lng"];
//
//        [self requestWeather];
//
//        if (!isOnece) {
//            [MoLocationManager stop];
//        }
//    } Failure:^(NSError *error){
//        isOnece = NO;
//        NSLog(@"error = %@", error);
//        if (!isOnece) {
//            [MoLocationManager stop];
//        }
//    }];
    
    self.edgesForExtendedLayout = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navImageView1];
    [self.view addSubview:self.tableView];
    self.title = @"视频";
    self.pageNum = 1;
//    self.navImageView1.frame = CGRectMake(0, kStatusHeight, kScreenWidth, kNavBarHeight);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navImageView1.frame), kScreenWidth, kScreenHeight-kStatusAndNavBarHeight);
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [self requestVideos];
    
//    if ([DEFAULTS objectForKey:@"ISFirst"] == nil) {
//        
//        JYUserAgreementView * agreeview = [JYUserAgreementView userAgreementView];
//        agreeview.frame = CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT);
//        
//        [self.view addSubview:agreeview];
//    }
    
    
    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = @"视频";
    titlelabel.backgroundColor = [UIColor whiteColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.frame =  self.navImageView1.frame;
    [self.navImageView1 insertSubview:titlelabel atIndex:0];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self requestWeather];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.playerView.state == ZFPlayerStatePlaying || self.playerView.state == ZFPlayerStateBuffering) {
        [self.playerView pause];
    }
}



- (void)requestVideos
{
//    NSDictionary *dic = @{@"size":@(10), @"pageNum":@(_pageNum)};
//    NSString* getApi = @"http://568tj.cn:8080/news/video/getbysize";
//
//    //1.创建会话管理者
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml", @"image/*"]];
//
//    [manager GET:getApi parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if ([self.tableView respondsToSelector:@selector(mj_footer)]) {
//                if ((self.tableView.mj_footer.isRefreshing == YES)) {
//                    [self.tableView.mj_footer endRefreshing];
//                }
//            }
//        });
//
//        self->_pageNum++;
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        //NSLog(@"dic:%@", dic);
//        if ([dic[@"code"] integerValue] == 200) {
//            NSArray* array = dic[@"result"];
//            for (NSDictionary* d in array) {
//                VideoModel* model = [[VideoModel alloc] initWithDic:d];
//                 [self.todayPlayArray addObject:model];
//            }
//            [self.tableView reloadData];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if ([self.tableView respondsToSelector:@selector(mj_footer)]) {
//                if ((self.tableView.mj_footer.isRefreshing == YES)) {
//                    [self.tableView.mj_footer endRefreshing];
//                }
//            }
//        });
//    }];
    
    
    [MBProgressHUD showMessage:@"加载中.."];
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    [manager GET:@"http://149.28.12.15:8080/gp/video/get" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUD];
        if ([responseObject[@"code"] intValue] == 200) {
            
            NSMutableArray *array = [SA_VideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"retData"]];
            [self.todayPlayArray addObjectsFromArray:array];
            [self.tableView reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"加载失败！"];
    }];
    
    
    
}

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
//                                                       NSLog(@"%@", bodyDic);
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

- (void)doSomethingWhenFooterRefresh
{
    [self requestVideos];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todayPlayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"todayCellId";
    
    Video3TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[Video3TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    SA_VideoModel *model = self.todayPlayArray[indexPath.row];
    VideoModel* vModel = [[VideoModel alloc]init];
    vModel.vId = [model.v_id integerValue];
    vModel.urlString = model.url;
    vModel.playPath = model.url;
    vModel.title = model.name;
    vModel.content = model.name;
    vModel.synopsisPic = model.img;
    
    cell.coverPath = vModel.synopsisPic;
    cell.videoTitle = vModel.title;
    cell.readNumber = vModel.popularity;

    __block NSIndexPath *weakIndexPath     = indexPath;
    __block Video3TableViewCell *weakCell = cell;
    __weak typeof(self)  weakSelf          = self;
    // 点击播放的回调
//    cell.playBlock = ^(UIButton *btn){
    
//        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
//        playerModel.title            = vModel.title;
//        playerModel.videoURL         = [NSURL URLWithString:vModel.playPath];
//        playerModel.placeholderImage = [UIImage imageNamed:@"ZFPlayer.bundle/ZFPlayer_loading_bgView.png"];
//        //playerModel.placeholderImageURLString = vModel.synopsisPic;
//        playerModel.scrollView       = weakSelf.tableView;
//        playerModel.indexPath        = weakIndexPath;
//        // 赋值分辨率字典
//        //playerModel.resolutionDic    = dic;
//        // player的父视图tag
//        playerModel.fatherViewTag    = weakCell.picView.tag;
        
//        // 设置播放控制层和model
//        [weakSelf.playerView playerControlView:nil playerModel:playerModel];
//
//        // 自动播放
//        [weakSelf.playerView autoPlayTheVideo];
//    };
    
    [cell hidePlayButton:YES];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SA_VideoModel *model = self.todayPlayArray[indexPath.row];
    VideoModel* vModel = [[VideoModel alloc]init];
    vModel.vId = [model.v_id integerValue];
    vModel.urlString = model.url;
    vModel.playPath = model.url;
    vModel.title = model.name;
    vModel.content = model.name;
    vModel.synopsisPic = model.img;

    VideoPlay3ViewController* playVC = [[VideoPlay3ViewController alloc] init];
    playVC.videoModel = vModel;
    playVC.contentType = @"video";
    [self presentViewController:playVC animated:YES completion:^{

    }];

}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (tableView == self.todayTableView) {
//        return nil;
//    }else{
//        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 25)];
//
//        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 2.5, tableView.bounds.size.width-40, 20)];
//        label.textAlignment = NSTextAlignmentLeft;
//        label.font = [UIFont systemFontOfSize:20 weight:0.5];
//
//        [view addSubview:label];
//        return view;
//    }
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (tableView == self.todayTableView) {
//        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
//        label.text = @"* 每日更新五条视频 *";
//        label.textAlignment = NSTextAlignmentCenter;
//        return label;
//    }else if(tableView == self.historyTableView && section == self.historySortedKeys.count - 1){
//        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
//        label.text = @"* 没有更多视频了 *";
//        label.textAlignment = NSTextAlignmentCenter;
//        return label;
//    }
//    return nil;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.0001;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (tableView == self.todayTableView) {
//        return 30;
//    }else if(tableView == self.historyTableView && section == self.historySortedKeys.count - 1){
//        return 30;
//    }else{
//        return 0.00001;
//    }
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    if (ZFPlayerShared.isLandscape) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return ZFPlayerShared.isStatusBarHidden;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
         _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        UIImageView* headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*100.0/375)];
        headerView.image = [UIImage imageNamed:@"bg-2"];
        
        [headerView addSubview:self.leftLabel];
        [headerView addSubview:self.rightLabel1];
        [headerView addSubview:self.rightLabel2];
        [headerView addSubview:self.flyImageView];
        
        self.leftLabel.frame = CGRectMake(0, 0, kScreenWidth*0.5, 33);
        self.rightLabel1.frame = CGRectMake(0, 33, kScreenWidth*0.5, 33);
        self.rightLabel2.frame = CGRectMake(0, 66, kScreenWidth*0.5, 33);
        self.flyImageView.center = CGPointMake(kScreenWidth*3/4, headerView.frame.size.height*0.5);
        
        
        //_tableView.tableHeaderView = headerView;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        //创建刷新效果视图
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doSomethingWhenFooterRefresh)];
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

- (NSMutableArray *)todayPlayArray
{
    if (!_todayPlayArray) {
        _todayPlayArray = [NSMutableArray array];
    }
    return _todayPlayArray;
}

- (UIImageView *)navImageView1
{
    if (!_navImageView1) {
        _navImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar2"]];
        _navImageView1.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _navImageView1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
