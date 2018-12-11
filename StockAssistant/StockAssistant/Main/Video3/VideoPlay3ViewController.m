//
//  TJWebViewController.m
//  HKGoodColor
//
//  Created by 周峻觉 on 2018/5/3.
//  Copyright © 2018年 chenkaijie. All rights reserved.
//

#import "VideoPlay3ViewController.h"
#import <WebKit/WebKit.h>
#import "CommentCell.h"
#import "AFNetworking.h"
#import "CommentModel.h"
#import "ZFPlayer.h"

#import "JYUserAgreementView.h"
#import "RCDCommonDefine.h"
//#import "Const.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusHeight                   [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight                   44
#define kStatusAndNavBarHeight          (kStatusHeight+kNavBarHeight)
#define kExtendedHeightAtIphoneXBottom  (kStatusHeight>20?34:0)

@interface VideoPlay3ViewController ()<UITextViewDelegate, UITableViewDelegate, UITableViewDataSource,ZFPlayerDelegate>

@property(nonatomic, strong)UIImageView* navImageView;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

//播放器
@property(nonatomic, strong)UIView* playerContainer;
@property(nonatomic, strong)ZFPlayerView* playerView;

//简介
@property(nonatomic, strong)UIScrollView* contentContainer;

@property(nonatomic, strong)UIView* bgView;
@property(nonatomic, strong)UIButton* closeButton;
@property(nonatomic, strong)UIButton* shareButton;
@property(nonatomic, strong)UIButton* commentButton;
@property(nonatomic, strong)UIButton* writeButton;

@property(nonatomic, strong)UIImageView* commentTextContainer;
@property(nonatomic, strong)UITextView* commentTextView;

@property(nonatomic, strong)UIView* commnentTableViewContainer;
@property(nonatomic, strong)UITableView* commentTableView;
@property(nonatomic, strong)UILabel* noCommentLabel;

@property(nonatomic, strong)NSString* commentContent;

@property(nonatomic, strong)NSMutableArray* commentList;

@property(nonatomic, strong)UILabel* hintLabel;



@end

@implementation VideoPlay3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navImageView];
    [self.view addSubview:self.playerContainer];
    [self.view addSubview:self.contentContainer];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.hintLabel];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    //[self.view addSubview:self.activityIndicator];
    //设置小菊花的frame
    self.activityIndicator.frame= CGRectMake(100, 100, 200, 200);
    self.activityIndicator.center = CGPointMake(self.view.bounds.size.width*0.5, self.view.bounds.size.height*0.5);
    //设置小菊花颜色
    self.activityIndicator.color = [UIColor redColor];
    //设置背景颜色
    //self.activityIndicator.backgroundColor = [UIColor cyanColor];
    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    self.activityIndicator.hidesWhenStopped = YES;
    [self.activityIndicator startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if ([DEFAULTS objectForKey:@"ISFirst"] == nil) {
        
        JYUserAgreementView * agreeview = [JYUserAgreementView userAgreementView];
        agreeview.frame = CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT);
        
        [self.view addSubview:agreeview];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navImageView.frame = CGRectMake(0, kStatusHeight, kScreenWidth, kNavBarHeight);
    self.playerContainer.frame = CGRectMake(0, CGRectGetMaxY(self.navImageView.frame), kScreenWidth, 260);
    self.contentContainer.frame = CGRectMake(0, CGRectGetMaxY(self.playerContainer.frame), kScreenWidth, kScreenHeight-CGRectGetMaxY(self.playerContainer.frame)-44-kExtendedHeightAtIphoneXBottom);
    self.bgView.frame = CGRectMake(0, kScreenHeight-44-kExtendedHeightAtIphoneXBottom, kScreenWidth, 44+kExtendedHeightAtIphoneXBottom);
    self.hintLabel.frame = CGRectMake(0, CGRectGetMaxY(self.playerContainer.frame), kScreenWidth, 40);
    
    
    ///* 设置内容 *///
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.contentContainer.bounds.size.width-20, 50)];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.text = self.videoModel.title;
    titleLabel.textColor = [UIColor blackColor];
    
    
    
    NSString* content = self.videoModel.content;
    content = [content stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    content = [content stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    
    UIFont* font = [UIFont systemFontOfSize:16];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    //[paragraphStyle setAlignment:NSTextAlignmentCenter];
    NSAttributedString* attString = [[NSAttributedString alloc] initWithString:content
                                                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                font,NSFontAttributeName,
                                                                                [UIColor blackColor],NSForegroundColorAttributeName,
                                                                                @(1),NSKernAttributeName,
                                                                                paragraphStyle,NSParagraphStyleAttributeName,
                                                                                nil]];
    CGSize labelSize = [self attributedStringSize:attString maxSize:CGSizeMake(self.contentContainer.bounds.size.width-20, MAXFLOAT)];
    UILabel* contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+10, labelSize.width, labelSize.height)];
    contentLabel.attributedText = attString;
    contentLabel.numberOfLines = 0;
    
    [self.contentContainer addSubview:titleLabel];
    [self.contentContainer addSubview:contentLabel];
    
    
    UIButton* complaintsBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(contentLabel.frame)+30, 80, 33)];
    [complaintsBtn setTitle:@"举报" forState:UIControlStateNormal];
    [complaintsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [complaintsBtn setBackgroundColor:[UIColor colorWithRed:229/255.0 green:45/255 blue:89/255 alpha:0.6]];
    [complaintsBtn setTitle:@"已举报" forState:UIControlStateSelected];
    complaintsBtn.layer.cornerRadius = 5;
    [complaintsBtn addTarget:self action:@selector(complaintsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentContainer addSubview:complaintsBtn];
    
    self.contentContainer.contentSize = CGSizeMake(self.contentContainer.bounds.size.width, CGRectGetMaxY(complaintsBtn.frame)+20);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ZFPlayerModel* playerModel = [[ZFPlayerModel alloc] init];
    playerModel.title = self.videoModel.title;
    playerModel.videoURL = [NSURL URLWithString:self.videoModel.playPath];
    playerModel.fatherView = self.playerContainer;
    playerModel.placeholderImageURLString = self.videoModel.synopsisPic;
    
    [self.playerView playerControlView:nil playerModel:playerModel];
    [self.playerView autoPlayTheVideo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - 计算属性化文本的矩形大小
- (CGSize)attributedStringSize:(NSAttributedString *_Nullable)text maxSize:(CGSize)size;
{
    if ([text isKindOfClass:[NSNull class]] || text == nil || text.length == 0) {
        return CGSizeZero;
    }
    
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
}

- (void)complaintsAction:(UIButton *)btn
{
    if (btn.selected == NO) {
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @(self.videoModel.vId),@"id",
                             nil];
        NSString* postApi = @"http://47.93.28.161:8080/news/video/getbyid";
        
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml", @"image/*"]];
        
        [manager GET:postApi parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"投诉成功");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"投诉失败");
        }];
    }
    btn.selected = YES;
    [btn setBackgroundColor:[UIColor colorWithRed:0/255 green:250/255 blue:154/255 alpha:0.6]];
    
}

- (void)closeAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareAction:(UIButton *)btn
{
    NSString* title = self.videoModel.title;
    UIImage* image = [UIImage imageNamed:@"icon.png"];
    NSString* urlString = [NSString stringWithFormat:@"http://newsvideo.568tj.cn?id=%ld", self.videoModel.vId];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSArray* postItems = @[title,image,url];
    
    UIActivityViewController* controller = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        
    }
}

- (void)commentAction:(UIButton *)btn
{
    if (btn == self.commentButton) {
        [UIView animateWithDuration:0.5 animations:^{
            self.commnentTableViewContainer.frame = CGRectMake(0, kScreenHeight*0.5, kScreenWidth, kScreenHeight*0.5);
        }];
        NSInteger type = [_contentType isEqualToString:@"info"] ? 1:([_contentType isEqualToString:@"video"]?2:3);
        [self requestCommentListWithType:type newsId:self.videoModel.vId];
        
    }else if(btn.tag == 1111){
        NSInteger type = [_contentType isEqualToString:@"info"] ? 1:([_contentType isEqualToString:@"video"]?2:3);
        [self publishCommentWithUsername:@"游客" content:self.commentContent type:type newsId:self.videoModel.vId];
        [self.commentTextView resignFirstResponder];
        [self.commentTextContainer removeFromSuperview];
        self.commentTextContainer = nil;
    }else if (btn.tag == 2222){
        [self.commentTextView resignFirstResponder];
        [self.commentTextContainer removeFromSuperview];
        self.commentTextContainer = nil;
    }
}

- (void)writeAction:(UIButton *)btn
{
    [self commentTextContainer];
}

- (void)closeCommentTableViewAction:(UIButton *)btn
{
    [UIView animateWithDuration:0.5 animations:^{
        self.commnentTableViewContainer.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight*0.5);
    }];
}

- (void)publishCommentWithUsername:(NSString *)name content:(NSString *)content type:(NSInteger)type newsId:(NSInteger)newsid
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         name,@"username",
                         content,@"content",
                         @(type),@"type",
                         @(newsid),@"newsId",
                         nil];
    NSString* postApi = @"http://568tj.cn:8080/news/comment/publish";
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml", @"image/*"]];
    
    [manager GET:postApi parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"评论成功:%@", responseObject);
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-150)*0.5, (kScreenHeight-60)*0.5, 150, 60)];
        label.backgroundColor = [UIColor grayColor]; //[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:20];
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"评论提交成功!";
        
        [self.view addSubview:label];
        
        [UIView animateWithDuration:5 animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"评论失败");
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-150)*0.5, (kScreenHeight-60)*0.5, 150, 60)];
        label.backgroundColor = [UIColor grayColor]; //[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:20];
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"评论提交失败!";
        
        [self.view addSubview:label];
        
        [UIView animateWithDuration:5 animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

- (void)requestCommentListWithType:(NSInteger)type newsId:(NSInteger)newsid
{
//    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         @(type),@"type",
//                         @(newsid),@"newsId",
//                         nil];
    NSString* postApi = @"http://568tj.cn:8080/news/comment/pull";
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml", @"image/*"]];
    
    [manager GET:postApi parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"dic:%@", dic);
        if ([dic[@"code"] integerValue] == 200) {
            NSArray* array = dic[@"result"];
            
            if (array.count > 0) {
                self.noCommentLabel.hidden = YES;
            }
            for (NSDictionary* d in array) {
                CommentModel* model = [[CommentModel alloc] initWithDic:d];
                [self.commentList addObject:model];
            }

            [self.commentTableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
}

- (void)keyboardDidShow:(NSNotification *)noti
{
    NSLog(@"------------------------------------");
    NSLog(@"%@", noti);
    NSLog(@"------------------------------------");
    
    CGRect endFrame = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.commentTextContainer.frame;
        frame.origin.y = endFrame.origin.y-frame.size.height;
        self.commentTextContainer.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.commentTextContainer.frame;
            frame.size = CGSizeMake(kScreenWidth, 118);
            self.commentTextContainer.frame = frame;
        }];
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti
{

}

- (void)textViewDidChange:(UITextView *)textView
{
    self.commentContent = textView.text;
    NSLog(@"%@", self.commentContent);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cell.id";
    
    CommentCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CommentModel* model = self.commentList[indexPath.row];
    cell.userName = model.username;
    cell.content = model.content;
    cell.timeString = model.date;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.contentContainer && scrollView.contentOffset.y < -80) {
        self.hintLabel.hidden = NO;
    }else{
        self.hintLabel.hidden = YES;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"offset:%f", scrollView.contentOffset.y);
    if (scrollView == self.contentContainer && scrollView.contentOffset.y < -80) {
        [self closeAction:nil];
    }else{
    }
}

- (void)zf_playerBackAction
{
    [self closeAction:nil];
}

- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen
{
    NSLog(@"%s:%@", __func__, fullscreen?@"全屏":@"非全屏");
}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen
{
    NSLog(@"%s:%@", __func__, fullscreen?@"全屏":@"非全屏");
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
        
        CGRect writeButtonFrame = self.writeButton.frame;
        writeButtonFrame.origin.x = kScreenWidth*0.5-self.writeButton.frame.size.width;
        writeButtonFrame.origin.y = (_bgView.bounds.size.height-self.writeButton.frame.size.height)*0.5;
        self.writeButton.frame = writeButtonFrame;
        [self.writeButton setTitle:@"我也来说两句" forState:UIControlStateNormal];
        [_bgView addSubview:self.writeButton];
        
        CGFloat space = kScreenWidth*0.5*1/6;
        self.commentButton.center = CGPointMake(kScreenWidth*0.5+space, _bgView.bounds.size.height*0.5);
        self.shareButton.center = CGPointMake(self.commentButton.center.x+space*2, self.commentButton.center.y);
        self.closeButton.center = CGPointMake(self.shareButton.center.x+space*2, self.shareButton.center.y);
        
        [_bgView addSubview:self.commentButton];
        [_bgView addSubview:self.shareButton];
        [_bgView addSubview:self.closeButton];
    }
    return _bgView;
}

- (UIButton *)writeButton
{
    if (!_writeButton) {
        _writeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 165, 28)];
        [_writeButton setBackgroundImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
        [_writeButton addTarget:self action:@selector(writeAction:) forControlEvents:UIControlEventTouchUpInside];
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

- (UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 19, 19)];
        [_shareButton setImage:[UIImage imageNamed:@"icon_share-1"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UIButton *)commentButton
{
    if (!_commentButton) {
        _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 19, 19)];
        [_commentButton setImage:[UIImage imageNamed:@"icon_comment-1"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (UIImageView *)commentTextContainer
{
    if (!_commentTextContainer) {
        _commentTextContainer = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 118)];
        _commentTextContainer.userInteractionEnabled = YES;
        _commentTextContainer.image = [UIImage imageNamed:@"icon_box.png"];
        
        self.commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-74, 98)];
        self.commentTextView.backgroundColor = [UIColor whiteColor];
        self.commentTextView.layer.cornerRadius = 15;
        self.commentTextView.delegate = self;
        self.commentTextView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.commentTextView.font = [UIFont systemFontOfSize:18];
        [self.commentTextView becomeFirstResponder];
        [_commentTextContainer addSubview:self.commentTextView];
        
        UIButton* submitButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentTextView.frame)+10, self.commentTextView.frame.origin.y+7, 44, 30)];
        submitButton.tag = 1111;
        [submitButton setTitle:@"发布" forState:UIControlStateNormal];
        [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitButton setBackgroundColor:[UIColor colorWithRed:253/255.0 green:169/255.0 blue:59/255.0 alpha:1.0]];
        submitButton.layer.cornerRadius = 5;
        [submitButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [_commentTextContainer addSubview:submitButton];
        
        UIButton* cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentTextView.frame)+10, CGRectGetMaxY(submitButton.frame)+24, 44, 30)];
        cancelButton.tag = 2222;
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setBackgroundColor:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0]];
        cancelButton.layer.cornerRadius = 5;
        [cancelButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [_commentTextContainer addSubview:cancelButton];
        
        [self.view addSubview:self.commentTextContainer];
        
    }
    return _commentTextContainer;
}

- (UIImageView *)navImageView
{
    if (!_navImageView) {
        if ([_contentType  isEqualToString:@"video"]) {
            _navImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation3"]];
        }else if([_contentType  isEqualToString:@"info"]){
            _navImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_detail"]];
        }else{
            _navImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_details"]];
        }
    
        _navImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _navImageView;
}

- (UIView *)playerContainer
{
    if (!_playerContainer) {
        _playerContainer = [[UIView alloc] init];
        _playerContainer.backgroundColor = [UIColor blackColor];
    }
    return _playerContainer;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        //_playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        //_playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}

- (UIScrollView *)contentContainer
{
    if (!_contentContainer) {
        _contentContainer = [[UIScrollView alloc] init];
        _contentContainer.delegate = self;
    }
    return _contentContainer;
}

- (UIView *)commnentTableViewContainer
{
    if (!_commnentTableViewContainer) {
        _commnentTableViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight*0.5)];
        
        self.commentTableView.frame = CGRectMake(0, 44, kScreenWidth, _commnentTableViewContainer.frame.size.height-44);
        [_commnentTableViewContainer addSubview:self.commentTableView];
        
        UIButton* closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-80, 0, 60, 30)];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeBtn setBackgroundColor:[UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0]];
        closeBtn.layer.cornerRadius = 10;
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [closeBtn addTarget:self action:@selector(closeCommentTableViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_commnentTableViewContainer addSubview:closeBtn];
        
        self.noCommentLabel.center = CGPointMake(kScreenWidth*0.5, _commnentTableViewContainer.bounds.size.height*0.5);
        [_commnentTableViewContainer addSubview:self.noCommentLabel];
        
        [self.view addSubview:_commnentTableViewContainer];
    }
    return _commnentTableViewContainer;
}

- (UITableView *)commentTableView
{
    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc] init];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentTableView.backgroundColor = [UIColor lightGrayColor];
    }
    return _commentTableView;
}

- (UILabel *)noCommentLabel
{
    if (!_noCommentLabel) {
        _noCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        _noCommentLabel.text = @"暂无评论";
        _noCommentLabel.font = [UIFont systemFontOfSize:24];
        _noCommentLabel.textColor = [UIColor whiteColor];
        _noCommentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noCommentLabel;
}

- (NSMutableArray *)commentList
{
    if (!_commentList) {
        _commentList = [NSMutableArray array];
    }
    return _commentList;
}

- (UILabel *)hintLabel
{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _hintLabel.text = @"下拉关闭";
        _hintLabel.textColor = [UIColor redColor];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.font = [UIFont systemFontOfSize:15 weight:0.5];
        _hintLabel.hidden = YES;
    }
    return _hintLabel;
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
