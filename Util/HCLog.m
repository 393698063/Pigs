/*!
 @header HCLog.m
 @abstract 日志工具
 @author Lemon
 @copyright Hecom
 @version 1.00 2015/07/13 Creation
 */

#import "HCLog.h"

@implementation HCLog


#pragma marks swift 打印的方法
-(instancetype)initWithFormat:(NSString*)format with:(va_list)varList
{
  [HCLog file:format varList:varList];
  return nil;
}

+ (void)print:(NSString *)format with:(va_list)varList
{
  [HCLog file:format varList:varList];
}

+ (void)file:(NSString*)format varList:(va_list)ap
{
  NSString *print;
  
//  va_start(ap,format);
  
  print = [[NSString alloc] initWithFormat: format arguments: ap];
  
//  va_end(ap);
  
#ifdef LOGTOFILE
  NSString *outpath = [self getOutPath];
  NSString *printLine = [NSString stringWithFormat:@"\n%@:%@",[self getTheTime],print];
  [self writeData:printLine path:outpath];
#endif
  
#ifdef DEBUG
  NSLog(@"%@", print);
#endif
  
}

#pragma marks OC 打印的方法
+(NSString *)getTheTime
{
    //获取当前时间
    NSTimeZone *zone = [NSTimeZone defaultTimeZone]; 
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];
    NSDate *nowDate=[NSDate dateWithTimeIntervalSinceNow:interval];
    NSString *theTime = [nowDate description];
    return theTime;
}

+(NSString *)getOutPath
{
    NSString *theDate = [[self getTheTime] substringToIndex:19];
    
    //获取document目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logpath = [documentsDirectory stringByAppendingPathComponent:@"Log"];
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath:logpath]) {
        [fileManage createDirectoryAtPath:logpath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //document目录下所有文件
    NSArray *fileList =[fileManage contentsOfDirectoryAtPath:logpath error:nil];
    if ([fileList count] == 0) 
    {
        //当前日期作为文件名
        NSString *outpath = [logpath stringByAppendingPathComponent:theDate];
        return outpath;
    }
    NSString *thepath = [logpath stringByAppendingPathComponent:
                         [fileList objectAtIndex:[fileList count]-1]];
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:thepath];
    unsigned long long length = [file seekToEndOfFile];
    if (length < LOGFILE_LENGTH) 
    {
        return thepath;
    }
    else 
    {
        if ([fileList count] == LOGFILE_COUNT) 
        {
            thepath = [logpath stringByAppendingPathComponent:
                       [fileList objectAtIndex:0]];
            [fileManage removeItemAtPath:thepath error:nil];
        }
        //当前日期作为文件名
        NSString *outpath = [logpath stringByAppendingPathComponent:theDate];
        return outpath;
    }
    
}

+(void)writeData:(NSString *)print path:(NSString *)path
{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath:path]) 
    {
        [fileManage createFileAtPath:path contents:[print dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    else
    {
        NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:path];
        [file seekToEndOfFile];
        [file writeData: [print dataUsingEncoding:NSUTF8StringEncoding]];
        
        [file closeFile];
    }
}

+ (void)file:(NSString*)format,...
{
    va_list ap;
	NSString *print;
    
	va_start(ap,format);
	
	print = [[NSString alloc] initWithFormat: format arguments: ap];
    
	va_end(ap);
    
#ifdef LOGTOFILE
    NSString *outpath = [self getOutPath];
    NSString *printLine = [NSString stringWithFormat:@"\n%@:%@",[self getTheTime],print];
    [self writeData:printLine path:outpath];
#endif
    
#ifdef DEBUG
	NSLog(@"%@", print);
#endif
  
}

+ (void)filenumber:(double)aNumber
{
#ifdef LOGTOFILE
    int numint = aNumber;
    NSString *outpath = [self getOutPath];
    NSString *print;
    if (aNumber - numint > 0) 
    {
        print = [NSString stringWithFormat:@"%d",numint];
    }
    else
    {
        print = [NSString stringWithFormat:@"%g",aNumber];
    }
    NSString *printLine = [NSString stringWithFormat:@"\n%@:%@",[self getTheTime],print];
    [self writeData:printLine path:outpath];    
#elif DEBUG
    int numint = aNumber;
    if (aNumber - numint > 0) 
    {
        NSLog(@"%g", aNumber);
    }
    else
    {
        NSLog(@"%d", numint);
    }
#endif
}

+ (void)file:(char*)aSourceFile function:(const char*)aFunctionName type:(NSString*)aType
{
  
   @synchronized(self)
  {
    NSString *file, *function;
    file = [[NSString alloc] initWithBytes: aSourceFile length: strlen(aSourceFile) encoding: NSUTF8StringEncoding];
    function = [[NSString alloc] initWithCString: aFunctionName encoding:NSUTF8StringEncoding];

    #ifdef LOGTOFILE
  
    NSString *outpath = [self getOutPath];
    NSString *print = [NSString stringWithFormat:@"%@ %@>>%@",
                       [file lastPathComponent], function,aType];
    NSString *printLine = [NSString stringWithFormat:@"\n%@:%@",[self getTheTime],print];
    [self writeData:printLine path:outpath];
  
    #endif
    
    #ifdef DEBUG
  
    NSLog(@"%@: %@>>%@", [file lastPathComponent], function,aType);
	
  #endif
  }
}

@end




