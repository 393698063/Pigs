//
//  DateFomatterTool.m
//  BiaoZhun4
//
//  Created by HEcom on 16/1/9.
//  Copyright (c) 2016年 Hecom. All rights reserved.
//

#import "DateFomatterTool.h"

@implementation DateFomatterTool
+(long long)getCurrentTimeStamp
{
  NSString *format = @"yyyy-MM-dd HH:mm:ss.SSS";
  NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
  [formatter setDateFormat:format];
  NSString *timeNow = [formatter stringFromDate:[NSDate date]];
  return [[self getTimeStampWithDateStr:timeNow dateFormat:format] longLongValue];
}
+(NSString *)getDateStringFromDate:(NSDate *)date dateFormatter:(NSString *)dateformatter
{
  NSDateFormatter * df = [[NSDateFormatter alloc] init];
  [df setDateFormat:dateformatter];
  return [df stringFromDate:date];
}
+(NSDate *)getDatefromDateString:(NSString *)timeStr dateFormatter:(NSString *)dateformatter
{
  NSDateFormatter * df = [[NSDateFormatter alloc] init];
  [df setDateFormat:dateformatter];
  return [df dateFromString:timeStr];
}
+(NSString *)getDateStringFromTimeStamp:(long long)aTimeStamp WithDateFormat:(NSString *)aFormat 
{
  aTimeStamp = aTimeStamp / 1000;
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:aTimeStamp];
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:aFormat];
  NSString *dateStr = [formatter stringFromDate:date];
  return dateStr;
}
+(NSDate *)getDateFromTimeStampWithTimeStamp:(long long)aTimeStamp
{
  aTimeStamp = aTimeStamp / 1000;
  return [NSDate dateWithTimeIntervalSince1970:aTimeStamp]; 
}
+(NSNumber *)getTimeStampWithDateStr:(NSString *)aDateStr dateFormat:(NSString *)aDateFormat
{
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:aDateFormat];
  NSDate *date = [formatter dateFromString:aDateStr];
  long long timeStamp = [date timeIntervalSince1970] * 1000;
  return @(timeStamp);
}
+(NSInteger)getDayIntervalFromDate:(NSDate *)aFromDate toDate:(NSDate *)aToDate
{
  NSCalendar *gregorian = [[NSCalendar alloc]
                           initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:aFromDate toDate:aToDate options:0];
  return dayComponents.day;
}
@end
