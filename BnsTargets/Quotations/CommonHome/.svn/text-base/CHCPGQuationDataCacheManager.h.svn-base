//
//  CHCPGQuationDataCacheManager.h
//  Pigs
//
//  Created by wangbin on 16/6/15.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
@interface CHCPGQuationDataCacheManager : NSObject

DEFINE_SINGLETON_FOR_HEADER(CHCPGQuationDataCacheManager)

/**
 *  获取缓存数据
 *
 *  @param param 请求参数
 *
 *  @return 缓存数组
 */
+ (NSMutableArray *)getQuationDataCacheWithParam:(NSDictionary *)param;
/**
 *  保存缓存数据
 *
 *  @param dataCaches 需要保存的数组
 */

+ (void)saveQuationDataCaches:(NSArray *)dataCaches
             withIsScrollData:(int)isScroll
                andQuationTag:(int)quationtag;

@end
