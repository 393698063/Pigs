//
//  CHCPGCountsHomeViewController.h
//  Pigs
//
//  Created by HEcom on 16/4/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"
#import "CHCPGCountPigVO.h"

@interface CHCPGCountsHomeViewController : CHCBaseViewController

@end

@interface CHCPGCountsHomeController : CHCBaseController
@property (nonatomic, strong) CHCPGCountPigVO * iCountVo;
@property (nonatomic, strong) NSMutableArray * iPromotionAry;
- (NSArray *)readCountNum;
- (void)resetSqlManager;
- (void)saveCountPigData:(NSDictionary *)data tableName:(NSString *)tableName;
- (void)getPromotionCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
@end


