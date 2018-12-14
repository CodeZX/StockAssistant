//
//  InformationViewController.m
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/8.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import "Info2ViewController.h"
#import "Info2TableViewCell.h"
#import "TJWebViewController.h"
#import "InfoDetailViewController.h"
#import "AFNetworking.h"
#import "InfoModel.h"
#import "MJRefresh.h"
#import "SA_VideoModel.h"
#import "VideoPlay3ViewController.h"
#import "SA_VideoModel.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusHeight                   [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight                   44
#define kStatusAndNavBarHeight          (kStatusHeight+kNavBarHeight)
#define kExtendedHeightAtIphoneXBottom  (kStatusHeight>20?34:0)

@interface Info2ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UIImageView* navImageView1;
@property(nonatomic, strong)UIButton* backBtn;
@property(nonatomic, strong)UITableView* tableView;

@property(nonatomic, strong)NSMutableArray* todayPlayArray;

@property(nonatomic, assign)NSInteger pageNum;

@end

@implementation Info2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.pageNum = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navImageView1];
    [self.view addSubview:self.tableView];
    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = @"热门资讯";
    titlelabel.backgroundColor = [UIColor whiteColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.frame =  self.navImageView1.frame;
    [self.navImageView1 insertSubview:titlelabel atIndex:0];
    
    
    
    [self requestInfos];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navImageView1.frame = CGRectMake(0, kStatusHeight, kScreenWidth, kNavBarHeight);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navImageView1.frame), kScreenWidth, self.view.bounds.size.height-CGRectGetMaxY(self.navImageView1.frame));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)requestInfos
{
//    NSDictionary *dic = @{@"size":@(10), @"pageNum":@(_pageNum)};
//    NSString* getApi = @"http://568tj.cn:8080/news/uav/getbysize";
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
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if ([self.tableView respondsToSelector:@selector(mj_footer)]) {
//                if ((self.tableView.mj_footer.isRefreshing == YES)) {
//                    [self.tableView.mj_footer endRefreshing];
//                }
//            }
//        });
//
//        self.pageNum++;
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"dic:%@", dic);
//        if ([dic[@"code"] integerValue] == 200) {
//            NSArray* array = dic[@"result"];
//            for (NSDictionary* d in array) {
//                InfoModel* model = [[InfoModel alloc] initWithDic:d];
//                [self.todayPlayArray addObject:model];
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
    
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    [manager GET:@"http://149.28.12.15:8080/gp/video/get" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] intValue] == 200) {
            
            NSMutableArray *array = [SA_VideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"retData"]];
            [self.todayPlayArray addObjectsFromArray:array];
            [self.tableView reloadData];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)doSomethingWhenFooterRefresh
{
    [self requestInfos];
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
    return self.todayPlayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"Info2TableViewCell";
    
    Info2TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[Info2TableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.infoModel = self.todayPlayArray[indexPath.row];
    cell.videoModel = self.todayPlayArray[indexPath.row];
    cell.edgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    InfoModel* infoModel = nil;
//    infoModel = self.todayPlayArray[indexPath.row];
//
//
//
//
//    InfoDetailViewController* vc = [[InfoDetailViewController alloc] init];
//    vc.infoModel = infoModel;
//    [self presentViewController:vc animated:YES completion:^{
//
//    }];
    
    
    SA_VideoModel *model = self.todayPlayArray[indexPath.row];
    
    VideoModel* videoModel = [[VideoModel alloc]init];
    videoModel.vId = [model.v_id integerValue];
    videoModel.urlString = model.url;
    videoModel.playPath = model.url;
    videoModel.title = model.name;
    videoModel.content = model.name;
    videoModel.synopsisPic = model.img;
    
    VideoPlay3ViewController* playVC = [[VideoPlay3ViewController alloc] init];
    playVC.videoModel = videoModel;
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
//        label.text = self.historySortedKeys[section];
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
//        label.text = @"* 每日更新五条资讯 *";
//        label.textAlignment = NSTextAlignmentCenter;
//        return label;
//    }else if(tableView == self.historyTableView && section == self.historySortedKeys.count - 1){
//        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
//        label.text = @"* 没有更多资讯了 *";
//        label.textAlignment = NSTextAlignmentCenter;
//        return label;
//    }
//    return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (tableView == self.todayTableView) {
//        return 0.0001;
//    }else{
//        return 25;
//    }
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

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
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
        _navImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_new"]];
        _navImageView1.contentMode = UIViewContentModeScaleAspectFill;
        _navImageView1.userInteractionEnabled = YES;
        
        self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_backBtn setImage:[UIImage imageNamed:@"icon_return-1"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [_navImageView1 addSubview:_backBtn];
    }
    return _navImageView1;
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
