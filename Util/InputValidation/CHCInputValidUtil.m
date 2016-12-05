//
//  CHCInputValidationUtil.m
//  ChannelVisit
//
//  Created by 陈荣杭 on 13-8-30.
//  Copyright (c) 2013年 yonyou. All rights reserved.
//

#import "CHCInputValidUtil.h"

@implementation CHCInputValidUtil

+(BOOL)valiadateWithRegx:(NSString *)aInputStr regex:(NSString *)aRegx
{
  NSPredicate *predict = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", aRegx];
  return [predict evaluateWithObject:aInputStr];
}
#pragma mark 整数校验
+(BOOL)checkInteger:(NSString *)aInputStr
{
  NSString *aRegx = @"^(-|\\+)?\\d+$";
  return [self valiadateWithRegx:aInputStr regex:aRegx];
}

#pragma mark 字符串校验
+ (BOOL)checkNormalString:(NSString *)aInputStr
{
  NSString *aRegx = @"[0-9a-zA-Z\u4E00-\u9FA5]*$";
  return [self valiadateWithRegx:aInputStr regex:aRegx];
}
#pragma mark 字符串包含空格校验
+ (BOOL)checkNormalStringWithSpace:(NSString *)aInputStr
{
  NSString *aRegx = @"[ 0-9a-zA-Z\u4E00-\u9FA5]*$";
  return [self valiadateWithRegx:aInputStr regex:aRegx];
}
#pragma mark 数值校验
+(BOOL)checkNumericalvalue:(NSString *)aInputStr
{
  NSString *aRegx = @"^-?([0-9]\\d*\\.\\d*|0\\.\\d*[0-9]\\d*|0?\\.0+|0)$";
  return [self valiadateWithRegx:aInputStr regex:aRegx];
}
#pragma mark 校验年
+(BOOL)checkYear:(NSString *)aInputStr
{
  NSString *aRegx = @"^\\d{4}$";
  return [self valiadateWithRegx:aInputStr regex:aRegx];
}


+(BOOL)checkMobileNumber:(NSString *)aInputStr
{
  NSString *aRegx = @"^\\d{11}$";
  return [self valiadateWithRegx:aInputStr regex:aRegx];
}

#pragma mark - 手机号验证
+ (BOOL)validateMobile:(NSString *)mobileNum
{
  /**
   * 手机号码
   * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
   * 联通：130,131,132,152,155,156,185,186
   * 电信：133,1349,153,180,189
   */
  NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
  /**
   10         * 中国移动：China Mobile
   11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
   12         */
  NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
  /**
   15         * 中国联通：China Unicom
   16         * 130,131,132,152,155,156,185,186
   17         */
  NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
  /**
   20         * 中国电信：China Telecom
   21         * 133,1349,153,180,189
   22         */
  NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
  /**
   25         * 大陆地区固话及小灵通
   26         * 区号：010,020,021,022,023,024,025,027,028,029
   27         * 号码：七位或八位
   28         */
  // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
  
  NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
  NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
  NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
  NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
  
  if (([regextestmobile evaluateWithObject:mobileNum] == YES)
      || ([regextestcm evaluateWithObject:mobileNum] == YES)
      || ([regextestct evaluateWithObject:mobileNum] == YES)
      || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
    return YES;
    }
  else
    {
    return NO;
    }
}


#pragma mark 校验月
+(BOOL)checkMonth:(NSString *)aInputStr
{
  NSString *aRegx = @"^(([0]{0,1}[1-9]{1})|([1]{1}[0-2]{1}))$";
  return [self valiadateWithRegx:aInputStr regex:aRegx];
}

#pragma mark 校验年月
+(BOOL)checkYearAndMonth:(NSString *)aInputStr
{
  NSString *aRegx = @"^(\\d{1,4})(-|\\/)(([0]{0,1}[1-9]{1})|([1]{1}[0-2]{1}))$";
  return [self valiadateWithRegx:aInputStr regex:aRegx];
}


#pragma mark 校验Email
+(BOOL)checkEmail:(NSString *)aInputStr
{
  NSString *aRegx = @"^([a-zA-Z0-9]+[_|\\_|\\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\\_|\\.]?)*[a-zA-Z0-9]+\\.[a-zA-Z]{2,4}$";
  //NSString *aRegx = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
  return [self valiadateWithRegx:aInputStr regex:aRegx];
}
#pragma mark 电话号码
+(BOOL)checkPhoneNum:(NSString *)aInputStr
{
  NSString *aRegx = @"^([0\\+]\\d{2,3}-)?(\\d{11})$|^([0\\+]\\d{2,3}-)?(0\\d{2,3}-)?(\\d{7,8})(-(\\d{1,4}))?$";
  return [self valiadateWithRegx:aInputStr regex:aRegx];
}

+(BOOL)checkCellPhoneNum:(NSString *)aInputStr
{
  NSString *aRegx = @"^\\+?(86)?(1)\\d{10}$";
  return [self valiadateWithRegx:aInputStr regex:aRegx];
}

#pragma mark 检查长度
+(BOOL)checkLength:(NSString *)aInputStr length:(NSInteger)length
{
  NSString *aRegx = [NSString stringWithFormat:@".{0,%ld}",(long)length];
  return [self valiadateWithRegx:aInputStr regex:aRegx];
}

#pragma mark 判断输入是否为字母、数字、汉字
+(BOOL)checkLetterCharacterNumber:(NSString *)aInputStr
{
    NSString *aRegx = @"^[A-Za-z0-9\u4E00-\u9FA5]+$";
    return [self valiadateWithRegx:aInputStr regex:aRegx];
}

#pragma mark 判断输入是否为汉字
+(BOOL)checkLetterCharacter:(NSString *)aInputStr
{
  NSString *aRegx = @"^[\u4E00-\u9FA5]+$";
  return [self valiadateWithRegx:aInputStr regex:aRegx];
}

@end
