//
//  CHCUpdateViewController.h
//  FoodYou
//
//  Created by Lemon-HEcom on 16/1/28.
//  Copyright © 2016年 AZLP. All rights reserved.
//
/**
 *  NSString * method = @"http://itunes.apple.com/lookup?id=968615456";
 *  NSString * method  = @"https://itunes.apple.com/cn/lookup?bundleId=com.hecom.xinyun.PIGS160411A";
 */

#import "CHCBaseViewController.h"

static NSString *const upDataMethod = @"https://itunes.apple.com/cn/lookup?bundleId=%@";

@interface CHCUpdateViewController : CHCBaseViewController

- (void)checkVersionUpdateCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;

@end


@interface CHCUpdateController : CHCBaseController

- (void)versionUpdateCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;

@end

@interface CHCUpdateModelHandler : CHCBaseModelHandler

@end

@interface CHCUpdateVO : CHCBaseVO
@property (nonatomic, strong) NSString *downlink;
@property (nonatomic, strong) NSNumber *force;
@property (nonatomic, strong) NSNumber *upgrade;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *desc;

@end