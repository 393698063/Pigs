//
//  CHCPGPriceTrendViewController.h
//  Pigs
//
//  Created by wangbin on 16/5/24.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"
#import "CHCQuatationPriceListInfoVO.h"

@protocol trendSelectCityDelegate <NSObject>

- (void)getTrendSelectCity:(NSString *)city andProvince:(NSString *)province;

@end

@interface CHCPGPriceTrendViewController : CHCBaseViewController

@property (nonatomic,copy) NSString *cityString;
@property (nonatomic,copy) NSString *provinceString;
@property (nonatomic,weak) id<trendSelectCityDelegate>delegate;
@end



@interface CHCPGPriceTrendController : CHCBaseController

@property (nonatomic,strong) NSMutableArray * iGloalDataArray;

@property (nonatomic,strong) NSMutableArray * iCityDataArray;

@property (nonatomic,strong) NSMutableArray *iLastDataArray;

@property (nonatomic,strong) NSMutableArray *iThisDataArray;
@property (nonatomic,strong) NSDictionary *param;
/**
 *  按月获取价格接口
 *
 *  @param uid         用户名
 *  @param city        所在城市
 *  @param page        页数
 *  @param aCompletion 回调
 */

- (void)getMouthAreaPriceListWithUid:(NSNumber *)uid
                      andCurrentCity:(NSString *)city
                     CurrentProvince:(NSString *)province
                            WithPage:(int)page
                          completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;

/**
 *  按年获取价格接口
 *
 *  @param uid         用户名
 *  @param city        城市
 *  @param page        页数
 *  @param aCompletion 回调
 */
- (void)getYearAreaPriceListWithUid:(NSNumber *)uid
                      andCurrentCity:(NSString *)city
                     CurrentProvince:(NSString *)province
                            WithPage:(int)page
                          completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
@end