//
//  CHCFreshTableViewController.h
//  Pigs
//
//  Created by Lemon-HEcom on 16/7/21.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

//post className+postName,则在viewDidAppear的时候刷新tableView。
#define HC_FreshTable_PostName @"_HeaderFresh"

/*!
 @method
 @abstract 子类需要调用的Block
 @discussion
 @param isSucceed 是否成功
 @param aDesc 描述信息，成功时可nil
 @param aDataAry 需要添加的数据，多section的时候可为nil，不分组需要为一维数组
 @param totlePage 总页数，可以为nil，不传则靠“aDataArray不为nil切无元素”判断结束条件，否则可以调用强制结束。
 @result
 */
typedef void (^THC_FreshTable_CompletionBlock)(BOOL isSucceed, NSString *aDesc, NSArray *aDataAry, NSNumber* totlePage);

/*!
 @enum
 @abstract 数据添加方式
 @constant EHCFreshTableStyleDefault 默认，tableview不分组，数据以不分组模式添加
 @constant EHCFreshTableStylePlain tableview不分组，数据以不分组方式添加。
 @constant EHCFreshTableStyleGrouped tableview分组，数据以分组方式添加。
 */
typedef enum
{
  EHCFreshTableStyleDefault = 0,
  EHCFreshTableStylePlain = EHCFreshTableStyleDefault,
  EHCFreshTableStyleGrouped
}EHCFreshTableStyle;

//需要子类实现的方法代理
@protocol MHCFreshTableDelegate<NSObject>
@required
/*!
 @method
 @abstract 刷新的实现，将结果由completionBlock返回处理
 @discussion
 @param tableview 操作的tableview
 @param aPageNO 页码
 @param aPageSize 条数
 @param aIsFresh YES:刷新；NO:加载
 @param aCompletionBlock 子类需要调用以返回请求结果。
 @result
 */
- (void)tableView:(UITableView *)tableView
         loadPage:(NSInteger)aPageNO
         pageSize:(NSInteger)aPageSize
          isFresh:(BOOL)aIsFresh
       completion:(THC_FreshTable_CompletionBlock)aCompletionBlock;
@end


@interface CHCFreshTableViewController : CHCBaseViewController<UITableViewDelegate, UITableViewDataSource>
/*!
 @property
 @abstract 基本的iFreshTableView，默认带上拉刷新下拉加载
 */
@property (nonatomic, weak) IBOutlet UITableView *iFreshTableView;

/*!
 @method
 @abstract 使tableview具有刷新和加载功能
 @discussion
 @param aTableView 添加刷新和加载的tableview
 @result
 */
- (void)makeUpTableViewWithFreshAction:(UITableView *)aTableView;

//以下两个方法配合特殊情况使用
/*!
 @method
 @abstract 强制tableview 到底／不到底
 @discussion
 @param tableview 操作的tableview
 @param aIsReachEnd YES，则到底不能加载；NO则不到底，可加载
 @result
 */
- (void)tableView:(UITableView *)tableView
     makeReachEnd:(BOOL)aIsReachEnd;

/*!
 @method
 @abstract 设置是否需要在viewDidAppear的时候刷新
 @discussion
 @param aIsNeedFresh NO，不需要刷新；YES，需要刷新。
 @result
 */
- (void)makeNeedFresh:(BOOL)aIsNeedFresh;

/*!
 @method
 @abstract 数据添加方式（分组方式添加，不分组方式添加）
 @discussion
 @param aStyle Plain=Default为不分组列表类型，Grouped为分组类型
 @result
 */
- (void)putDataStyle:(EHCFreshTableStyle)aStyle;

/*!
 @method
 @abstract 添加而且数组，其中第一个元素会继续之前分组的最后一个。
 @discussion
 @param aDataAry 二维数组，可以多次添加
 @result
 */
- (void)addMutableSectionData:(NSArray *)aDataAry;

/*!
 @method
 @abstract viewdidappear的时候需要刷新。
 @discussion
 @result
 */
- (void)needFreshWhildDidAppear;

/*!
 @method
 @abstract 获取对应的VO
 @discussion
 @param aIndexPath 获取aIndexPath对应的VO
 @result
 */
- (NSObject *)objectAtIndexPath:(NSIndexPath *)aIndexPath;

@end

@interface CHCFreshTableController : CHCBaseController
/*!
 @property
 @abstract 基本的iDataArray，数据源
 */
@property (nonatomic, strong) NSMutableArray *iDataArray;
@end


