//
//  CHCPGQuationDataCacheManager.m
//  Pigs
//
//  Created by wangbin on 16/6/15.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGQuationDataCacheManager.h"
#import "CHCPGCommonDataSyncViewController.h"
#import "CHCSqliteManager.h"
#import "SynchronzeDef.h"
#import "AFNetworking.h"
@interface CHCPGQuationDataCacheManager()

//@property (nonatomic,strong) CHCSqliteManager *iSqliteManager;

@end

@implementation CHCPGQuationDataCacheManager
DEFINE_SINGLETON_FOR_CLASS(CHCPGQuationDataCacheManager)

static  CHCSqliteManager *_iSqliteManager;

+ (void)initialize
{
  NSString * tablePath = [NSString stringWithFormat:@"%@/%@",
                              [CHCPGCommonDataSyncController creatCommonPath],
                              @"area.db"];
    _iSqliteManager = [CHCSqliteManager creatSqliteManager:tablePath];
  [_iSqliteManager openDB];
  [_iSqliteManager beginTransaction];
  NSMutableString *sqlStr=[NSMutableString stringWithString:@"CREATE TABLE IF NOT EXISTS"];
  [sqlStr appendFormat:@" %@",HCPG_QuationDataCacheTable];
  [sqlStr appendFormat:@"%@",@"( id integer PRIMARY KEY, QuationDatas text NOT NULL, quationTag integer NOT NULL,isScrollData integer NOT NULL,idStr text);"];
  [_iSqliteManager executeNotQuery:sqlStr];
  [_iSqliteManager commitTransaction];
  [_iSqliteManager closeDB];

}

+ (void)saveQuationDataCaches:(NSArray *)dataCaches withIsScrollData:(int)isScroll andQuationTag:(int)quationtag
{
  [_iSqliteManager openDB];
  NSString *deleteSql=[NSString stringWithFormat:@"delete from %@ where isScrollData=%d and quationtag=%d",HCPG_QuationDataCacheTable,isScroll,quationtag];
  [_iSqliteManager executeNotQuery:deleteSql];
  for (NSDictionary *quationInfo in dataCaches) {
    NSData * data = [NSJSONSerialization dataWithJSONObject:quationInfo options:0 error:nil];
    NSString * quationInfoData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *insertSql=[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (QuationDatas, quationTag,idStr,isScrollData) VALUES (\'%@\', \'%@\',0,\'%d\');",
                         HCPG_QuationDataCacheTable,quationInfoData,quationInfo[@"tag"],isScroll];
    [_iSqliteManager executeNotQuery:insertSql];
  }
  [_iSqliteManager closeDB];
  
}

+ (NSArray *)getQuationDataCacheWithParam:(NSDictionary *)param
{
  
  [_iSqliteManager openDB];
  int Tag=[param[@"quationTag"] intValue];
  int isScroll=[param[@"isScroll"] intValue];
  NSString *quationTag=[NSString stringWithFormat:@"%d",Tag];
  NSString *selectSql=[NSString stringWithFormat:@"Select QuationDatas  From %@ where quationTag=%@  and isScrollData=%d ORDER BY  id DESC LIMIT 10;",
                       HCPG_QuationDataCacheTable,quationTag,isScroll];
  NSArray *array=[_iSqliteManager executeQueryRtnAry:selectSql];
  NSMutableArray *DataCacheArray=[NSMutableArray array];
  
  for (NSDictionary *dic in array) {
    NSString *DataString=dic[@"QuationDatas"];
    NSData * data = [DataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [DataCacheArray addObject:dict];
  }
  [_iSqliteManager closeDB];
  return DataCacheArray;

}
@end
