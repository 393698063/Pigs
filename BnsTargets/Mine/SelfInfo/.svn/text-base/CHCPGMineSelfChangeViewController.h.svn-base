//
//  CHCPGMineSelfChangeViewController.h
//  Pigs
//
//  Created by HEcom on 16/4/27.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"
typedef NS_ENUM(NSInteger,EHCChangeType)
{
  kChangeTypeName,
  kChangeTypeNick
};
@interface CHCPGMineSelfChangeViewController : CHCBaseViewController
- (instancetype)initWtihChangeType:(EHCChangeType)type
                              name:(NSString *)name
                        completion:(void(^)(BOOL isCompleted))aCompletion;
@end


@interface CHCPGMineSelfChangeController : CHCBaseController
- (void)changeUserInfoWithUid:(NSNumber *)uid
                         name:(NSString *)name
                     niceName:(NSString *)nickName
                   completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
@end