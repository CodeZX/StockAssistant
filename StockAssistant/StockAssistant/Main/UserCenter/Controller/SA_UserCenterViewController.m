//
//  SA_UserCenterViewController.m
//  StockAssistant
//
//  Created by 周鑫 on 2018/12/11.
//  Copyright © 2018 TJ. All rights reserved.
//

#import "SA_UserCenterViewController.h"
#import "MineCell.h"
#import "FeedbackVC.h"
#import "JYSettingViewController.h"
#import "JYLoginViewController.h"

#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define SC_WIDTH [UIScreen mainScreen].bounds.size.width
#define SC_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SA_UserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView* _tableView;
    NSArray* titleArr;
    UIButton* avatarBtn;
    CGFloat _totalSize;
}

@property(nonatomic, strong)UIButton* loginBtn;
@end

@implementation SA_UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArr = [NSArray arrayWithObjects:@"清除缓存",@"意见反馈",@"设置", nil];
    
    [self createBtn];
    [self createTableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //131 3347 1758
    NSString* userId = [JFSaveTool objectForKey:@"UserID"];
    if (userId == nil || [userId isEqualToString:@""]) {
        self.loginBtn.selected = NO;
    }else{
        userId = [userId substringFromIndex:3];
        [self.loginBtn setTitle:userId forState:UIControlStateSelected];
        self.loginBtn.selected = YES;
    }
}

- (NSString *)cacheSizeStr {
    NSInteger totalSize = _totalSize;
    NSString *sizeStr = @"";
    if (totalSize > 1000 * 1000) {
        CGFloat sizeF = totalSize / 1000.0 / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fMB)", sizeStr, sizeF];
    } else if (totalSize > 1000) {
        CGFloat sizeF = totalSize / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fKB)", sizeStr, sizeF];
    } else if (totalSize > 0) {
        sizeStr = [NSString stringWithFormat:@"%@(%.ldB)", sizeStr, totalSize];
    }
    return sizeStr;
}


#pragma mark ヾ(=･ω･=)o============== 创建圆形button ==============Σ(((つ•̀ω•́)つ
-(void)createBtn
{
    UIImage *imgFromUrl3;
    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),@"headerImage"];
    imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
    if (imgFromUrl3 == nil) {
        imgFromUrl3 = [UIImage imageNamed:@"icon_hand"];
    }
    
    
    avatarBtn = [[UIButton alloc]init];
    avatarBtn.frame = CGRectMake( SC_WIDTH/2 - SC_WIDTH * 0.618/6, SC_WIDTH * 0.618/3, SC_WIDTH * 0.618/3,SC_WIDTH * 0.618/3);  //把按钮设置成正方形
    avatarBtn.layer.cornerRadius = SC_WIDTH * 0.618/6;  //设置按钮的拐角为宽的一半
    avatarBtn.layer.borderWidth = 3;  // 边框的宽
    avatarBtn.layer.borderColor = [UIColor whiteColor].CGColor;//边框的颜色
    avatarBtn.layer.masksToBounds = YES;// 这个属性很重要，把超出边框的部分去除
    avatarBtn.backgroundColor = [UIColor grayColor];
    [avatarBtn setBackgroundImage:imgFromUrl3 forState:UIControlStateNormal];
    [avatarBtn addTarget:self action:@selector(changePic) forControlEvents:UIControlEventTouchUpInside];
    avatarBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    self.loginBtn.frame = CGRectMake((SC_WIDTH-160)/2, CGRectGetMaxY(avatarBtn.frame)+10, 160, 40);
}

#pragma mark ❀==============❂ 更换头像功能 ❂==============❀
-(void)changePic{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //把newPhono设置成头像
    [avatarBtn setBackgroundImage:newPhoto forState:UIControlStateNormal];
    //关闭当前界面，即回到主界面去
    
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/headerImage.png"];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(newPhoto) writeToFile:imagePath atomically:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ヾ(=･ω･=)o============== 创建tableview ==============Σ(((つ•̀ω•́)つ
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT+20) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //创建头视图
    UIView* HeadView = [[UIView alloc]init];
    _tableView.tableHeaderView = HeadView;
    HeadView.frame = CGRectMake(0, 0, SC_WIDTH, SC_WIDTH * 0.618);
    HeadView.backgroundColor = [UIColor whiteColor];
    UIImageView* background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sunshine.png"]];
    background.frame = CGRectMake(0, 0, SC_WIDTH, SC_WIDTH * 0.618);
    
    background.userInteractionEnabled = YES;
    
    
    [background addSubview:avatarBtn];
    [HeadView addSubview:background];
    [HeadView addSubview:self.loginBtn];
    
    [self.view addSubview:_tableView];
}

//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellStr =[NSString stringWithFormat:@"cellID"];
    MineCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(cell==nil)
    {
        cell = [[MineCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //    if(indexPath.row == 0){
    //        cell.detailTextLabel.text = @"";
    //        cell.imageView.image = [UIImage imageNamed:@"icon_topic"];
    //    }else
    if (indexPath.row == 0) {
        [LLFileTool getFileSize:cachePath completion:^(NSInteger totalSize) {
            self->_totalSize = totalSize;
            cell.detailTextLabel.text = [self cacheSizeStr];
        }];
        cell.imageView.image = [UIImage imageNamed:@"icon_clean"];
    }else if(indexPath.row == 1){
        cell.detailTextLabel.text = @"";
        cell.imageView.image = [UIImage imageNamed:@"icon_feedback"];
    }else{
        cell.detailTextLabel.text = @"";
        cell.imageView.image = [UIImage imageNamed:@"icon_set"];
    }
    cell.textLabel.text = titleArr[indexPath.row];
    
    return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark ヾ(=･ω･=)o============== cell点击事件 ==============Σ(((つ•̀ω•́)つ
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    //    if (indexPath.row == 0) {
    //        if ([[JFSaveTool objectForKey:@"UserID"] isEqualToString:@""] || [JFSaveTool objectForKey:@"UserID"] == NULL) {
    //            JYLoginViewController * vc = [[JYLoginViewController alloc] init];
    //            UINavigationController *askNavi = [[UINavigationController alloc] initWithRootViewController:vc];
    //            [self presentViewController:askNavi animated:YES completion:nil];
    //        }else {
    //            JYAskTableViewController *askVC = [[JYAskTableViewController alloc] init];
    //            askVC.title = @"话题";
    //            UINavigationController *askNavi = [[UINavigationController alloc] initWithRootViewController:askVC];
    //            [self presentViewController:askNavi animated:YES completion:nil];
    //        }
    //
    //    }else
    if (indexPath.row==0) {
        [LLFileTool removeDirectoryPath:cachePath];
        [tableView reloadData];
    }else if (indexPath.row==1) {
        FeedbackVC* feedbackVC  = [FeedbackVC new];
        feedbackVC.hidesBottomBarWhenPushed = YES;
        [self presentViewController:feedbackVC animated:YES completion:nil];
    }else if (indexPath.row == 2){
        JYSettingViewController* vc = [[JYSettingViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)loginAction:(UIButton *)btn
{
    //未登录状态
    if (btn.selected == NO) {
        JYLoginViewController * vc = [[JYLoginViewController alloc] init];
        UINavigationController *askNavi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:askNavi animated:YES completion:nil];
    }
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
