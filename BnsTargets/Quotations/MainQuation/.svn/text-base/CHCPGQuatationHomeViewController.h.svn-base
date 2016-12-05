//
//  CHCPGQuatationHomeViewController.h
//  Pigs
//
//  Created by HEcom on 16/4/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"
#import "CHCQuationPriceInfoVO.h"
#import "LocationManager.h"
#import "CHCCommonInfoVO.h"
#import "CHCQuationInfoVO.h"
#import "CHCQuationTableInfoVO.h"
#import "CHCPGQuationDataCacheManager.h"
#import "CHCPGUserDataSycnViewController.h"
@interface CHCPGQuatationHomeViewController : CHCBaseViewController
@property (nonatomic,strong) UIScrollView *iGlobalScrollView;
@end


@interface CHCPGQuatationHomeController : CHCBaseController

/**
 *  轮播图的图片数组源
 */
@property (nonatomic,strong) NSMutableArray *imageGroups;
/**
 *  轮播图的标题数据源
 */
@property (nonatomic,strong) NSMutableArray *scrollTitleArray;
/**
 *  轮播图的数据源
 */

@property (nonatomic,strong) NSMutableArray *scrollDataArray;
@property (nonatomic,strong) NSMutableArray *scrollDataSource;
/**
 *  咨询列表的数据源
 */

@property (nonatomic,strong) NSMutableArray *tableDataArray;
@property (nonatomic,strong) NSMutableArray *tableDataSource;

/**
   轮播图的数据源
 */
@property (nonatomic,strong) CHCQuationInfoVO *quationinfoVO;
/**
 *  tableview的资讯的数据模型
 */
@property (nonatomic,strong) CHCQuationTableInfoVO *tableInfoVO;
/**
 *  行情价格面板的数据模型
 */
@property (nonatomic,strong) CHCQuationPriceInfoVO *priceInfoVO;
/**
 *  行情的模型的数组
 */
@property (nonatomic,strong) NSMutableArray *priceDataArray;
/**
 *  判断下拉刷新的时候是否是最后一页
 */
@property (nonatomic,assign) BOOL footerRefreshEnd;
/**
 *  获取的猪场地址
 */
@property (nonatomic,copy)  NSString *area;

/**
 *  地理定位位置信息
 */

@property (nonatomic,copy) NSString *iAddressArr;
/**
 *  获取文章列表
 *
 *  @param page        加载的页数
 *  @param firstID     第一个ID
 *  @param tag         标签栏索引
 *  @param aCompletion 回调
 */

- (void)readUserGoldData;

- (void)getArticleInfoWithPage:(NSNumber *)page
                   withFirstId:(NSNumber *)firstID
                 andArticleTag:(NSNumber *)tag
                    completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;



- (void)getLocation;

/**
 *  获得地区动态价格
 *
 *  @param page        页数
 *  @param aCompletion 回调
 */

- (void)getAreaDynamicPriceInfoWithCity:(NSString *)city
                        completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;

/**
 *  获取动态价格
 *
 *  @param uid         用户名
 *  @param aCompletion 回调
 */

- (void)getDynamicPriceInfoWithUid:(NSNumber *)uid
                        completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;


@end
