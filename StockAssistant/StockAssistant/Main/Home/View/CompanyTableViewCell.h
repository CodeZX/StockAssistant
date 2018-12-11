//
//  VideoTableViewCell.h
//  天空资讯
//
//  Created by 周峻觉 on 2018/5/4.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyTableViewCell : UITableViewCell

@property(nonatomic, strong)NSString* name;
@property(nonatomic, strong)NSString* picture;
@property(nonatomic, assign)UIEdgeInsets edgeInsets;

@end
