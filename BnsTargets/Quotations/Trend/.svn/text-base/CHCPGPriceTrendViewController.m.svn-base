//
//  CHCPGPriceTrendViewController.m
//  Pigs
//
//  Created by wangbin on 16/5/24.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define kScreenSize [UIScreen mainScreen].bounds.size

#import "CHCPGPriceTrendViewController.h"
#import "UIButton+Extension.h"
#import "BnsQuationDef.h"
#import "UIColor+Hex.h"
#import "CHCPGQutationChangeCityViewController.h"
#import "CHCPGPriceTrendPlot.h"
#import "CHCPGPriceTrendDataSource.h"
#import "CHCPGQuatationHomeViewController.h"

@interface CHCPGPriceTrendViewController ()<UIScrollViewDelegate,
                                              CPTPlotAreaDelegate,
                                                CPTPlotSpaceDelegate,
                                                CPTScatterPlotDelegate>
@property (nonatomic,strong) CHCPGPriceTrendController *iController;
@property (nonatomic,strong) UIScrollView *iGlobalScrollView;
@property (nonatomic,strong) UIView *iNavigationView;
@property (nonatomic,strong) UIView *iMouthView;
@property (nonatomic,strong) UIView *iYearView;
@property (nonatomic,strong) UILabel *iLineLabel;
@property (nonatomic,strong) UIButton *iSelectButton;
@property (nonatomic,strong) UIButton *iChangeTrendButton;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIView *iGraphBgView;
@property (weak, nonatomic) IBOutlet UILabel *yearGlobelLabel;
@property (nonatomic, strong) CHCPGPriceTrendPlot * iPlotItem;
@property (nonatomic, strong) CHCPGPriceTrendDataSource * iPlotDataSource;
@property (nonatomic, strong) UIView * iHostView;
@property (nonatomic,assign) int iFinallyTag;
@property (nonatomic,assign) EHCPreciTrendType iMouthYearChangeTag;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *globeImageView;

@property (weak, nonatomic) IBOutlet UILabel *localLabel;


@end

@implementation CHCPGPriceTrendViewController
@dynamic iController;
static  NSString * const  noNetWorkToast= @"断网啦，请检查网络连接";
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.cityLabel.text = self.cityString;
  self.localLabel.text=self.cityString;
  /**
   *  首先显示的品种是在报猪价界面里面所报的品种  如果没有报猪价就显示外三元的曲线图
   */
  self.iFinallyTag=[[[NSUserDefaults standardUserDefaults] valueForKey:@"kQuoteSelectItem"] intValue];
  if (@(self.iFinallyTag) == nil) {
    self.iFinallyTag = 0;
  }
  UIView *aMisSelect=(UIView *)[self.view viewWithTag:2];
  aMisSelect.hidden=YES;
  self.view.backgroundColor=[UIColor whiteColor];
  
  UIButton *iButton = (UIButton *)[self.view viewWithTag:3];

  [self mouthYearTrendAction:iButton];
  UIButton *iTrendButton = (UIButton *)[self.view viewWithTag:self.iFinallyTag+5];
  [iTrendButton setBackgroundColor:[UIColor  colorWithHex:0xffe15150]];
  [iTrendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
  iTrendButton.selected = YES;
  self.iSelectButton = iTrendButton;

  self.iNavBar.topItem.title=@"价格趋势";
 
  
}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if ([self.cityString isEqualToString:@"全国"])
  {
    self.yearGlobelLabel.hidden = YES;
    self.globeImageView.hidden = YES;
  }
  else
  {
    self.yearGlobelLabel.hidden = NO;
    self.globeImageView.hidden = NO;
  }
}

- (NSArray *)getPlotDataArrayWithIndex:(NSInteger)index
{
  NSMutableArray * dataAry = [NSMutableArray arrayWithCapacity:1];
  NSDictionary* globaldic = [self.iController.iGloalDataArray objectAtIndex:index];
  [dataAry addObject:globaldic];
  NSDictionary * localDic = [self.iController.iCityDataArray objectAtIndex:index];
  [dataAry addObject:localDic];
  return dataAry;
}
- (NSArray *)getPlotYearDataArrayWithIndex:(NSUInteger)index
{
  NSMutableArray * dataAry = [NSMutableArray arrayWithCapacity:1];
  NSDictionary* lastdic = [self.iController.iLastDataArray objectAtIndex:index];
  [dataAry addObject:lastdic];
  NSDictionary * thisDic = [self.iController.iThisDataArray objectAtIndex:index];
  [dataAry addObject:thisDic];
  return dataAry;
  
}
#pragma mark - addPlotitem
- (void)setIPlotItem:(CHCPGPriceTrendPlot *)iPlotItem
{
  if (_iPlotItem != iPlotItem) {
    [_iPlotItem killGraph];
  }
  _iPlotItem = iPlotItem;
  [_iPlotItem renderInView:self.iHostView withTheme:(id)[NSNull null] animated:YES];
}
- (CHCPGPriceTrendPlot *)getPlotItemWithDataSource:(id)dataSource
{
  return [[CHCPGPriceTrendPlot alloc] initWithdelegate:self dataSource:dataSource];
}
- (void)addPlotItemHostingViewWithDataSource:(NSArray *)dataArray;
{
  if (!self.iPlotDataSource) {
    self.iPlotDataSource = [[CHCPGPriceTrendDataSource alloc] init];
  }
  [self.iPlotDataSource setDataSourceWithDataArray:dataArray type:self.iMouthYearChangeTag];
  
  if (self.iHostView) {
    [self.iHostView removeFromSuperview];
  }
  
  CGRect frame = CGRectMake(0, 0, kScreenSize.width - 35, 220);
  self.iHostView = [[UIView alloc] initWithFrame:frame];
  [self.iGraphBgView addSubview:self.iHostView];
  self.iPlotItem = [self getPlotItemWithDataSource:self.iPlotDataSource];
}

- (IBAction)backToRootAction:(id)sender {
  
  [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)mouthYearTrendAction:(UIButton *)sender
{
  if (self.iChangeTrendButton == sender) {
    return;
  }
  [sender setTitleColor:[UIColor colorWithHex:0xff999999] forState:UIControlStateNormal];
  self.iChangeTrendButton.selected=NO;
  sender.selected=YES;
  self.iChangeTrendButton=sender;
  [self.iChangeTrendButton setTitleColor:[UIColor colorWithHex:0xffe15150]
                                forState:UIControlStateSelected];
  UIView *aSelectView=(UIView *)[self.view viewWithTag:1];
  UIView *aMisSelect=(UIView *)[self.view viewWithTag:2];
  if (sender.tag==3) {
    aMisSelect.hidden=YES;
    aSelectView.hidden=NO;
    self.iMouthYearChangeTag = EHCPreciTrendMonth;
  }
  else
  {
    self.iMouthYearChangeTag = EHCPreciTrendYear;
    aSelectView.hidden=YES;
    aMisSelect.hidden=NO;
  }
  
  [self selectByMouthYearChange];
}

- (IBAction)trendSelectAction:(UIButton *)sender
{
  if (sender == self.iSelectButton) {
    return;
  }
  if (sender.tag==8)
  {
  self.unitLabel.text=@"";
  }else if (sender.tag==9||sender.tag==10)
  {
  self.unitLabel.text=@"单位：元／吨";
  }else
  {
  self.unitLabel.text=@"单位：元／公斤";
  }
  [self.iSelectButton setBackgroundColor:[UIColor colorWithHex:0xfff1f1f1]];
  self.iSelectButton.selected = NO;
  sender.selected = YES;
  self.iSelectButton = sender;
  [self.iSelectButton setBackgroundColor:[UIColor  colorWithHex:0xffe15150]];
  [self.iSelectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
  self.iFinallyTag=(int)sender.tag-5;
  if (self.iMouthYearChangeTag == EHCPreciTrendMonth) {
    [self addPlotItemHostingViewWithDataSource:[self getPlotDataArrayWithIndex:self.iFinallyTag]];
  }else{
   [self addPlotItemHostingViewWithDataSource:[self getPlotYearDataArrayWithIndex:self.iFinallyTag]];
  }
  
}
- (IBAction)selectCitysAction:(UIButton *)sender
{

  CHCPGQutationChangeCityViewController *cityVC=[[CHCPGQutationChangeCityViewController alloc]
                                                 initWithCityChooseBlock:^(NSDictionary *selectCity) {
    self.cityString = selectCity[@"area"];
    self.provinceString = selectCity[@"parent"];
                                                   self.localLabel.text=self.cityString;
                                                   
                                                   if ([_delegate respondsToSelector:@selector(getTrendSelectCity:andProvince:)]) {
                                                     [_delegate getTrendSelectCity:self.cityString andProvince:self.provinceString];
                                                   }
    dispatch_async(dispatch_get_main_queue(), ^{
      self.cityLabel.text=selectCity[@"area"];
    });
          [self selectByMouthYearChange];
           }];

  cityVC.hidesBottomBarWhenPushed=YES;
  [self.navigationController pushViewController:cityVC animated:YES];

}

- (void)selectByMouthYearChange
{
  __weak typeof(self)wSelf = self;
  if (self.iMouthYearChangeTag == EHCPreciTrendMonth)
  {
    /**
     *  获取月趋势图
     */
    [self.iController getMouthAreaPriceListWithUid:[CHCCommonInfoVO sharedManager].iHCid
                                    andCurrentCity:self.cityString
                                   CurrentProvince:self.provinceString
                                          WithPage:0
                                        completion:^(BOOL isSucceed, NSString *aDes)
     {
       if (isSucceed) {
         [wSelf addPlotItemHostingViewWithDataSource:[self getPlotDataArrayWithIndex:self.iFinallyTag]];
         [wSelf hideNoNetWorkView];
       }else{
         [self showNoNetWorkView];
       }
     }];
    
  }else
  {
    /**
     *  获取年趋势图
     */
    [self.iController getYearAreaPriceListWithUid:[CHCCommonInfoVO sharedManager].iHCid
                                   andCurrentCity:self.cityString
                                  CurrentProvince:self.provinceString
                                         WithPage:0
                                       completion:^(BOOL isSucceed, NSString *aDes) {
                                         if (isSucceed)
                                         {
                                           [wSelf addPlotItemHostingViewWithDataSource:[self getPlotYearDataArrayWithIndex:self.iFinallyTag]];
                                           [wSelf hideNoNetWorkView];
                                         }else
                                         {
                                     
                                         }
                                       }];
  }
}

- (void)noNetWorkButtonAction
{
  [self selectByMouthYearChange];
}
- (BOOL)isNeedNoNetworkView{
  return YES;
  
}

@end
@interface CHCPGPriceTrendController()
@end

@implementation CHCPGPriceTrendController
- (instancetype)init
{
  if (self = [super init]) {
    self.iGloalDataArray = [NSMutableArray arrayWithCapacity:1];
    self.iCityDataArray = [NSMutableArray arrayWithCapacity:1];
    self.iLastDataArray = [NSMutableArray arrayWithCapacity:1];
    self.iThisDataArray = [NSMutableArray arrayWithCapacity:1];
  }
  return self;
}
- (void)getMouthAreaPriceListWithUid:(NSNumber *)uid
                      andCurrentCity:(NSString *)city
                     CurrentProvince:(NSString *)province
                             WithPage:(int)page
                          completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_MonthRegionDynamicPrice];
  if (![CHCCommonInfoVO sharedManager].isLogin)
  {
    if ([city isEqualToString:@"全国"]) {
      province=@"全国";
    }
    self.param=@{@"uid":@(0),@"province":province,@"city":city,@"page":@(page)};
  }else 
  {
    if (province==nil) {
      province=@"";
    }
  self.param=@{@"uid":uid,@"province":province,@"city":city,@"page":@(page)};
  }
    [self.iModelHandler postMethod:method parameters:self.param completion:^(NSInteger aFlag, NSString *aDesc,
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
       [wSelf constructDataWithData:aData];
      if (aCompletion)
      {
        aCompletion(YES,nil);
      }
    }
  }];
}
- (void)constructDataWithData:(NSDictionary *)dict
{
  [self.iGloalDataArray removeAllObjects];
  [self.iCityDataArray removeAllObjects];
  NSArray * globalAry = [dict valueForKeyPath:@"globle.list"];
  [self.iGloalDataArray addObjectsFromArray:globalAry];
  NSArray * localAry = [dict valueForKeyPath:@"local.list"];
  [self.iCityDataArray addObjectsFromArray:localAry];
  
}
- (void)constructYearDataWithData:(NSDictionary *)dict
{
  [self.iLastDataArray removeAllObjects];
  [self.iThisDataArray removeAllObjects];
  NSArray *lastDataArray=[dict valueForKeyPath:@"lastYear.list"];
  [self.iLastDataArray addObjectsFromArray:lastDataArray];
  NSArray *thisDataArray=[dict valueForKeyPath:@"thisYear.list"];
  [self.iThisDataArray addObjectsFromArray:thisDataArray];
  
}
- (void)getYearAreaPriceListWithUid:(NSNumber *)uid
                     andCurrentCity:(NSString *)city
                    CurrentProvince:(NSString *)province
                           WithPage:(int)page
                         completion:(void (^)(BOOL, NSString *))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_YearRegionDynamicPrice];
  NSDictionary *param=@{@"uid":uid,@"province":province, @"city":city,@"page":@(page)};
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
       [wSelf constructYearDataWithData:aData];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}

@end

