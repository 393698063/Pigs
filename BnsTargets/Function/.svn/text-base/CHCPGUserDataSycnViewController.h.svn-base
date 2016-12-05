//
//  CHCPGUserDataSycnViewController.h
//  Pigs
//
//  Created by HEcom on 16/5/6.
//  Copyright © 2016年 HEcom. All rights reserved.
//


#import "CHCBaseViewController.h"

//static NSString *const HCPG_UserSyncPopularData = @"syncPopularData";

@class CHCSqliteManager;
@interface CHCPGUserDataSycnViewController : CHCBaseViewController

/*
 *同步用户金币数据
 */
- (void)sycnUserGoldDataCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
/*
 *同步用户日记等数据
 */
- (void)syncUserOtherDataCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
/**
 *  上传用户金币，报价日记等数据
 */
- (void)upLoadUserLocalData;
/**
 *  上传用户金币纪录
 *
 *  @param aCompletion 回调
 */
- (void)upLoadUserGoldCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;

/**
 *  上传报价日记
 *
 *  @param aCompletion 回调
 */
- (void)upLoadPriceDiaryCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
/**
 *  上传简单日记
 *
 *  @param aCompletion 返回block
 */
- (void)uploadSimplDiaryCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
@end

@interface CHCPGUserDataSycnController : CHCBaseController;
@property (nonatomic, strong) CHCSqliteManager * iSqlManager;

- (void)creatUserFile:(NSString *)aPath;

+ (NSString *)createUserPath;

//
/*
 *同步用户金币数据
 */
- (void)syncUserGoldDataCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
/*
 *同步金币规则
 */
- (void)synChGoldRulesWithUid:(NSNumber *)uid lastGetTime:(NSNumber *)lastGetTime
                   completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
/*
 *同步金币纪录
 */
- (void)syncHGoldAccountWithUid:(NSNumber *)uid lastUpTime:(NSNumber *)lastUpTime
                     completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
//
/*
 *同步用户数据
 */
- (void)syncUserOtherDataCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
/*
 *同步报价日记
 */
- (void)syncPriceDiaryWithUid:(NSNumber *)uid lastUPTime:(NSNumber *)lastUpTime
                   completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
/**
 *  同步报数简单日记
 *
 *  @param uid         用户id
 *  @param lastUptime  上次更新时间
 *  @param aCompletion 完成回调
 */
- (void)syncSimpleDiaryWithUid:(NSNumber *)uid lastUpTime:(NSNumber *)lastUpTime
                    completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;

/**
 *  上传金币纪录
 *
 *  @param uid         用户id
 *  @param gold        金币纪录数组
 *  @param aCompletion 回调
 */
- (void)upLoadGoldWithUid:(NSNumber *)uid gold:(NSArray *)gold
               completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
/**
 *  上传报价日记
 *
 *  @param uid         用户id
 *  @param data        报价数据
 *  @param aCompletion 回调
 */
- (void)upLoadPriceDiaryWithUid:(NSNumber *)uid
                           data:(NSArray *)data
                     completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
/**
 *  上传简单日记
 *
 *  @param uid         用户uid
 *  @param data        数据数组
 *  @param aCompletion 回调
 */
- (void)upLoadSimpleDiaryWithUid:(NSNumber *)uid
                            data:(NSArray *)data
                      completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
/**
 *  insert or replace into table
 *
 *  @param aDicAry   数据数组
 *  @param tableName 表名
 */
- (void)saveSyncDicData:(NSArray *)aDicAry
                toTable:(NSString *)tableName;

@end

@interface CHCPGUserDataSycnModelHandler : CHCBaseModelHandler

@end
