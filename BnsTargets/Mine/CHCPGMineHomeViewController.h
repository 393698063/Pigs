//
//  CHCPGMineHomeViewController.h
//  Pigs
//
//  Created by HEcom on 16/4/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

@interface CHCPGMineHomeViewController : CHCBaseViewController

@end

@class CHCPGAuthentifyVO;
@interface CHCPGMineHomeController : CHCBaseController
@property (nonatomic, strong) CHCPGAuthentifyVO * iAuthentifyVo;
@property (nonatomic, strong) NSMutableArray * iDataArray;

- (void)getViewData;
- (void)getMyCouponsInfoWithUid:(NSNumber *)uid
                     completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
- (void)getMyMoneyInfoWithUid:(NSNumber *)uid
                   completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
- (void)getAuthentifyWithUid:(NSNumber *)uid
                  completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
@end

@interface CHCPGAuthentifyVO : CHCBaseVO

@property (nonatomic, copy) NSString * bisName;
@property (nonatomic, copy) NSString * bisPhone;
@property (nonatomic, copy) NSString * certified;
@property (nonatomic, copy) NSString * farmAddress;
@property (nonatomic, copy) NSString * farmCity;
@property (nonatomic, copy) NSString * farmCounty;
@property (nonatomic, copy) NSString * farmProvince;
@property (nonatomic, copy) NSString * farmTownship;
@property (nonatomic, copy) NSString * iProvice;//省
@property (nonatomic, copy) NSString * iCity;//市
@property (nonatomic, copy) NSString * iCountry;//区／县
@property (nonatomic, copy) NSString * iTown;//乡镇／街道
@property (nonatomic, copy) NSString * iAddress;//详细地址
@property (nonatomic, copy) NSString * iManName;//业务员名称
@property (nonatomic, copy) NSString * iManPhone;//业务员手机号
@end

