//
//  CHCPGMineSelfInfoViewController.h
//  Pigs
//
//  Created by HEcom on 16/4/26.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

@interface CHCPGMineSelfInfoViewController : CHCBaseViewController
- (instancetype)initWithChangeBlock:(void(^)(BOOL isChanged))aChangeBlock;
@end

@interface CHCPGMineSelfInfoController : CHCBaseController
-(void)upload:(CHCHttpFilePartVO *)aVO
   completion:(void (^)(NSError *, NSString *))aBlock;
-(void)updateUserPhoto:(NSString *)aPath
            completion:(void (^)(BOOL, NSError *))aBlock;
@end
