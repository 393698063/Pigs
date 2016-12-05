//
//  CHCPGGoldManager.h
//  Pigs
//
//  Created by HEcom on 16/5/19.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
/**
 *  最近登录的时间
 */
//static NSString *const HCPG_RecentLoginTime = @"recentLoginTime";
/**
 *  持续登录时间
 */
//static NSString *const HCPG_ContinueLoginDays = @"continueLoginDays";

//static NSString *const HCPG_QuoteTime = @"quoteTime";
/**
 *  金币改变的通知
 */
static NSString *const HCPG_GoldChangeNotice = @"goldChangeNotice";

typedef NS_ENUM(NSInteger,EHCGoldType)
{
  EHCGoldLogin,//登录的金币
  EHCGoldRegist,//注册的金币
  EHCGoldQuote,//报价的金币
  EHCGoldCount//报数的金币
};
/**
 *  获取金币code
 */
typedef NS_ENUM(NSInteger,EHCGoldCode) {
  /**
   *  登录
   */
  EHCGoldCodeLogin = 12,
  /**
   *  注册
   */
  EHCGoldCodeRegist = 10,
  /**
   *  报价
   */
  EHCGoldCodeQuote = 300,
  /**
   *  首次数猪
   */
  EHCGoldCodeCountFirst = 106,
  /**
   *  其它数猪
   */
  EHCGoldCodeCount = 105
};

@interface CHCPGGoldManager : NSObject
+ (CHCPGGoldManager *)sharedCHCPGGoldManager;
//DEFINE_SINGLETON_FOR_HEADER(CHCPGGoldManager)
/**
 *  获取金币无回调
 *
 *  @param type 枚举
 */
- (void)showGoldGifWithType:(EHCGoldType)type;
/**
 *  获取金币有回调
 *
 *  @param type         枚举
 *  @param aCompeletion 回调
 */
- (void)showGoldGifWithType:(EHCGoldType)type
                compeletion:(void(^)(BOOL compeleted,NSString * aDesc))aCompeletion;
/**
 *  获取用户金币数量
 */
- (NSInteger)readUserGoldCount;
/**
 *  重置金币管理
 */
- (void)reset;
+ (void)destroy;
@end
