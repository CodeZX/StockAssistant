//
//  UIScrollView+Refresh.m
//  246News
//
//  Created by dong on 2018/2/7.
//  Copyright © 2018年 JY. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "MJRefresh.h"

@implementation UIScrollView (Refresh)
- (void)dong_addHeaderRefresh:(void(^)())block{
    //    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    self.mj_header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    //自动更改透明度, 初始值为alpha 0
    header.automaticallyChangeAlpha = YES;
}
- (void)dong_endHeaderRefresh{
    [self.mj_header endRefreshing];
}
- (void)dong_beginHeaderRefresh{
    [self.mj_header beginRefreshing];
}

- (void)dong_addFooterRefresh:(void(^)())block{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
}
- (void)dong_endFooterRefresh{
    [self.mj_footer endRefreshing];
}
- (void)dong_endFooterWithNoMore{
    [self.mj_footer endRefreshingWithNoMoreData];
}
- (void)dong_resetFooter{
    [self.mj_footer resetNoMoreData];
}
@end
