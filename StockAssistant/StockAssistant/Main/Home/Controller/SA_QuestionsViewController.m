//
//  SA_QuestionsViewController.m
//  StockAssistant
//
//  Created by 周鑫 on 2018/12/13.
//  Copyright © 2018 TJ. All rights reserved.
//

#import "SA_QuestionsViewController.h"


#import "JYASKTableViewCell.h"
#import "JYCommitViewController.h"
#import "JYCommentDetailsViewController.h"
#import "JYASKTableViewCell+CommunityItem.h"
#import "JYCommunity.h"
//#import "JYLoginViewController.h"
#import "MJRefresh.h"
#import "JFSaveTool.h"
#import "NetManager.h"
#import "Masonry.h"
#import "UIView+HUD.h"
//#import "Const.h"
#import "UIScrollView+Refresh.h"
#import "JYLoginViewController.h"
#import "AFNetworking.h"

static NSString * const kCellIdentifier = @"ASKCell.identifier";
static NSString * pageNum = @"20";


#define PIC_WIDTH 70
#define PIC_HEIGHT 80
#define COL_COUNT 3

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusHeight                   [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight                   44
#define kStatusAndNavBarHeight          (kStatusHeight+kNavBarHeight)
#define kExtendedHeightAtIphoneXBottom  (kStatusHeight>20?34:0)

@interface SA_QuestionsViewController ()<UITableViewDelegate,UITableViewDataSource,JYASKTableViewCellDelegate>

@property(nonatomic, strong)UIImageView* navImageView;
@property(nonatomic, strong)UIButton* backBtn;
@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, assign) NSInteger status;   ///< 状态
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArrays;  ///< 数据源数组

@property (nonatomic ,strong) NSString * eval_id; ///< 问一问分类

@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isNeededRequest;
@property (nonatomic, assign) BOOL isFirst;

@property(nonatomic, strong)UIView* bgView;
@property(nonatomic, strong)UIButton* closeButton;
@property(nonatomic, strong)UIButton* writeButton;

@property(nonatomic, strong)UIButton* clickLoginButton;

@end

@implementation SA_QuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.view addSubview:self.navImageView];
    //初始化参数
    [self ds_setupTableView];
    [self.tableView.mj_header beginRefreshing];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.clickLoginButton];
    
    
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = @"高手问答";
    titlelabel.backgroundColor = [UIColor whiteColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.frame =  self.navImageView.frame;
    [self.navImageView insertSubview:titlelabel atIndex:0];
}

-  (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navImageView.frame = CGRectMake(0, kStatusHeight, kScreenWidth, kNavBarHeight);
    self.bgView.frame = CGRectMake(0, kScreenHeight-44-kExtendedHeightAtIphoneXBottom, kScreenWidth, 44+kExtendedHeightAtIphoneXBottom);
    self.clickLoginButton.frame = CGRectMake((kScreenWidth-200)*0.5, kScreenHeight*0.5, 200, 40);
    
    if ([[JFSaveTool objectForKey:@"UserID"] isEqualToString:@""] || [JFSaveTool objectForKey:@"UserID"] == NULL) {
        self.tableView.hidden = YES;
        self.clickLoginButton.hidden = NO;
    }else{
        self.tableView.hidden = NO;
        self.clickLoginButton.hidden = YES;
    }
}

- (void)backAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JYASKTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.likeButton.tag = indexPath.row;
    cell.reportButton.tag = indexPath.row;
    JYCommunity_retData * item = self.dataArray[indexPath.row];
    [cell configCellWithModel:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JYCommentDetailsViewController * vc = [[JYCommentDetailsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"评论详情";
    JYCommunity_retData * item = self.dataArray[indexPath.row];
    
    //    vc.card_id = item.card_id;
    vc.card_id = item.post_id;
    vc.isPraise = item.is_like;
    vc.iconImageURL = item.user_pic;
    vc.content = item.title;
    vc.commentNum = item.comment;
    [self.navigationController pushViewController:vc animated:YES];
}


//点赞按钮
- (void)likeButtonAction:(UIButton *)button {
    JYCommunity_retData * item = self.dataArray[button.tag];
    
    if ([[JFSaveTool objectForKey:@"UserID"] isEqualToString:@""] || [JFSaveTool objectForKey:@"UserID"] == NULL) {
        //        JYLoginViewController * vc = [[JYLoginViewController alloc] init];
        //        [self.navigationController pushViewController:vc animated:YES];
    }else {
        if (button.selected == NO) {
            [NetManager POSTJoinLikeCardId:item.card_id userId:[JFSaveTool objectForKey:@"UserID"] completionHandler:^(JYRegisterItem *allCommunity, NSError *error) {
                button.selected = YES;
                
                [self.tableView reloadData];
            }];
        }else {
            [NetManager POSTDeleteLikeCardId:item.card_id userId:[JFSaveTool objectForKey:@"UserID"] completionHandler:^(JYRegisterItem *allCommunity, NSError *error) {
                button.selected = NO;
                [self.tableView reloadData];
            }];
        }
    }
}

//举报
- (void)reportButtonAction:(UIButton *)button {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确认要举报这个话题吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        
        //举报
        JYCommunity_retData * item = self.dataArray[button.tag];
        if ([[JFSaveTool objectForKey:@"UserID"] isEqualToString:@""] || [JFSaveTool objectForKey:@"UserID"] == NULL) {
            //            JYLoginViewController * vc = [[JYLoginViewController alloc] init];
            //            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [NetManager POSTReportCardId:item.card_id userID:[JFSaveTool objectForKey:@"UserID"] completionHandler:^(JYRegisterItem *allCommunity, NSError *error) {
                [self.view showMessage:allCommunity.msg];
            }];
        }
        
    }];
    UIAlertAction * cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - private method
- (void)ds_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusAndNavBarHeight, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - kStatusAndNavBarHeight-kExtendedHeightAtIphoneXBottom-44) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.estimatedRowHeight = 180;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[JYASKTableViewCell nib] forCellReuseIdentifier:kCellIdentifier];
    __weak SA_QuestionsViewController * weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->_isRefreshing = YES;
        
        [weakSelf orderNetWorking];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isRefreshing = NO;
        if (self->_isNeededRequest) {
            [weakSelf orderNetWorking];
        }else{
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
    }];
    [self.view addSubview:self.tableView];
    
}

- (void)tiwenButtonAction:(UIButton *)button {
    
    if ([[JFSaveTool objectForKey:@"UserID"] isEqualToString:@""] || [JFSaveTool objectForKey:@"UserID"] == NULL) {
        //        JYLoginViewController * vc = [[JYLoginViewController alloc] init];
        //        [self.navigationController pushViewController:vc animated:YES];
    }else {
        JYCommitViewController * vc = [[JYCommitViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"发表话题";
        kPushViewController(vc);
    }
}

- (void)closeAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickloginAction:(UIButton *)btn
{
    JYLoginViewController * vc = [[JYLoginViewController alloc] init];
    UINavigationController *askNavi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:askNavi animated:YES completion:nil];
}

#pragma mark - 网络请求
- (void)orderNetWorking {
    
    if ([[JFSaveTool objectForKey:@"UserID"] isEqualToString:@""] || [JFSaveTool objectForKey:@"UserID"] == NULL) {
        [NetManager GETAllCommunityID:@"" completionHandler:^(JYCommunity *allCommunity, NSError *error) {
            self.dataArray = allCommunity.retData ;
            [self.tableView reloadData];
            [self.tableView dong_endHeaderRefresh];
            [self.tableView dong_endFooterRefresh];
        }];
    }else {
        [MBProgressHUD showMessage:@"加载中.."];
        [NetManager GETAllCommunityID:[JFSaveTool objectForKey:@"UserID"] completionHandler:^(JYCommunity *allCommunity, NSError *error) {
            [MBProgressHUD hideHUD];
            [self.tableView.mj_header endRefreshing];
            self.dataArray = allCommunity.retData ;
            [self.tableView reloadData];
            [self.tableView dong_endHeaderRefresh];
            [self.tableView dong_endFooterRefresh];
            //                if (error) {
            //                    [MBProgressHUD showSuccess:@"加载失败..."];
            //                }else {
            //
            //                }
            
        }];
    }
    //
    
    //    [MBProgressHUD showMessage:@"加载中...111"];
    //    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    //    [manager GET:@"http://149.28.12.15:8080/gp/post/list_all" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        [MBProgressHUD hideHUD];
    //        if ([responseObject[@"code"] integerValue] == 200) {
    //
    ////            self.dataArray = [
    //        }
    //
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //        TJLog(@"zxzxzxzx%@",[error localizedDescription]);
    //        TJLog(@"zxzxzxzx%@",[error localizedDescription]);
    //    }];
    
    
    
    
}

#pragma mark - 懒加载
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
        
        CGRect writeButtonFrame = self.writeButton.frame;
        writeButtonFrame.origin.x = 30; //kScreenWidth*0.5-self.writeButton.frame.size.width;
        writeButtonFrame.origin.y = (_bgView.bounds.size.height-self.writeButton.frame.size.height)*0.5;
        self.writeButton.frame = writeButtonFrame;
        [self.writeButton setTitle:@"创建话题" forState:UIControlStateNormal];
        [_bgView addSubview:self.writeButton];
        
        //CGFloat space = kScreenWidth*0.5*1/6;
        self.closeButton.center = CGPointMake(kScreenWidth*0.85, _bgView.bounds.size.height*0.5);
        
        [_bgView addSubview:self.closeButton];
    }
    return _bgView;
}

- (UIButton *)writeButton
{
    if (!_writeButton) {
        _writeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*0.7, 28)];
        [_writeButton setBackgroundImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
        [_writeButton addTarget:self action:@selector(tiwenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _writeButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 19, 19)];
        [_closeButton setImage:[UIImage imageNamed:@"icon_close-1"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)clickLoginButton
{
    if (!_clickLoginButton) {
        _clickLoginButton = [[UIButton alloc] init];
        [_clickLoginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_clickLoginButton setTitle:@"请先登录。点击登录" forState:UIControlStateNormal];
        [_clickLoginButton addTarget:self action:@selector(clickloginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickLoginButton;
}

- (UIImageView *)navImageView
{
    if (!_navImageView) {
        _navImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"话题.png"]];
        _navImageView.contentMode = UIViewContentModeScaleAspectFill;
        _navImageView.userInteractionEnabled = YES;
        
        self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_backBtn setImage:[UIImage imageNamed:@"return2"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [_navImageView addSubview:_backBtn];
    }
    return _navImageView;
}

@end
