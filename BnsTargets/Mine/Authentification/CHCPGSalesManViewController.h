//
//  CHCPGSalesManViewController.h
//  Pigs
//
//  Created by HEcom on 16/4/29.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

@class CHCPGAuthentifyVO;
@interface CHCPGSalesManViewController : CHCBaseViewController
- (instancetype)initWithAuthentifyVo:(CHCPGAuthentifyVO *)iAuthentifyVo;
@end

@interface CHCPGSalesManController : CHCBaseController
- (void)authentifyWithAuthentifyVo:(CHCPGAuthentifyVO *)authentigyVo
                        completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;

@end
