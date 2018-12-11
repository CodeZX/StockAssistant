//
//  ChildVCTwo.m
//  SGPageViewExample
//
//  Created by apple on 17/4/18.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "PictViewController.h"
#import "PuBuLiuLayout.h"
#import "PictureModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+XLExtension.h"
#import "XLPhotoBrowser.h"
#import "UIButton+XLExtension.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#define DMRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define DMRGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define DMRandColor DMRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
#define DMPadding   5

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusHeight                   [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight                   44
#define kStatusAndNavBarHeight          (kStatusHeight+kNavBarHeight)
#define kExtendedHeightAtIphoneXBottom  (kStatusHeight>20?34:0)

@interface PictViewController () <PuBuLiuLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>

@property(nonatomic, strong)UIImageView* navImageView;
@property(nonatomic, strong)UIButton* backBtn;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray* pictureArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property(nonatomic, strong) PictureModel* selectedPictureModel;

@property(nonatomic, strong)NSTimer* timer;

@end

@implementation PictViewController

- (void)endRefreshingOfData
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (self.collectionView.mj_footer.isRefreshing) {
        [self.collectionView.mj_footer endRefreshing];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DidUpdatePicturesNotification" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.view addSubview:self.navImageView];
    [self createCollectionView];
    [self requestPictures];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navImageView.frame = CGRectMake(0, kStatusHeight, kScreenWidth, kNavBarHeight);
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.navImageView.frame), kScreenWidth, kScreenHeight-kStatusAndNavBarHeight);
  
    [self.collectionView reloadData];
}

- (void)requestPictures
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml", @"image/*"]];
    
    NSString* postString = @"http://47.93.28.161:8080/news/photograph/get";
    NSDictionary* para = [NSDictionary dictionaryWithObjectsAndKeys:@(20), @"pageSize", @(self.pageNum), @"pageNum", nil];;
    
    [manager GET:postString parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSArray* result = dic[@"result"];
        
        for (NSDictionary* ddd in result) {
            NSLog(@"%@", ddd);
            PictureModel* model = [[PictureModel alloc] init];
            model.ID = [ddd[@"id"] integerValue];
            model.content = ddd[@"content"];
            model.pics = ddd[@"pics"];
            model.title = ddd[@"title"];
            [self.pictureArray addObject:model];
        }
        
        [self.collectionView reloadData];
        if (self.collectionView.mj_footer.isRefreshing) {
            [self.collectionView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"+++++%@",error);
        }
        
        if (self.collectionView.mj_footer.isRefreshing) {
            [self.collectionView.mj_footer endRefreshing];
        }
    }];
}

- (void)backAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pictureArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //cell.backgroundColor = DMRandColor;
    
    NSArray* views = cell.contentView.subviews;
    for (UIView* view in views) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
        
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    
    PictureModel* model = self.pictureArray[indexPath.row];
    NSString* picPath = [[model.pics firstObject] valueForKey:@"picPath"];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.tag = indexPath.row;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:picPath]];
    [cell.contentView addSubview:imageView];
    
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, cell.contentView.bounds.size.height-35, 30, 30)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    label.text = [NSString stringWithFormat:@"%ld", model.pics.count];
    label.layer.cornerRadius = 15;
    label.layer.masksToBounds = YES;
    [cell.contentView addSubview:label];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    self.currentIndexPath = indexPath;
}

#pragma mark - layout的代理事件

- (CGFloat)puBuLiuLayoutHeightForItemAtIndex:(NSIndexPath *)index {
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat cellW = (screenW-DMPadding*3)/2;
    CGFloat cellH = cellW*(404.0/720);
    return cellH;
}

- (void)dosomethingWhenFooterRefresh
{
    self.pageNum++;
    [self requestPictures];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(endRefreshingOfData) userInfo:nil repeats:NO];
}

- (void)createCollectionView
{
    PuBuLiuLayout *layout = [[PuBuLiuLayout alloc] init];
    layout.columnNumber = 2;
    layout.delegate = self;
    layout.padding = DMPadding;
    layout.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView = collectionView;
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dosomethingWhenFooterRefresh)];
}

/**
 *  浏览图片
 *
 */
- (void)clickImage:(UITapGestureRecognizer *)tap
{
    self.selectedPictureModel = self.pictureArray[tap.view.tag];
    
    
    // 快速创建并进入浏览模式
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:0 imageCount:_selectedPictureModel.pics.count datasource:self];
    
    // 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
    [browser setActionSheetWithTitle:nil delegate:self cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:@"保存",nil];
    
    // 自定义一些属性
    browser.pageDotColor = [UIColor purpleColor]; ///< 此属性针对动画样式的pagecontrol无效
    browser.currentPageDotColor = [UIColor greenColor];
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleNone;///< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
    
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, browser.bounds.size.height-60, browser.bounds.size.width,60)];
    titleLabel.text = self.selectedPictureModel.title;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor whiteColor];
    [browser addSubview:titleLabel];
}

#pragma mark    -   XLPhotoBrowserDatasource

/**
 *  返回这个位置的占位图片 , 也可以是原图(如果不实现此方法,会默认使用placeholderImage)
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 占位图片
 */
//- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
//{
//    return self.images[index];
//}

/**
 *  返回指定位置图片的UIImageView,用于做图片浏览器弹出放大和消失回缩动画等
 *  如果没有实现这个方法,没有回缩动画,如果传过来的view不正确,可能会影响回缩动画效果
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 展示图片的容器视图,如UIImageView等
 */
//- (UIView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index
//{
//    return self.scrollView.subviews[index];
//}

/**
 *  返回指定位置的高清图片URL
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 返回高清大图索引
 */
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString* picPath = [self.selectedPictureModel.pics[index] valueForKey:@"picPath"];
    
    return [NSURL URLWithString:picPath];
}

#pragma mark    -   XLPhotoBrowserDelegate
- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex
{
    // do something yourself
    switch (actionSheetindex) {
        case 1: // 收藏
        {
            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
            NSArray* pictures = nil;
            
            
            //PictureModel* model = pictures[currentImageIndex];
        }
            break;
        case 0: // 保存
        {
            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
            [browser saveCurrentShowImage];
        }
            break;
        default:
        {
            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
        }
            break;
    }
}

- (NSMutableArray *)pictureArray
{
    if (!_pictureArray) {
        _pictureArray = [[NSMutableArray alloc] init];
    }
    return _pictureArray;
}

- (UIImageView *)navImageView
{
    if (!_navImageView) {
        _navImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_photo"]];
        _navImageView.contentMode = UIViewContentModeScaleAspectFill;
        _navImageView.userInteractionEnabled = YES;
        
        self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_backBtn setImage:[UIImage imageNamed:@"icon_return-1"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [_navImageView addSubview:_backBtn];
    }
    return _navImageView;
}


@end
