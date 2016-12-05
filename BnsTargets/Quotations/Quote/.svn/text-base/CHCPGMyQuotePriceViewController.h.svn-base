//
//  CHCPGMyQuotePriceViewController.h
//  Pigs
//
//  Created by wangbin on 16/5/18.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"
#import "CHCPGMyQuotePriceInfoVO.h"
@interface CHCPGMyQuotePriceViewController : CHCBaseViewController

@end

@interface CHCPGMyQuotePriceController : CHCBaseController

@property (nonatomic,strong) CHCPGMyQuotePriceInfoVO *myQuoteVO;
/**
 *  保存我的报价的数据源
 */
@property (nonatomic,strong) NSMutableArray *iPriceDataArray;
@property (nonatomic,assign) BOOL footerRefreshEnd;
/**
 *  获取我的报价保存在数据库的数据源
 *
 *  @param page        页数
 *  @param size
 *  @param aCompletion
 */
- (void)getDataWithPage:(NSInteger )page size:(NSInteger )size
             completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
@end

