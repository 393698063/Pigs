//
//  CHCPGUserDataSycnViewController.m
//  Pigs
//
//  Created by HEcom on 16/5/6.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGUserDataSycnViewController.h"
#import "SynchronzeDef.h"
#import "CHCSqliteManager.h"
#import "CHCFileUtil.h"
#import "CHCStringUtil.h"
#import "CHCCommonInfoVO.h"

@interface CHCPGUserDataSycnViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) CHCPGUserDataSycnController * iController;
@property (nonatomic, copy) void(^syncUserDataCompletion)(BOOL isSucceed,NSString * aDes);
@end

@implementation CHCPGUserDataSycnViewController
@dynamic iController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
/*
 *同步金币数据
 */
- (void)sycnUserGoldDataCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
{
  self.syncUserDataCompletion = aCompletion;
  [self.iController syncUserGoldDataCompletion:^(BOOL isSucceed, NSString *aDes)
   {
     if (isSucceed)
     {
       if (aCompletion)
       {
         aCompletion(isSucceed,aDes);
       }
     }
     else
     {
       NSString * path = [[self.iController class] createUserPath];
       NSString * dicPath = [NSString stringWithFormat:@"%@/%@",path,@"updateRecord.plist"];
       NSDictionary * updateTimeDic = [NSDictionary dictionaryWithContentsOfFile:dicPath];
       NSDictionary * ruleDic = [updateTimeDic objectForKey:HCPG_GoldRulesTable];
       if ([[ruleDic objectForKey:kUpdateTime] isEqualToNumber:@(0)])
       {
         UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"数据同步失败,请重试!"
                                                          message:@"" delegate:self
                                                cancelButtonTitle:@"重试" otherButtonTitles:nil, nil];
         [alert show];
       }
       else
       {
         if (aCompletion) {
           aCompletion(YES,nil);
         }
       }
     }
   }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  __weak typeof(self)wSelf = self;
  [self sycnUserGoldDataCompletion:^(BOOL isSucceed, NSString *aDes)
  {
    if (isSucceed)
    {
      if (wSelf.syncUserDataCompletion)
      {
        wSelf.syncUserDataCompletion(isSucceed,aDes);
      }
      else
      {
        NSString * path = [[self.iController class] createUserPath];
        NSString * dicPath = [NSString stringWithFormat:@"%@/%@",path,@"updateRecord.plist"];
        NSDictionary * updateTimeDic = [NSDictionary dictionaryWithContentsOfFile:dicPath];
        NSDictionary * ruleDic = [updateTimeDic objectForKey:HCPG_GoldRulesTable];
        if ([[ruleDic objectForKey:kUpdateTime] isEqualToNumber:@(0)])
        {
          UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"数据同步失败,请重试!"
                                                           message:@"" delegate:self
                                                 cancelButtonTitle:@"重试" otherButtonTitles:nil, nil];
          [alert show];
        }
        else
        {
          if (wSelf.syncUserDataCompletion)
          {
            wSelf.syncUserDataCompletion(isSucceed,aDes);
          }
        }
      }
    }
  }];
}
/*
 *同步其它数据
 */
- (void)syncUserOtherDataCompletion:(void (^)(BOOL, NSString *))aCompletion
{
  [self.iController syncUserOtherDataCompletion:^(BOOL isSucceed, NSString *aDes) {
    if (aCompletion) {
      aCompletion(isSucceed,aDes);
    }
  }];
}
//上传用户数据
- (void)upLoadUserLocalData
{
  [self upLoadPriceDiaryCompletion:^(BOOL isSucceed, NSString *aDes) {
    
  }];
  [self upLoadUserGoldCompletion:^(BOOL isSucceed, NSString *aDes) {
    
  }];
  [self uploadSimplDiaryCompletion:^(BOOL isSucceed, NSString *aDes) {
    
  }];
}
/**
 *  上传金币纪录
 *
 *  @param aCompletion
 */
- (void)upLoadUserGoldCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  NSString * path = [[self.iController class] createUserPath];
  NSString * tablePath = [NSString stringWithFormat:@"%@/%@",path,@"database.db"];
  self.iController.iSqlManager = [CHCSqliteManager creatSqliteManager:tablePath];
  NSString * sqlStr = [NSString stringWithFormat:@"SELECT * FROM HCPG_GoldAccounts WHERE upFlag = 0"];
  NSArray * array = [self.iController.iSqlManager executeQueryRtnAry:sqlStr];
    [self.iController.iSqlManager openDB];
  NSString * upStr = [NSString stringWithFormat:@"UPDATE HCPG_GoldAccounts SET upFlag = 1 "];
  [self.iController.iSqlManager executeNotQuery:upStr];
  [self.iController.iSqlManager closeDB];
  if (array.count != 0)
  {
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
       NSDictionary * dict = obj;
       if ([dict[@"delete"] isEqualToString:@"0"]) {
         [dict setValue:@"false" forKey:@"delete"];
       }
     }];
    [self.iController upLoadGoldWithUid:[CHCCommonInfoVO sharedManager].iHCid
                                   gold:array completion:^(BOOL isSucceed, NSString *aDes)
     {
       if (!isSucceed) {
         [self.iController saveSyncDicData:array toTable:HCPG_GoldAccountTable];
       }
     }];
  }
}

/**
 *  上传报价日记
 *
 *  @param aCompletion 回调
 */
- (void)upLoadPriceDiaryCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  NSString * path = [[self.iController class] createUserPath];
  NSString * tablePath = [NSString stringWithFormat:@"%@/%@",path,@"database.db"];
  self.iController.iSqlManager = [CHCSqliteManager creatSqliteManager:tablePath];
  [self.iController.iSqlManager openDB];
  NSString * sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE upFlag = 0",HCPG_PriceDiaryTable];
  NSArray * array = [self.iController.iSqlManager executeQueryRtnAry:sqlStr];
  [self.iController.iSqlManager closeDB];
  if (array.count != 0)
  {
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
       NSDictionary * dict = obj;
       if ([dict[@"delete"] isEqualToString:@"0"]) {
         [dict setValue:@"false" forKey:@"delete"];
       }
     }];
    [self.iController upLoadPriceDiaryWithUid:[CHCCommonInfoVO sharedManager].iHCid
                                         data:array completion:^(BOOL isSucceed, NSString *aDes)
     {
       if (isSucceed) {
         if (aCompletion)
         {
           aCompletion(YES,nil);
         }
       }
     }];
  }
}
/**
 *  上传简单日记
 *
 *  @param aCompletion <#aCompletion description#>
 */
- (void)uploadSimplDiaryCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  NSString * path = [[self.iController class] createUserPath];
  NSString * tablePath = [NSString stringWithFormat:@"%@/%@",path,@"database.db"];
  self.iController.iSqlManager = [CHCSqliteManager creatSqliteManager:tablePath];
  [self.iController.iSqlManager openDB];
  NSString * sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE upFlag = 0",HCPG_SimpDiaryTable];
  NSArray * array = [self.iController.iSqlManager executeQueryRtnAry:sqlStr];
  [self.iController.iSqlManager closeDB];
  if (array.count != 0)
  {
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
       NSDictionary * dict = obj;
       if ([dict[@"delete"] isEqualToString:@"0"]) {
         [dict setValue:@"false" forKey:@"delete"];
       }
     }];
    [self.iController upLoadSimpleDiaryWithUid:[CHCCommonInfoVO sharedManager].iHCid
                                          data:array completion:^(BOOL isSucceed, NSString *aDes)
     {
       if (isSucceed) {
         if (aCompletion)
         {
           aCompletion(YES,nil);
         }
       }
     }];
  }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@interface CHCPGUserDataSycnController ()
@property (nonatomic, weak) CHCPGUserDataSycnViewController * iViewController;
@end

@implementation CHCPGUserDataSycnController
@dynamic iViewController;

- (instancetype)init
{
  if (self = [super init])
  {
    [self creatUserFile:[[self class] createUserPath]];
    NSString * aPath = [[self class] createUserPath];
    NSString * dataBaseName = [NSString stringWithFormat:@"%@/%@",aPath,@"database.db"];
    self.iSqlManager = [[CHCSqliteManager alloc] initWithDataBasePath:dataBaseName];
  }
  return self;
}
#pragma mark - 创建路径
+ (NSString *)createUserPath
{
  NSString *path = [CHCFileUtil getCachesPath];
  NSString *server = [NSString stringWithFormat:@"%@:%@",HC_UrlConnection_URL,HC_UrlConnection_Port];
  server = [CHCStringUtil urlEncodedString:server];
  
  NSString *uid = [[CHCCommonInfoVO sharedManager].iHCid stringValue];
  
  path = [NSString stringWithFormat:@"%@/PIG_UserData/%@/%@",path,server,uid];
  
  BOOL isExist = [CHCFileUtil dirExistsAtPath:path];
  if (!isExist)
  {
    [CHCFileUtil createPath:path];
  }
  HCLog(@"file local path:%@",path);
  return path;
}
#pragma mark 创建文件
- (void)creatUserFile:(NSString *)aPath
{
  NSString * dataPath = [NSString stringWithFormat:@"%@/%@",aPath,@"database.db"];
  if ([CHCFileUtil fileExistsAtPath:dataPath]) {
    if ([CHCFileUtil fileSizeAtPaht:dataPath] == 0) {
      [CHCFileUtil deleteAllFileAtPath:aPath];
    }
  }
  [self copyBundleFile:@"database.db" ToLocalPath:aPath];
  [self copyBundleFile:@"updateRecord.plist" ToLocalPath:aPath];
  [self copyBundleFile:@"viewLayoutConfig.plist" ToLocalPath:aPath];
}

- (void)copyBundleFile:(NSString *)aFileName ToLocalPath:(NSString *)aPath
{
  NSString *resource = [[aFileName componentsSeparatedByString:@"."] firstObject];
  NSString *type = [[aFileName componentsSeparatedByString:@"."] lastObject];
  
  NSString *localPath = [NSString stringWithFormat:@"%@/%@",aPath,aFileName];
  if (![CHCFileUtil fileExistsAtPath:localPath])
  {
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:resource
                                                          ofType:type];
    [CHCFileUtil copyItemAtPath:bundlePath
                         toPath:localPath
                          error:nil];
  }
}
#pragma mark - syncUserGoldData
- (void)syncUserGoldDataCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  NSString * path = [[self class] createUserPath];
  NSString * dicPath = [NSString stringWithFormat:@"%@/%@",path,@"updateRecord.plist"];
  NSDictionary * updateTimeDic = [NSDictionary dictionaryWithContentsOfFile:dicPath];
  __block BOOL isError = NO;
  dispatch_group_t userDataGroup = dispatch_group_create();
  
  dispatch_group_enter(userDataGroup);
  NSDictionary * ruleDic = [updateTimeDic objectForKey:HCPG_GoldRulesTable];
  [self synChGoldRulesWithUid:[CHCCommonInfoVO sharedManager].iHCid
                  lastGetTime:[ruleDic objectForKey:kUpdateTime] completion:^(BOOL isSucceed, NSString *aDes)
   {
     if (!isSucceed) {
       isError = YES;
     }
     dispatch_group_leave(userDataGroup);
   }];
  
  dispatch_group_enter(userDataGroup);
  NSDictionary * accountDic = [updateTimeDic objectForKey:HCPG_GoldAccountTable];
  [self syncHGoldAccountWithUid:[CHCCommonInfoVO sharedManager].iHCid
                     lastUpTime:[accountDic objectForKey:kUpdateTime]
                     completion:^(BOOL isSucceed, NSString *aDes)
  {
    if (!isSucceed) {
      isError = YES;
    }
    dispatch_group_leave(userDataGroup);
  }];
  
  dispatch_group_notify(userDataGroup, dispatch_get_main_queue(), ^
  {
    if (aCompletion) {
      aCompletion(!isError,nil);
    }
  });
}
//同步金币规则
- (void)synChGoldRulesWithUid:(NSNumber *)uid
                  lastGetTime:(NSNumber *)lastGetTime
                   completion:(void (^)(BOOL, NSString *))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_SynchGoldRules];
 //同步时间设为0，每次必同步
  NSDictionary * param = @{@"lastGetTime":@(0),@"uid":uid};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     NSError *aError = error;
     if(aFlag != 0 && !aError)
     {
       aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     
     if (aError)
     {
       if (aCompletion)
       {
         aCompletion(NO,[aError domain]);
       }
     }
     else
     {
       [wSelf saveSyncDicData:[aData objectForKey:@"goldRules"] toTable:HCPG_GoldRulesTable];
       [[wSelf class] writeUpdateTime:[aData objectForKey:@"serverTime"]
                               toPath:[[wSelf class] createUserPath] toType:HCPG_GoldRulesTable];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
/*
 *同步金币纪录
 */
- (void)syncHGoldAccountWithUid:(NSNumber *)uid lastUpTime:(NSNumber *)lastUpTime
                     completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_syncGoldAccounts];
  NSDictionary * param = @{@"lastUpTime":lastUpTime,@"uid":uid};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     NSError *aError = error;
     if(aFlag != 0 && !aError)
     {
       aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     
     if (aError)
     {
       if (aCompletion)
       {
         aCompletion(NO,[aError domain]);
       }
     }
     else
     {
       NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
       NSArray * dataAry = [wSelf deleteAlreadyExistWithData:[aData objectForKey:@"gold"]
                                                               andTable:HCPG_GoldAccountTable];
       [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
          NSMutableDictionary * adic = [NSMutableDictionary dictionaryWithDictionary:obj];
          [adic setObject:@(1) forKey:@"upFlag"];
          [ary addObject:adic];
        }];
       [wSelf saveSyncDicData:ary toTable:HCPG_GoldAccountTable];
       [[wSelf class] writeUpdateTime:[aData objectForKey:@"upTime"]
                               toPath:[[wSelf class] createUserPath] toType:HCPG_GoldAccountTable];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
#pragma mark - syncOtherUserData
/*
 *同步其它数据
 */
- (void)syncUserOtherDataCompletion:(void (^)(BOOL, NSString *))aCompletion
{
  NSString * path = [[self class] createUserPath];
  NSString * dicPath = [NSString stringWithFormat:@"%@/%@",path,@"updateRecord.plist"];
  NSDictionary * updateTimeDic = [NSDictionary dictionaryWithContentsOfFile:dicPath];
    __block BOOL isError = NO;
    dispatch_group_t userDataGroup = dispatch_group_create();
  NSDictionary * upDic = [updateTimeDic objectForKey:HCPG_PriceDiaryTable];
  dispatch_group_enter(userDataGroup);
  [self syncPriceDiaryWithUid:[CHCCommonInfoVO sharedManager].iHCid
                   lastUPTime:[upDic objectForKey:kUpdateTime]
                   completion:^(BOOL isSucceed, NSString *aDes)
   {
     dispatch_group_leave(userDataGroup);
     if (!isSucceed) {
       isError = YES;
     }
   }];
  
  NSDictionary * upSimDiary = [updateTimeDic objectForKey:HCPG_SimpDiaryTable];
  dispatch_group_enter(userDataGroup);
  [self syncSimpleDiaryWithUid:[CHCCommonInfoVO sharedManager].iHCid
                    lastUpTime:[upSimDiary objectForKey:kUpdateTime]
                    completion:^(BOOL isSucceed, NSString *aDes)
   {
     dispatch_group_leave(userDataGroup);
     if (!isSucceed) {
       isError = YES;
     }
   }];
  //add other request
  
  dispatch_group_notify(userDataGroup, dispatch_get_main_queue(), ^
  {
    if (aCompletion) {
      aCompletion(!isError,nil);
    }
  });
  
}
/*
 *同步报价日记
 */
- (void)syncPriceDiaryWithUid:(NSNumber *)uid lastUPTime:(NSNumber *)lastUpTime
                   completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_SyncPriceDiary];
  NSDictionary * param = @{@"lastUpTime":lastUpTime,@"uid":uid};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     NSError *aError = error;
     if(aFlag != 0 && !aError)
     {
       aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     
     if (aError)
     {
       if (aCompletion)
       {
         aCompletion(NO,[aError domain]);
       }
     }
     else
     {
       NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
       NSArray * dataAry = [aData objectForKey:@"data"];
       [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
          NSMutableDictionary * adic = [NSMutableDictionary dictionaryWithDictionary:obj];
          [adic setObject:@(1) forKey:@"upFlag"];
          [ary addObject:adic];
        }];
       [wSelf saveSyncDicData:ary toTable:HCPG_PriceDiaryTable];
       [[wSelf class] writeUpdateTime:[aData objectForKey:@"upTime"]
                               toPath:[[wSelf class] createUserPath]
                               toType:HCPG_PriceDiaryTable];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}

/**
 *  同步报数简单日记
 *
 *  @param uid         用户id
 *  @param lastUptime  上次更新时间
 *  @param aCompletion 完成回调
 */
- (void)syncSimpleDiaryWithUid:(NSNumber *)uid lastUpTime:(NSNumber *)lastUpTime
                    completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_SyncSimDiary];
  NSDictionary * param = @{@"lastUpTime":lastUpTime,@"uid":uid};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     NSError *aError = error;
     if(aFlag != 0 && !aError)
     {
       aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     
     if (aError)
     {
       if (aCompletion)
       {
         aCompletion(NO,[aError domain]);
       }
     }
     else
     {
       NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
       NSArray * dataAry = [wSelf deleteAlreadyExistWithData:[aData objectForKey:@"pigDiary"]
                                                    andTable:HCPG_SimpDiaryTable];
       [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
          NSMutableDictionary * adic = [NSMutableDictionary dictionaryWithDictionary:obj];
          [adic setObject:@(1) forKey:@"upFlag"];
          [ary addObject:adic];
        }];
       [wSelf saveSyncDicData:ary toTable:HCPG_SimpDiaryTable];
       [[wSelf class] writeUpdateTime:[aData objectForKey:@"upTime"]
                               toPath:[[wSelf class] createUserPath]
                               toType:HCPG_SimpDiaryTable];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
- (NSArray *)deleteAlreadyExistWithData:(NSArray *)array andTable:(NSString *)table
{
  NSMutableArray * rtnAccounts = [NSMutableArray arrayWithCapacity:1];
  [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
   {
     NSDictionary * dict = (NSDictionary *)obj;
     NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE id = %@",table,dict[@"id"]];
     NSArray * ary = [self.iSqlManager executeQueryRtnAry:sql];
     if (ary.count == 0) {
       [rtnAccounts addObject:obj];
     }
     else
     {
       NSMutableString * upSql = [NSMutableString stringWithFormat:@"UPDATE \"%@\" SET",table];
//       [upSql appendFormat:@" createAt = %@",dict[@"createAt"]];
//       [upSql appendFormat:@" delete = %@",dict[@"delete"]];
//       [upSql appendFormat:@" goldCount = %@",dict[@"goldCount"]];
//       [upSql appendFormat:@" reson = %@",dict[@"reson"]];
       [upSql appendFormat:@" upFlag = 1"];
       [upSql appendFormat:@" where id = %@",dict[@"id"]];
       [self.iSqlManager openDB];
       [self.iSqlManager beginTransaction];
       [self.iSqlManager executeNotQuery:upSql];
       [self.iSqlManager commitTransaction];
       [self.iSqlManager closeDB];
     }
   }];
  return rtnAccounts;
}
- (NSArray *)deleteAlreadyExistGoldAccountWithData:(NSArray *)array andTable:(NSString *)table
{
  NSMutableArray * rtnAccounts = [NSMutableArray arrayWithCapacity:1];
  

  [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
   {
     NSDictionary * dict = (NSDictionary *)obj;
     NSString * sql = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE id = %@",table,dict[@"id"]];
     NSArray * ary = [self.iSqlManager executeQueryRtnAry:sql];
     if (ary.count == 0) {
       [rtnAccounts addObject:obj];
     }
     else
     {
       NSMutableString * upSql = [NSMutableString stringWithFormat:@"UPDATE \"%@\" SET",table];
       [upSql appendFormat:@" createAt = %@",dict[@"createAt"]];
       [upSql appendFormat:@" delete = %@",dict[@"delete"]];
       [upSql appendFormat:@" goldCount = %@",dict[@"goldCount"]];
       [upSql appendFormat:@" reson = %@",dict[@"reson"]];
       [upSql appendFormat:@" upFlag = 1"];
       [upSql appendFormat:@" where id = %@",dict[@"id"]];
       [self.iSqlManager openDB];
       [self.iSqlManager beginTransaction];
       [self.iSqlManager executeNotQuery:upSql];
       [self.iSqlManager commitTransaction];
       [self.iSqlManager closeDB];
     }
   }];
  return rtnAccounts;
}
- (void)saveSyncDicData:(NSArray *)aDicAry
                toTable:(NSString *)tableName
{
  [self.iSqlManager openDB];
  [self.iSqlManager beginTransaction];
// chu li fan hui shu ju wei kong de wen ti
  if ([aDicAry isKindOfClass:[NSNull class]]) {
    return;
  }
  
  [aDicAry enumerateObjectsUsingBlock:
   ^(id obj, NSUInteger idx, BOOL *stop)
   {
     NSMutableString *updataSql = [NSMutableString stringWithString:@""];
     NSDictionary *data = obj;
     
     [updataSql appendFormat:@"INSERT OR REPLACE INTO "];
     [updataSql appendFormat:@"'%@'",tableName?:@""];
     [updataSql appendFormat:@" ("];
     
     NSMutableString *keys = [NSMutableString stringWithString:@""];
     NSMutableString *values = [NSMutableString stringWithString:@""];
     [data enumerateKeysAndObjectsUsingBlock:
      ^(id key, id obj, BOOL *stop)
      {
        [keys appendFormat:@"\"%@\" ,",key];
        [values appendFormat:@"\"%@\" ,",obj];
      }];
     [keys deleteCharactersInRange:NSMakeRange(keys.length-1, 1)];
     [values deleteCharactersInRange:NSMakeRange(values.length-1, 1)];
     
     [updataSql appendFormat:@"%@",keys];
     [updataSql appendFormat:@") VALUES ("];
     [updataSql appendFormat:@"%@",values];
     
     [updataSql appendFormat:@")"];
     
     [self.iSqlManager executeNotQuery:updataSql];
   }];
  
  [self.iSqlManager commitTransaction];
  [self.iSqlManager closeDB];
}

+ (BOOL)writeUpdateTime:(NSNumber *)aLastUpdateTime
                 toPath:(NSString *)path
                 toType:(NSString *)aType
{
  BOOL rtnValue = NO;
  
  path = [NSString stringWithFormat:@"%@/%@",path,@"updateRecord.plist"];
  NSDictionary * iUpdatetimeDic = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
  
  NSDictionary *typeDic = [iUpdatetimeDic objectForKey:aType];
  [typeDic setValue:aLastUpdateTime forKey:kUpdateTime];
  
  @synchronized(iUpdatetimeDic)
  {
    rtnValue = [iUpdatetimeDic writeToFile:path atomically:YES];
  }
  
  return rtnValue;
}

/**
 *  上传金币纪录
 *
 *  @param uid         用户id
 *  @param gold        金币纪录数组
 *  @param aCompletion 回调
 */
- (void)upLoadGoldWithUid:(NSNumber *)uid gold:(NSArray *)gold
               completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_UploadGold];
  NSDictionary * param = @{@"uid":uid,@"gold":gold};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     NSError *aError = error;
     if(aFlag != 0 && !aError)
     {
       aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     
     if (aError)
     {
       if (aCompletion)
       {
         aCompletion(NO,[aError domain]);
       }
     }
     else
     {
       [wSelf updataGoldRecordWithGoldIds:[aData objectForKey:@"goldIds"] golds:gold];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
- (void)updataGoldRecordWithGoldIds:(NSArray *)goldIds golds:(NSArray *)gold
{
  [goldIds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
  {
    NSDictionary * dict = [gold objectAtIndex:idx];
    [dict setValue:obj forKey:@"id"];
    [dict setValue:@(1) forKey:@"upFlag"];
    [dict setValue:@"0" forKey:@"delete"];
  }];
  [self saveSyncDicData:gold toTable:HCPG_GoldAccountTable];
}
/**
 *  上传报价日记
 *
 *  @param uid         用户id
 *  @param data        报价数据
 *  @param aCompletion 回调
 */- (void)upLoadPriceDiaryWithUid:(NSNumber *)uid data:(NSArray *)data
                     completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_UploadPriceDiary];
  NSDictionary * param = @{@"uid":uid,@"data":data};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     NSError *aError = error;
     if(aFlag != 0 && !aError)
     {
       aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     
     if (aError)
     {
       if (aCompletion)
       {
         aCompletion(NO,[aError domain]);
       }
     }
     else
     {
       [wSelf upDataPriceDiaryTableWithData:data];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
- (void)upDataPriceDiaryTableWithData:(NSArray *)data
{
  [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
   {
     NSDictionary * dict = (NSDictionary *)obj;
     [dict setValue:@(1) forKey:@"upFlag"];
   }];
  [self saveSyncDicData:data toTable:HCPG_PriceDiaryTable];
}

- (void)upLoadSimpleDiaryWithUid:(NSNumber *)uid
                            data:(NSArray *)data
                      completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_UploadSimDiary];
  NSDictionary * param = @{@"uid":uid,@"pigDiary":data};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     NSError *aError = error;
     if(aFlag != 0 && !aError)
     {
       aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     
     if (aError)
     {
       if (aCompletion)
       {
         aCompletion(NO,[aError domain]);
       }
     }
     else
     {
       [wSelf upDataSimpleDiaryTableWithData:data simpleDiary:[aData objectForKey:@"pigDiaryIds"]];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
- (void)upDataSimpleDiaryTableWithData:(NSArray *)data simpleDiary:(NSArray *)diaryIDS;
{
  [diaryIDS enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
   {
     NSDictionary * dict = [data objectAtIndex:idx];
     [dict setValue:obj forKey:@"id"];
     [dict setValue:@(1) forKey:@"upFlag"];
     [dict setValue:@"0" forKey:@"delete"];
   }];
  [self saveSyncDicData:data toTable:HCPG_SimpDiaryTable];
}
@end

@implementation CHCPGUserDataSycnModelHandler

- (void)shouldPostRequest:(CHCHttpRequestHandler *)aHandler
{

}
- (void)willFinishPostRrequest:(CHCHttpRequestHandler *)aHandler succeed:(BOOL)isSucceed
{
  
}
@end
