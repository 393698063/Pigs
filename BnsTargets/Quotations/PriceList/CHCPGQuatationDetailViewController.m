//
//  CHCPGQuatationDetailViewController.m
//  Pigs
//
//  Created by wangbin on 16/5/9.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGQuatationDetailViewController.h"
#import "CHCQuationPriceListView.h"
#import "CHCPGQutationChangeCityViewController.h"
#import "CHCPGQuationPriceListCell.h"
#import "BnsQuationDef.h"
#import "CHCCommonInfoVO.h"
#import "UIColor+Hex.h"
#import "MJRefresh.h"
#import "DateFomatterTool.h"
#import "CHCPGQuatationHomeViewController.h"
#import "DateFomatterTool.h"
@interface CHCPGQuatationDetailViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) UIView *iView;//价格列表页面的头视图
@property (nonatomic,strong) UITableView *iTableView;//当前视图的tableView
@property (nonatomic,assign) int page;//当前页面的刷新page
@property (nonatomic,strong) CHCQuationPriceListView *iHeadPriceItem; //自定义view
@property (nonatomic,strong) CHCPGQuatationDetailController *iController;
@end

@implementation CHCPGQuatationDetailViewController

@dynamic iController;
static  NSString * const  noNetWorkToast= @"断网啦，请检查网络连接";
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  if (self.iCityString.length>8)
  {
    NSString *cityString=[NSString stringWithFormat:@"%@...",[self.iCityString substringToIndex:8]];
    self.iNavBar.topItem.title=[NSString stringWithFormat:@"%@",cityString];
  }
  else
  {
    self.iNavBar.topItem.title=[NSString stringWithFormat:@"%@",self.iCityString];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self createTableView];
  self.page=0;
  CHCPGQuatationHomeController *iHomeVC=[[CHCPGQuatationHomeController alloc]init];
  if ([CHCCommonInfoVO sharedManager].isLogin && [self.iCityString isEqualToString:iHomeVC.area])
  {
    [self.iController getAreaDynamicPriceListWithUid:[CHCCommonInfoVO sharedManager].iHCid
                                            WithPage:0
                                          completion:^(BOOL isSucceed, NSString *aDes) {
                                            if (isSucceed) {
                                              [self.iTableView reloadData];
                                              [self createTableViewHeaderView];
                                            }else
                                            {
                                          [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES
                                                                                       withShowingText:noNetWorkToast
                                                                                    withIconImageName:nil];
                                            }
                                          }];
    
  }
  else
  {
    [self.iController getAreaDynamicPriceListCity:self.iCityString
                                             WithPage:0
                                           completion:^(BOOL isSucceed, NSString *aDes) {
                                             if (isSucceed) {
                                               [self.iTableView reloadData];
                                               [self createTableViewHeaderView];
                                             }
                                             else{
                                              [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES
                                                                                           withShowingText:noNetWorkToast
                                                                                         withIconImageName:nil];
                                             }
                                             
                                           }];
  }
}
- (BOOL)isNeedBaseViewTapAction
{
  return NO;
}

- (IBAction)goBackedAction:(id)sender
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)citySelectClick:(id)sender
{
  CHCPGQutationChangeCityViewController *iChangeCityVC=[[CHCPGQutationChangeCityViewController alloc]initWithCityChooseBlock:^(NSDictionary *selectCity) {
    
    self.iCityString=[selectCity objectForKey:@"area"];
    [self.iController getAreaDynamicPriceListCity:self.iCityString WithPage:0 completion:^(BOOL isSucceed, NSString *aDes) {
      if (isSucceed) {
        [self.view setNeedsDisplay];

        if (self.iCityString.length>8) {
          NSString *cityString=[NSString stringWithFormat:@"%@...",[self.iCityString substringToIndex:8]];
          self.iNavBar.topItem.title=[NSString stringWithFormat:@"%@",cityString];
        }else{
          self.iNavBar.topItem.title=[NSString stringWithFormat:@"%@",self.iCityString];
        }

        [self.iTableView reloadData];
        [self loadTableViewHeadInfoWithNameArray:self.iController.nameArray entityArray:self.iController.entityValueArray unitArray:self.iController.unitArray changeValueArray:self.iController.changeValueArray];
        if ([_delegate respondsToSelector:@selector(getSelectRegionCity:)]) {
          [_delegate getSelectRegionCity:[selectCity objectForKey:@"area"]];
        }
      }else{
        [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES withShowingText:noNetWorkToast withIconImageName:nil];
      }
    }];
  }];
  [self.navigationController pushViewController:iChangeCityVC animated:YES];
}

- (void)createTableView
{
  self.iTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, MAIN_Screen.width, MAIN_Screen.height-64) style:UITableViewStylePlain];
  self.automaticallyAdjustsScrollViewInsets=NO;
  self.iTableView.delegate=self;
  self.iTableView.dataSource=self;
  self.iView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_Screen.width, 95)];
  self.iTableView.tableHeaderView=self.iView;
  [self.view addSubview:self.iTableView];
  self.iTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.iTableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
    [self refreshData];
  }];
  self.iTableView.footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    
    [self loadMoreData];
  }];
  [self.iTableView registerNib:[UINib nibWithNibName:@"CHCPGQuationPriceListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark   tableView的头视图

- (void)refreshData
{
  self.page = 0;
[self.iController getAreaDynamicPriceListCity:self.iCityString
                                     WithPage:0
                                   completion:^(BOOL isSucceed, NSString *aDes) {
  if (isSucceed) {
    [self createTableViewHeaderView];
    [self.iTableView reloadData];
  }else
  {
    [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES withShowingText:noNetWorkToast withIconImageName:nil];
  }
  if (self.iController.footerRefreshEnd)
  {
    self.iTableView.footer.state = MJRefreshStateNoMoreData;
  }else
  {
    self.iTableView.footer.state = MJRefreshStateIdle;
  }

  [self.iTableView.header endRefreshing];
}];
  
}
- (void)loadMoreData
{
  if (self.iController.footerRefreshEnd) {
    self.iTableView.footer.state = MJRefreshStateNoMoreData;
    return;
  }
  self.page++;
  [self.iController getAreaDynamicPriceListCity:self.iCityString WithPage:self.page completion:^(BOOL isSucceed, NSString *aDes) {
    
    if (isSucceed) {
       [self.iTableView reloadData];
    }
    else
    {
     [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES withShowingText:noNetWorkToast withIconImageName:nil];
    }
    [self.iTableView.footer endRefreshing];
    
  }];
  
}

- (void)createTableViewHeaderView
{
  if (self.iController.nameArray.count==0)
  {
    return;
  }
  CHCQuationPriceListView *item=[CHCQuationPriceListView item];
  item.frame=CGRectMake(0, 0, MAIN_Screen.width, 95);
  item.nameLabel.text=self.iController.nameArray[self.nameTag];
  NSNumber *iCurrentNumber= self.iController.entityValueArray[0];
  item.unitLabel.text=self.iController.unitArray[self.nameTag];
  
  NSNumber *iChangeNumber=[self.iController.changeValueArray firstObject];
  if ([iChangeNumber floatValue]>0)
  {
    item.changeLabel.text=[NSString stringWithFormat:@"%+.2f元",[iChangeNumber floatValue]];
    item.changeLabel.textColor=[UIColor colorWithHex:0xffe15150];
    item.unitLabel.textColor=[UIColor colorWithHex:0xffe15150];
  }else if([iChangeNumber floatValue]<0)
  {
    item.changeLabel.text=[NSString stringWithFormat:@"%.2f元",[iChangeNumber floatValue]];
   item.changeLabel.textColor=[UIColor colorWithHex:0xff86c036];
    item.priceLabel.textColor=[UIColor colorWithHex:0xff86c036];
    item.unitLabel.textColor=[UIColor colorWithHex:0xff86c036];
    
  }else{
    item.changeLabel.text=[NSString stringWithFormat:@"%.2f元",[iChangeNumber floatValue]];
    item.changeLabel.textColor=[UIColor grayColor];
    item.priceLabel.textColor=[UIColor grayColor];
    item.unitLabel.textColor=[UIColor grayColor];
  }
  if (self.nameTag==3)
  {
    item.unitLabel.text=@"";
    item.priceLabel.text = [NSString stringWithFormat:@"%.2f:1",[iCurrentNumber floatValue]];
    item.priceUnitLabel.text = self.priceUnitString;
    item.changeUnitLabel.text = @"涨幅";
    if ([iChangeNumber floatValue] > 0)
    {
      item.changeLabel.text=[NSString stringWithFormat:@"%+.2f",[iChangeNumber floatValue]];
      item.changeLabel.textColor=[UIColor colorWithHex:0xffe15150];
      item.unitLabel.textColor=[UIColor colorWithHex:0xffe15150];
    }else if([iChangeNumber floatValue]<0)
    {
      item.changeLabel.text=[NSString stringWithFormat:@"%.2f",[iChangeNumber floatValue]];
      item.changeLabel.textColor=[UIColor colorWithHex:0xff86c036];
      item.priceLabel.textColor=[UIColor colorWithHex:0xff86c036];
      item.unitLabel.textColor=[UIColor colorWithHex:0xff86c036];
    }else{
      item.changeLabel.text=[NSString stringWithFormat:@"%.2f",[iChangeNumber floatValue]];
      item.changeLabel.textColor=[UIColor grayColor];
      item.priceLabel.textColor=[UIColor grayColor];
      item.unitLabel.textColor=[UIColor grayColor];
    
    }
    
  }else if (self.nameTag==5||self.nameTag==4)
  {
    NSNumber *iChangeNumber=[self.iController.changeValueArray firstObject];
    if ([iChangeNumber floatValue]>0)
    {
      item.changeLabel.text=[NSString stringWithFormat:@"+%d元",[iChangeNumber intValue]];
      item.changeLabel.textColor=[UIColor colorWithHex:0xffe15150];
      item.unitLabel.textColor=[UIColor colorWithHex:0xffe15150];
    }else if([iChangeNumber floatValue]<0)
    {
      item.changeLabel.text=[NSString stringWithFormat:@"%d元",[iChangeNumber intValue]];
      item.changeLabel.textColor=[UIColor colorWithHex:0xff86c036];
      item.priceLabel.textColor=[UIColor colorWithHex:0xff86c036];
      item.unitLabel.textColor=[UIColor colorWithHex:0xff86c036];
    }else{
      item.changeLabel.text=[NSString stringWithFormat:@"%d元",[iChangeNumber intValue]];
      item.changeLabel.textColor=[UIColor grayColor];
      item.priceLabel.textColor=[UIColor grayColor];
      item.unitLabel.textColor=[UIColor grayColor];
    }
    item.priceLabel.text=[NSString stringWithFormat:@"%d",[iCurrentNumber intValue]];
    [self changeTextFeatureWithRangeLength:5 withItem:item];
    
  }
  else
  {
 item.priceLabel.text=[NSString stringWithFormat:@"%.2f",[iCurrentNumber floatValue]];
    [self changeTextFeatureWithRangeLength:6 withItem:item];
  }
  self.iHeadPriceItem=item;
  [self.iView addSubview:self.iHeadPriceItem];
}

- (void)changeTextFeatureWithRangeLength:(int)rangeLength withItem:(CHCQuationPriceListView *)item
{
  NSMutableAttributedString *attributeString=[[NSMutableAttributedString alloc]initWithString:self.priceUnitString];
  NSRange  range=NSMakeRange(2, rangeLength);
  [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:range];
  [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 2)];
  [attributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, 2)];
  item.priceUnitLabel.attributedText=attributeString;
  NSMutableAttributedString *attributeStringTwo=[[NSMutableAttributedString alloc]initWithString:self.changeUnitString];
  [attributeStringTwo addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(2, 3)];
  [attributeStringTwo addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 2)];
  [attributeStringTwo addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, 2)];
  item.changeUnitLabel.attributedText=attributeStringTwo;
}

- (void)loadTableViewHeadInfoWithNameArray:(NSMutableArray *)nameArray
                               entityArray:(NSMutableArray *)entityArray
                                 unitArray:(NSMutableArray *)unitArray
                          changeValueArray:(NSMutableArray *)changeValueArray
{
  
  self.iHeadPriceItem.nameLabel.text=nameArray[self.nameTag];
  NSNumber *iCurrentNumber= entityArray[0];
  if (self.nameTag==4||self.nameTag==5)
  {
    self.iHeadPriceItem.priceLabel.text=[NSString stringWithFormat:@"%d",[iCurrentNumber intValue]];
  }else
  {
    self.iHeadPriceItem.priceLabel.text=[NSString stringWithFormat:@"%.2f",[iCurrentNumber floatValue]];
  }
  self.iHeadPriceItem.unitLabel.text=unitArray[self.nameTag];
  if (self.nameTag==3)
  {
    self.iHeadPriceItem.unitLabel.text=@"";
    self.iHeadPriceItem.priceLabel.text=[NSString stringWithFormat:@"%.2f:1",[iCurrentNumber floatValue]];
  }
  NSNumber *iChangeNumber=[changeValueArray firstObject];
  if ([iChangeNumber floatValue] > 0) {
    self.iHeadPriceItem.changeLabel.text=[NSString stringWithFormat:@"%+.2f",[iChangeNumber floatValue]];
    self.iHeadPriceItem.changeLabel.textColor=[UIColor colorWithHex:0xffe15150];
    self.iHeadPriceItem.unitLabel.textColor=[UIColor colorWithHex:0xffe15150];
    self.iHeadPriceItem.priceLabel.textColor=[UIColor colorWithHex:0xffe15150];
  }else if([iChangeNumber floatValue]<0){
    self.iHeadPriceItem.changeLabel.text=[NSString stringWithFormat:@"%.2f",[iChangeNumber floatValue]];
   self.iHeadPriceItem.changeLabel.textColor=[UIColor colorWithHex:0xff86c036];
    self.iHeadPriceItem.unitLabel.textColor=[UIColor colorWithHex:0xff86c036];
    self.iHeadPriceItem.priceLabel.textColor=[UIColor colorWithHex:0xff86c036];
  }else{
      self.iHeadPriceItem.changeLabel.text = [NSString stringWithFormat:@"%.2f",[iChangeNumber floatValue]];
    self.iHeadPriceItem.changeLabel.textColor=[UIColor grayColor];
    self.iHeadPriceItem.unitLabel.textColor=[UIColor grayColor];
    self.iHeadPriceItem.priceLabel.textColor=[UIColor grayColor];
  
  }
  
}
#pragma mark   tableView的代理方法

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *ID=@"cell";
      CHCPGQuationPriceListCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
  if (indexPath.row < self.iController.entityValueArray.count)
  {
    long long currentTimeStamp=  [DateFomatterTool getCurrentTimeStamp];
    long long interval = (long long)((long long)indexPath.row *3600*24* 1000);
    long long  previousTimeStamp=currentTimeStamp - interval;
  NSString *iDateStr=  [DateFomatterTool getDateStringFromTimeStamp:previousTimeStamp WithDateFormat:@"MM-dd"];
      cell.dateLabel.text=iDateStr;
    NSNumber *valueNumber=self.iController.entityValueArray[indexPath.row];
    if (indexPath.row < self.iController.changeValueArray.count)
    {
      if (self.nameTag==4||self.nameTag==5)
      {
        double valuePriceList=round([valueNumber doubleValue]);
       cell.priceLabel.text=[NSString stringWithFormat:@"%d",(int)valuePriceList];
        NSNumber *changeNumber=self.iController.changeValueArray[indexPath.row];
        NSString *changeString=[NSString stringWithFormat:@"%d",(int)round([changeNumber floatValue])];
        if ([changeNumber intValue]>0) {
          cell.changeLabel.textColor=[UIColor colorWithRed:225/255.0 green:81/255.0 blue:80/255.0 alpha:1.0];
          cell.changeLabel.text=[NSString stringWithFormat:@"+%@",changeString];
        }else if ([changeNumber intValue]<0){
        
          cell.changeLabel.textColor=[UIColor colorWithRed:134/255.0 green:192/255.0 blue:54/255.0 alpha:1.0];
          cell.changeLabel.text=changeString;
        
        }else{
          cell.changeLabel.textColor=[UIColor grayColor];
          cell.changeLabel.text=changeString;
        
        }
    
      }else if (self.nameTag==3){
      
        cell.priceLabel.text=[NSString stringWithFormat:@"%.2f:1",[valueNumber floatValue]];
        NSNumber *changeNumber=self.iController.changeValueArray[indexPath.row];
        
        NSString *changeString=[NSString stringWithFormat:@"%.2f",round([changeNumber floatValue]*100)/100];
        if ([changeNumber floatValue]>0) {
          cell.changeLabel.textColor=[UIColor colorWithRed:225/255.0 green:81/255.0 blue:80/255.0 alpha:1.0];
          cell.changeLabel.text=[NSString stringWithFormat:@"+%@",changeString];
        }else if ([changeNumber floatValue]<0){
          cell.changeLabel.textColor=[UIColor colorWithRed:134/255.0 green:192/255.0 blue:54/255.0 alpha:1.0];
          cell.changeLabel.text=changeString;
          
        }
        else{
          cell.changeLabel.textColor = [UIColor grayColor];
          cell.changeLabel.text = changeString;
        }
      }
      
      else
      {
         cell.priceLabel.text=[NSString stringWithFormat:@"%.2f",[valueNumber floatValue]];
        NSNumber *changeNumber=self.iController.changeValueArray[indexPath.row];
        
        NSString *changeString=[NSString stringWithFormat:@"%.2f",round([changeNumber floatValue]*100)/100];
        if ([changeNumber floatValue]>0) {
          cell.changeLabel.textColor=[UIColor colorWithRed:225/255.0 green:81/255.0 blue:80/255.0 alpha:1.0];
          cell.changeLabel.text=[NSString stringWithFormat:@"+%@",changeString];
        }else if ([changeNumber floatValue]<0){
          cell.changeLabel.textColor=[UIColor colorWithRed:134/255.0 green:192/255.0 blue:54/255.0 alpha:1.0];
          cell.changeLabel.text=changeString;
        
        }
        else{
          cell.changeLabel.textColor = [UIColor grayColor];
          cell.changeLabel.text = changeString;
        }
       
      }
    }
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    if (indexPath.row%2 == 1)
    {
      cell.backgroundColor = [UIColor colorWithHex:0xfff9f9f9];
    }else
    {
      cell.backgroundColor = [UIColor whiteColor];
    }
  }
     return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.iController.entityValueArray.count-1;
}

@end


@interface CHCPGQuatationDetailController()

@property (nonatomic,weak) CHCPGQuatationDetailViewController *iViewController;

@end

@implementation CHCPGQuatationDetailController

@dynamic iViewController;

- (void)getAreaDynamicPriceListCity:(NSString *)city
                              WithPage:(int)page
                            completion:(void (^)(BOOL isSucceed, NSString *aDes))aCompletion{
  __weak typeof(self)wSelf = self;

  NSDictionary *param = @{@"city":city,@"page":@(page),@"pageSize":@(15)};;
  NSString *method =  method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_RegionDynamicPriceList];

  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc,
                                                                      NSError *error, NSDictionary *aData)
    {
      NSError *aError = error;
      if(aFlag != 0 && !aError)
      {
        aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
      }
      if (aError)
      {
        if (aCompletion)
        {
          aCompletion(NO,[aError domain]);
        }
      }
      else
      {
        [wSelf.changeValueArray removeAllObjects];
        [wSelf.valueArray removeAllObjects];
        if (page == 0) {
          wSelf.footerRefreshEnd = NO;
          [wSelf.entityValueArray removeAllObjects];
          [wSelf.changeValueArray removeAllObjects];
          
        }
        [wSelf constructPriceData:aData];
        [wSelf createChangeValueArray];
      
      if (aCompletion)
      {
        aCompletion(YES,nil);
      
      }
      }
  }];
  
}
- (void)getAreaDynamicPriceListWithUid:(NSNumber *)uid WithPage:(int)page completion:(void (^)(BOOL, NSString *))aCompletion{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_DynamicPriceList];
  NSDictionary *param=@{@"uid":uid,@"page":@(page),@"pageSize":@(15)};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData) {
    {
      NSError *aError = error;
      if(aFlag != 0 && !aError)
      {
        aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
      }
      if (aError)
      {
        if (aCompletion)
        {
          aCompletion(NO,[aError domain]);
        }
      }
      else
        
      {
        [wSelf.changeValueArray removeAllObjects];
        [wSelf.valueArray removeAllObjects];
        
        if (page == 0) {
          wSelf.footerRefreshEnd = NO;
          [wSelf.entityValueArray removeAllObjects];
          [wSelf.changeValueArray removeAllObjects]; 
        }
        [wSelf constructPriceData:aData];
        [wSelf createChangeValueArray];
      }
      if (aCompletion)
      {
        aCompletion(YES,nil);
      }
    }
  }];
  
}
- (void)constructPriceData:(NSDictionary *)aData
{
  NSDictionary *dic = aData[@"data"];
  NSArray *listArray = dic[@"list"];
  
  if (listArray.count == 0) {
    self.footerRefreshEnd = YES;
  }
  for (NSDictionary *dict in listArray)
  {
    self.priceListInfoVO=[[CHCQuatationPriceListInfoVO alloc]initWithDic:dict];
  
    [self.valueArray addObject:self.priceListInfoVO.values];
    [self.nameArray addObject:self.priceListInfoVO.name];
    [self.unitArray addObject:self.priceListInfoVO.unit];
  }
  if (self.valueArray.count==0) {
    [self.iViewController.iTableView.footer endRefreshing];
    return ;
  }
}
- (void)createChangeValueArray
{
  int a = self.iViewController.nameTag;
  float changeValue = 0;
  if (self.valueArray.count) {
    NSArray *valuearray = self.valueArray[a];
    [self.entityValueArray addObjectsFromArray:valuearray];

  }
  
  for (int index = 0; index < self.entityValueArray.count-1; index ++ )
  {
    changeValue =round([self.entityValueArray[index] floatValue]*100)/100 -round([self.entityValueArray[index+1] floatValue]*100)/100 ;
    [self.changeValueArray addObject:[NSNumber numberWithFloat:changeValue]];
  }
  
}

- (NSMutableArray *)nameArray
{
  if (_nameArray==nil) {
    _nameArray=[[NSMutableArray alloc]init];
  }
  return _nameArray;
  
  
}
- (NSMutableArray *)unitArray
{
  if (_unitArray==nil) {
    _unitArray=[[NSMutableArray alloc]init];
  }
  return _unitArray;
  
}
- (NSMutableArray *)valueArray
{
  if (_valueArray==nil) {
    _valueArray=[[NSMutableArray alloc]init];
  }
  return _valueArray;
  
}
- (NSMutableArray *)changeValueArray
{
  if (_changeValueArray==nil) {
    _changeValueArray=[[NSMutableArray alloc]init];
  }
  return _changeValueArray;
}

- (NSMutableArray *)entityValueArray
{
  if (_entityValueArray==nil) {
    _entityValueArray=[[NSMutableArray alloc]init];
  }
  return _entityValueArray;
}

@end
