//
//  VideoTableViewCell.h
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/4.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"

@class SA_VideoModel,SA_NewsModel;
@interface Info2TableViewCell : UITableViewCell

@property(nonatomic, strong)InfoModel* infoModel;
@property(nonatomic, assign)UIEdgeInsets edgeInsets;
@property (nonatomic,strong) SA_VideoModel *videoModel;
@property (nonatomic,strong) SA_NewsModel *newsModel;

@property(nonatomic, assign)BOOL isVideo;

@end
