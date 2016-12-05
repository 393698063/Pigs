//
//  CHCQuationBaseTableView.h
//  Pigs
//
//  Created by wangbin on 16/5/12.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@protocol getDetailWebUrlDelegate <NSObject>

/**
 *   资讯加载H5页面的代理方法
 */
- (void)getDetailTableInfoWebUrlWithContentPath:(NSString *)pathUrl
                                    imageUrlStr:(NSString *)imageUrlStr
                                    andTitleStr:(NSString *)titleStr
                                  informationId:(NSNumber *)informationId;

/**
 *   轮播图加载H5页面的代理方法
 */
- (void)getDetailScrollCircleWebUrlWithContentPath:(NSString *)pathUrl
                                       imageUrlStr:(NSString *)imageUrlStr
                                       andTitleStr:(NSString *)titleStr
                                     informationId:(NSNumber *)informationId;

- (void)getNoNetworkViewShowInOffLine;
- (void)getHideNoNetworkShowInLine;
- (void)getArticlePageHeaderRefreshWith:(int)quationTag;
- (void)getArticlePageFooterRefreshWith:(int)quationTag;
@end

@interface CHCQuationBaseTableView : UIView

@property (nonatomic,strong) UITableView *iTableView;       //标签的tableview
@property (nonatomic,strong) SDCycleScrollView *iScrollView; //轮播图的数据源
@property (nonatomic,assign) NSUInteger quationTag;          //标签的tag值
@property (nonatomic,assign) int iBasePage;;                 //轮播图的刷新page
@property (nonatomic,strong) NSMutableArray *imageGroups;    //轮播图图片数据源
@property (nonatomic,strong) NSMutableArray *dataSourceTable; //tableview数据源
@property (nonatomic,strong) NSMutableArray *scrollDataArray; //轮播图数据源
@property (nonatomic,strong) NSMutableArray *iTitleArray;     //轮播图的title数据源

@property (nonatomic,weak)id<getDetailWebUrlDelegate>delegate;
/**
 *  创建tableview以及轮播图
 *
 *  @return tableview对象
 */
- (UITableView *)createTableView;
/**
 *  加载缓存数据
 */
- (void)loadQuationDataCache;
/**
 *  创建轮播图
 *
 *  @param imageGroups 图片数组
 *  @param titleArray  标题数组
 */
- (void)createScrollViewWithImageGroups:(NSMutableArray *)imageGroups
                          andTitleArray:(NSMutableArray *)titleArray;
@end
