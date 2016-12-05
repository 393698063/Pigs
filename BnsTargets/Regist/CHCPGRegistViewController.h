//
//  CHCPGRegistViewController.h
//  Pigs
//
//  Created by HEcom on 16/4/20.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

@interface CHCPGRegistViewController : CHCBaseViewController
- (instancetype)initWithMobile:(NSString *)mobile;
@end

@class CHCPGRegistVO;
@interface CHCPGRegistController : CHCBaseController
- (void)implenentRegistWithRegistVo:(CHCPGRegistVO *)registVo
                         completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
- (void)implementRegistWithMobile:(NSString *)mobile
                          useName:(NSString *)userName
                         isFarmer:(NSString *)isFarmer
                     farmerMobile:(NSString *)farmerMobile
                recommendTelphone:(NSString *)recommendTelphone
                         deviceId:(NSString *)deviceId
                       completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;

- (void)queryTablesWithUid:(NSNumber *)uid
                    tables:(NSArray *)tables
                completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
@end



@interface CHCPGRegistModelHandler : CHCBaseModelHandler

@end

@interface CHCPGRegistVO : CHCBaseVO
@property (nonatomic , copy) NSString * mobile;
@property (nonatomic , copy) NSString * userName;
@property (nonatomic , copy) NSString * deviceId;
@property (nonatomic , copy) NSString * isFarmer;
@property (nonatomic , copy) NSString * farmerMobile;
@property (nonatomic , copy) NSString * recommendTelphone;
@property (nonatomic , copy) NSString * locaProvince;
@property (nonatomic , copy) NSString * locaCity;
@property (nonatomic , copy) NSString * locaCounty;
@property (nonatomic , copy) NSString * locaTownship;
@property (nonatomic , copy) NSString * longitude;
@property (nonatomic , copy) NSString * latitude;
@property (nonatomic , copy) NSString * farmProvince;
@property (nonatomic , copy) NSString * farmCity;
@property (nonatomic , copy) NSString * farmCounty;
@property (nonatomic , copy) NSString * farmVillage;
@property (nonatomic , copy) NSString * farmAddress;
@end
