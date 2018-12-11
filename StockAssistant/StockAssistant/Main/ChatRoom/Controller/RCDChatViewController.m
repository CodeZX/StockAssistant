//
//  RCDChatViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDChatViewController.h"
#import "RCDChatViewController.h"
#import "RCDCustomerEmoticonTab.h"
#import "RCDRoomSettingViewController.h"
#import "RCDTestMessage.h"
#import "RCDTestMessageCell.h"
#import "RCDUIBarButtonItem.h"
#import "RCDataBaseManager.h"
#import "RealTimeLocationEndCell.h"
#import "RealTimeLocationStartCell.h"
#import "RealTimeLocationStatusView.h"
#import "RealTimeLocationViewController.h"
#import <RongContactCard/RongContactCard.h>
#import <RongIMKit/RongIMKit.h>
#import "RCDForwardAlertView.h"
@interface RCDChatViewController () <UIActionSheetDelegate, RCRealTimeLocationObserver,
                                     RealTimeLocationStatusViewDelegate, UIAlertViewDelegate, RCMessageCellDelegate>
@property(nonatomic, weak) id<RCRealTimeLocationProxy> realTimeLocation;
@property(nonatomic, strong) RealTimeLocationStatusView *realTimeLocationStatusView;

@property(nonatomic, strong) RCUserInfo *cardInfo;

- (UIView *)loadEmoticonView:(NSString *)identify index:(int)index;

@property(nonatomic) BOOL isLoading;
@end

NSMutableDictionary *userInputStatus;

@implementation RCDChatViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *userInputStatusKey =
        [NSString stringWithFormat:@"%lu--%@", (unsigned long)self.conversationType, self.targetId];
    if (userInputStatus && [userInputStatus.allKeys containsObject:userInputStatusKey]) {
        KBottomBarStatus inputType = (KBottomBarStatus)[userInputStatus[userInputStatusKey] integerValue];
        //输入框记忆功能，如果退出时是语音输入，再次进入默认语音输入
        if (inputType == KBottomBarRecordStatus) {
            self.defaultInputType = RCChatSessionInputBarInputVoice;
        } else if (inputType == KBottomBarPluginStatus) {
            //      self.defaultInputType = RCChatSessionInputBarInputExtention;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;//获取当前的视图控制其
    if ([viewControllers indexOfObject:self] == NSNotFound) {
        //当前视图控制器不在栈中，故为pop操作
        [self.realTimeLocation removeRealTimeLocationObserver:self];
        self.realTimeLocation = nil;
    }
    KBottomBarStatus inputType = self.chatSessionInputBarControl.currentBottomBarStatus;
    if (!userInputStatus) {
        userInputStatus = [NSMutableDictionary new];
    }
    NSString *userInputStatusKey =
        [NSString stringWithFormat:@"%lu--%@", (unsigned long)self.conversationType, self.targetId];
    [userInputStatus setObject:[NSString stringWithFormat:@"%ld", (long)inputType] forKey:userInputStatusKey];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableSaveNewPhotoToLocalSystem = YES;
    //self.displayUserNameInCell = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    self.navigationItem.rightBarButtonItem = nil;


    //    self.chatSessionInputBarControl.hidden = YES;
    //    CGRect intputTextRect = self.conversationMessageCollectionView.frame;
    //    intputTextRect.size.height = intputTextRect.size.height+50;
    //    [self.conversationMessageCollectionView setFrame:intputTextRect];
    //    [self scrollToBottomAnimated:YES];
    /***********如何自定义面板功能***********************
//     自定义面板功能首先要继承RCConversationViewController，如现在所在的这个文件。
//     然后在viewDidLoad函数的super函数之后去编辑按钮：
//     插入到指定位置的方法如下：
     [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:imagePic
                                                                    title:title
                                                                  atIndex:0
                                                                      tag:101];
     删除指定位置的方法：
     [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:0];
     删除指定标签的方法：
     [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:101];
     删除所有：
     [self.chatSessionInputBarControl.pluginBoardView removeAllItems];
     更换现有扩展项的图标和标题:
     [self.chatSessionInputBarControl.pluginBoardView updateItemAtIndex:0 image:newImage title:newTitle];
     或者根据tag来更换
     [self.chatSessionInputBarControl.pluginBoardView updateItemWithTag:101 image:newImage title:newTitle];
     以上所有的接口都在RCPluginBoardView.h可以查到。

     当编辑完扩展功能后，下一步就是要实现对扩展功能事件的处理，放开被注掉的函数
     pluginBoardView:clickedItemWithTag:
     在super之后加上自己的处理。

     */

    //默认输入类型为语音
    // self.defaultInputType = RCChatSessionInputBarInputExtention;

    /***********如何在会话页面插入提醒消息***********************

        RCInformationNotificationMessage *warningMsg =
       [RCInformationNotificationMessage
       notificationWithMessage:@"请不要轻易给陌生人汇钱！" extra:nil];
        BOOL saveToDB = NO;  //是否保存到数据库中
        RCMessage *savedMsg ;
        if (saveToDB) {
            savedMsg = [[RCIMClient sharedRCIMClient]
       insertOutgoingMessage:self.conversationType targetId:self.targetId
       sentStatus:SentStatus_SENT content:warningMsg];
        } else {
            savedMsg =[[RCMessage alloc] initWithType:self.conversationType
       targetId:self.targetId direction:MessageDirection_SEND messageId:-1
       content:warningMsg];//注意messageId要设置为－1
        }
        [self appendAndDisplayMessage:savedMsg];
    */
    //    self.enableContinuousReadUnreadVoice = YES;//开启语音连读功能
    if (self.conversationType == ConversationType_PRIVATE || self.conversationType == ConversationType_GROUP) {
    }

    //清除历史消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearHistoryMSG:)
                                                 name:@"ClearHistoryMsg"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateForSharedMessageInsertSuccess:)
                                                 name:@"RCDSharedMessageInsertSuccess"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onEndForwardMessage:)
                                                 name:@"RCDForwardMessageEnd"
                                               object:nil];
    
    _isLoading = NO;
    [self addToolbarItems];
}

/*点击系统键盘的语音按钮，导致输入工具栏被遮挡*/
- (void)keyboardWillShowNotification:(NSNotification *)notification {
    if(!self.chatSessionInputBarControl.inputTextView.isFirstResponder)
    {
        [self.chatSessionInputBarControl.inputTextView becomeFirstResponder];
    }
}

/**
 *  返回的 view 大小必须等于 contentViewSize （宽度 = 屏幕宽度，高度 = 186）
 *
 *  @param identify 表情包标示
 *  @param index    index
 *
 *  @return view
 */
- (UIView *)loadEmoticonView:(NSString *)identify index:(int)index {
    UIView *view11 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 186)];
    view11.backgroundColor = [UIColor blackColor];
    switch (index) {
    case 1:
        view11.backgroundColor = [UIColor yellowColor];
        break;
    case 2:
        view11.backgroundColor = [UIColor redColor];
        break;
    case 3:
        view11.backgroundColor = [UIColor greenColor];
        break;
    case 4:
        view11.backgroundColor = [UIColor grayColor];
        break;

    default:
        break;
    }
    return view11;
}

- (void)updateForSharedMessageInsertSuccess:(NSNotification *)notification {
    RCMessage *message = notification.object;
    if (message.conversationType == self.conversationType && [message.targetId isEqualToString:self.targetId]) {
        [self appendAndDisplayMessage:message];
    }
}

- (void)setRightNavigationItem:(UIImage *)image withFrame:(CGRect)frame {
    RCDUIBarButtonItem *rightBtn = [[RCDUIBarButtonItem alloc] initContainImage:image imageViewFrame:frame buttonTitle:nil
                                                                     titleColor:nil
                                                                     titleFrame:CGRectZero
                                                                    buttonFrame:frame
                                                                         target:self
                                                                         action:@selector(rightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)clearHistoryMSG:(NSNotification *)notification {
    [self.conversationDataRepository removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationMessageCollectionView reloadData];
    });
}

- (void)leftBarButtonItemPressed:(id)sender {
    if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_OUTGOING ||
        [self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_CONNECTED) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"离开聊天，位置共享也会结束，确认离开"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
    } else {
        [self popupChatViewController];
    }
}

- (void)popupChatViewController {
    [super leftBarButtonItemPressed:nil];
    [self.realTimeLocation removeRealTimeLocationObserver:self];
    if (_needPopToRootView == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCMessageModel *)model {
    RCImageSlideController *previewController = [[RCImageSlideController alloc] init];
    previewController.messageModel = model;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:previewController];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    [super didLongTouchMessageCell:model inView:view];
    NSLog(@"%s", __FUNCTION__);
}

- (void)setLeftNavigationItem
{
    RCDUIBarButtonItem *leftButton = [[RCDUIBarButtonItem alloc] initWithLeftBarButton:@"返回" target:self                        action:@selector(leftBarButtonItemPressed:)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

/**
 *  更新左上角未读消息数
 */
- (void)notifyUpdateUnreadMessageCount {
    if (self.allowsMessageCellSelection) {
        [super notifyUpdateUnreadMessageCount];
        return;
    }
    int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
        @(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE),
        @(ConversationType_PUBLICSERVICE), @(ConversationType_GROUP)
    ]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *backString = nil;
        if (count > 0 && count < 1000) {
            backString = [NSString stringWithFormat:@"返回(%d)", count];
        } else if (count >= 1000) {
            backString = @"返回(...)";
        } else {
            backString = @"返回";
        }
        RCDUIBarButtonItem *leftButton = [[RCDUIBarButtonItem alloc] initWithLeftBarButton:backString target:self                        action:@selector(leftBarButtonItemPressed:)];
        [self.navigationItem setLeftBarButtonItem:leftButton];
    });
}

- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage {
    //保存图片
    UIImage *image = newImage;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
}

- (void)setRealTimeLocation:(id<RCRealTimeLocationProxy>)realTimeLocation {
    _realTimeLocation = realTimeLocation;
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    switch (tag) {
    case PLUGIN_BOARD_ITEM_LOCATION_TAG: {
        if (self.realTimeLocation) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"发送位置", @"位置实时共享", nil];
            [actionSheet showInView:self.view];
        } else {
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
        }

    } break;

    default:
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
        break;
    }
}

- (RealTimeLocationStatusView *)realTimeLocationStatusView {
    if (!_realTimeLocationStatusView) {
        _realTimeLocationStatusView =
            [[RealTimeLocationStatusView alloc] initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 0)];
        _realTimeLocationStatusView.delegate = self;
        [self.view addSubview:_realTimeLocationStatusView];
    }
    return _realTimeLocationStatusView;
}
#pragma mark - RealTimeLocationStatusViewDelegate
- (void)onJoin {
    [self showRealTimeLocationViewController];
}
- (RCRealTimeLocationStatus)getStatus {
    return [self.realTimeLocation getStatus];
}

- (void)onShowRealTimeLocationView {
    [self showRealTimeLocationViewController];
}
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent {
    //可以在这里修改将要发送的消息
    if ([messageContent isMemberOfClass:[RCTextMessage class]]) {
        // RCTextMessage *textMsg = (RCTextMessage *)messageContent;
        // textMsg.extra = @"";
    }
    return messageContent;
}

#pragma mark override
- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        [self showRealTimeLocationViewController];
    }

    if ([model.content isKindOfClass:[RCContactCardMessage class]]) {
        RCContactCardMessage *cardMSg = (RCContactCardMessage *)model.content;
        RCUserInfo *user =
            [[RCUserInfo alloc] initWithUserId:cardMSg.userId name:cardMSg.name portrait:cardMSg.portraitUri];
        [self gotoNextPage:user];
    }
}

- (void)gotoNextPage:(RCUserInfo *)user {
    NSArray *friendList = [[RCDataBaseManager shareInstance] getAllFriends];
    BOOL isGotoDetailView = NO;
    for (RCDUserInfo *friend in friendList) {
        if ([user.userId isEqualToString:friend.userId] && [friend.status isEqualToString:@"20"]) {
            isGotoDetailView = YES;
        } else if ([user.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            isGotoDetailView = YES;
        }
    }
}

///**
// *  重写方法实现未注册的消息的显示
// *
// 如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
// *  需要设置RCIM showUnkownMessage属性
// **

#pragma mark override
- (void)resendMessage:(RCMessageContent *)messageContent {
    if ([messageContent isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        [self showRealTimeLocationViewController];
    } else {
        [super resendMessage:messageContent];
    }
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
    case 0: {
        [super pluginBoardView:self.chatSessionInputBarControl.pluginBoardView clickedItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    } break;
    case 1: {
        [self showRealTimeLocationViewController];
    } break;
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    SEL selector = NSSelectorFromString(@"_alertController");

    if ([actionSheet respondsToSelector:selector]) {
        UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
        if ([alertController isKindOfClass:[UIAlertController class]]) {
            alertController.view.tintColor = [UIColor blackColor];
        }
    } else {
        for (UIView *subView in actionSheet.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subView;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - RCRealTimeLocationObserver
- (void)onRealTimeLocationStatusChange:(RCRealTimeLocationStatus)status {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

- (void)onReceiveLocation:(CLLocation *)location type:(RCRealTimeLocationType)type fromUserId:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

- (void)onParticipantsJoin:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你加入了地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource
            getUserInfoWithUserId:userId
                       completion:^(RCUserInfo *userInfo) {
                           if (userInfo.name.length) {
                               [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@加入地理位置共享",
                                                                                            userInfo.name]];
                           } else {
                               [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>加入地理位置共享",
                                                                                            userId]];
                           }
                       }];
    }
}

- (void)onParticipantsQuit:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你退出地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource
            getUserInfoWithUserId:userId
                       completion:^(RCUserInfo *userInfo) {
                           if (userInfo.name.length) {
                               [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@退出地理位置共享",
                                                                                            userInfo.name]];
                           } else {
                               [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>退出地理位置共享",
                                                                                            userId]];
                           }
                       }];
    }
}

- (void)onRealTimeLocationStartFailed:(long)messageId {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < self.conversationDataRepository.count; i++) {
            RCMessageModel *model = [self.conversationDataRepository objectAtIndex:i];
            if (model.messageId == messageId) {
                model.sentStatus = SentStatus_FAILED;
            }
        }
        NSArray *visibleItem = [self.conversationMessageCollectionView indexPathsForVisibleItems];
        for (int i = 0; i < visibleItem.count; i++) {
            NSIndexPath *indexPath = visibleItem[i];
            RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
            if (model.messageId == messageId) {
                [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[ indexPath ]];
            }
        }
    });
}

- (void)notifyParticipantChange:(NSString *)text {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.realTimeLocationStatusView updateText:text];
        [weakSelf performSelector:@selector(updateRealTimeLocationStatus) withObject:nil afterDelay:0.5];
    });
}

- (void)onFailUpdateLocation:(NSString *)description {
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
    case 101: {
        if (buttonIndex == 1) {
            [self.realTimeLocation quitRealTimeLocation];
            [self popupChatViewController];
        }
    } break;

        break;
    default:
        break;
    }
}

- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message {
    return message;
}

/*******************实时地理位置共享***************/
- (void)showRealTimeLocationViewController {
    RealTimeLocationViewController *lsvc = [[RealTimeLocationViewController alloc] init];
    lsvc.realTimeLocationProxy = self.realTimeLocation;
    if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_INCOMING) {
        [self.realTimeLocation joinRealTimeLocation];
    } else if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_IDLE) {
        [self.realTimeLocation startRealTimeLocation];
    }
    [self.navigationController presentViewController:lsvc
                                            animated:YES
                                          completion:^{

                                          }];
   // [self.navigationController pushViewController:lsvc animated:YES];
}
- (void)updateRealTimeLocationStatus {
    if (self.realTimeLocation) {
        [self.realTimeLocationStatusView updateRealTimeLocationStatus];
        __weak typeof(&*self) weakSelf = self;
        NSArray *participants = nil;
        switch ([self.realTimeLocation getStatus]) {
        case RC_REAL_TIME_LOCATION_STATUS_OUTGOING:
            [self.realTimeLocationStatusView updateText:@"你正在共享位置"];
            break;
        case RC_REAL_TIME_LOCATION_STATUS_CONNECTED:
        case RC_REAL_TIME_LOCATION_STATUS_INCOMING:
            participants = [self.realTimeLocation getParticipants];
            if (participants.count == 1) {
                NSString *userId = participants[0];
                [weakSelf.realTimeLocationStatusView
                    updateText:[NSString stringWithFormat:@"user<%@>正在共享位置", userId]];
                [[RCIM sharedRCIM].userInfoDataSource
                    getUserInfoWithUserId:userId
                               completion:^(RCUserInfo *userInfo) {
                                   if (userInfo.name.length) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [weakSelf.realTimeLocationStatusView
                                               updateText:[NSString stringWithFormat:@"%@正在共享位置", userInfo.name]];
                                       });
                                   }
                               }];
            } else {
                if (participants.count < 1)
                    [self.realTimeLocationStatusView removeFromSuperview];
                else
                    [self.realTimeLocationStatusView
                        updateText:[NSString stringWithFormat:@"%d人正在共享地理位置", (int)participants.count]];
            }
            break;
        default:
            break;
        }
    }
}

- (void)didTapReceiptCountView:(RCMessageModel *)model {
    if ([model.content isKindOfClass:[RCTextMessage class]]) {
//        RCDReceiptDetailsTableViewController *vc = [[RCDReceiptDetailsTableViewController alloc] init];
//        RCTextMessage *messageContent = (RCTextMessage *)model.content;
//        NSString *sendTime = [RCKitUtility ConvertMessageTime:model.sentTime / 1000];
//        RCMessage *message = [[RCIMClient sharedRCIMClient] getMessageByUId:model.messageUId];
//        NSMutableDictionary *readReceiptUserList = message.readReceiptInfo.userIdList;
//        NSArray *hasReadUserList = [readReceiptUserList allKeys];
//        if (hasReadUserList.count > 1) {
//            hasReadUserList = [self sortForHasReadList:readReceiptUserList];
//        }
//        vc.targetId = self.targetId;
//        vc.messageContent = messageContent.content;
//        vc.messageSendTime = sendTime;
//        vc.hasReadUserList = hasReadUserList;
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSArray *)sortForHasReadList:(NSDictionary *)readReceiptUserDic {
    NSArray *result;
    NSArray *sortedKeys = [readReceiptUserDic keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    result = [sortedKeys copy];
    return result;
}

- (BOOL)stayAfterJoinChatRoomFailed {
    //加入聊天室失败之后，是否还停留在会话界面
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"stayAfterJoinChatRoomFailed"] isEqualToString:@"YES"];
}

- (void)alertErrorAndLeft:(NSString *)errorInfo {
    if (![self stayAfterJoinChatRoomFailed]) {
        [super alertErrorAndLeft:errorInfo];
    }
}

#pragma Load More Chatroom History Message From Server
//需要开通聊天室消息云端存储功能，调用getRemoteChatroomHistoryMessages接口才可以从服务器获取到聊天室消息的数据
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //当会话类型是聊天室时，下拉加载消息会调用getRemoteChatroomHistoryMessages接口从服务器拉取聊天室消息
    if (self.conversationType == ConversationType_CHATROOM) {
        if (scrollView.contentOffset.y < -15.0f && !_isLoading) {
            _isLoading = YES;
            [self performSelector:@selector(loadMoreChatroomHistoryMessageFromServer) withObject:nil afterDelay:0.4f];
        }
    } else {
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

//从服务器拉取聊天室消息的方法
- (void)loadMoreChatroomHistoryMessageFromServer {
    long long recordTime = 0;
    RCMessageModel *model;
    if (self.conversationDataRepository.count > 0) {
        model = [self.conversationDataRepository objectAtIndex:0];
        recordTime = model.sentTime;
    }
    __weak typeof(self) weakSelf = self;
    [[RCIMClient sharedRCIMClient] getRemoteChatroomHistoryMessages:self.targetId
        recordTime:recordTime
        count:20
        order:RC_Timestamp_Desc
        success:^(NSArray *messages, long long syncTime) {
            _isLoading = NO;
            [weakSelf handleMessages:messages];
        }
        error:^(RCErrorCode status) {
            NSLog(@"load remote history message failed(%zd)", status);
        }];
}

//对于从服务器拉取到的聊天室消息的处理
- (void)handleMessages:(NSArray *)messages {
    NSMutableArray *tempMessags = [[NSMutableArray alloc] initWithCapacity:0];
    for (RCMessage *message in messages) {
        RCMessageModel *model = [RCMessageModel modelWithMessage:message];
        [tempMessags addObject:model];
    }
    //对去拉取到的消息进行逆序排列
    NSArray *reversedArray = [[tempMessags reverseObjectEnumerator] allObjects];
    tempMessags = [reversedArray mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        //将逆序排列的消息加入到数据源
        [tempMessags addObjectsFromArray:self.conversationDataRepository];
        self.conversationDataRepository = tempMessags;
        //显示消息发送时间的方法
        [self figureOutAllConversationDataRepository];
        [self.conversationMessageCollectionView reloadData];
        if (self.conversationDataRepository != nil && self.conversationDataRepository.count > 0 &&
            [self.conversationMessageCollectionView numberOfItemsInSection:0] >= messages.count - 1) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:messages.count - 1 inSection:0];
            [self.conversationMessageCollectionView scrollToItemAtIndexPath:indexPath
                                                           atScrollPosition:UICollectionViewScrollPositionTop
                                                                   animated:NO];
        }
    });
}

//显示消息发送时间的方法
- (void)figureOutAllConversationDataRepository {
    for (int i = 0; i < self.conversationDataRepository.count; i++) {
        RCMessageModel *model = [self.conversationDataRepository objectAtIndex:i];
        if (0 == i) {
            model.isDisplayMessageTime = YES;
        } else if (i > 0) {
            RCMessageModel *pre_model = [self.conversationDataRepository objectAtIndex:i - 1];

            long long previous_time = pre_model.sentTime;

            long long current_time = model.sentTime;

            long long interval =
                current_time - previous_time > 0 ? current_time - previous_time : previous_time - current_time;
            if (interval / 1000 <= 3 * 60) {
                if (model.isDisplayMessageTime && model.cellSize.height > 0) {
                    CGSize size = model.cellSize;
                    size.height = model.cellSize.height - 45;
                    model.cellSize = size;
                }
                model.isDisplayMessageTime = NO;
            } else if (![[[model.content class] getObjectName] isEqualToString:@"RC:OldMsgNtf"]) {
                if (!model.isDisplayMessageTime && model.cellSize.height > 0) {
                    CGSize size = model.cellSize;
                    size.height = model.cellSize.height + 45;
                    model.cellSize = size;
                }
                model.isDisplayMessageTime = YES;
            }
        }
        if ([[[model.content class] getObjectName] isEqualToString:@"RC:OldMsgNtf"]) {
            model.isDisplayMessageTime = NO;
        }
    }
}

/******************消息多选功能:转发、删除**********************/
- (void)addToolbarItems{
    //转发按钮
    UIButton *forwardBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [forwardBtn setImage:[UIImage imageNamed:@"forward_message"] forState:UIControlStateNormal];
    [forwardBtn addTarget:self action:@selector(forwardMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *forwardBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:forwardBtn];
    //删除按钮
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [deleteBtn setImage:[RCKitUtility imageNamed:@"delete_message" ofBundle:@"RongCloud.bundle"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteMessages) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    //按钮间 space
    UIBarButtonItem *spaceItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.messageSelectionToolbar setItems:@[spaceItem,forwardBarButtonItem,spaceItem,deleteBarButtonItem,spaceItem] animated:YES];
}

- (void)forwardMessage{
    if ([[RCDForwardMananer shareInstance] allSelectedMessagesAreLegal]) {
//        [RCDForwardMananer shareInstance].isForward = YES;
//        [RCDForwardMananer shareInstance].selectedMessages = self.selectedMessages;
//        RCDContactViewController *contactViewController = [[RCDContactViewController alloc] init];
//        contactViewController.title = @"选择一个聊天";
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:contactViewController];
//        [self.navigationController presentViewController:navi animated:YES completion:nil];
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"语音、表情、红包、发送失败的消息和其它特殊消息类型不支持转发。"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

- (void)onEndForwardMessage:(NSNotification *)notification{
    //置为 NO,将消息 cell 重置为初始状态
    self.allowsMessageCellSelection = NO;
}

- (void)deleteMessages{
    for (int i = 0; i < self.selectedMessages.count; i++) {
        [self deleteMessage:self.selectedMessages[i]];
    }
    //置为 NO,将消息 cell 重置为初始状态
    self.allowsMessageCellSelection = NO;
}
/******************消息多选功能:转发、删除**********************/
@end