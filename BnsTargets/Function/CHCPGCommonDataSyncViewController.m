//
//  CHCPGCommonDataSyncViewController.m
//  Pigs
//
//  Created by HEcom on 16/5/21.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGCommonDataSyncViewController.h"
#import "SynchronzeDef.h"
#import "CHCSqliteManager.h"
#import "CHCFileUtil.h"
#import "CHCStringUtil.h"
#import "CHCCommonInfoVO.h"

@interface CHCPGCommonDataSyncViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iLaunchImageView;
@property (nonatomic, strong) CHCPGCommonDataSyncController * iController;
@end

@implementation CHCPGCommonDataSyncViewController
@dynamic iController;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  NSString * path = @"";
  if ([UIScreen mainScreen].bounds.size.height == 480)
  {
    path = [[NSBundle mainBundle] pathForResource:@"LaunchImage4@2x" ofType:@"png"];
  }
  else if ([UIScreen mainScreen].bounds.size.height == 568 )
  {
    path = [[NSBundle mainBundle] pathForResource:@"LaunchImage5@2x" ofType:@"png"];
  }
  else if ([UIScreen mainScreen].bounds.size.height == 667)
  {
    path = [[NSBundle mainBundle] pathForResource:@"LaunchImage6@2x" ofType:@"png"];
  }
  else if ([UIScreen mainScreen].bounds.size.height)
  {
    path = [[NSBundle mainBundle] pathForResource:@"LaunchImage6p@2x" ofType:@"png"];
  }
  UIImage * image = [UIImage imageWithContentsOfFile:path];
  self.iLaunchImageView.image = image;
  [self syncPopularData];
}
/*
 *同步公共数据
 */
- (void)syncPopularData
{
  [self.iController syncPopularDataCompletion:^(BOOL isSucceed, NSString *aDes)
   {
     if (isSucceed)
     {
       [CHCCommonInfoVO sync];
       [[NSNotificationCenter defaultCenter] postNotificationName:HCPG_UserSyncPopularData object:@"YES"];
     }
     else
     {
       NSString * path = [[self.iController class] creatCommonPath];
       NSString * dicPath = [NSString stringWithFormat:@"%@/%@",path,@"updateRecord.plist"];
       NSDictionary * updateTimeDic = [NSDictionary dictionaryWithContentsOfFile:dicPath];
       NSDictionary * ruleDic = [updateTimeDic objectForKey:HCPG_PopularAreaTable];
       if ([[ruleDic objectForKey:kUpdateTime] isEqualToNumber:@(0)])
       {
         UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"数据同步失败,请重试!"
                                                          message:@""
                                                         delegate:self
                                                cancelButtonTitle:@"重试"
                                                otherButtonTitles:nil, nil];
         [alert show];
       }
       else
       {
         [CHCCommonInfoVO sync];
         [[NSNotificationCenter defaultCenter] postNotificationName:HCPG_UserSyncPopularData object:@"YES"];
       }
     }
   }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  [self syncPopularData];
}
/*
 *上传资讯统计信息
 */
- (void)upLoadInformationStatisticCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  NSString * path = [[self.iController class] creatCommonPath];
  NSString * tablePath = [NSString stringWithFormat:@"%@/%@",path,@"area.db"];
  self.iController.iSqlManager = [CHCSqliteManager creatSqliteManager:tablePath];
  [self.iController.iSqlManager openDB];
  NSString * sqlStr = [NSString stringWithFormat:@"SELECT informationId , enter, wxFriend,wxFriendCircle,dingding,statisticstype FROM HCPG_InfoStatistics WHERE uid = %@",
                       [CHCCommonInfoVO sharedManager].iHCid?:@(0)];
  NSArray * array = [self.iController.iSqlManager executeQueryRtnAry:sqlStr];
  [self.iController.iSqlManager closeDB];
  [self.iController upLoadInformationStatisticWithUid:[CHCCommonInfoVO sharedManager].iHCid?:@(0)
                                                 data:array
                                           completion:^(BOOL isSucceed, NSString *aDes)
   {
     if (aCompletion) {
       aCompletion(isSucceed,aDes);
     }
   }];
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

@interface CHCPGCommonDataSyncController ()

@end

@implementation CHCPGCommonDataSyncController
- (instancetype)init
{
  if (self = [super init])
  {
    [self creatCommonFile:[CHCPGCommonDataSyncController creatCommonPath]];
    NSString * aPath = [[self class] creatCommonPath];
    NSString * dataBaseName = [NSString stringWithFormat:@"%@/%@",aPath,@"area.db"];
    self.iSqlManager = [[CHCSqliteManager alloc] initWithDataBasePath:dataBaseName];
  }
  return self;
}
#pragma mark - 创建路径
+ (NSString *)creatCommonPath
{
  NSString *path = [CHCFileUtil getCachesPath];
  NSString *server = [NSString stringWithFormat:@"%@:%@",HC_UrlConnection_URL,HC_UrlConnection_Port];
  server = [CHCStringUtil urlEncodedString:server];
  
  path = [NSString stringWithFormat:@"%@/PIG_UserData/%@",path,server];
  
  BOOL isExist = [CHCFileUtil dirExistsAtPath:path];
  if (!isExist)
  {
    [CHCFileUtil createPath:path];
  }
  HCLog(@"file local path:%@",path);
  return path;
}
#pragma mark 创建文件
- (void)creatCommonFile:(NSString *)aPath
{
  NSString * dbPath = [NSString stringWithFormat:@"%@/%@",aPath,@"area.db"];
  if ([CHCFileUtil fileSizeAtPaht:dbPath] == 0) {
    [CHCFileUtil deleteAllFileAtPath:aPath];
  }
  [self copyBundleFile:@"area.db" ToLocalPath:aPath];
  [self copyBundleFile:@"updateRecord.plist" ToLocalPath:aPath];
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
#pragma mark - syncCommonData
- (void)syncPopularDataCompletion:(void (^)(BOOL isSucceed, NSString * aDesc))aCompletion
{
  [[CHCSpinnerView sharedSpinnerView] showInWindowsIsFullScreen:YES
                                                withShowingText:NSLocalizedStringFromTable(@"Spinner_loading", @"Controller_MessageView", nil)];
  __block BOOL isError = NO;
  dispatch_group_t syncCommonService = dispatch_group_create();
  dispatch_group_enter(syncCommonService);
  [self syncInfoTagCompletion:^(BOOL isSucceed, NSString *aDes)
   {
     if (!isSucceed) {
       isError = YES;
     }
     dispatch_group_leave(syncCommonService);
   }];
  
  dispatch_group_enter(syncCommonService);
  [self syncPopularAreaDataCompletion:^(BOOL isSucceed, NSString *aDes)
   {
     if (!isSucceed) {
       isError = YES;
     }
     dispatch_group_leave(syncCommonService);
   }];
  dispatch_group_notify(syncCommonService, dispatch_get_main_queue(), ^
                        {
                          [[CHCSpinnerView sharedSpinnerView]hiddenSpinnerView];
                          if (aCompletion) {
                            aCompletion(!isError,nil);
                          }
                        });
}
#pragma mark - 同步标签
- (void)syncInfoTagCompletion:(void (^)(BOOL isSucceed, NSString * aDesc))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString *path = [[wSelf class] creatCommonPath];
  path = [NSString stringWithFormat:@"%@/%@",path,@"updateRecord.plist"];
  NSDictionary * iUpdatetimeDic = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
  NSDictionary * lastDic = [iUpdatetimeDic objectForKey:HCPG_PopularAreaTable];
  NSString * lastUpdateTime = (![[lastDic objectForKey:kUpdateTime] isEqualToNumber:@(0)])? [lastDic objectForKey:kUpdateTime]: @(0);
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_SynInfoTag];
  NSDictionary * param = @{@"lastUpTime":lastUpdateTime};
  [self.iModelHandler postMethod:method
                      parameters:param
                      completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
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
       [wSelf saveSyncDicData:[aData objectForKey:@"tags"] toTable:HCPG_TagInfoTable];
       [[wSelf class] writeUpdateTime:[aData objectForKey:@"upTime"]
                               toPath:[[wSelf class] creatCommonPath]  toType:HCPG_TagInfoTable];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
#pragma mark - 同步区域
- (void)syncPopularAreaDataCompletion:(void (^)(BOOL isSucceed, NSString * aDesc))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString *path = [[self class] creatCommonPath];
  path = [NSString stringWithFormat:@"%@/%@",path,@"updateRecord.plist"];
  NSDictionary * iUpdatetimeDic = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
  NSDictionary * lastDic = [iUpdatetimeDic objectForKey:HCPG_PopularAreaTable];
  NSString * lastUpdateTime = (![[lastDic objectForKey:kUpdateTime] isEqualToNumber:@(0)])? [lastDic objectForKey:kUpdateTime]: @(0);
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_SynPopularizeArea];
  NSDictionary * param = @{@"lastUpTime":lastUpdateTime};
  [self.iModelHandler postMethod:method
                      parameters:param
                      completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
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
       [wSelf saveSyncDicData:[aData objectForKey:@"popularize"] toTable:HCPG_PopularAreaTable];
       [[wSelf class] writeUpdateTime:[aData objectForKey:@"upTime"]
                               toPath:[[wSelf class] creatCommonPath]  toType:HCPG_PopularAreaTable];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
  
}
- (void)saveSyncDicData:(NSArray *)aDicAry
                toTable:(NSString *)tableName
{
  [self.iSqlManager openDB];
  [self.iSqlManager beginTransaction];
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
/*
 *上传资讯统计信息
 */
- (void)upLoadInformationStatisticWithUid:(NSNumber *)uid data:(NSArray *)data
                               completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_UploadService,HCPG_UploadStatistics];
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
       [wSelf deleteUploadedData];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
- (void)deleteUploadedData
{
  [self.iSqlManager openDB];
  [self.iSqlManager beginTransaction];
  NSString * sqlStr = [NSString stringWithFormat:@"delete FROM HCPG_InfoStatistics WHERE uid = %@",
                       [CHCCommonInfoVO sharedManager].iHCid?:@(0)];
  [self.iSqlManager executeNotQuery:sqlStr];
  [self.iSqlManager commitTransaction];
  [self.iSqlManager closeDB];
}
@end


@implementation CHCPGCommonDataSyncModelHandler

- (void)shouldPostRequest:(CHCHttpRequestHandler *)aHandler
{
  
}
- (void)willFinishPostRrequest:(CHCHttpRequestHandler *)aHandler succeed:(BOOL)isSucceed
{
  
}

@end