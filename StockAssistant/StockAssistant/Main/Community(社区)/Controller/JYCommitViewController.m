//
//  JYCommitViewController.m
//  246News
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 Edgar_Guan. All rights reserved.
//  提交

#import "JYCommitViewController.h"
#import "OSSImageUploader.h"
#import "RCDCommonDefine.h"

#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "TZLocationManager.h"
//#import "Const.h"
#import "Masonry.h"
#import "YYKit.h"
#import "UIView+HUD.h"
#import "NetManager.h"
#import "JFSaveTool.h"

#import "JYUserAgreementView.h"

#define kStatusHeight                   [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavBarHeight                   44
#define kStatusAndNavBarHeight          (kStatusHeight+kNavBarHeight)
#define kExtendedHeightAtIphoneXBottom  (kStatusHeight>20?34:0)

static NSString *kTempFolder = @"temp";

@interface JYCommitViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>
{
    NSString *imagePath;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    UIControl * _control;
}

@property(nonatomic, strong)UIImageView* navImageView1;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (strong, nonatomic) UILabel *placeHolder;
@property (strong, nonatomic) UIButton *commitButton;
@property (strong, nonatomic) UITextView *feedBackTextView;
@property (strong, nonatomic) UITextField * titleTextField;
@property (nonatomic, strong) UIView* cutline;
@property (strong, nonatomic) NSMutableArray * imagesArray;

@property (strong, nonatomic) UIButton * imgButton;

@property (strong, nonatomic) NSString * picString;

@property (strong, nonatomic) UIView * picView;

@end

@implementation JYCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.picString = @"";
    _selectedPhotos = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.navImageView1];
    self.navImageView1.frame = CGRectMake(0, kStatusHeight, kScreenWidth, kNavBarHeight);
    [self ds_setCommitView];
    
    UITapGestureRecognizer* ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    [self.view addGestureRecognizer:ges];
    
    
    
    if ([DEFAULTS objectForKey:@"ISFirst"] == nil) {
        
        JYUserAgreementView * agreeview = [JYUserAgreementView userAgreementView];
        agreeview.frame = CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT);
        
        [self.view addSubview:agreeview];
    }
    

}

- (void)gestureRecognizer:(UITapGestureRecognizer *)tap
{
    if (self.titleTextField.isFirstResponder || self.feedBackTextView.isFirstResponder) {
        [self.titleTextField resignFirstResponder];
        [self.feedBackTextView resignFirstResponder];
    }
}

- (void)ds_setCommitView {
    
    
    if (![self.title isEqualToString:@"评论"]) {
        
        self.navImageView1.image = [UIImage imageNamed:@"发表话题.png"];
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusAndNavBarHeight, DEVICE_SCREEN_WIDTH, 204)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        self.titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, DEVICE_SCREEN_WIDTH-30, 44)];
        self.titleTextField.placeholder = @"添加您的标题";
        //self.titleTextField.backgroundColor = RGB(237, 237, 237);
        self.titleTextField.font = [UIFont systemFontOfSize:18];
        [bgView addSubview:self.titleTextField];
        
        self.cutline.frame = CGRectMake(15, CGRectGetMaxY(self.titleTextField.frame)-0.4, DEVICE_SCREEN_WIDTH-30, 0.4);
        [bgView addSubview:self.cutline];
        
        //textView
        _feedBackTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 60, DEVICE_SCREEN_WIDTH-30, 160)];
        _feedBackTextView.delegate = self;
        _feedBackTextView.editable = YES;
        //_feedBackTextView.backgroundColor = RGB(237, 237, 237);
        _feedBackTextView.font = [UIFont systemFontOfSize:16 ];
        [bgView addSubview:_feedBackTextView];
        
        [self.view addSubview:bgView];
        
        //placeHolder
        UILabel * placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _feedBackTextView.bounds.size.width, 25)];
        placeHolder.text = @"请输入您的内容";
        placeHolder.font = [UIFont systemFontOfSize:16];
        placeHolder.textColor = [UIColor lightGrayColor];
        [_feedBackTextView addSubview:placeHolder];
        self.placeHolder = placeHolder;
        self.placeHolder.userInteractionEnabled = NO;
        
        [self.view addSubview:self.imgButton];
        self.imgButton.frame = CGRectMake(20, CGRectGetMaxY(bgView.frame)+10, 80, 80);
//        [self.imgButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(80, 80));
//            make.top.equalTo(self.feedBackTextView.mas_bottom).offset(20);
//            make.left.equalTo(self.view).offset(20);
//        }];

    }else {
        
        self.navImageView1.image = [UIImage imageNamed:@"评论.png"];
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusAndNavBarHeight, DEVICE_SCREEN_WIDTH, 160)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        //textView
        _feedBackTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, DEVICE_SCREEN_WIDTH-30, 160)];
        _feedBackTextView.delegate = self;
        _feedBackTextView.editable = YES;
        //_feedBackTextView.backgroundColor = RGB(237, 237, 237);
        _feedBackTextView.font = [UIFont systemFontOfSize:16];
        [bgView addSubview:_feedBackTextView];
        
        [self.view addSubview:bgView];
        
        //placeHolder
        UILabel * placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _feedBackTextView.bounds.size.width, 25)];
        placeHolder.text = @"请输入您的内容";
        placeHolder.font = [UIFont systemFontOfSize:16];
        placeHolder.textColor = [UIColor lightGrayColor];
        [_feedBackTextView addSubview:placeHolder];
        self.placeHolder = placeHolder;
        self.placeHolder.userInteractionEnabled = NO;
    }
    
    //commitButton
    UIButton * commitButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [commitButton setTitle:@"发表" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.backgroundColor = KMainColor;
    self.commitButton.userInteractionEnabled = NO;

    [commitButton addTarget:self action:@selector(commitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.commitButton = commitButton;
    self.commitButton.clipsToBounds = YES;
    self.commitButton.layer.cornerRadius = 10;
    
    [self.view addSubview:commitButton];
    
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(DEVICE_SCREEN_WIDTH - 60, 44));
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(30);
    }];
    
}

- (void)didIconImage{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [self pushTZImagePickerController];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

//打开相册
- (void)pushTZImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.width - 2 * left;
    NSInteger top = (self.view.height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    
    imagePickerVc.isStatusBarDefault = NO;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    [self uploadImages:_selectedPhotos];
    [self setupPhotos];
    [self.view showMessage:@""];
}

#pragma mark - UIImagePickerController
//调用相机
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
    }
}


-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];

    [self uploadImages:_selectedPhotos];
    [self setupPhotos];
}



#pragma mark - 添加图片
- (void)setupPhotos {
    
    UIImageView* lastImageView = nil;
    for (NSInteger i = 0; i < _selectedPhotos.count; i++) {
        CGFloat width = 80;
        CGFloat height = 80;
        CGFloat spaceHor = 20;
        CGFloat spaceVer = 10;
        CGFloat x = spaceHor + (i % 3) * (width + spaceHor);
        CGFloat y = CGRectGetMaxY(self.feedBackTextView.superview.frame) + (i / 3) * (height + spaceVer) + 20;
        
        UIImageView * photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        photoImage.tag = i + 1000;
        photoImage.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        photoImage.contentMode = UIViewContentModeScaleAspectFit;
        photoImage.backgroundColor = [UIColor lightGrayColor];
        photoImage.layer.borderWidth = 0.5;
        photoImage.layer.cornerRadius = 4;
        photoImage.layer.masksToBounds = YES;
        photoImage.userInteractionEnabled = YES;
        photoImage.image = _selectedPhotos[i];
        [self.view addSubview:photoImage];
        
        lastImageView = photoImage;

        
        UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"photo_delete.png"] forState:UIControlStateNormal];
        deleteBtn.frame = CGRectMake(photoImage.frame.size.width - 25, 0, 25, 25);
        deleteBtn.tag = i + 500;
        [deleteBtn addTarget:self action:@selector(didClickdeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.alpha = 0.6;
        [photoImage addSubview:deleteBtn];
        //添加点击图片的手势
        UITapGestureRecognizer * taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapsPressGestures:)];
        [photoImage addGestureRecognizer:taps];
    }
    
    self.imgButton.frame = CGRectMake(self.imgButton.origin.x, CGRectGetMaxY(lastImageView.frame)+10, self.imgButton.bounds.size.width, self.imgButton.bounds.size.height);
}

- (void)didClickdeleteBtn:(UIButton *)btn {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"是否删除图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [_selectedPhotos removeObjectAtIndex:btn.tag - 500];
        [_selectedAssets removeObjectAtIndex:btn.tag - 500];
        
        for(id tmpView in [self.view subviews])
        {
            //找到要删除的子视图的对象
            if([tmpView isKindOfClass:[UIImageView class]])
            {
                UIImageView *imgView = (UIImageView *)tmpView;
                if(imgView.tag == btn.tag + 500) //判断是否满足自己要删除的子视图的条件
                {
                    [imgView removeFromSuperview];
                    break; //跳出for循环,因为子视图已经找到,无须往下遍历
                }
            }
        }
        [self setupPhotos];
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tapsPressGestures:(UITapGestureRecognizer *)tap {
   
    
}


//正在改变
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placeHolder.hidden = YES;
        //允许提交按钮点击操作
        self.commitButton.backgroundColor = KMainColor;
        self.commitButton.userInteractionEnabled = YES;
    }else {
        self.placeHolder.hidden = NO;
        //不许提交按钮点击操作
        self.commitButton.backgroundColor = [UIColor lightGrayColor];
        self.commitButton.userInteractionEnabled = NO;
    }
}

//提交
- (void)commitButtonAction{
    
    if ([self.title isEqualToString:@"评论"]) {
        [self ds_commentsNetWorking];
    }else {
        [self ds_netWorkingWithPic:self.picString];
    }
}

#pragma mark - 网络请求
//发帖子
- (void)ds_netWorkingWithPic:(NSString *)pic {
    [NetManager POSTUploadUserId:[JFSaveTool objectForKey:@"UserID"] title:self.titleTextField.text text:self.feedBackTextView.text pic:pic completionHandler:^(JYRegisterItem *allCommunity, NSError *error) {
        [self.view showMessage:allCommunity.msg];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//评论
- (void)ds_commentsNetWorking {
    
    [NetManager POSTAddCommentCardID:self.card_id userId:[JFSaveTool objectForKey:@"UserID"] text:self.feedBackTextView.text completionHandler:^(JYRegisterItem *allCommunity, NSError *error) {
        
        [self.view showMessage:allCommunity.msg];
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

//上传图片到OSS
- (void)uploadImages:(NSArray<UIImage *> *)images {
    [OSSImageUploader asyncUploadImages:images complete:^(NSArray<NSString *> *names, UploadImageState state) {
        NSMutableArray * imagesArr = [NSMutableArray array];
        for (NSInteger i = 0; i < names.count; i++) {
            NSString * newName = [NSString stringWithFormat:@"http://51gongjiang.oss-cn-shanghai.aliyuncs.com/%@",names[i]];
            [imagesArr addObject:newName];
        }
        NSString *string = [imagesArr componentsJoinedByString:@","];
        self.picString = string;
    }];
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
//        if (iOS9Later) {
//            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
//            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
//        }
        tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
        BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (UIButton *)imgButton {
    if (!_imgButton) {
        _imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imgButton setImage:[UIImage imageNamed:@"icon_frame60"] forState:UIControlStateNormal];
        [_imgButton addTarget:self action:@selector(didIconImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgButton;
}

- (UIImageView *)navImageView1
{
    if (!_navImageView1) {
        _navImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"话题.png"]];
        _navImageView1.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _navImageView1;
}

- (UIView *)cutline
{
    if (!_cutline) {
        _cutline = [[UIView alloc] init];
        _cutline.backgroundColor = [UIColor lightGrayColor];
    }
    return _cutline;
}

@end
