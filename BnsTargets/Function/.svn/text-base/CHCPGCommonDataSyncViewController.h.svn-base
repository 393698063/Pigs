//
//  CHCPGCommonDataSyncViewController.h
//  Pigs
//
//  Created by HEcom on 16/5/21.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

static NSString *const HCPG_UserSyncPopularData = @"syncPopularData";

@interface CHCPGCommonDataSyncViewController : CHCBaseViewController
/*
 *上传资讯统计信息
 */
- (void)upLoadInformationStatisticCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
@end

@class CHCSqliteManager;
@interface CHCPGCommonDataSyncController : CHCBaseController
@property (nonatomic, strong) CHCSqliteManager * iSqlManager;
//
/*
 *同步公共数据
 */
- (void)syncPopularDataCompletion:(void (^)(BOOL isSucceed, NSString * aDesc))aCompletion;
/*
 *同步省市区表
 */
- (void)syncPopularAreaDataCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;

/*
 *上传资讯统计信息
 */
- (void)upLoadInformationStatisticWithUid:(NSNumber *)uid data:(NSArray *)data
                               completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
- (void)syncInfoTagCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
- (void)creatCommonFile:(NSString *)aPath;
+ (NSString *)creatCommonPath;
@end

@interface CHCPGCommonDataSyncModelHandler : CHCBaseModelHandler

@end
