//
//  SA_ChatRoomViewController.m
//  StockAssistant
//
//  Created by 周鑫 on 2018/12/13.
//  Copyright © 2018 TJ. All rights reserved.
//

#import "SA_ChatRoomViewController.h"
#import "ConversationViewController.h"

#import "MessageTableViewCell.h"

#import <JMessage/JMessage.h>


// 屏幕宽、高
#define DEVICE_SCREEN_FRAME     ([UIScreen mainScreen].bounds)
#define DEVICE_SCREEN_WIDTH     ([UIScreen mainScreen].bounds.size.width)
#define DEVICE_SCREEN_HEIGHT    ([UIScreen mainScreen].bounds.size.height)

static NSString * const kCellIdentifier = @"MessageCell.identifier";


@interface SA_ChatRoomViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation SA_ChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天室";
    self.view.backgroundColor = [UIColor whiteColor];
   
    __weak typeof(self) weakSelf = self;
    if ([[JFSaveTool objectForKey:@"UserID"] isEqualToString:@""] || [JFSaveTool objectForKey:@"UserID"] == NULL) {
      
        UILabel *label = [[UILabel alloc]init];
        label.text = @"未登录！请前往个人中心登录！";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.view);
        }];
        
    }else{
//        self.tableView.hidden = NO;
//        self.clickLoginButton.hidden = YES;
        
        [self getAllConversationList];
        [self.view addSubview:self.tableView];
    }
    
    
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    JMSGConversation *conversation = self.dataArray[indexPath.row];
    cell.conversation = conversation;
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self gotoConversationInfoPageWithConversation:self.dataArray[indexPath.row]];
}


- (void)gotoConversationInfoPageWithConversation:(JMSGConversation *)conversation {
    if (conversation == nil) {
        [JMSGChatRoom enterChatRoomWithRoomId:[conversation valueForKey:@"id"] completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                ConversationViewController *conversationVC = [[ConversationViewController alloc] init];
                conversationVC.conversation = conversation;
//                ConversationViewController.hidesBottomBarWhenPushed = YES
//                [self.navigationController pushViewController:conversationVC animated:YES];
                [self presentViewController:conversationVC animated:YES completion:nil];
            }else{
                NSLog(@"加入失败");
            }
        }];
    } else {
        ConversationViewController *conversationVC = [[ConversationViewController alloc] init];
        conversationVC.conversation = conversation;
        conversationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

//创建聊天室
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [JMSGConversation createChatRoomConversationWithRoomId:@"12926079" completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            NSArray *conversationList = (NSArray *)resultObject;
            self.dataArray = [NSMutableArray arrayWithArray:conversationList];
        } else {
            
        }
    }];
    
}

#pragma mark - NetWork
- (void)getAllConversationList
{
    [JMSGChatRoom getChatRoomListWithAppKey:nil start:0 count:20 completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            NSArray *conversationList = (NSArray *)resultObject;
            self.dataArray = [NSMutableArray arrayWithArray:conversationList];
            [self.tableView reloadData];
        } else {
            
        }
    }];
}

#pragma mark - Lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.sectionFooterHeight = 1;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



@end
