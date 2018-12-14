//
//  Colors.m
//  天空资讯
//
//  Created by 周峻觉 on 2018/6/5.
//  Copyright © 2018年 周峻觉. All rights reserved.
//

#import "Colors.h"

@interface Colors()

@property(nonatomic, strong)NSArray* colorArray;

@end

@implementation Colors

+ (instancetype)share
{
    static Colors* colors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colors = [[Colors alloc] init];
    });
    return colors;
}

- (UIColor *)any
{
    NSInteger count = self.colorArray.count;
    return self.colorArray[rand()%count];
}

- (NSArray *)colorArray
{
    if (!_colorArray) {
        _colorArray = @[[Colors colorWithHexString:@"#FFEFDB"],
                        [Colors colorWithHexString:@"#ffffcc"],
                        [Colors colorWithHexString:@"#ffcc99"],
                        [Colors colorWithHexString:@"#ff9999"],
                        [Colors colorWithHexString:@"#ff6699"],
                        [Colors colorWithHexString:@"#ccffcc"],
                        [Colors colorWithHexString:@"#cccc99"],
                        [Colors colorWithHexString:@"#cc66cc"],
                        [Colors colorWithHexString:@"#99cccc"],
                        [Colors colorWithHexString:@"#9999cc"],
                        [Colors colorWithHexString:@"#66cccc"],
                        [Colors colorWithHexString:@"#6699cc"],
                        [Colors colorWithHexString:@"#33cc99"],
                        [Colors colorWithHexString:@"#3399cc"],
                        [Colors colorWithHexString:@"#336699"],
                        [Colors colorWithHexString:@"#FFEBCD"],
                        [Colors colorWithHexString:@"#FF7F00"],
                        [Colors colorWithHexString:@"#EECFA1"],
                        [Colors colorWithHexString:@"#CDCD00"],
                        [Colors colorWithHexString:@"#BCEE68"],
                        [Colors colorWithHexString:@"#00FF7F"],
                        [Colors colorWithHexString:@"#218868"]];
    }
    return _colorArray;
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
