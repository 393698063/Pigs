//
//  CHCFreshTableViewController.m
//  Pigs
//
//  Created by Lemon-HEcom on 16/7/21.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCFreshTableViewController.h"
#import "MJRefresh.h"


#define HC_FreshTable_DefaultPageSize @(20)
#define HC_FreshTable_DefaultStartPage @(0)


@class CHCFreshTableController;
@interface CHCFreshTableViewController ()
@property (nonatomic, assign) BOOL iIsNeedFresh;//默认为NO
@property (nonatomic, strong) CHCFreshTableController *iController;
@property (nonatomic, assign) EHCFreshTableStyle iDataStyle;//默认为Default=Plain
@end


@interface CHCFreshTableController()
@property (nonatomic, strong) NSString *iCurrentPage;
@property (nonatomic, strong) NSNumber *iPageCount;
@property (nonatomic, strong) NSMutableDictionary *iPageSizeMap;
@property (nonatomic, strong) NSMutableDictionary *iStartPageMap;

- (void)putStartPage:(NSNumber *)aStartPage
            pageSize:(NSNumber *)aPageSize
        forTableView:(UITableView *)aTableView;
- (void)putPageCount:(NSNumber *)aPageCount
        forTableView:(UITableView *)aTableView;

- (NSNumber *)pageCount:(UITableView *)aTableView;
- (NSNumber *)pageSize:(UITableView *)aTableView;
- (NSNumber *)startPage:(UITableView *)aTableView;

- (void)addData:(NSArray *)aDataAry;
- (void)addMutableSectionData:(NSArray *)aDataAry;
- (NSObject *)objectAtIndexPath:(NSIndexPath *)aIndexPath;

- (void)resetDataArray;
@end


@implementation CHCFreshTableViewController
@dynamic iController;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSString *name = [NSString stringWithFormat:@"%@%@",NSStringFromClass([self class]),HC_FreshTable_PostName];
  [[NSNotificationCenter defaultCenter]addObserver:self
                                          selector:@selector(needFreshWhildDidAppear)
                                              name:name
                                            object:nil];
  
  [self makeUpTableViewWithFreshAction:self.iFreshTableView];
  self.iFreshTableView.delegate = self;
  self.iFreshTableView.dataSource = self;
  // Do any additional setup after loading the view.
}

- (void)needFreshWhildDidAppear
{
  self.iIsNeedFresh = YES;
}

- (void)makeNeedFresh:(BOOL)aIsNeedFresh
{
  self.iIsNeedFresh = aIsNeedFresh;
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if (self.iIsNeedFresh)
  {
    self.iIsNeedFresh = NO;
    [self headerRefresh:self.iFreshTableView];
  }
}

- (void)putDataStyle:(EHCFreshTableStyle)aStyle
{
  self.iDataStyle = aStyle;
}

- (void)makeUpTableViewWithFreshAction:(UITableView *)aTableView
{
  [self makeUpTableViewWithFreshAction:aTableView
                              pageSize:[self defaultPageSize]
                             startPage:[self defaultStartPage]];
}

- (NSNumber *)defaultPageSize
{
  return HC_FreshTable_DefaultPageSize;
}

- (NSNumber *)defaultStartPage
{
  return HC_FreshTable_DefaultStartPage;
}

- (void)makeUpTableViewWithFreshAction:(UITableView *)aTableView
                              pageSize:(NSNumber *)aPageSize
                             startPage:(NSNumber *)aStartPage
{
  aTableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:
                     ^(void)
                     {
                       [self headerRefresh:aTableView];
                     }];
  
  aTableView.footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:
                     ^(void)
                     {
                       [self footerLoad:aTableView];
                     }];
  
  [self.iController putStartPage:aStartPage
                        pageSize:aPageSize
                    forTableView:aTableView];
}

- (void)headerRefresh:(UITableView *)aTableView
{
  NSNumber *pageNO = [self.iController startPage:aTableView];
  NSNumber *pageSize = [self.iController pageSize:aTableView];
  
  [self tableView:aTableView
         loadPage:pageNO.integerValue
         pageSize:pageSize.integerValue
          isFresh:YES
       completion:
   ^(BOOL isSucceed, NSString *aDesc, NSArray *aDataAry, NSNumber* totlePage)
   {
     [aTableView.header endRefreshing];
     
     if (isSucceed)
     {
       [self.iController resetDataArray];
       [self addData:aDataAry];
       
       NSNumber *startPage = [self.iController startPage:aTableView];//此处startPage ＝ pageNO
       //没有请求到数据，或者本页数据已经到达总页数（当前请求第0页，总共1页，则0+2 > 1为真）
       BOOL reachEnd = (aDataAry&&([aDataAry count]==0))||(totlePage&&((pageNO.integerValue+2-startPage.integerValue)>totlePage.integerValue));
       [self tableView:aTableView makeReachEnd:reachEnd];
       [self.iController putPageCount:@(pageNO.integerValue)
                         forTableView:aTableView];
       
       [aTableView reloadData];
     }
     else if (aDesc)
     {
       [self failLoad:aDesc isFresh:YES];
     }
     else
     {
       //do nothing,因为进入这里是错误情况
     }
   }];
}

- (void)footerLoad:(UITableView *)aTableView
{
  NSNumber *pageNO = [self.iController pageCount:aTableView];
  NSNumber *pageSize = [self.iController pageSize:aTableView];
  
  [self tableView:aTableView
         loadPage:pageNO.integerValue+1
         pageSize:pageSize.integerValue
          isFresh:NO
       completion:
   ^(BOOL isSucceed, NSString *aDesc, NSArray *aDataAry, NSNumber* totlePage)
   {
     [aTableView.footer endRefreshing];
     
     if (isSucceed)
     {
       [self addData:aDataAry];
       
       NSNumber *startPage = [self.iController startPage:aTableView];
       //没有请求到数据，或者本页数据已经到达总页数（当前请求第0+1页，总共2页，则0+3 > 2为真）
       BOOL reachEnd = (aDataAry&&([aDataAry count]==0))||(totlePage&&((pageNO.integerValue+3-startPage.integerValue)>totlePage.integerValue));
       [self tableView:aTableView makeReachEnd:reachEnd];
       [self.iController putPageCount:@(pageNO.integerValue+1)
                         forTableView:aTableView];
       
       [aTableView reloadData];
     }
     else if (aDesc)
     {
       [self failLoad:aDesc isFresh:NO];
     }
     else
     {
       //do nothing,因为进入这里是错误情况
     }
   }];
}

- (void)addData:(NSArray *)aDataAry
{
  switch (self.iDataStyle)
  {
    case EHCFreshTableStylePlain:
    {
      [self.iController addData:aDataAry];
      break;
    }
      
    case EHCFreshTableStyleGrouped:
    {
      [self.iController addMutableSectionData:aDataAry];
      break;
    }
      
    default:
    {
      //do nothing 因为EHCFreshTableStylePlain=Default
      break;
    }
  }
}

- (void)tableView:(UITableView *)tableView
     makeReachEnd:(BOOL)aIsReachEnd
{
  if (aIsReachEnd)
  {
    tableView.footer.state = MJRefreshStateNoMoreData;
  }
  else
  {
    tableView.footer.state = MJRefreshStateIdle;
  }
}

- (void)failLoad:(NSString *)aDesc
         isFresh:(BOOL)aIsFresh
{
  [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                withShowingText:aDesc
                                              withIconImageName:nil];
}

- (void)tableView:(UITableView *)tableView
         loadPage:(NSInteger)aPageNO
         pageSize:(NSInteger)aPageSize
          isFresh:(BOOL)aIsFresh
       completion:(THC_FreshTable_CompletionBlock)aCompletionBlock
{
  aCompletionBlock(YES, @"", @[], 0);
}

- (void)addMutableSectionData:(NSArray *)aDataAry
{
  [self.iController addMutableSectionData:aDataAry];
}

- (NSObject *)objectAtIndexPath:(NSIndexPath *)aIndexPath
{
  return [self.iController objectAtIndexPath:aIndexPath];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.iController.iDataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  NSInteger rtnValue = 0;
  
  NSArray *subAry = nil;
  if ([self.iController.iDataArray count] > section)
  {
    subAry = [self.iController.iDataArray objectAtIndex:section];
  }
  if (subAry && [subAry isKindOfClass:[NSArray class]] )
  {
    rtnValue = [subAry count];
  }
  
  return rtnValue;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [[UITableViewCell alloc]init];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


#pragma mark - Controller
@implementation CHCFreshTableController

- (instancetype)init
{
  self = [super init];
  if (self)
  {
    [self resetDataArray];
    
    self.iPageSizeMap = [NSMutableDictionary dictionaryWithCapacity:1];
    self.iStartPageMap = [NSMutableDictionary dictionaryWithCapacity:1];
  }
  return self;
}

- (void)resetDataArray
{
  self.iDataArray = [NSMutableArray arrayWithCapacity:1];
  NSMutableArray *firstAry = [NSMutableArray arrayWithCapacity:1];
  [self.iDataArray addObject:firstAry];
}

- (void)addData:(NSArray *)aDataAry
{
  if (aDataAry)
  {
    NSArray *array = @[aDataAry];
    [self addMutableSectionData:array];
  }
}

- (void)addMutableSectionData:(NSArray *)aDataAry
{
  @try
  {
    if (aDataAry)
    {
      NSMutableArray *aMutableDataAry = [aDataAry mutableCopy];
      NSMutableArray *curDataAry = [self.iDataArray lastObject];
      
      [curDataAry addObjectsFromArray:[aMutableDataAry firstObject]];
      [aMutableDataAry removeObjectAtIndex:0];
      
      [aMutableDataAry enumerateObjectsUsingBlock:
       ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
       {
         NSMutableArray *oneDataAry = [obj mutableCopy];
         [self.iDataArray addObject:oneDataAry];
       }];
    }
  }
  @catch (NSException *exception)
  {
    
  }
  @finally
  {
    
  }
}

- (NSObject *)objectAtIndexPath:(NSIndexPath *)aIndexPath
{
  NSObject *rtnObj = nil;
  if ( [self.iDataArray count] > aIndexPath.section )
  {
    NSArray *sectionAry = [self.iDataArray objectAtIndex:aIndexPath.section];
    if ( [sectionAry count] > aIndexPath.row )
    {
      rtnObj = [sectionAry objectAtIndex:aIndexPath.row];
    }
  }
  return rtnObj;
}

- (NSString *)creatTableDesc:(UITableView *)aTableView
{
  NSString *tableDesc = [NSString stringWithFormat:@"%p",aTableView];
  return tableDesc?:@"";
}

- (void)putPageCount:(NSNumber *)aPageCount
        forTableView:(UITableView *)aTableView
{
  self.iPageCount = aPageCount;
}

- (void)putStartPage:(NSNumber *)aStartPage
            pageSize:(NSNumber *)aPageSize
        forTableView:(UITableView *)aTableView
{
  NSString *tableDesc = [self creatTableDesc:aTableView];
  
  if (tableDesc.length>0)
  {
    [self putPageCount:aStartPage forTableView:aTableView];
    [self.iPageSizeMap setObject:aPageSize forKey:tableDesc];
    [self.iStartPageMap setObject:aStartPage forKey:tableDesc];
  }
}

- (NSNumber *)pageCount:(UITableView *)aTableView
{
  return self.iPageCount;
}

- (NSNumber *)pageSize:(UITableView *)aTableView
{
  NSString *tableDesc = [self creatTableDesc:aTableView];
  return [self.iPageSizeMap objectForKey:tableDesc];
}

- (NSNumber *)startPage:(UITableView *)aTableView
{
  NSString *tableDesc = [self creatTableDesc:aTableView];
  return [self.iStartPageMap objectForKey:tableDesc];
}

@end

