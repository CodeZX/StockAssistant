//
//  JYCommentDetailsViewController.m
//  246News
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 Edgar_Guan. All rights reserved.
//

#import "JYCommentDetailsViewController.h"
#import "JYCommentCell.h"
#import "JYCommentItem.h"
#import "JYCommentCell+JYcommentItem.h"
#import "JYCommitViewController.h"
#import "UIButton+JYAdd.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "JFSaveTool.h"
#import "NetManager.h"
#import "UIView+HUD.h"
#import "UIScrollView+Refresh.h"
//#import "JYLoginViewController.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusHeight                   [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight                   44
#define kStatusAndNavBarHeight          (kStatusHeight+kNavBarHeight)
#define kExtendedHeightAtIphoneXBottom  (kStatusHeight>20?34:0)

static NSString * pageNum = @"20";

@interface JYCommentDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,JYCommentCellDelegate>
@property (nonatomic, strong) NSArray * dataArray;

@property (strong, nonatomic) UIImageView *navImageView;
@property (strong, nonatomic) UIButton* backButton;
@property (strong, nonatomic)  UIButton *commentButton;
@property (strong, nonatomic)  UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * dataArrays;
@property (weak, nonatomic) IBOutlet UIView *topView;



@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isNeededRequest;
@end

@implementation JYCommentDetailsViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.navImageView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commentButton];
    [self.view addSubview:self.likeButton];
    [self.view addSubview:self.backButton];
    [self ds_setTopView];

    if ([self.isPraise isEqualToString:@"0"]) {
        self.likeButton.selected = NO;
    }else {
        self.likeButton.selected = YES;
    }
    
    [self ds_netWorking];
}

-  (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navImageView.frame = CGRectMake(0, kStatusHeight, kScreenWidth, kNavBarHeight);
    self.tableView.frame = CGRectMake(0, kStatusAndNavBarHeight, kScreenWidth, kScreenHeight- kStatusAndNavBarHeight- 44 -kExtendedHeightAtIphoneXBottom);
    self.commentButton.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreenWidth/3, 44);
    self.likeButton.frame = CGRectMake(kScreenWidth/3, CGRectGetMaxY(self.tableView.frame), kScreenWidth/3, 44);
    self.backButton.frame = CGRectMake(kScreenWidth*2/3, CGRectGetMaxY(self.tableView.frame), kScreenWidth/3, 44);
}


- (void)ds_setTopView {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.iconImageURL] placeholderImage:[UIImage imageNamed:@"icon_head40"]];
    self.iconImageView.layer.cornerRadius = 20;
    self.contentLabel.text = self.content;
    [self.contentLabel sizeToFit];
    self.commentLabel.text = [NSString stringWithFormat:@"评论(%@)",self.commentNum];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellid = @"JYCommentCell";
    
    JYCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[JYCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate = self;
    cell.reportButton.tag = indexPath.row;
    JYCommentItemy_retData * item = self.dataArray[indexPath.row];
    [cell configCellWithModel:item];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}


//评论
- (void)commentButtonAction:(UIButton *)sender {
    
    if ([[JFSaveTool objectForKey:@"UserID"] isEqualToString:@""] || [JFSaveTool objectForKey:@"UserID"] == NULL) {
        //        JYLoginViewController * vc = [[JYLoginViewController alloc] init];
        //        [self.navigationController pushViewController:vc animated:YES];
    }else {
        JYCommitViewController * vc = [[JYCommitViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"评论";
        vc.card_id = self.card_id;
        [self.navigationController pushViewController:vc animated:YES];
        //kPushViewController(vc);
    }
}

//点赞
- (void)likeButtonAction:(UIButton *)sender {
    
    if ([[JFSaveTool objectForKey:@"UserID"] isEqualToString:@""] || [JFSaveTool objectForKey:@"UserID"] == NULL) {
        //        JYLoginViewController * vc = [[JYLoginViewController alloc] init];
        //        [self.navigationController pushViewController:vc animated:YES];
    }else {
        if (sender.selected == NO) {
            [NetManager POSTJoinLikeCardId:self.card_id userId:[JFSaveTool objectForKey:@"UserID"] completionHandler:^(JYRegisterItem *allCommunity, NSError *error) {
                sender.selected = YES;
                [self.tableView reloadData];
            }];
        }else {
            [NetManager POSTDeleteLikeCardId:self.card_id userId:[JFSaveTool objectForKey:@"UserID"] completionHandler:^(JYRegisterItem *allCommunity, NSError *error) {
                sender.selected = NO;
                [self.tableView reloadData];
            }];
        }
    }
}

#define mark - JYCommentCellDelegate
//举报
- (void)reportAction:(UIButton *)button {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确认要举报这个话题吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
    
        JYCommentItemy_retData * item = self.dataArray[button.tag];
        if ([[JFSaveTool objectForKey:@"UserID"] isEqualToString:@""] || [JFSaveTool objectForKey:@"UserID"] == NULL) {
//            JYLoginViewController * vc = [[JYLoginViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [NetManager POSTReportCommentId:item.comment_id userId:[JFSaveTool objectForKey:@"UserID"] cardID:item.card_id completionHandler:^(JYRegisterItem *allCommunity, NSError *error) {
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

- (void)backButtonAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 网络请求
- (void)ds_netWorking {
    [NetManager POSTShowCommentCardId:self.card_id completionHandler:^(JYCommentItem *allCommunity, NSError *error) {
        self.dataArray = allCommunity.retData ;
        [self.tableView reloadData];
        [self.tableView dong_endHeaderRefresh];
        [self.tableView dong_endFooterRefresh];
    }];
}

- (NSMutableArray *)dataArrays {
    if (!_dataArrays) {
        _dataArrays = [NSMutableArray array];
    }
    return _dataArrays;
}

- (UIImageView *)navImageView
{
    if (!_navImageView) {
        _navImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"评论详情.png"]];
        _navImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _navImageView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        //初始化tableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        //_tableView.estimatedRowHeight = 180;
        //_tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.tableView.tableHeaderView = self.topView;
        
        __weak JYCommentDetailsViewController * weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self->_isRefreshing = YES;
            
            [weakSelf ds_netWorking];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self->_isRefreshing = NO;
            if (self->_isNeededRequest) {
                [weakSelf ds_netWorking];
            }else{
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }
        }];
        //[_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

- (UIButton *)commentButton
{
    if (!_commentButton) {
        _commentButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_commentButton setImage:[UIImage imageNamed:@"icon_message2"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //_commentButton.layer.borderWidth = 0.5;
//        _commentButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _commentButton.contentMode = UIViewContentModeCenter;
    }
    return _commentButton;
}

- (UIButton *)likeButton
{
    if (!_likeButton) {
        _likeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_likeButton setImage:[UIImage imageNamed:@"icon_heart_nor"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"icon_heart_pre"] forState:UIControlStateSelected];
        [_likeButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //_likeButton.layer.borderWidth = 0.5;
//        _likeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _likeButton.contentMode = UIViewContentModeCenter;
    }
    return _likeButton;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_backButton setImage:[UIImage imageNamed:@"icon_close-1"] forState:UIControlStateNormal];
        //[_backButton setImage:[UIImage imageNamed:@"icon2_heart_pre"] forState:UIControlStateSelected];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //_backButton.layer.borderWidth = 0.5;
        //        _likeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //        _likeButton.contentMode = UIViewContentModeCenter;
    }
    return _backButton;
}

@end
