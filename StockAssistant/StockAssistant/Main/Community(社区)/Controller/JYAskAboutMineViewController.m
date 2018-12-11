//
//  JYAskAboutMineViewController.m
//  246News
//
//  Created by apple on 2018/2/3.
//  Copyright © 2018年 Edgar_Guan. All rights reserved.
//

#import "JYAskAboutMineViewController.h"
#import "JYASKTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
//#import "Const.h"

static NSString * const kCellIdentifier = @"ASKCell.identifier";
static NSString * pageNum = @"20";


#define PIC_WIDTH 70
#define PIC_HEIGHT 80
#define COL_COUNT 3
@interface JYAskAboutMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArrays;  ///< 数据源数组
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isNeededRequest;

@end

@implementation JYAskAboutMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self ds_setupTableView];
    [self.tableView.mj_header beginRefreshing];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JYASKTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [cell.iconImage sd_setImageWithURL:[self.dataArrays[indexPath.row] valueForKey:@"pic_url"]];
    cell.nameLabel.text = [self.dataArrays[indexPath.row] valueForKey:@"creator_id"];
    cell.timeLabel.text = [self.dataArrays[indexPath.row] valueForKey:@"create_time"];
    cell.titleLabel.text = [self.dataArrays[indexPath.row] valueForKey:@"eval_comments"];
    
    
    cell.replyButton.hidden = YES;
    
    [cell.likeButton setTitle:[NSString stringWithFormat:@"  %@",[self.dataArrays[indexPath.row] valueForKey:@"praise_num"]] forState:UIControlStateNormal];

    
    NSString * eval_url = [self.dataArrays[indexPath.row] valueForKey:@"eval_url"];
    NSLog(@"%@",eval_url);
    if (eval_url.length > 0) {
        NSArray * imgArray = [eval_url componentsSeparatedByString:@","];
        cell.fileView.hidden = NO;
        cell.imageHight.constant = (10 + PIC_HEIGHT) * ((imgArray.count - 1) / COL_COUNT + 1) + 10;
        [self ds_setfileImage:imgArray andView:cell.fileView];
    }else {
        cell.imageHight.constant = 1;
        cell.fileView.hidden = YES;
    }

    return cell;
}


- (void)ds_setfileImage:(NSArray *)fileArray andView:(UIView *)fileView {
    //    NSLog(@"%@",fileArray);
    for (NSInteger i = 0; i < fileArray.count; i++) {
        //所在行
        NSInteger row = i / COL_COUNT;
        //所在列
        NSInteger col = i % COL_COUNT;
        //间距
        CGFloat margin = (fileView.bounds.size.width - (PIC_WIDTH * COL_COUNT)) / (COL_COUNT + 1);
        CGFloat picX = margin + (PIC_WIDTH + margin) * col;
        CGFloat picY = 10 + (PIC_HEIGHT + 10) * row;
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.layer.borderWidth = 2.0f;
        imageView.layer.borderColor = RGB(230, 230, 230).CGColor;
        [imageView sd_setImageWithURL:[NSURL URLWithString:fileArray[i]]];
        [fileView addSubview:imageView];
        
        imageView.frame = CGRectMake(picX, picY, PIC_WIDTH, PIC_HEIGHT);
        
    }
}

#pragma mark - private method
- (void)ds_setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.estimatedRowHeight = 180;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    [self.tableView registerNib:[JYASKTableViewCell nib] forCellReuseIdentifier:kCellIdentifier];
    __weak JYAskAboutMineViewController * weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isRefreshing = YES;
        
        [weakSelf orderNetWorking];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isRefreshing = NO;
        if (_isNeededRequest) {
            [weakSelf orderNetWorking];
        }else{
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
    }];
    [self.view addSubview:self.tableView];
    
}



#pragma mark - 网络请求
- (void)orderNetWorking {

    
    
}


- (NSMutableArray *)dataArrays {
    if (!_dataArrays) {
        _dataArrays = [NSMutableArray array];
    }
    return _dataArrays;
}

@end
