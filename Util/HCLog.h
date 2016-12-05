/*!
 @header HCLog.h
 @abstract 日志工具
 @author Lemon
 @copyright Hecom
 @version 1.00 2015/07/13 Creation
 */

#import <Foundation/Foundation.h>
//用于输出LOG到文件的开关,最大文件为4MB
//#define LOGTOFILE 应用程序需要定义它
#define LOGFILE_LENGTH 10485760
#define LOGFILE_COUNT 4

#define HCLog(s,...) [HCLog file:(s),##__VA_ARGS__]
#define HCLognumber(s) [HCLog filenumber:(s)]
#define FUNCBEGIN [HCLog file:__FILE__ function: (char *)__FUNCTION__ type:@"begin"]
#define FUNCEND [HCLog file:__FILE__ function: (const char *)__FUNCTION__ type:@"end"] 
/*!
 @class
 @abstract 输出日志：带参数，带数值参数和不带参数
 */
@interface HCLog : NSObject

#pragma marks swift 打印的方法
/*!
 @method
 @abstract 打印的方法for swift
 @discussion (@"%@",@"abc")
 @param format,varList
 @result void
 */
+ (void)print:(NSString *)format with:(va_list)varList;
/*!
 @method
 @abstract 打印的方法for swift
 @discussion (@"%@",@"abc")
 @param format,varList
 @result nil
 */
-(instancetype)initWithFormat:(NSString*)format with:(va_list)varList;


#pragma marks for OC
/*!
 @method
 @abstract 带参数
 @discussion (@"%@",@"abc")
 @param format,...
 @result void
 */
+ (void)file:(NSString*)format,...;
/*!
 @method
 @abstract 带数值参数
 @discussion 123 or 321.11
 @param number 数值
 @result void
 */
+ (void)filenumber:(double)aNumber;
/*!
 @method
 @abstract 不带参数
 @discussion funclog
 @param sourceFile 文件名
 @param functionName 方法名
 @param type begin or end
 @result void
 */
+ (void)file:(char*)aSourceFile function:(const char*)aFunctionName type:(NSString*)aType;

@end
