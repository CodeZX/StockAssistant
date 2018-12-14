//
//  SK_MainTabBarController.m
//  StockAssistant
//
//  Created by 周鑫 on 2018/12/11.
//  Copyright © 2018 TJ. All rights reserved.
//

#import "SA_MainTabBarController.h"

#import "SA_MainNavigationController.h"
#import "SA_HomeViewController.h"
#import "SA_UserCenterViewController.h"
#import "Video3ViewController.h"
#import "SA_ChatRoomViewController.h"
//#import "RCDSquareTableViewController.h"

@interface SA_MainTabBarController ()

@end

@implementation SA_MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addAllChildVC];
    
    [self.tabBar setTintColor:[UIColor orangeColor]];
    
}

- (void)addAllChildVC {
    
    SA_HomeViewController* homeVC = [[SA_HomeViewController alloc] init];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"icon_home_nor"] selectedImage:[UIImage imageNamed:@"icon_home_pre"]];
    SA_MainNavigationController * homeNC = [[SA_MainNavigationController alloc] initWithRootViewController:homeVC];
//
    Video3ViewController* videoVC = [[Video3ViewController alloc] init];
    videoVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"视频" image:[UIImage imageNamed:@"icon_video_nor"] selectedImage:[UIImage imageNamed:@"icon_video_pre"]];
//
    SA_ChatRoomViewController *squareVC = [[SA_ChatRoomViewController alloc] init];
    squareVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"聊天室" image:[UIImage imageNamed:@"icon_community_nor"] selectedImage:[UIImage imageNamed:@"icon_community_pre"]];
    SA_MainNavigationController* squareNC = [[SA_MainNavigationController alloc] initWithRootViewController:squareVC];
//
//    //    VideoViewController* videoVC = [[VideoViewController alloc] init];
//    //    videoVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"视频" image:[UIImage imageNamed:@"icon_video_nor"] selectedImage:[UIImage imageNamed:@"icon_video_pre"]];
//
//    //    Info2ViewController* infoVC = [[Info2ViewController alloc] init];
//    //    infoVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"资讯" image:[UIImage imageNamed:@"icon_news_nor"] selectedImage:[UIImage imageNamed:@"icon_news_pre"]];
//
//    DefaultScrollVC* scrollVC = [[DefaultScrollVC alloc] init];
//    scrollVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"资讯" image:[UIImage imageNamed:@"icon_news_nor"] selectedImage:[UIImage imageNamed:@"icon_news_pre"]];
//
//    CompanyViewController* companyVC = [[CompanyViewController alloc] init];
//    companyVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"公司" image:[UIImage imageNamed:@"icon_company_nor"] selectedImage:[UIImage imageNamed:@"icon_company_pre"]];
//
    SA_UserCenterViewController* mineVC = [[SA_UserCenterViewController alloc] init];
    mineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"用户中心" image:[UIImage imageNamed:@"icon_my_nor"] selectedImage:[UIImage imageNamed:@"icon_my_pre"]];
//
//
    [self addChildViewController:homeNC];
    [self addChildViewController:videoVC];
    [self addChildViewController:squareNC];
//    //[tabBarVC addChildViewController:scrollVC];
//    //[tabBarVC addChildViewController:companyVC];
    [self addChildViewController:mineVC];
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
