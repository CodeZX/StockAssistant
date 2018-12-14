//
//  NetManager.h
//  246News
//
//  Created by dong on 2018/2/7.
//  Copyright © 2018年 JY. All rights reserved.
//

#import "BaseNetManager.h"
#import "JYCommunity.h"
#import "JYCommentItem.h"
#import "JYRegisterItem.h"
#import "JYLoginItem.h"

@interface NetManager : BaseNetManager

////注册
+ (id)POSTRegisterPhone:(NSString *)phone pwd:(NSString *)pwd code:(NSString *)code completionHandler:(void(^)(JYRegisterItem *essences, NSError *error))completionHandler;
//
////登录
+ (id)POSTloginPhone:(NSString *)phone pwd:(NSString *)pwd completionHandler:(void(^)(JYLoginItem *essences, NSError *error))completionHandler;

// 获取验证码
+ (id)POSTPhoneCode:(NSString *)phone  code:(NSString *)code completionHandler:(void(^)(JYRegisterItem *essences, NSError *error))completionHandler;
//
////精华页
//+ (id)GETEssenceItem:(NSString *)lastKey completionHandler:(void(^)(JYEssenceItem *essences, NSError *error))completionHandler;
//
////栏目列表
//+ (id)GetListItemCompletionHandler:(void(^)(NSArray<JYListItem *> *lists, NSError *error))completionHandler;
//
////栏目详细列表
//+ (id)GETDetailListItem:(NSString *)detailName completionHandler:(void(^)(JYDetailListItem *detailItem, NSError *error))completionHandler;
//
////栏目详细刷新页
//+ (id)GETDetailListOtherPage:(NSString *)path conpletionHandler:(void(^)(JYDetailListItem *detailItem, NSError *error))completionHandler;
//
////往
//+ (id)GETHomeItemCompletionHandler:(void(^)(JYHomeItem *homeItem, NSError *error))completionHandler;
//
////往 往期精选
//+ (id)GETAgoEssenceCompletionHandler:(void(^)(JYAgoEssenceItem *agoItem, NSError *error))completionHandler;
//
////夜
//+ (id)GETCategoryItemCompletionHandler:(void(^)(JYCategoryItem *cateItem, NSError *error))complteionHandler;
//
////夜 全部分类
//+ (id)GETAllCategory:(NSInteger)page completionHandler:(void(^)(JYAllCategoryItem *allCategoryItem, NSError *error))completionHandler;

//夜 全部分类 全部分类
//+ (id)GETAllDetailCategory:(NSInteger)page ID:(NSString *)ID completionHandler:(void(^)(JYAllDetailCategoryItem *allDetailCategoryItem, NSError *error))completionHandler;

//社区所有帖子
+ (id)GETAllCommunityID:(NSString *)ID completionHandler:(void(^)(JYCommunity *allCommunity, NSError *error))completionHandler;

//举报帖子
+ (id)POSTReportCardId:(NSString *)cardId userID:(NSString *)userId completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler;

//删除帖子
+ (id)POSTDeleteCardId:(NSString *)cardId completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler;

//帖子点赞
+ (id)POSTJoinLikeCardId:(NSString *)cardId userId:(NSString *)userId completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler;

//帖子取消点赞
+ (id)POSTDeleteLikeCardId:(NSString *)cardId userId:(NSString *)userId completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler;

//发帖
+ (id)POSTUploadUserId:(NSString *)userId title:(NSString *)title text:(NSString *)text pic:(NSString *)pic completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler;

//发评论
+ (id)POSTAddCommentCardID:(NSString *)cardID userId:(NSString *)userId text:(NSString *)text completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler;

//展示单个帖子的所有评论
+ (id)POSTShowCommentCardId:(NSString *)cardID completionHandler:(void(^)(JYCommentItem *allCommunity, NSError *error))completionHandler;

//举报评论
+ (id)POSTReportCommentId:(NSString *)commentId userId:(NSString *)userId cardID:(NSString *)cardID completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler;

//个人中心
//+ (id)POSTPersonalID:(NSString *)userID completionHandler:(void(^)(JYMineItem *essences, NSError *error))completionHandler;

//我的话题
+ (id)POSTMyCardUserId:(NSString *)userId completionHandler:(void(^)(JYCommunity *allCommunity, NSError *error))completionHandler;

//修改用户资料
+ (id)POSTModifyUserId:(NSString *)userId name:(NSString *)name pic:(NSString *)pic completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler;

//反馈
+ (id)POSTFeedBackUserId:(NSString *)userId comments:(NSString *)comments completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler;

@end
