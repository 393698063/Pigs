//
//  CHCPGAuthentifyViewController.h
//  Pigs
//
//  Created by HEcom on 16/4/28.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"
#import "CHCFreshTableViewController.h"
#import "BnsProfessorDef.h"

@class CHCPGAuthentifyVO;
@interface CHCPGAuthentifyViewController : CHCFreshTableViewController
- (instancetype)initWithAuthentify:(CHCPGAuthentifyVO *)iAuthentifyVo;
- (void)freshView;
@end

@class CHCPGSpportVo;
@interface CHCPGAuthentifyController : CHCFreshTableController
@property (nonatomic, strong) CHCPGSpportVo * iExpertVo;
@property (nonatomic, strong) CHCPGSpportVo * iSalemanVo;

- (void)getSupportWithUid:(NSNumber *)uid
               completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
@end

@interface CHCPGSpportVo : CHCBaseVO
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * telphone;
@end