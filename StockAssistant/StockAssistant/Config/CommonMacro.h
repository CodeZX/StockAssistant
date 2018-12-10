//
//  CommonMacro.h
//  StockAssistant
//
//  Created by 周鑫 on 2018/12/10.
//  Copyright © 2018 TJ. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h


// 屏幕宽、高
#define DEVICE_SCREEN_FRAME     ([UIScreen mainScreen].bounds)
#define DEVICE_SCREEN_WIDTH     ([UIScreen mainScreen].bounds.size.width)
#define DEVICE_SCREEN_HEIGHT    ([UIScreen mainScreen].bounds.size.height)

#define is_iPhoneX          ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


// 导航栏宽、高
#define NAVIGATIONBAR_WIDTH     DEVICE_SCREEN_WIDTH
#define NAVIGATIONBAR_HEIGHT  (is_iPhoneX ? 88.f : 64.f)
// 标签栏宽、高
#define TABBAR_WIDTH            DEVICE_SCREEN_WIDTH
#define TABBAR_HEIGHT        (is_iPhoneX ? 83.f : 49.f)
// 状态栏高度
#define STATUSBAR_HEIGHT     (is_iPhoneX ? 44.f : 20.f)

//RGB 颜色
#define KRGBA(r,g,b,a)  [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

#define RGB(r,g,b) KRGBA(r,g,b,1.0f)


#pragma mark - 颜色
#define KBlueColor RGB(0,165,234) //默认蓝色
/** 随机色 */
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]


#define TJString(string)   NSLocalizedString(string,nil)

#pragma mark - 判断是否为空
#define NonEmptyString(a)    (a == nil || [a isKindOfClass:[NSNull class]] || a == NULL) ? @"" :a
// 是否为NSDictionary，并且是否为空
#define NSDictionaryMatchAndCount(ownOBJ)    ([ownOBJ isKindOfClass:[NSDictionary class]] && ((NSDictionary *)ownOBJ).allKeys.count > 0)
// 是否为NSArray，并且是否为空
#define NSArrayMatchAndCount(ownOBJ)    ([ownOBJ isKindOfClass:[NSArray class]] && ((NSArray *)ownOBJ).count > 0)
/// 仅支持value为String类型
#define NSDictionaryContentWithKey(dic, key)  [NSString stringWithFormat:@"%@", NonEmptyString([dic objectForKey:key])]
// 是否为NSArray，并且是否为空
#define NSArrayMatchAndCount(ownOBJ)    ([ownOBJ isKindOfClass:[NSArray class]] && ((NSArray *)ownOBJ).count > 0)

#pragma mark - 获取角度、弧度
// 由角度获取弧度、有弧度获取角度
#define kDegreesToRadian(x)         (M_PI * (x) / 180.0)
#define kRadianToDegrees(radian)    (((radian) * 180.0) / (M_PI))

#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self

#define FONTNAME        @"PingFangSC-Regular"
#define FONTNAMEBLOD    @"PingFangSC-Medium"

#define FONTSIZE_CELL_TITLE      (15)
#define FONTSIZE_CELL_SUBTITLE   (14)

#ifdef DEBUG
#define TJLog(xx, ...)          NSLog((@"%s [Line %d] " xx), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define TJLog(...)
#endif


#pragma mark -------------------------- Device ----------------------------------------

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


#pragma mark -------------------------- Colour ----------------------------------------

/**主题颜色*/
#define MotifColor UIColorFromRGB(0xfdf3d1)

/** 透明度为 1 的 RGB */
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
/** RGBA */
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
/** 使用十六进制的颜色*/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/** 随机色 */
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

/** 常用颜色*/
#define WhiteColor [UIColor whiteColor]
#define BlackColor [UIColor blackColor] //黑色
#define ClearColor [UIColor clearColor] //无色
#define GlobalBg  RGBCOLOR(243,243,243)



//---便捷颜色---color for test---用来 Debug 的颜色
#define PurpleColor    [UIColor purpleColor]   //紫色
#define RedColor       [UIColor redColor]
#define GrayColor      [UIColor grayColor]
#define YellowColor    [UIColor yellowColor]
#define GreenColor     [UIColor greenColor]
#define MagentaColor   [UIColor magentaColor] //品红,洋红 /mə'dʒentə/
#define BlueColor      [UIColor blueColor]
#define BrownColor     [UIColor brownColor]
#define AppColor       [UIColor colorWithRed:(113)/255.0f green:(205)/255.0f blue:(207)/255.0f alpha:1]

#ifdef DEBUG
// 测试环境
#define NETWORK_ENVIRONMENT    0
#else
// 上线环境
#define NETWORK_ENVIRONMENT    1
#endif




#ifdef __cplusplus
#define TJKIT_EXTERN        extern "C" __attribute__((visibility ("default")))
#else
#define TJKIT_EXTERN            extern __attribute__((visibility ("default")))
#endif




#endif /* CommonMacro_h */
