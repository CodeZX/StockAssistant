//
//  RCDSquareTableViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/4/1.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDSquareTableViewController.h"
#import "DefaultPortraitView.h"
#import "RCDBaseSettingTableViewCell.h"
#import "RCDChatViewController.h"
#import "RCDCommonDefine.h"
#import "RCDHttpTool.h"
#import "RCDSquareCell.h"
#import "RCDataBaseManager.h"
#import "UIColor+RCColor.h"
#import "AFNetworking.h"
#import "ChatRoom.h"
#import "RCDSquareTableViewCell.h"
#import "JFSaveTool.h"

@interface RCDSquareTableViewController ()

@property(nonatomic, strong)NSString* roomNameWillCreate;

@property(nonatomic, strong)NSMutableArray* roomIds;
@property(nonatomic, strong)NSMutableArray* roomNames;
@property(nonatomic, strong)NSMutableArray* chatrooms;

@end

@implementation RCDSquareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"聊天室";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createChatroomAction)];
    
    [self requestChatRooms];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)createChatroomAction
{
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction* createAction = [UIAlertAction actionWithTitle:@"创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        [self requestCreatChatRoom];
    }];
    
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"创建聊天室" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入聊天室的名称";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    [ac addAction:cancelAction];
    [ac addAction:createAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)noti
{
    UITextField* textfield = (UITextField *)noti.object;
    self.roomNameWillCreate = textfield.text;
}

- (void)requestCreatChatRoom
{
    NSDictionary *dic = @{@"name":self.roomNameWillCreate};
    NSString* getApi = @"http://47.93.28.161:8080/news/chatroom/create";
    
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
            ChatRoom* room = [[ChatRoom alloc] init];
            room.rID = dic[@"data"];
            room.name = self.roomNameWillCreate;
            [self.chatrooms insertObject:room atIndex:0];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)requestChatRooms
{
    NSDictionary *dic = @{@"count":@(100)};
    NSString* getApi = @"http://47.93.28.161:8080/news/chatroom/getAll";
    
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
            NSArray* roomdics = dic[@"result"];
            for (NSDictionary* rdic in roomdics) {
                ChatRoom* room = [[ChatRoom alloc] init];
                room.rID = rdic[@"roomId"];
                room.name = rdic[@"name"];
                [self.chatrooms addObject:room];
                [self requestChatroomDetailWithId:room.rID];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)requestChatroomDetailWithId:(NSString *)roomId
{
    NSDictionary *dic = @{@"count":@(100),@"roomId":roomId};
    NSString* getApi = @"http://47.93.28.161:8080/news/chatroom/user/getAll";
    
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
            for (ChatRoom* room in self.chatrooms) {
                if ([roomId isEqualToString:room.rID]) {
                    NSArray* array = dic[@"result"];
                    room.count = array.count;
                    break ;
                }
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.chatrooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    static NSString *reusableCellWithIdentifier = @"RCDSquareCell";
//    RCDSquareCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
//
//    ChatRoom* room = self.chatrooms[indexPath.row];
//    if (cell == nil) {
//        cell = [[RCDSquareCell alloc] initWithIconName:[NSString stringWithFormat:@"icon_%ld", indexPath.row]
//                                             TitleName:room.name];
//    }
//    return cell;
    
    static NSString *reusableCellWithIdentifier = @"RCDSquareTableViewCell";
    RCDSquareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    if (cell == nil) {
        cell = [[RCDSquareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ChatRoom* room = self.chatrooms[indexPath.row];
    cell.title = room.name;
    cell.count = room.count;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[JFSaveTool objectForKey:@"UserID"] isEqualToString:@""] || [JFSaveTool objectForKey:@"UserID"] == NULL) {
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"暂未登录" message:@"请先登录！" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
    }else{
        ChatRoom* room = self.chatrooms[indexPath.row];
        NSString *chatroomId = room.rID;
        RCDChatViewController *chatVC =
        [[RCDChatViewController alloc] initWithConversationType:ConversationType_CHATROOM targetId:chatroomId];
        chatVC.title = room.name;
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - 懒加载
- (NSMutableArray *)roomIds
{
    if (!_roomIds) {
        _roomIds = [[NSMutableArray alloc] init];
    }
    return _roomIds;
}

- (NSMutableArray *)roomNames
{
    if (!_roomNames) {
        _roomNames = [[NSMutableArray alloc] init];
    }
    return _roomNames;
}

- (NSMutableArray *)chatrooms
{
    if (!_chatrooms) {
        _chatrooms = [[NSMutableArray alloc] init];
    }
    return _chatrooms;
}

@end
