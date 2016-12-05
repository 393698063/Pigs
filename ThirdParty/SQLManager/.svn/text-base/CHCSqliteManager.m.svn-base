//
//  CHCSqliteManager.m
//  NewHopeForAgency
//
//  Created by HEcom-PC on 15/7/25.
//  Copyright (c) 2015年 Hecom. All rights reserved.
//

#import "CHCSqliteManager.h"

@implementation CHCSqliteManager
@synthesize iDataBase;

+ (CHCSqliteManager *)creatSqliteManager:(NSString *)aWholePath
{
  CHCSqliteManager *aManager = [[CHCSqliteManager alloc]initWithDataBasePath:aWholePath];
  return aManager;
}

+ (CHCSqliteManager *)creatSqliteManager:(NSString *)aDBPath withDBName:(NSString *)aDBName
{
  NSString *path = [NSString stringWithFormat:@"%@/%@",aDBPath,aDBName];
  CHCSqliteManager *aManager = [[CHCSqliteManager alloc]initWithDataBasePath:path];
  return aManager;
}

#pragma mark init & delloc
- (instancetype)initWithFMDB:(FMDatabase *)aFMDataBase
{
  self = [super init];
  if (self)
  {
    self.iDataBase = aFMDataBase;
  }
  return self;
}

- (instancetype)initWithDataBasePath:(NSString *)aPath
{
  FMDatabase *aFMDB = [[FMDatabase alloc]initWithPath:aPath];
  self = [self initWithFMDB:aFMDB];
  return self;
}

- (void)dealloc
{
  [self.iDataBase close];
}

#pragma mark open&close
- (BOOL)openDB
{
  return [self.iDataBase open];
}

- (BOOL)closeDB
{
  return [self.iDataBase close];
}

#pragma mark transaction
- (BOOL)beginTransaction
{
  return [self.iDataBase beginTransaction];
}

- (BOOL)commitTransaction
{
  return [self.iDataBase commit];
}

#pragma mark 执行查询语句
- (FMResultSet *)executeQuery:(NSString *)aQuerySQL
{
  FMResultSet *rtnValue = [self.iDataBase executeQuery:aQuerySQL];
  return rtnValue;
}

#pragma mark 执行非查询语句
- (BOOL)executeNotQuery:(NSString *)aNotQuerySQL
{
  BOOL result = [self executeNotQuery:aNotQuerySQL withResultBlock:nil];
  return result;
}

- (BOOL)executeNotQuery:(NSString *)sql
        withResultBlock:(int (^)(NSDictionary *resultDic))block
{
  BOOL result = NO;
  if (block)
  {
    result = [self.iDataBase executeStatements:sql
                               withResultBlock:
              ^int(NSDictionary *resultsDictionary)
              {
                return block(resultsDictionary);
              }];
  }
  else
  {
    result = [self.iDataBase executeStatements:sql
                               withResultBlock:nil];
  }
  
  return result;
}


- (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments
{
  BOOL result = NO;
  result = [self.iDataBase executeUpdate:sql
                 withParameterDictionary:arguments];
  return result;
}

#pragma mark 执行非查询语句返回结果
- (NSArray *)executeQueryRtnAry:(NSString *)aQuerySQL
{
  NSMutableArray *rtnAry = [NSMutableArray arrayWithCapacity:1];
  
  [self openDB];
  FMResultSet *resSet = [self executeQuery:aQuerySQL];
  while ([resSet next])
  {
    [rtnAry addObject:[resSet resultDictionary]];
  }
  [self closeDB];
  
  return rtnAry;
}
@end
