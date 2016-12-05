//
//  CHCPGGoldManager.m
//  Pigs
//
//  Created by HEcom on 16/5/19.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define kLoginContinueState @"loginContinueState"
#define kQuoteTimeState @"quoteTimeState"
#define kDateFormatter @"yyyy/MM/dd"


#import "CHCPGGoldManager.h"
#import "CHCPGGoldGif.h"
#import "CHCSqliteManager.h"
#import "CHCPGUserDataSycnViewController.h"
#import "SynchronzeDef.h"
#import "DateFomatterTool.h"
#import "CHCPGUserDataSycnViewController.h"
#import "AppDelegate.h"


@interface CHCPGGoldManager ()
@property (nonatomic, strong) CHCSqliteManager * iSqliteManager;
@end

@implementation CHCPGGoldManager
static CHCPGGoldManager * sharedManager = nil;
static dispatch_once_t onceToken;
//DEFINE_SINGLETON_FOR_CLASS(CHCPGGoldManager)
+ (CHCPGGoldManager *)sharedCHCPGGoldManager
{
  dispatch_once(&onceToken, ^{
    sharedManager = [[CHCPGGoldManager alloc] init];
  });
  return sharedManager;
}
- (instancetype)init
{
  if (self = [super init]) {
    NSString * tablePath = [NSString stringWithFormat:@"%@/%@",
                            [CHCPGUserDataSycnController createUserPath],
                            @"database.db"];
    self.iSqliteManager = [CHCSqliteManager creatSqliteManager:tablePath];
  }
  return self;
}
- (void)showGoldGifWithType:(EHCGoldType)type
{
  [self showGoldGifWithType:type compeletion:nil];
}
- (void)showGoldGifWithType:(EHCGoldType)type compeletion:(void(^)(BOOL compeleted,NSString * aDesc))aCompeletion
{
  switch (type) {
    case EHCGoldLogin:
    {
      [self loginActionObtainGoldCompeletion:^(BOOL compeleted, NSString *aDesc)
      {
        if (aCompeletion) {
          aCompeletion(compeleted,aDesc);
        }
      }];
      break;
    }
    case EHCGoldRegist:
    {
      [self getGoldWithCode:EHCGoldCodeRegist
               message:@"+"
                compeletion:^(BOOL compeleted, NSString *aDesc)
      {
        if (aCompeletion) {
          aCompeletion(compeleted,aDesc);
        }
      }];
      break;
    }
      case EHCGoldQuote:
    {
      [self quoteActionObtainGoldCompeletion:^(BOOL compeleted, NSString *aDesc)
      {
        if (aCompeletion) {
          aCompeletion(compeleted,aDesc);
        }
      }];
      break;
    }
      case EHCGoldCount:
    {
      [self countedObtainGoldCompeletion:^(BOOL compeleted, NSString *aDesc) {
        if (aCompeletion) {
          aCompeletion(compeleted,aDesc);
        }
      }];
      break;
    }
    default:
      break;
  }
  [((AppDelegate *)([UIApplication sharedApplication].delegate)).iUserDataSyncController
   upLoadUserGoldCompletion:^(BOOL isSucceed, NSString *aDes)
   {
     
   }];
}
//登录得金币
- (void)loginActionObtainGoldCompeletion:(void(^)(BOOL compeleted,NSString * aDesc))aCompeletion
{
  NSString * currentTimeStr = [DateFomatterTool getDateStringFromDate:[NSDate date] dateFormatter:kDateFormatter];
  NSNumber * currentTimeFor = [DateFomatterTool getTimeStampWithDateStr:currentTimeStr dateFormat:kDateFormatter];
  NSInteger code = EHCGoldCodeLogin;
  //获取数据库中的金币纪录
  NSArray * accounts = [self getLoginGoldAccount];
  if (accounts.count != 0)
  {
    //检测是否在纪录中已经得过金币，若得过，直接return
    if ([self testWhetherContain:currentTimeFor with:accounts])
    {
      if (aCompeletion) {
        aCompeletion(YES,nil);
      }
      return;
    }
    //检测连续登录的天数
    NSInteger lastDays = [self continueOneLine:currentTimeFor withAccounts:accounts];
    if (lastDays >= 6 ) {
      lastDays = 6;
    }
    code += lastDays;
  }
 else
 {
   //code = 12
 }
  [self getGoldWithCode:code
                message:@"+"
            compeletion:^(BOOL compeleted, NSString *aDesc)
  {
    if (aCompeletion) {
      aCompeletion(compeleted,aDesc);
    }
  }];
}

- (NSInteger)continueOneLine:(NSNumber *)newDay withAccounts:(NSArray *)accounts
{
  NSInteger lastDays = 0;
  NSNumber * tmpDay = newDay;
  for (int i = (int)accounts.count - 1; i >= 0; i--)
  {
    NSDictionary * dict = [accounts objectAtIndex:i];
    int  dayLength = abs([self getDaysDistanceFrom:tmpDay to:[dict objectForKey:@"createAt"]]);
    if (dayLength == 1) {
      lastDays ++;
      tmpDay = [dict objectForKey:@"createAt"];
    }
    else
    {
      break;
    }
  }
  return lastDays;
}
- (NSArray *)getLoginGoldAccount
{
  NSString * sql = @"select * FROM \"HCPG_GoldAccounts\" WHERE reson>= 12 and reson <= 18 ORDER BY createAt ";
  NSArray * accounts = [self.iSqliteManager executeQueryRtnAry:sql];
  return accounts;
}
//遍历数组是因为可能有手机改时间多次获取金币的可能
- (BOOL)testWhetherContain:(NSNumber *)loginDate with:(NSArray *)accounts
{
  __block BOOL isHave = NO;
  __weak typeof(self)wSelf = self;
  [accounts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
  {
    NSNumber * accoutDate = [obj objectForKey:@"createAt"];
    NSInteger aparts = [wSelf getDaysDistanceFrom:loginDate to:accoutDate];
    if (aparts == 0) {
      isHave = YES;
      * stop = YES;
    }
  }];
  return isHave;
}
- (int)getDaysDistanceFrom:(NSNumber *)day1 to:(NSNumber *)day2
{
  int aparts = 0;
  NSDate * date1 = [DateFomatterTool getDateFromTimeStampWithTimeStamp:[day1 longLongValue]];
  NSDate * date2 = [DateFomatterTool getDateFromTimeStampWithTimeStamp:[day2 longLongValue]];
  NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSInteger flag = NSCalendarUnitDay;
  NSDateComponents * components = [calendar components:flag fromDate:date1 toDate:date2 options:0];
  aparts = (int)components.day;
  
  return aparts;
}
/**
 *  报价得金币
 *
 *  @param aCompeletion
 */
- (void)quoteActionObtainGoldCompeletion:(void(^)(BOOL compeleted,NSString * aDesc))aCompeletion
{
  NSString * currentTimeStr = [DateFomatterTool getDateStringFromDate:[NSDate date] dateFormatter:kDateFormatter];
  NSNumber * currentTimeFor = [DateFomatterTool getTimeStampWithDateStr:currentTimeStr dateFormat:kDateFormatter];
 NSInteger code = EHCGoldCodeQuote;
  //获取数据库中的金币纪录
  NSArray * accounts = [self getQuoteGoldAccount];
  if (accounts.count != 0)
  {
    //检测是否在纪录中已经得过金币，若得过，直接return
    if ([self testWhetherContain:currentTimeFor with:accounts])
    {
      if (aCompeletion)
      {
        aCompeletion(YES,nil);
      }
      return;
    }
    //检测连续登录的天数
    NSInteger lastDays = [self continueOneLine:currentTimeFor withAccounts:accounts];
    if (lastDays >= 6 ) {
      lastDays = 6;
    }
    code += lastDays;
  }
  else
  {
    //code = 300
  }
  
  [self getGoldWithCode:code message:@"+"
            compeletion:^(BOOL compeleted, NSString *aDesc)
   {
     if (aCompeletion) {
       aCompeletion(YES, nil);
     }
   }];
}
- (NSArray *)getQuoteGoldAccount
{
  NSString * sql = @"select * FROM \"HCPG_GoldAccounts\" WHERE reson>= 300 and reson <= 306 ORDER BY createAt ";
  NSArray * accounts = [self.iSqliteManager executeQueryRtnAry:sql];
  return accounts;
}
/**
 *  数猪简单日记获取金币纪录，第一次code＝ 106 ，其它 code ＝ 105；
 *
 *  @param aCompeletion 返回block
 */
- (void)countedObtainGoldCompeletion:(void(^)(BOOL compeleted,NSString * aDesc))aCompeletion
{
  NSString * currentTimeStr = [DateFomatterTool getDateStringFromDate:[NSDate date] dateFormatter:kDateFormatter];
  NSNumber * currentTimeFor = [DateFomatterTool getTimeStampWithDateStr:currentTimeStr dateFormat:kDateFormatter];
  NSInteger code = EHCGoldCodeCountFirst;
  //获取数据库中的金币纪录
  NSArray * accounts = [self getCountedGoldAccount];
  if (accounts.count != 0)
  {
    //检测是否在纪录中已经得过金币，若得过，直接return
    if ([self testWhetherContain:currentTimeFor with:accounts])
    {
      if (aCompeletion)
      {
        aCompeletion(YES,nil);
      }
      return;
    }
//    //检测连续登录的天数
//    NSInteger lastDays = [self continueOneLine:currentTimeFor withAccounts:accounts];
//    if (lastDays >= 6 ) {
//      lastDays = 6;
//    }
    code = EHCGoldCodeCount;
  }
  else
  {
//    code = 106;
  }
  
  [self getGoldWithCode:code message:@"+"
            compeletion:^(BOOL compeleted, NSString *aDesc)
   {
     if (aCompeletion) {
       aCompeletion(YES, nil);
     }
   }];
}
- (NSArray *)getCountedGoldAccount
{
  NSString * sql = @"select * FROM \"HCPG_GoldAccounts\" WHERE reson = 105 or reson = 106 ORDER BY createAt ";
  NSArray * accounts = [self.iSqliteManager executeQueryRtnAry:sql];
  return accounts;
}
- (void)getGoldWithCode:(NSInteger)code
                message:(NSString * )message
            compeletion:(void(^)(BOOL compeleted,NSString * aDesc))aCompeletion
{
  NSMutableDictionary * goldDic = [NSMutableDictionary dictionary];
  NSString * goldStr = nil;
  NSString * currentTimeStr = [DateFomatterTool getDateStringFromDate:[NSDate date] dateFormatter:kDateFormatter];
  NSNumber * currentTimeFor = [DateFomatterTool getTimeStampWithDateStr:currentTimeStr dateFormat:kDateFormatter];
  
  //获取基准时间，同步金币规则的时间
  NSString * path = [CHCPGUserDataSycnController createUserPath];
  NSString * dicPath = [NSString stringWithFormat:@"%@/%@",path,@"updateRecord.plist"];
  NSDictionary * updateTimeDic = [NSDictionary dictionaryWithContentsOfFile:dicPath];
   NSDictionary * ruleDic = [updateTimeDic objectForKey:HCPG_GoldRulesTable];
  NSNumber * basicTimeFormat = [ruleDic objectForKey:kUpdateTime];
  
  //金币衰减值
  NSInteger dayLength = abs([self getDaysDistanceFrom:basicTimeFormat to:currentTimeFor]);
  NSInteger weakNum = 0;
  if ((dayLength - 3) > 0) {
    weakNum = dayLength - 3;
    if (weakNum > 9)
    {
      weakNum = 9;
    }
  }
  NSString * sqlStr = [NSString stringWithFormat:@"select * from %@ where code = %ld",HCPG_GoldRulesTable,(long)code];
  NSArray * ary = [self.iSqliteManager executeQueryRtnAry:sqlStr];
  if (ary)
  {
    NSDictionary * ruleDic = [ary firstObject];
    NSInteger gold = [self obtainRandomGoldWithDict:ruleDic];
    if (gold == 0)
    {
      //等于0也入库，用于记录的金币的次数
//      return;
    }
    else
    {
      gold = gold * (10 -  weakNum) * 0.1;
      if (gold == 0) {
        gold = 1;
      }
    }
    HCLog(@"weak--------------%ld",weakNum);
    [goldDic setObject:@(gold) forKey:@"goldCount"];
    [goldDic setObject:@(-1) forKey:@"id"];
    [goldDic setObject:@(code) forKey:@"reson"];
    [goldDic setObject:[CHCCommonInfoVO sharedManager].iHCid forKey:@"uid"];
    [goldDic setObject:@(0) forKey:@"delete"];
    [goldDic setObject:currentTimeFor forKey:@"createAt"];
    goldStr = [NSString stringWithFormat:@"%@ %ld",message,(long)gold];
  }
  //入库操作，为0也入库
  [self saveDataWithDic:goldDic];
  CHCCommonInfoVO * userinfo = [CHCCommonInfoVO sharedManager];
  userinfo.gold = @(userinfo.gold.integerValue + [[goldDic objectForKey:@"goldCount"] integerValue]);
  NSDictionary * userDic = [userinfo fillVoDictionary];
  [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:HC_CommonInfo_UserData];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[NSNotificationCenter defaultCenter] postNotificationName:HCPG_GoldChangeNotice object:nil];
  
  if (![[goldDic objectForKey:@"goldCount"] isEqualToNumber:@(0)])
  {
    [CHCPGGoldGif showWithMessage:goldStr compeletion:^(BOOL compeleted, NSString *aDesc)
     {
       if (aCompeletion) {
         aCompeletion(compeleted,aDesc);
       }
     }];
  }
  else
  {
    if (aCompeletion)
    {
      aCompeletion(YES,nil);
    }
  }
  
}
- (NSInteger)apartDaysFromLoginDay:(NSNumber *)loginDay
{
  NSDate * nowDate = [NSDate date];
  NSDate * loginDate = [DateFomatterTool getDateFromTimeStampWithTimeStamp:[loginDay longLongValue]];
  NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSInteger flag = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
  NSDateComponents * components = [calendar components:flag fromDate:loginDate toDate:nowDate options:0];
  NSInteger days= components.day;
  return days;
}
- (NSInteger )obtainRandomGoldWithDict:(NSDictionary *)dict
{
  NSInteger random = 0;
  NSInteger min = [[dict objectForKey:@"min"] integerValue];;
  NSInteger max = [[dict objectForKey:@"max"] integerValue];
  NSInteger btw = max - min;
  if (btw == 0)
  {
    random = min;
  }
  else
  {
    int aRandom = arc4random()%(btw + 1);
    random = aRandom + min;
  }
  return random;
}
- (void)saveDataWithDic:(NSDictionary *)dict
{
  [self.iSqliteManager openDB];
  [self.iSqliteManager beginTransaction];
  NSMutableString * sqlStr = [NSMutableString stringWithString:@"INSERT OR REPLACE INTO "];
  [sqlStr appendFormat:@"%@",HCPG_GoldAccountTable];
  
  NSMutableString * keys = [NSMutableString stringWithString:@"("];
  NSMutableString * values = [NSMutableString stringWithString:@"("];
  [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)
  {
    [keys appendFormat:@"\"%@\",",key];
    [values appendFormat:@"%@,",obj];
  }];
  NSInteger  keyLength = [keys length];
  NSInteger valueLength = [values length];
  [keys deleteCharactersInRange:NSMakeRange(keyLength - 1, 1)];
  [values deleteCharactersInRange:NSMakeRange(valueLength - 1, 1)];
  
  [keys appendFormat:@")"];
  [values appendFormat:@")"];
  
  [sqlStr appendFormat:@"%@ VALUES",keys];
  [sqlStr appendFormat:@"%@",values];
  HCLog(@"goldINDb -------- %@",sqlStr);
  [self.iSqliteManager executeNotQuery:sqlStr];
  
  [self.iSqliteManager commitTransaction];
  [self.iSqliteManager closeDB];
}
#pragma mark - 获取用户金币数量
- (NSInteger)readUserGoldCount
{
  if (![CHCCommonInfoVO isLogin]) {
    return -1;
  }
  NSInteger goldCount = 0;
//  NSString * path = [CHCPGUserDataSycnController createUserPath];
//  NSString * tabPath = [NSString stringWithFormat:@"%@/%@",path,@"database.db"];
//  NSString * sql = @"SELECT *,sum(goldCount) FROM HCPG_GoldAccounts";
//  self.iSqliteManager = [[CHCSqliteManager alloc] initWithDataBasePath:tabPath];
//  NSArray * ary = [self.iSqliteManager executeQueryRtnAry:sql];
//  if (ary)
//  {
//    NSDictionary * dic = [ary firstObject];
//    if ([[dic objectForKey:@"sum(goldCount)"] isKindOfClass:[NSNull class]]) {
//      goldCount = 0;
//    }
//    else
//    {
//      goldCount = [[dic objectForKey:@"sum(goldCount)"] integerValue];
//    }
//  }
  goldCount = [[CHCCommonInfoVO sharedManager].gold integerValue];
  return goldCount;
}
- (void)reset
{
  NSString * tablePath = [NSString stringWithFormat:@"%@/%@",
                          [CHCPGUserDataSycnController createUserPath],
                          @"database.db"];
  self.iSqliteManager = [CHCSqliteManager creatSqliteManager:tablePath];
}

+ (void)destroy
{
  onceToken = 0;
  sharedManager = nil;
}

@end
