//
//  NetManager.m
//  246News
//
//  Created by dong on 2018/2/7.
//  Copyright © 2018年 JY. All rights reserved.
//

#import "NetManager.h"
#import "NSObject+Parse.h"

@implementation NetManager

//注册
+ (id)POSTRegisterPhone:(NSString *)phone pwd:(NSString *)pwd completionHandler:(void(^)(JYRegisterItem *essences, NSError *error))completionHandler {
    NSString *path = @"http://host-119-148-162-231.iphost.gotonets.com:8080/tj_diary/user/register";
    
    NSDictionary * param = @{@"phone_num":phone,@"pwd":pwd};
    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYRegisterItem Parse:obj], error);
    }];
}

//登录
+ (id)POSTloginPhone:(NSString *)phone pwd:(NSString *)pwd completionHandler:(void(^)(JYLoginItem *essences, NSError *error))completionHandler {
    NSString *path = @"http://host-119-148-162-231.iphost.gotonets.com:8080/tj_diary/user/login";

    NSDictionary * param = @{@"phone_num":phone,@"pwd":pwd};
    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYLoginItem Parse:obj], error);
    }];
}
//
//
//+ (id)GETEssenceItem:(NSString *)lastKey completionHandler:(void (^)(JYEssenceItem *, NSError *))completionHandler
//{
//    NSString *path = [NSString stringWithFormat:@"http://app3.qdaily.com/app3/homes/index/%@.json?",lastKey];
//    return [self GET:path param:nil completionHandler:^(id obj, NSError *error) {
//        !completionHandler ?: completionHandler([JYEssenceItem Parse:obj], error);
//    }];
//}
//
//
//+ (id)GetListItemCompletionHandler:(void (^)(NSArray<JYListItem *> *, NSError *))completionHandler
//{
//    NSString *path = @"http://baobab.kaiyanapp.com/api/v3/categories.Bak";
//    return [self GET:path param:nil completionHandler:^(id obj, NSError *error) {
//        !completionHandler ?: completionHandler([JYListItem Parse:obj], error);
//    }];
//}
//
//
//+ (id)GETDetailListItem:(NSString *)detailName completionHandler:(void (^)(JYDetailListItem *, NSError *))completionHandler
//{
//    NSString *cateName = [detailName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *path = [NSString stringWithFormat:@"http://baobab.kaiyanapp.com/api/v1/videos.bak?categoryName=%@&num=10", cateName];
//    return [self GET:path param:nil completionHandler:^(id obj, NSError *error) {
//        !completionHandler ?: completionHandler([JYDetailListItem Parse:obj], error);
//    }];
//}
//
//
//+ (id)GETDetailListOtherPage:(NSString *)path conpletionHandler:(void (^)(JYDetailListItem *, NSError *))completionHandler
//{
//    return [self GET:path param:nil completionHandler:^(id obj, NSError *error) {
//        !completionHandler ?: completionHandler([JYDetailListItem Parse:obj], error);
//    }];
//}
//
//
//+ (id)GETHomeItemCompletionHandler:(void (^)(JYHomeItem *, NSError *))completionHandler
//{
//    NSString *path = @"http://www.moviebase.cn/uread/app/recommend/recommend?platform=1&deviceId=F9864FEA-7A4E-4DAA-AE8E-3ED48E542577&appVersion=1.10.0&versionCode=1104&sysver=ios10.2&channelId=0&resolutionWidth=640&resolutionHeight=1136&deviceModel=iPhone5s";
//    return [self GET:path param:nil completionHandler:^(id obj, NSError *error) {
//        !completionHandler ?: completionHandler([JYHomeItem Parse:obj], error);
//    }];
//}
//
//
//+ (id)GETAgoEssenceCompletionHandler:(void (^)(JYAgoEssenceItem *, NSError *))completionHandler
//{
//    NSString *path = @"http://www.moviebase.cn/uread/app/recommend/lastDays?platform=1&deviceId=F9864FEA-7A4E-4DAA-AE8E-3ED48E542577&appVersion=1.10.0&versionCode=1104&sysver=ios10.2&channelId=0&resolutionWidth=640&resolutionHeight=1136&deviceModel=iPhone5s";
//    return [self GET:path param:nil completionHandler:^(id obj, NSError *error) {
//        !completionHandler ?: completionHandler([JYAgoEssenceItem Parse:obj], error);
//    }];
//}
//
//
//+ (id)GETCategoryItemCompletionHandler:(void (^)(JYCategoryItem *, NSError *))complteionHandler
//{
//    NSString *path = @"http://www.moviebase.cn/uread/app/category/categoryList?platform=1&deviceId=F9864FEA-7A4E-4DAA-AE8E-3ED48E542577&appVersion=1.10.0&versionCode=1104&sysver=ios10.2&channelId=0&resolutionWidth=640&resolutionHeight=1136&deviceModel=iPhone5s";
//    return [self GET:path param:nil completionHandler:^(id obj, NSError *error) {
//        !complteionHandler ?: complteionHandler([JYCategoryItem Parse:obj], error);
//    }];
//}
//
//
//+ (id)GETAllCategory:(NSInteger)page completionHandler:(void (^)(JYAllCategoryItem *, NSError *))completionHandler
//{
//    NSString *path = [NSString stringWithFormat:@"http://www.moviebase.cn/uread/app/topic/topicList?pageContext=%ld&platform=1&deviceId=F9864FEA-7A4E-4DAA-AE8E-3ED48E542577&appVersion=1.10.0&versionCode=1104&sysver=ios10.2&channelId=0&resolutionWidth=640&resolutionHeight=1136&deviceModel=iPhone5s", page];
//    return [self GET:path param:nil completionHandler:^(id obj, NSError *error) {
//        !completionHandler ?: completionHandler([JYAllCategoryItem Parse:obj], error);
//    }];
//}
//
//
//+ (id)GETAllDetailCategory:(NSInteger)page ID:(NSString *)ID completionHandler:(void (^)(JYAllDetailCategoryItem *, NSError *))completionHandler
//{
//    NSString *path = [NSString stringWithFormat:@"http://www.moviebase.cn/uread/app/topic/topicDetail/articleList?topicId=%@&pageContext=%ld&platform=1&deviceId=F9864FEA-7A4E-4DAA-AE8E-3ED48E542577&appVersion=1.10.0&versionCode=1104&sysver=ios10.2&channelId=0&resolutionWidth=640&resolutionHeight=1136&deviceModel=iPhone5s", ID, page];
//    return [self GET:path param:nil completionHandler:^(id obj, NSError *error) {
//        !completionHandler ?: completionHandler([JYAllDetailCategoryItem Parse:obj], error);
//    }];
//}

//社区所有帖子
+ (id)GETAllCommunityID:(NSString *)ID completionHandler:(void(^)(JYCommunity *allCommunity, NSError *error))completionHandler {
    
    NSString *path = @"http://host-119-148-162-231.iphost.gotonets.com:8080/tj_diary/card/show";
    
    NSDictionary * param = @{@"user_id":ID};

    return [self GET:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYCommunity Parse:obj], error);
    }];
}

//举报帖子
+ (id)POSTReportCardId:(NSString *)cardId userID:(NSString *)userId completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler {
    NSString *path = @"http://host-119-148-162-231.iphost.gotonets.com:8080/tj_diary/card/report";
    NSDictionary * param = @{@"user_id":userId,@"card_id":cardId};
    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYRegisterItem Parse:obj], error);
    }];
}

//删除帖子
+ (id)POSTDeleteCardId:(NSString *)cardId completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler {
    NSString *path = @"http://host-119-148-162-231.iphost.gotonets.com:8080/tj_diary/card/delete";
    NSDictionary * param = @{@"card_id":cardId};
    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYRegisterItem Parse:obj], error);
    }];
}

//帖子点赞
+ (id)POSTJoinLikeCardId:(NSString *)cardId userId:(NSString *)userId completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler {
    NSString *path = @"http://host-119-148-162-231.iphost.gotonets.com:8080/tj_diary/card/join_like";
    NSDictionary * param = @{@"card_id":cardId,@"user_id":userId};
    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYRegisterItem Parse:obj], error);
    }];
}

//帖子取消点赞
+ (id)POSTDeleteLikeCardId:(NSString *)cardId userId:(NSString *)userId completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler {
    NSString *path = @"http://host-119-148-162-231.iphost.gotonets.com:8080/tj_diary/card/card/delete_like";
    NSDictionary * param = @{@"card_id":cardId,@"user_id":userId};
    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYRegisterItem Parse:obj], error);
    }];
}

//发帖
+ (id)POSTUploadUserId:(NSString *)userId title:(NSString *)title text:(NSString *)text pic:(NSString *)pic completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler {
    NSString *path = @"http://host-119-148-162-231.iphost.gotonets.com:8080/tj_diary/card/upload";
    NSDictionary * param = @{@"user_id":userId,@"title":title,@"text":text,@"pic":pic};
    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYRegisterItem Parse:obj], error);
    }];
}

//发评论
+ (id)POSTAddCommentCardID:(NSString *)cardID userId:(NSString *)userId text:(NSString *)text completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler {
    NSString *path = @"http://host-119-148-162-231.iphost.gotonets.com:8080/tj_diary/comments/add";
    NSDictionary * param = @{@"card_id":cardID,@"user_id":userId,@"text":text};
    NSLog(@"%@",param);
    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYRegisterItem Parse:obj], error);
    }];
}


//展示单个帖子的所有评论
+ (id)POSTShowCommentCardId:(NSString *)cardID completionHandler:(void(^)(JYCommentItem *allCommunity, NSError *error))completionHandler {
    NSString *path = @"http://host-219-235-5-8.iphost.gotonets.com:8080/tj_news/comments/show";
    NSDictionary * param = @{@"card_id":cardID};
    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYCommentItem Parse:obj], error);
    }];
}

//举报评论
+ (id)POSTReportCommentId:(NSString *)commentId userId:(NSString *)userId cardID:(NSString *)cardID completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler {
    NSString *path = @"http://host-119-148-162-231.iphost.gotonets.com:8080/tj_diary/comments/report";
    NSDictionary * param = @{@"comment_id":commentId,@"user_id":userId,@"card_id":cardID};
    NSLog(@"%@",param);
    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYRegisterItem Parse:obj], error);
    }];
}


//个人中心
//+ (id)POSTPersonalID:(NSString *)userID completionHandler:(void(^)(JYMineItem *essences, NSError *error))completionHandler {
//    NSString *path = @"http://host-219-235-5-8.iphost.gotonets.com:8080/tj_news/user/personal";
//    
//    NSDictionary * param = @{@"user_id":userID};
//    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
//        !completionHandler ?: completionHandler([JYMineItem Parse:obj], error);
//    }];
//}

//我的话题
+ (id)POSTMyCardUserId:(NSString *)userId completionHandler:(void(^)(JYCommunity *allCommunity, NSError *error))completionHandler {
    NSString *path = @"http://host-119-148-162-231.iphost.gotonets.com:8080/tj_diary/user/my_card";
    
    NSDictionary * param = @{@"user_id":userId};
    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYCommunity Parse:obj], error);
    }];
}

//修改用户资料
+ (id)POSTModifyUserId:(NSString *)userId name:(NSString *)name pic:(NSString *)pic completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler {
    NSString *path = @"http://host-119-148-162-231.iphost.gotonets.com:8080/tj_diary/user/modify";
    NSDictionary * param = @{@"user_id":userId,@"name":name,@"profile_pic":pic};
    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYRegisterItem Parse:obj], error);
    }];
}

//反馈
+ (id)POSTFeedBackUserId:(NSString *)userId comments:(NSString *)comments completionHandler:(void(^)(JYRegisterItem *allCommunity, NSError *error))completionHandler {
    NSString *path = @"http://host-119-148-162-231.iphost.gotonets.com:8080/tj_diary/start_page/feedback";
    NSDictionary * param = @{@"user_id":userId,@"context":comments};
    return [self POST:path param:param completionHandler:^(id obj, NSError *error) {
        !completionHandler ?: completionHandler([JYRegisterItem Parse:obj], error);
    }];
}

@end
