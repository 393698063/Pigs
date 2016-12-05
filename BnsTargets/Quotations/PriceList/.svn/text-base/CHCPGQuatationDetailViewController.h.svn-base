//
//  CHCPGQuatationDetailViewController.h
//  Pigs
//
//  Created by wangbin on 16/5/9.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define MAIN_Screen [[UIScreen mainScreen]bounds].size
#import "CHCBaseViewController.h"
#import "CHCQuationInfoVO.h"
#import "CHCQuatationPriceListInfoVO.h"
#import "CHCQuationPriceInfoVO.h"

@protocol selectCityPriceListDelegate <NSObject>

- (void)getSelectRegionCity:(NSString *)selectCity;

@end

@interface CHCPGQuatationDetailViewController : CHCBaseViewController

@property (nonatomic,strong) CHCQuationInfoVO *quationinfoVO;
@property (nonatomic,copy) NSString *iCityString;
@property (nonatomic,copy) NSString *priceUnitString;
@property (nonatomic,copy) NSString *changeUnitString;
@property (nonatomic,assign) int nameTag;


@property (nonatomic,weak)id<selectCityPriceListDelegate>delegate;
- (void)createTableViewHeaderView;
@end


@interface CHCPGQuatationDetailController : CHCBaseController


@property (nonatomic,strong) NSMutableArray *nameArray;//保存价格列表的品种
@property (nonatomic,strong) NSMutableArray *unitArray;//保存价格列表的单位
@property (nonatomic,strong) NSMutableArray *entityValueArray;//保存各个品种的价格
@property (nonatomic,strong) NSMutableArray *valueArray;//保存所有品种的价格
@property (nonatomic,strong) NSMutableArray *changeValueArray;//保存各个品种的涨幅
@property (nonatomic,strong) CHCQuatationPriceListInfoVO *priceListInfoVO;
@property (nonatomic,assign) BOOL footerRefreshEnd;//表示是否是最后一页的数据


/**
 *  地区动态价格列表接口
 *
 *  @param city        城市
 *  @param page        页数
 *  @param aCompletion 回调
 */
- (void)getAreaDynamicPriceListCity:(NSString *)city
                              WithPage:(int)page
                            completion:(void (^)(BOOL isSucceed, NSString *aDes))aCompletion;

/**
 *  通过用户名获取动态价格列表接口
 *
 *  @param uid         用户名
 *  @param page        页数
 *  @param aCompletion 回调
 */
- (void)getAreaDynamicPriceListWithUid:(NSNumber *)uid
                              WithPage:(int)page
                            completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;


@end
