//
//  CHCSqliteManager.h
//  NewHopeForAgency
//
//  Created by HEcom-PC on 15/7/25.
//  Copyright (c) 2015年 Hecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface CHCSqliteManager : NSObject
{
  FMDatabase *iDataBase;
}

@property (nonatomic, strong)FMDatabase *iDataBase;


+ (CHCSqliteManager *)creatSqliteManager:(NSString *)aWholePath;
+ (CHCSqliteManager *)creatSqliteManager:(NSString *)aDBPath
                              withDBName:(NSString *)aDBName;

- (instancetype)initWithFMDB:(FMDatabase *)aFMDataBase;
- (instancetype)initWithDataBasePath:(NSString *)aPath;

- (FMResultSet *)executeQuery:(NSString *)aQuerySQL;
- (NSArray *)executeQueryRtnAry:(NSString *)aQuerySQL;


- (BOOL)executeNotQuery:(NSString *)aNotQuerySQL;

- (BOOL)executeNotQuery:(NSString *)sql
        withResultBlock:(int (^)(NSDictionary *resultDic))block;

- (BOOL)beginTransaction;
- (BOOL)commitTransaction;

- (BOOL)openDB;
- (BOOL)closeDB;
@end
