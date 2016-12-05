//
//  CHCPGLoginViewController.h
//  Pigs
//
//  Created by HEcom on 16/4/13.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

@interface CHCPGLoginViewController : CHCBaseViewController

@end


@interface CHCPGLoginController : CHCBaseController
/*
 *获取验证码
 */
- (void)getVerifyCodeWithMobilPhone:(NSString *)mobile
                         completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
/*
 * 验证验证码
 */
- (void)validityVerifyCodeWithMobil:(NSString *)mobile
                         verifyCode:(NSString *)verifyCode
                         completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
/*
 *登录
 */
- (void)loginWithMobile:(NSString *)mobile
               deviceId:(NSString *)deviceId
             completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
@end

@interface CHCPGLoginModelHandler : CHCBaseModelHandler

@end