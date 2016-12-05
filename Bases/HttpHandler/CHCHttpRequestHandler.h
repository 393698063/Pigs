//
//  CHCHttpRequestHandler.h
//  NewHopeForAgency
//
//  Created by HEcom-PC on 15/7/14.
//  Copyright (c) 2015年 Hecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCHttpDef.h"
#import "CHCBaseVO.h"
#import "CHCHttpMultiConstructor.h"

@interface CHCHttpRequestHandler : NSObject
{
  dispatch_queue_t iSerialQueue;
  dispatch_semaphore_t iSemaphore;
}
@property (nonatomic, strong) dispatch_queue_t iSerialQueue;
@property (nonatomic, strong) dispatch_semaphore_t iSemaphore;

+ (instancetype)sharedInstance;

- (NSURLSessionDataTask *)HCPOST:(NSString *)aServiceName
                      parameters:(NSDictionary *)aParams
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)sycnHCPOST:(NSString *)aServiceName
        parameters:(NSDictionary *)aParams
           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
 __deprecated_msg("Method deprecated.");

- (void)cancelRequest;

+ (NSDictionary *)readCookie:(NSURL *)aURL;
+ (void)setCookie:(NSMutableURLRequest *)request;
+ (void)saveCookie:(NSMutableURLRequest *)request;
+ (void)delAllCookies;

+ (NSURL *)creatBaseURL;
+ (NSURL *)creatBaseFileURL;

@end

