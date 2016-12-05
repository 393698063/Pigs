//
//  CHCPGMineSuggestViewController.h
//  Pigs
//
//  Created by HEcom on 16/4/28.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

@interface CHCPGMineSuggestViewController : CHCBaseViewController

@end

@interface CHCPGMineSuggestController : CHCBaseController
- (void)submitSuggestWithUid:(NSNumber *)uid
                     suggest:(NSString *)suggest
                  completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
@end