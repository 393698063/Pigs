//
//  LocationManager.h
//  Pigs
//
//  Created by HEcom on 16/4/15.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "CHCBaseVO.h"

@interface LocationManager : CHCBaseVO
@property (nonatomic, copy) AMapLocatingCompletionBlock completion;
@property (nonatomic, copy) NSString * iProvice;
@property (nonatomic, copy) NSString * iCity;
@property (nonatomic, copy) NSString * iCounty;
@property (nonatomic, copy) NSString * iTownship;
@property (nonatomic, copy) NSString * iLatitude;
@property (nonatomic, copy) NSString * iLongitude;

DEFINE_SINGLETON_FOR_HEADER(LocationManager)

/*
 *返回地理反编码
 */
- (void)gecodeLocationCompeletionBlock:(AMapLocatingCompletionBlock)completion;

/*
 *直接返回经纬度
 */
- (void)loacationCompeletionBlock:(AMapLocatingCompletionBlock)completion;
@end
