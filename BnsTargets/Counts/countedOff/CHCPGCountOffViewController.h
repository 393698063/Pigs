//
//  CHCPGCountOffViewController.h
//  Pigs
//
//  Created by HEcom on 16/7/22.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

@interface CHCPGCountOffViewController : CHCBaseViewController
- (instancetype)initWithDate:(NSNumber *)date;
@end

@interface CHCPGCountOffController : CHCBaseController
/**
 *  读取某天的简单日记
 *
 *  @param date 时间
 *
 *  @return 返回某天日记数组
 */
- (NSArray *)readOneDayData:(NSDate *)date;
/**
 *  read some historyDiary
 *
 *  @return return historyData;
 */
- (NSArray *)readSomeHistorySimpleDiaar;
/**
 *  保存数猪简单日记
 *
 *  @param data      简单日记数据
 *  @param tableName 简单日记表
 */
- (void)saveCountPigData:(NSDictionary *)data tableName:(NSString *)tableName;
@end
