//
//  DateFomatterTool.h
//  BiaoZhun4
//
//  Created by HEcom on 16/1/9.
//  Copyright (c) 2016年 Hecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFomatterTool : NSObject
+(long long)getCurrentTimeStamp;
+(NSString *)getDateStringFromDate:(NSDate *)date dateFormatter:(NSString *)dateformatter;
+(NSDate *)getDatefromDateString:(NSString *)timeStr dateFormatter:(NSString *)dateformatter;
+(NSString *)getDateStringFromTimeStamp:(long long)aTimeStamp WithDateFormat:(NSString *)aFormat;
+(NSNumber *)getTimeStampWithDateStr:(NSString *)aDateStr dateFormat:(NSString *)aDateFormat;
+(NSDate *)getDateFromTimeStampWithTimeStamp:(long long)aTimeStamp;
+(NSInteger)getDayIntervalFromDate:(NSDate *)aFromDate toDate:(NSDate *)aToDate;
@end
