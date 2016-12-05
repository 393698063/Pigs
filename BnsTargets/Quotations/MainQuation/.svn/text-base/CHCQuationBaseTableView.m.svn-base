//
//  CHCQuationBaseTableView.m
//  Pigs
//
//  Created by wangbin on 16/5/12.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define MAIN_Screen [[UIScreen mainScreen]bounds].size
#import "CHCQuationBaseTableView.h"
#import "CHCQuationTableInfoVO.h"
#import "CHCBaseViewController.h"
#import "BnsQuationDef.h"
#import "CHCQuationInfoVO.h"
#import "MJRefresh.h"
#import "CHCPGQuatationHomeCell.h"
#import "UIColor+Hex.h"
#import "CHCPGWebViewController.h"
#import "CHCPGQuatationHomeViewController.h"
#import "CHCPGQuationDataCacheManager.h"
@interface CHCQuationBaseTableView()<UITableViewDataSource,
UITableViewDelegate,SDCycleScrollViewDelegate>


@property (nonatomic,strong) CHCQuationTableInfoVO *iTableInfoVO;
@property (nonatomic,strong) UIView *iHeadView;

@end
@implementation CHCQuationBaseTableView

- (UITableView *)createTableView
{
  self.iTableView=[[UITableView alloc]initWithFrame:self.bounds];
  self.iTableView.delegate=self;
  self.iTableView.dataSource=self;
  self.iTableView.rowHeight=85;
  self.iTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
  self.iTableView.tableFooterView=[[UIView alloc]init];
  self.iTableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
    if ([_delegate respondsToSelector:@selector(getArticlePageHeaderRefreshWith:)])
    {
      [_delegate getArticlePageHeaderRefreshWith:(int)self.quationTag];
    }
  }];
  
  self.iTableView.footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    if ([_delegate respondsToSelector:@selector(getArticlePageFooterRefreshWith:)])
    {
      [_delegate getArticlePageFooterRefreshWith:(int)self.quationTag];
    }
    
  }];
  
  [self.iTableView registerNib:[UINib nibWithNibName:@"CHCPGQuatationHomeCell" bundle:nil]
        forCellReuseIdentifier:@"cell"];
  [self addSubview:self.iTableView];
  [self createScrollViewWithImageGroups:self.imageGroups andTitleArray:self.iTitleArray];
  return self.iTableView;
  
}
- (void)loadQuationDataCache
{
  NSMutableArray *titleArray=[NSMutableArray array];
  NSMutableArray *scrollDataArray=[NSMutableArray array];
  NSMutableArray *imageGroups=[NSMutableArray array];
  NSMutableDictionary *param=[NSMutableDictionary dictionary];
  NSMutableArray *dataSource=[NSMutableArray array];
  param[@"quationTag"]=@(self.quationTag);
  param[@"isScroll"]=@(0);
  NSMutableArray *QuationDataCache=[CHCPGQuationDataCacheManager getQuationDataCacheWithParam:param];
  if (QuationDataCache.count!=0)
  {
    for (NSDictionary *dic in QuationDataCache)
    {
      CHCQuationTableInfoVO *tableInfoVO=[[CHCQuationTableInfoVO alloc]initWithDic:dic];
      [dataSource  addObject:tableInfoVO];
    }
    NSArray *dataSourceTable=[[dataSource reverseObjectEnumerator] allObjects];
   self.dataSourceTable=[NSMutableArray arrayWithArray:dataSourceTable];
    [self.iTableView reloadData];
    param[@"isScroll"]=@(1);
    NSMutableArray *scrollDataCache=[CHCPGQuationDataCacheManager getQuationDataCacheWithParam:param];
    for (NSDictionary *dict in scrollDataCache) {
      CHCQuationInfoVO *scrollInfoVO=[[CHCQuationInfoVO alloc]initWithDic:dict];
      [scrollDataArray addObject:scrollInfoVO];
      [imageGroups addObject:[scrollInfoVO.picture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
      [titleArray addObject:scrollInfoVO.title];
      
    }
    self.imageGroups=[NSMutableArray arrayWithArray:imageGroups];
    self.iTitleArray=[NSMutableArray arrayWithArray:titleArray];
    self.scrollDataArray=[NSMutableArray arrayWithArray:scrollDataArray];
    [self createScrollViewWithImageGroups:imageGroups
                            andTitleArray:titleArray];
    if ([_delegate respondsToSelector:@selector(getHideNoNetworkShowInLine)]) {
      [_delegate getHideNoNetworkShowInLine];
    }
  }
  
   else{
  
  if ([_delegate respondsToSelector:@selector(getNoNetworkViewShowInOffLine)]) {
    [_delegate getNoNetworkViewShowInOffLine];
  }

}

}
- (void)createScrollViewWithImageGroups:(NSMutableArray *)imageGroups andTitleArray:(NSMutableArray *)titleArray
{
  self.iScrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MAIN_Screen.width, 110)
                                          imageURLStringsGroup:imageGroups];
  self.iScrollView.delegate=self;
  self.iScrollView.placeholderImage=[UIImage imageNamed:@"zhuge_default"];
  
  self.iScrollView.titlesGroup=[NSArray arrayWithArray:titleArray];
  self.iScrollView.pageControlStyle= SDCycleScrollViewPageContolStyleClassic;
  if (imageGroups.count==1) {
     self.iScrollView.autoScroll=NO;
  }else{
   self.iScrollView.autoScroll=YES;
  }
 
  self.iScrollView.infiniteLoop=YES;
  self.iScrollView.userInteractionEnabled=YES;
  self.iScrollView.autoScrollTimeInterval=5;
  self.iHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_Screen.width, 120)];
  self.iHeadView.backgroundColor=[UIColor colorWithHex:0xffeff3fc];
  [self.iHeadView addSubview:self.iScrollView];
  self.iTableView.tableHeaderView=self.iHeadView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
  CHCQuationInfoVO *quationInfoVO=self.scrollDataArray[index];
  if ([_delegate respondsToSelector:@selector(getDetailScrollCircleWebUrlWithContentPath:imageUrlStr:andTitleStr:informationId:)]) {
    [_delegate getDetailScrollCircleWebUrlWithContentPath:quationInfoVO.content
                                              imageUrlStr:quationInfoVO.picture
                                              andTitleStr:quationInfoVO.title
                                            informationId:quationInfoVO.iHCid];
    
  }
}

#pragma mark   tableView的代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.dataSourceTable.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CHCPGQuatationHomeCell *quationCell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
  CHCQuationTableInfoVO *tableInfoVO=nil;
  if (indexPath.row<[self.dataSourceTable count])
  {
    tableInfoVO =self.dataSourceTable[indexPath.row];
  }
  quationCell.selectionStyle=UITableViewCellSelectionStyleNone;
  [quationCell addQuationInfoVO:tableInfoVO];
  return quationCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  CHCQuationTableInfoVO *tableInfo=self.dataSourceTable[indexPath.row];
  if ([_delegate respondsToSelector:@selector(getDetailTableInfoWebUrlWithContentPath:imageUrlStr:andTitleStr:informationId:)]) {
    [_delegate getDetailTableInfoWebUrlWithContentPath:tableInfo.informationLink imageUrlStr:tableInfo.logoLink andTitleStr:tableInfo.title informationId:tableInfo.iHCid];
  }
  
}
#pragma mark   懒加载
- (NSMutableArray *)dataSourceTable
{
  if (_dataSourceTable==nil) {
    _dataSourceTable=[[NSMutableArray alloc]init];
  }
  return _dataSourceTable;
}
- (NSMutableArray *)imageGroups
{
  if (_imageGroups==nil) {
    _imageGroups=[[NSMutableArray alloc]init];
  }
  return _imageGroups;
  
}
- (NSMutableArray *)scrollDataArray
{
  if (_scrollDataArray==nil) {
    _scrollDataArray=[[NSMutableArray alloc]init];
  }
  return _scrollDataArray;
  
}

- (NSMutableArray *)iTitleArray
{  
  if (_iTitleArray==nil) {
    _iTitleArray=[[NSMutableArray alloc]init];
  }
  return _iTitleArray;
  
}
@end
