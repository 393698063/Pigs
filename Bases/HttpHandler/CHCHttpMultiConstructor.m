//
//  CHCHttpMultipartVO.m
//  FoodYou
//
//  Created by Lemon-HEcom on 15/9/24.
//  Copyright (c) 2015年 AZLP. All rights reserved.
//

#import "CHCHttpMultiConstructor.h"

static NSString *HC_HTTP_Wrap_RN = @"\r\n";
static NSString *HC_HTTP_DoubleHyphens = @"--";
static NSString *HC_HTTP_Boundary = @"--SDFOIJFJDIJAIVNUENVIAQQDFXVEJOIJIVHF--";

#pragma mark - CHCHttpMultiConstructor
@implementation CHCHttpMultiConstructor
@synthesize iParts;

- (instancetype)init
{
  self = [super init];
  if (self)
  {
    self.iParts = [NSMutableArray arrayWithCapacity:1];
  }
  return self;
}

- (void)addParts:(CHCHttpMultiPartVO *)aVO
{
  [self.iParts addObject:aVO];
}


- (NSMutableData *)doOutput
{
  NSMutableData *rtnData = [[NSMutableData alloc]init];
  
  for (CHCHttpMultiPartVO *part in self.iParts)
  {
    [self outPutPart:rtnData multiParty:part];
  }
  
  NSString *endStr = [NSString stringWithFormat:@"%@%@%@%@",HC_HTTP_DoubleHyphens,HC_HTTP_Boundary,HC_HTTP_DoubleHyphens,HC_HTTP_Wrap_RN];
  NSData *endData = [self dataFromStr:endStr];
  [rtnData appendData:endData];
  
  return rtnData;
}


- (void)outPutPart:(NSMutableData *)aOS multiParty:(CHCHttpMultiPartVO *)part
{
  
  NSString *separate = [NSString stringWithFormat:@"%@%@%@",HC_HTTP_DoubleHyphens,HC_HTTP_Boundary,HC_HTTP_Wrap_RN];
  NSData *separateData = [self dataFromStr:separate];
  [aOS appendData:separateData];
  
  NSString *header = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"",part.iKey];
  NSData *headerData = [self dataFromStr:header];
  [aOS appendData:headerData];
  
  NSString *otherDis = [part otherDisposition];
  NSString *otherDisStr = [NSString stringWithFormat:@"%@%@%@",otherDis?@";":@"",otherDis?:@"",HC_HTTP_Wrap_RN];
  NSData *otherDisData = [self dataFromStr:otherDisStr];
  [aOS appendData:otherDisData];
  
  if (part.iContentType && ![@"" isEqualToString:part.iContentType])
  {
    NSString *contentType = [NSString stringWithFormat:@"Content-Type:%@%@",part.iContentType,HC_HTTP_Wrap_RN];
    NSData *contentTypeData = [self dataFromStr:contentType];
    [aOS appendData:contentTypeData];
  }
  
  NSData *endData = [self dataFromStr:HC_HTTP_Wrap_RN];
  [aOS appendData:endData];
  
  [part doOutputContent:aOS];
  
  [aOS appendData:endData];
  
}

- (NSString *)contentType
{
  NSString *rtnValue = [NSString stringWithFormat:@"multipart/form-data;boundary=%@",HC_HTTP_Boundary];
  return rtnValue;
}

- (Byte *)byteFromStr:(NSString *)aStr
{
  NSData *data = [aStr dataUsingEncoding:NSUTF8StringEncoding];
  Byte *byte = (Byte *)[data bytes];
  return byte;
}
- (NSData *)dataFromStr:(NSString *)aStr
{
  NSData *data = [aStr dataUsingEncoding:NSUTF8StringEncoding];
  return data;
}
@end

#pragma mark - CHCHttpMultiPartVO
@interface CHCHttpMultiPartVO()
@property (nonatomic, strong) NSString *iKey;
@end

@implementation CHCHttpMultiPartVO
@synthesize iKey;
@synthesize iContentType;

- (NSString *)otherDisposition
{
  return nil;
}

- (NSInteger)doOutputContent:(NSMutableData *)aOs
{
  return -1;
}

@end

#pragma mark CHCHttpFilePartVO
@interface CHCHttpFilePartVO()
@property (nonatomic, strong) NSString *iKey;
@property (nonatomic, assign) Byte *iData;
@property (nonatomic, strong) NSString *iFileName;
@property (nonatomic, strong) NSString *iFilePath;
@end

@implementation CHCHttpFilePartVO
@dynamic iKey;
@synthesize iData;
@synthesize iFileName;
@synthesize iFilePath;

- (instancetype)initWithFileName:(NSString *)aFileName filePath:(NSString *)aFilePath;
{
  self = [self initWithKey:@"file" fileName:aFileName filePath:aFilePath];
  return self;
}

- (instancetype)initWithKey:(NSString *)aKey fileName:(NSString *)aFileName filePath:(NSString *)aFilePath
{
  self = [super init];
  if (self)
  {
    self.iKey = aKey;
    self.iFilePath = aFilePath;
    self.iFileName = aFileName;
  }
  return self;
}

- (instancetype)initWithKey:(NSString *)aKey fileName:(NSString *)aFileName
{
  self = [super init];
  if (self)
  {
    self.iKey = aKey;
    self.iFileName = aFileName;
  }
  return self;
}

- (instancetype)initWithKey:(NSString *)aKey fileName:(NSString *)aFileName datas:(Byte *)aData
{
  self = [super init];
  if (self)
  {
    self.iKey = aKey;
    self.iData = aData;
    self.iFileName = aFileName;
  }
  return self;
}

- (NSString *)otherDisposition
{
  NSMutableString *rtnValue = [NSMutableString stringWithString:@"filename=\""];
  if (!self.iFileName || [@"" isEqual:self.iFileName])
  {
    self.iFileName = [self.iFilePath lastPathComponent];
  }
  [rtnValue appendString:self.iFileName];
  [rtnValue appendString:@"\""];
  return rtnValue;
}

- (NSInteger)doOutputContent:(NSMutableData *)aOS
{
  NSInteger rtnValue = [super doOutputContent:aOS];
  
  if (self.iData && sizeof(self.iData) > 0)
  {
    NSData *data = [NSData dataWithBytes:self.iData length:strlen((char *)self.iData)];
    [aOS appendData:data];
    rtnValue = data.length;
  }
  else
  {
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:self.iFilePath] ;
    @try
    {
      NSData *data = [file readDataToEndOfFile];
      NSInteger length = [data length];
      char *dataByte = malloc(sizeof(char)*length);
      strcpy(dataByte, [data bytes]);
      for (int i = 0; i<[data length]; i++)
      {
        if (dataByte[i] == '\0')
        {
          dataByte[i] = '\n';
        }
      }
      NSOutputStream *stream = [[NSOutputStream alloc]initToBuffer:(u_int8_t *)dataByte capacity:length];
      [stream open];
      [stream write:[data bytes] maxLength:length];
      [stream close];
      NSString *dataStr = [NSString stringWithUTF8String:dataByte];
//      [dataStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, dataStr.length)];
//      dataStr = (NSMutableString *)[dataStr substringWithRange:NSMakeRange(1, dataStr.length-2)];
      [aOS appendData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
      
      rtnValue = data.length;
    }
    @catch (NSException *exception)
    {
      
    }
    @finally
    {
      [file closeFile];
    }
  }
  return rtnValue;
}

@end

#pragma mark CHCHttpStringPartVO
@interface CHCHttpStringPartVO()
@property (nonatomic, strong) NSString *iKey;
@property (nonatomic, strong) NSString *iValue;
@end

@implementation CHCHttpStringPartVO
@dynamic iKey;
@synthesize iValue;

- (instancetype)initWithValue:(NSString *)aValue
{
  self = [self initWithKey:@"project" withValue:aValue];
  return self;
}

- (instancetype)initWithKey:(NSString *)aKey withValue:(NSString *)aValue
{
  self = [super init];
  if (self)
  {
    self.iKey = aKey;
    self.iValue = aValue;
  }
  return self;
}

- (NSInteger)doOutputContent:(NSMutableData *)aOS
{
  NSData *data = [self.iValue dataUsingEncoding:NSUTF8StringEncoding];
  [aOS appendData:data];
  NSInteger length = data.length;
  return length;
}
@end

  