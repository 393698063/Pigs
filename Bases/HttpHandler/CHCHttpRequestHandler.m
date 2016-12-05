//
//  CHCHttpRequestHandler.m
//  NewHopeForAgency
//
//  Created by HEcom-PC on 15/7/14.
//  Copyright (c) 2015年 Hecom. All rights reserved.
//

#import "CHCHttpRequestHandler.h"
#import "AFHTTPSessionManager.h"
#import "CHCPushUtil.h"
#import "HCLog.h"
#import "CHCCommonInfoVO.h"

static NSTimeInterval const CH_HTTPRequest_TimeoutInterval = 15.0f;

#pragma mark - CHCHttpCompleteVO
@interface CHCHttpCompleteVO : CHCBaseVO
{
  BOOL iIsSucceed;
  NSURLSessionDataTask *iTask;
  id iResponseObject;
  NSError *iError;
  void (^iSucceedBlock)(NSURLSessionDataTask *task, id responseObject);
  void (^iFailBlock)(NSURLSessionDataTask *task, NSError *error);
}

@property (nonatomic) BOOL iIsSucceed;
@property (nonatomic, strong) NSURLSessionDataTask *iTask;
@property (nonatomic, strong)id iResponseObject;
@property (nonatomic, strong)NSError *iError;
@property (nonatomic, copy) void (^iSucceedBlock)(NSURLSessionDataTask *task, id responseObject);
@property (nonatomic, copy) void (^iFailBlock)(NSURLSessionDataTask *task, NSError *error);

@end

@implementation CHCHttpCompleteVO
@synthesize iTask;
@synthesize iResponseObject;
@synthesize iError;
@synthesize iIsSucceed;
@synthesize iSucceedBlock;
@synthesize iFailBlock;

@end

#pragma mark - CHCHttpRequestHandler
@interface CHCHttpRequestHandler()
{
  AFHTTPSessionManager *iHttpSessionManager;
  
  NSString *iBaseUrlStr;
  NSURL *iBaseUrl;
  
  NSString *iFileUrlStr;
  NSURL *iFileUrl;
}

@property (nonatomic, strong) AFHTTPSessionManager *iHttpSessionManager;

@property (nonatomic, strong) NSString *iBaseUrlStr;
@property (nonatomic, strong) NSURL *iBaseUrl;

@property (nonatomic, strong) NSString *iFileUrlStr;
@property (nonatomic, strong) NSURL *iFileUrl;

@end


@implementation CHCHttpRequestHandler
@synthesize iHttpSessionManager;
@synthesize iSemaphore;
@synthesize iSerialQueue;
@synthesize iBaseUrlStr;
@synthesize iBaseUrl;
@synthesize iFileUrlStr;
@synthesize iFileUrl;

#pragma mark 初始化方法
//设置单例的方法
+ (instancetype)sharedInstance
{
  static CHCHttpRequestHandler *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken,
                ^{
                  //初始化单例
                  sharedInstance = [[self alloc]init];
                });
  
  return sharedInstance;
}

//初始化
- (instancetype)init
{
  FUNCBEGIN;
  
  self = [super init];
  if (self)
  {
    self.iSemaphore = dispatch_semaphore_create(1);
    self.iSerialQueue = dispatch_queue_create("com.HecomXinyun.CHCHttpRequestHandler.dispatchName", DISPATCH_QUEUE_SERIAL);
    
    NSURL *url= [[self class] creatBaseURL];
    if ( [[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"] )
    {
      url = [url URLByAppendingPathComponent:@""];
    }
    self.iBaseUrl = url;
    self.iBaseUrlStr = [self.iBaseUrl absoluteString];
    
    NSURL *urlFile= [[self class] creatBaseFileURL];
    if ( [[urlFile path] length] > 0 && ![[urlFile absoluteString] hasSuffix:@"/"] )
    {
      urlFile = [urlFile URLByAppendingPathComponent:@""];
    }
    self.iFileUrl = urlFile;
    self.iFileUrlStr = [self.iFileUrl absoluteString];
    
    //初始化http manager
    self.iHttpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    
    NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet: self.iHttpSessionManager.responseSerializer.acceptableContentTypes];
    [acceptableContentTypes addObject:@"text/html"];
    [acceptableContentTypes addObject:@"text/plain"];
    [acceptableContentTypes addObject:@"application/json"];
    self.iHttpSessionManager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
                                                                           
    //给session manager设置属性
    [self putAttrForRequestManager:self.iHttpSessionManager];
  }
  
  FUNCEND;
  return self;
}

+ (NSURL *)creatBaseURL
{
  NSDictionary *connectionDic = [[NSUserDefaults standardUserDefaults]objectForKey:HC_UrlConnection_Info_Key];
  
  //初始化属性http url
  NSString *connectProtocal = [connectionDic objectForKey:HC_UrlConnection_ProtocolType_Key];
  NSString *connectUrl = [connectionDic objectForKey:HC_UrlConnection_URL_Key];
  NSString *connectPort = [connectionDic objectForKey:HC_UrlConnection_Port_Key];
  
  NSString *urlStr = [NSString stringWithFormat:@"%@%@:%@",
                      connectProtocal,
                      connectUrl,
                      connectPort];
  NSURL *url= [NSURL URLWithString:urlStr];
  return url;
}

+ (NSURL *)creatBaseFileURL
{
  NSDictionary *connectionDic = [[NSUserDefaults standardUserDefaults]objectForKey:HC_UrlConnection_Info_Key];
  
  //初始化属性http file url
  NSString *connectFileProtocal = [connectionDic objectForKey:HC_UrlConnection_FileProtocolType_Key];
  NSString *connectFileUrl = [connectionDic objectForKey:HC_UrlConnection_FileURL_Key];
  NSString *connectFilePort = [connectionDic objectForKey:HC_UrlConnection_FilePort_Key];
  
  NSString *urlFileStr = [NSString stringWithFormat:@"%@%@:%@",
                          connectFileProtocal,
                          connectFileUrl,
                          connectFilePort];
  NSURL *urlFile= [NSURL URLWithString:urlFileStr];
  return urlFile;
}

//初始化调用方法：为http session manager设置属性
- (void)putAttrForRequestManager:(AFHTTPSessionManager *)aRequestManager
{
  
  //设置timeout时间
  aRequestManager.requestSerializer.timeoutInterval = CH_HTTPRequest_TimeoutInterval;
  
  //设置请求头信息中的字段，否则服务器无法解析请求
  [aRequestManager.requestSerializer setValue:@"text/plain; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
  
  //设置请求信息中的数据填充方式。否则服务器会以默认方式（好像是key，value对以及&分割填充数据）
  [aRequestManager.requestSerializer setQueryStringSerializationWithBlock:
   ^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error)
   {
     return parameters;
   }];
//    sharedInstance.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
  
}

//扩展：重新设置http request url的方法
- (void)putHttpUrl:(NSURL *)aUrl
{
  FUNCBEGIN;
  
  self.iBaseUrl = aUrl;
  self.iBaseUrlStr = [aUrl absoluteString];
  
  FUNCEND;
}

#pragma mark 发送请求的接口方法
- (void)sycnHCPOST:(NSString *)aServiceName
        parameters:(id)aParams
           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  dispatch_async(self.iSerialQueue,
                 ^{
                   FUNCBEGIN;
                   
                   dispatch_semaphore_wait(self.iSemaphore, DISPATCH_TIME_FOREVER);
                   [self HCPOST:aServiceName
                     parameters:aParams
                        success:^(NSURLSessionDataTask *task, id responseObject)
                    {
                      success(task,responseObject);
                      dispatch_semaphore_signal(self.iSemaphore);
                    }
                        failure:^(NSURLSessionDataTask *task, NSError *error)
                    {
                      failure(task,error);
                      dispatch_semaphore_signal(self.iSemaphore);
                    }];
                   
                   FUNCEND;
                 });
}


//发送post请求的方法
- (NSURLSessionDataTask *)HCPOST:(NSString *)aServiceName
                      parameters:(id)aParams
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject) )success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error) )failure
{
  
  NSURLSessionDataTask *rtnValue = nil;
  if ([aParams isKindOfClass:[CHCHttpMultiConstructor class]])
  {
    //发送提交文件请求
    CHCHttpMultiConstructor *aConstructor = aParams;

    //无错误，可以正常发送请求
    rtnValue = [self HCPOST:aServiceName
                  serverUrl:self.iFileUrl
            multipartFormat:aConstructor
                    success:success
                    failure:failure];
  }
  else
  {
    //普通的Json请求
    NSError *error = nil;
    id reqData = [self dataConstruct:aParams error:&error];
    
    if (error)
    {
      //数据构造错误
      [self endPostReqFail:nil withError:error withBlock:failure];
    }
    else if (!reqData)
    {
      //数据构造无错误，但返回为空
      /*理论上来说不会进到这里*/
      HCLog(@"aParams为%@",aParams);
      NSError *error = [[NSError alloc]initWithDomain:HC_HTTPERROR_NilJsonOrObj_domain
                                                 code:HC_HTTPERROR_NilJsonOrObj_code
                                             userInfo:nil];
      [self endPostReqFail:nil withError:error withBlock:failure];
    }
    else
    {
      
      NSMutableDictionary *header= [@{@"Content-Type":@"text/plain ; charset=UTF-8"} mutableCopy];
      
      //无错误，可以正常发送请求
      rtnValue = [self HCPOST:aServiceName
                    serverUrl:self.iBaseUrl
                      headers:header
                   parameters:reqData
                      success:success
                      failure:failure];
    }

  }
    return rtnValue;
}

+ (NSDictionary *)readCookie:(NSURL *)aURL
{
  if (!aURL)
  {
    aURL = [CHCHttpRequestHandler creatBaseURL];
  }
  NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:aURL];
  NSMutableDictionary *cookieDic = [[NSHTTPCookie requestHeaderFieldsWithCookies:cookies] mutableCopy];
  
  NSDictionary *nowHeaders = [NSMutableDictionary dictionaryWithCapacity:1];
  [cookieDic addEntriesFromDictionary:nowHeaders];
  
  return cookieDic;
}

+ (void)setCookie:(NSMutableURLRequest *)request
{
  NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
  NSMutableDictionary *cookieDic = [[NSHTTPCookie requestHeaderFieldsWithCookies:cookies] mutableCopy];
  
  NSDictionary *nowHeaders = request.allHTTPHeaderFields;
  [cookieDic addEntriesFromDictionary:nowHeaders];
  
  [request setAllHTTPHeaderFields:cookieDic];
}

+ (void)saveCookie:(NSMutableURLRequest *)request
{
  //最新的Cookies
  NSArray *newCookieAry = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
  
  //老的Cookies
  NSMutableArray *oldCookieAry = [NSMutableArray arrayWithCapacity:1];
  NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:HC_UrlConnection_Cookie_Key];
  if ([cookiesdata length] > 0)
  {
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
    [oldCookieAry addObjectsFromArray:cookies];
  }
  
  //置换老cookie中同名变化的。
  NSHTTPCookie *tempCookie = nil;
  for ( NSHTTPCookie *newCookie in newCookieAry )
  {
    for ( NSHTTPCookie *oldCookie in oldCookieAry )
    {
      if ([oldCookie.properties[NSHTTPCookieName] isEqualToString: newCookie.properties[NSHTTPCookieName]])
      {
        tempCookie = oldCookie;
        break;
      }
    }
    if (tempCookie)
    {
      //去重
      NSInteger idx = [oldCookieAry indexOfObject:tempCookie];
      [oldCookieAry removeObjectAtIndex:idx];
      tempCookie = nil;
    }
  }
  
  //加新
  [oldCookieAry addObjectsFromArray:newCookieAry];
  
  //需要更新
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:oldCookieAry];
  [[NSUserDefaults standardUserDefaults] setObject:data forKey:HC_UrlConnection_Cookie_Key];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)delAllCookies
{
  NSURL *url = [[self class] creatBaseURL];
  NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
  [cookies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
  {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:obj];
  }];
}

#pragma mark 数据转化方法
- (id)dataConstruct:(id)aParams error:(NSError **)aError
{
  
  NSString *reqData = nil;
  NSError *error = nil;

  //json转化
  NSError *jsonError = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aParams options:NSJSONWritingPrettyPrinted error:&jsonError];
  NSString *json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
  
  if (!json || jsonError)
  {
    //object 转换JSon失败
    HCLog(@"aParams转化Json失败. error:%@\n",jsonError);
    error = [[NSError alloc]initWithDomain:HC_HTTPERROR_NilJsonOrObj_domain
                                      code:HC_HTTPERROR_NilJsonOrObj_code
                                  userInfo:nil];
    reqData = nil;
  }
  else
  {
    error = nil;
    reqData = json;
  }
  
  if (aError)
  {
    *aError = error;
  }
  return reqData;
}

#pragma mark 真正发送请求的方法
//发送post请求的方法
- (NSURLSessionDataTask *)HCPOST:(NSString *)aServiceName
                       serverUrl:(NSURL *)aServerUrl
                 multipartFormat:(CHCHttpMultiConstructor *)aParams
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  FUNCBEGIN;
  
  //传入方法名称和表体数据
  NSURLSessionDataTask *rtnValue = [self.iHttpSessionManager POST:[[NSURL URLWithString:aServiceName
                                                                          relativeToURL:aServerUrl] absoluteString]
                                                       parameters:nil
                                        constructingBodyWithBlock:
                                    ^void(id<AFMultipartFormData> formatData)
                                    {
                                      [aParams.iParts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                                       {
                                         if ([obj isKindOfClass:[CHCHttpFilePartVO class]])
                                         {
                                           CHCHttpFilePartVO *aVO = obj;
                                           NSError *error = nil;
                                           NSString *path = [@"file://" stringByAppendingString:aVO.iFilePath];
                                           [formatData appendPartWithFileURL:[NSURL URLWithString:path]
                                                                        name:aVO.iKey
                                                                    fileName:aVO.iFileName
                                                                    mimeType:@""
                                                                       error:&error];
                                           
                                         }
                                         else if ([obj isKindOfClass:[CHCHttpStringPartVO class]])
                                         {
                                           CHCHttpStringPartVO *aVO = obj;
                                           NSData *data = [aVO.iValue dataUsingEncoding:NSUTF8StringEncoding];
                                           [formatData appendPartWithFormData:data name:aVO.iKey];
                                         }
                                      }];
                                    }
                                                          success:
                                    ^void(NSURLSessionDataTask *task, id responseObject)
                                    {
                                      CHCHttpCompleteVO *aSuccessVO = [[CHCHttpCompleteVO alloc]init];
                                      aSuccessVO.iIsSucceed = YES;
                                      aSuccessVO.iTask = task;
                                      aSuccessVO.iResponseObject = responseObject;
                                      aSuccessVO.iSucceedBlock = success;
                                      
                                      [self performSelectorOnMainThread:@selector(requestFinished:)
                                                             withObject:aSuccessVO
                                                          waitUntilDone:YES];
                                      //success(task, responseObject);
                                      
                                    }
                                                          failure:
                                    ^void(NSURLSessionDataTask *task, NSError *error)
                                    {
                                      [self endPostReqFail:task withError:error withBlock:failure];
                                      //failure(task, error);
                                    }];
  FUNCEND;
  return rtnValue;
}

//发送post请求的方法
- (NSURLSessionDataTask *)HCPOST:(NSString *)aServiceName
                       serverUrl:(NSURL *)aServerUrl
                         headers:(NSDictionary *)aHeaders
                      parameters:(id)aParams
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  FUNCBEGIN;
  
  //设置Http头
  [aHeaders enumerateKeysAndObjectsUsingBlock:
   ^(id key, id obj, BOOL *stop)
   {
     [self.iHttpSessionManager.requestSerializer setValue:obj
                                       forHTTPHeaderField:key];
   }];
  
  //传入方法名称和表体数据
  NSURLSessionDataTask *rtnValue = [self.iHttpSessionManager POST:[[NSURL URLWithString:aServiceName
                                                                          relativeToURL:aServerUrl] absoluteString]
                                                       parameters:aParams
                                                          success:
                                    ^void(NSURLSessionDataTask *task, id responseObject)
                                    {
                                      CHCHttpCompleteVO *aSuccessVO = [[CHCHttpCompleteVO alloc]init];
                                      aSuccessVO.iIsSucceed = YES;
                                      aSuccessVO.iTask = task;
                                      aSuccessVO.iResponseObject = responseObject;
                                      aSuccessVO.iSucceedBlock = success;
                                      
                                      [self performSelectorOnMainThread:@selector(requestFinished:)
                                                             withObject:aSuccessVO
                                                          waitUntilDone:YES];
                                      //success(task, responseObject);
                                      
                                    }
                                                          failure:
                                    ^void(NSURLSessionDataTask *task, NSError *error)
                                    {
                                      [self endPostReqFail:task withError:error withBlock:failure];
                                      //failure(task, error);
                                    }];
  FUNCEND;
  return rtnValue;
}

#pragma mark 请求失败处理
- (void)endPostReqFail:(NSURLSessionDataTask *)task
             withError:(NSError *)error
             withBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
  //转到主线程执行
  CHCHttpCompleteVO *aFailVO = [[CHCHttpCompleteVO alloc]init];
  aFailVO.iIsSucceed = NO;
  aFailVO.iTask = task;
  aFailVO.iError = error;
  aFailVO.iFailBlock = failure;
  [self performSelectorOnMainThread:@selector(requestFinished:) withObject:aFailVO waitUntilDone:YES];
}

- (void)requestFinished:(CHCHttpCompleteVO *)aCompletionVO
{
  if (aCompletionVO.iIsSucceed)
  {
    if (aCompletionVO.iSucceedBlock)
    {
      aCompletionVO.iSucceedBlock(aCompletionVO.iTask, aCompletionVO.iResponseObject);
    }
  }
  else
  {
    if (aCompletionVO.iFailBlock)
    {
      aCompletionVO.iFailBlock(aCompletionVO.iTask, aCompletionVO.iError);
    }
  }
}

- (void)cancelRequest
{
  //  self.iHttpSessionManager 
}
@end
