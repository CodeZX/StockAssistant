//
//  NSString+Verify.h
//  WriteMe
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 LuckySoldier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Verify)
+ (BOOL)NSStringIsValidPhone:(NSString *)phoneString;
- (BOOL)NSStringIsValidPhone:(NSString *)phoneString;


//身份证号码判断
+ (NSString *)ittemDisposeIdcardNumber:(NSString *)idcardNumber;
- (NSString *)ittemDisposeIdcardNumber:(NSString *)idcardNumber;

// 新的正则表达式。包含170号段
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
- (BOOL)isMobileNumber:(NSString *)mobileNum;


+ (BOOL)isPureNumandCharacters:(NSString *)string;

+ (BOOL)isPureNumAndChar:(NSString *)string;

+ (BOOL)checkIsHaveNumAndLetter:(NSString*)numCharStr;

@end
