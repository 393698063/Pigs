//
//  CHCPGMyQuotePriceViewController.m
//  Pigs
//
//  Created by wangbin on 16/5/18.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGMyQuotePriceViewController.h"
#import "BnsQuationDef.h"
#import "CHCSqliteManager.h"
#import "CHCPGMyQuotePriceCell.h"
#import "CHCPGUserDataSycnViewController.h"
#import "UIButton+Extension.h"
#import "SynchronzeDef.h"
#import "MJRefresh.h"
#import "UIColor+Hex.h"

@interface CHCPGMyQuotePriceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *iTableView;
@property (nonatomic,strong) CHCPGMyQuotePriceController *iController;
@property (nonatomic,strong) UISegmentedControl *iSegmentControl;
@property (nonatomic,strong) UIScrollView *iGlobalScrollView;
@property (nonatomic,strong) UIView *iNavigationView;
@property (nonatomic,strong) UILabel *iLineLabel;
@property (nonatomic, assign) NSInteger iPage;
@end

@implementation CHCPGMyQuotePriceViewController
@dynamic iController;
- (void)viewDidLoad {
    [super viewDidLoad];
  [self createTableView];
  self.iTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
  self.iTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
  UIView *iFooterView=[[UIView alloc]init];
  iFooterView.backgroundColor=[UIColor colorWithHex:0xffeff3fc];
  self.view.backgroundColor=[UIColor colorWithHex:0xffeff3fc];
  self.iTableView.tableFooterView=iFooterView;
[self refreshAction];
}

- (void)refreshAction
{
  self.iPage = 0;
  __weak typeof(self)wSelf = self;
  [self.iController getDataWithPage:self.iPage size:15 completion:^(BOOL isSucceed, NSString *aDes)
  {
    if (isSucceed) {
      [wSelf.iTableView reloadData];
    }
    [self.iTableView.header endRefreshing];
    if (self.iController.footerRefreshEnd) {
      self.iTableView.footer.state = MJRefreshStateNoMoreData;
    }else{
      self.iTableView.footer.state = MJRefreshStateIdle;
    }
  }];
}
- (void)loadMoreData
{
  
  if (self.iController.footerRefreshEnd) {
    self.iTableView.footer.state=MJRefreshStateNoMoreData;
    return;
  }
  [self.iController getDataWithPage:self.iPage + 1 size:15 completion:^(BOOL isSucceed, NSString *aDes) {
    if (isSucceed) {
      self.iPage ++;
      [self.iTableView reloadData];
    }
    [self.iTableView.footer endRefreshing];
  }];
}
- (IBAction)goBackAction:(id)sender {
  
  [self.navigationController popViewControllerAnimated:YES];

}

- (void)createTableView
{
  self.iTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 94, MAIN_Screen.width, MAIN_Screen.height-94) style:UITableViewStylePlain];
  self.iTableView.delegate=self;
  self.iTableView.dataSource=self;
  self.iTableView.contentSize=CGSizeMake(MAIN_Screen.width, 40 *self.iController.iPriceDataArray.count);
  [self.view addSubview:self.iTableView];
  [self.iTableView registerNib:[UINib nibWithNibName:@"CHCPGMyQuotePriceCell" bundle:nil] forCellReuseIdentifier:@"cell"];

}


#pragma mark   tableView代理方法

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *ID=@"cell";
  CHCPGMyQuotePriceCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
  CHCPGMyQuotePriceInfoVO *priceInfoVO=self.iController.iPriceDataArray[indexPath.row];
  [cell addPriceInfoVO:priceInfoVO];
  tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
  if (indexPath.row%2==1) {
    cell.backgroundColor=[UIColor colorWithHex:0xfff9f9f9];
  }
  return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.iController.iPriceDataArray.count;

}
@end

@interface CHCPGMyQuotePriceController()

@property (nonatomic,strong) CHCSqliteManager *iManager;

@end


@implementation CHCPGMyQuotePriceController
- (instancetype)init
{
  if (self = [super init]) {
    NSString *path=[NSString stringWithFormat:@"%@/%@",[CHCPGUserDataSycnController createUserPath],@"database.db"];
    self.iManager=[[CHCSqliteManager alloc]initWithDataBasePath:path];
  }
  return self;
}
- (void)constructPriceData:(NSDictionary *)dict{
  
  self.myQuoteVO=[[CHCPGMyQuotePriceInfoVO alloc]initWithDic:dict];
}

- (NSMutableArray *)iPriceDataArray
{
  if (_iPriceDataArray==nil)
  {
    _iPriceDataArray=[[NSMutableArray alloc]init];
  }
  return _iPriceDataArray;
}

- (void)getDataWithPage:(NSInteger )page
                   size:(NSInteger )size
             completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * sql = [NSString stringWithFormat:@"select * from %@ ORDER BY createAt DESC limit %ld,%ld",HCPG_PriceDiaryTable,(long)page * size,(long)size];
  NSArray * ary = [self.iManager executeQueryRtnAry:sql];
  if (ary.count == 0) {
    wSelf.footerRefreshEnd = YES;
  }
  if (ary) {
    if (page == 0) {
      [self.iPriceDataArray removeAllObjects];
      self.footerRefreshEnd = NO;
    }
    [wSelf constructData:ary];
    if (aCompletion)
    {
      aCompletion(YES,nil);
    }
  }

  
}
- (void)constructData:(NSArray *)array
{
  [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
  {
    CHCPGMyQuotePriceInfoVO * priceVo = [[CHCPGMyQuotePriceInfoVO alloc] initWithDic:obj];
    [self.iPriceDataArray addObject:priceVo];
  }];
}
@end

