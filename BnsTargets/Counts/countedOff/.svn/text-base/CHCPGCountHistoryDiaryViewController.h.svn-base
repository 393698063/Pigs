//
//  CHCPGCountHistoryDiaryViewController.h
//  Pigs
//
//  Created by HEcom on 16/7/23.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

@interface CHCPGCountHistoryDiaryViewController : CHCBaseViewController

@end

@interface CHCPGCountHistoryDiaryController : CHCBaseController
@property (nonatomic, strong) NSNumber * iPage;
@property (nonatomic, strong) NSNumber * iSize;
@property (nonatomic, strong) NSMutableArray * iDateFormatAry;
@property (nonatomic, strong) NSMutableArray * iDateStrAry;
- (void)readHistoryDataWithPage:(NSNumber *)page
                           size:(NSNumber *)size
                    compeletion:(void (^)(BOOL isSucceed, NSString * aDesc,BOOL isMore))aCompeltion;
@end