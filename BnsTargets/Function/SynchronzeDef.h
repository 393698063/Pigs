//
//  SynchronzeDef.h
//  Pigs
//
//  Created by HEcom on 16/4/25.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#import "AppDef.h"

#ifndef SynchronzeDef_h
#define SynchronzeDef_h
#define kUpdateTime @"lastUpdateTime"
#pragma mark - 接口
static NSString *const HCPG_SynchGoldRules = @"/coinlog/getGoldRules.do";//同步金币规则
//static NSString *const HCPG_SynchGoldAccount = @"/coinlog/syncUserCoinLog.do";//同步金币纪录
static NSString *const HCPG_SynPopularizeArea = @"/popularize/syncPopularizeArea.do";//同步省市区表
static NSString *const HCPG_SynInfoTag = @"/informationTag/syncInformationTag.do";//同步标签
static NSString *const HCPG_syncGoldAccounts = @"/coinlog/syncUserCoinLog.do";//同步金币纪录
static NSString *const HCPG_SyncPriceDiary = @"/quote/syncPrice.do";//同步报价日记
static NSString *const HCPG_SyncSimDiary = @"/diary/syncSimDiary.do";//同步简单日记

static NSString *const HCPG_UploadStatistics = @"/inforstatistics/uploadstatistics.do";//上传统计信息
static NSString *const HCPG_UploadGold = @"/coinlog/addUserCoinLog.do";//上传金币纪录
static NSString *const HCPG_UploadPriceDiary = @"/quote//uploadPrice.do";//上传报价日记
static NSString *const HCPG_UploadSimDiary = @"/diary/uploadSimDiary.do";//上传简单日记
#pragma mark - 数据库表名/纪录名

static NSString *const HCPG_PopularAreaTable = @"v30_md_popularArea";//地区表
static NSString *const HCPG_TagInfoTable = @"v30_md_informationTag";//标签表

static NSString *const HCPG_GoldRulesTable = @"HCPG_GoldRules";//金币规则表
static NSString *const HCPG_GoldAccountTable = @"HCPG_GoldAccounts";//金币纪录表
static NSString *const HCPG_PriceDiaryTable = @"HCPG_PriceDiary";//报价日记表
static NSString *const HCPG_QuationDataCacheTable = @"HCPG_QuationDataCache";//行情资讯缓存表
static NSString *const HCPG_SimpDiaryTable = @"HCPG_SimpleDiary";//报数简单日记表


#endif /* SynchronzeDef_h */
