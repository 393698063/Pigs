//
//  CHCPGCountsHomeViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define kScreenSize [UIScreen mainScreen].bounds.size
#import "CHCPGCountsHomeViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "LocationManager.h"
#import "CHCPGCustomAnnotationView.h"
#import "CHCPGCustomCountAnnotationView.h"
#import "CHCSqliteManager.h"
#import "CHCPGUserDataSycnViewController.h"
#import "SynchronzeDef.h"
#import "drawDownMenu.h"
#import "drawUpMenu.h"
#import "UIView+frame.h"
#import "DateFomatterTool.h"
#import "CHCPGCountOffViewController.h"
#import "CHCPGGoldManager.h"
#import "AppDelegate.h"
#import "BnsCountDef.h"
#import "CHCPGCountPromotionVO.h"
#import "CHCPGCountPromotionView.h"
#import "CHCPGWebViewController.h"
#import "CHCCommonInfoVO.h"

@interface CHCPGCountsHomeViewController ()<MAMapViewDelegate,
CustomAnnotationDelegate,
CustomCountedAnnotationDelegate,
promotionViewDelegate>
{
  MAMapView * _mapView;
}
@property (nonatomic, assign) BOOL iCountedFlag;
@property (nonatomic, strong) CHCPGCountsHomeController * iController;
@property (nonatomic, strong) drawUpMenu * iDrawUpMenu;
@property (nonatomic, strong) drawDownMenu * iDrawDownMenu;
@property (weak, nonatomic) IBOutlet UIImageView *iGoldImage;
@property (weak, nonatomic) IBOutlet UILabel *iGoldLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iTitleImage;
@end

@implementation CHCPGCountsHomeViewController
@dynamic iController;
- (BOOL)isNeedBaseViewTapAction
{
  return NO;
}
- (BOOL)isNeedRightGestureRecognizer
{
  return YES;
}
- (instancetype)init
{
  if (self = [super init])
  {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(login:)
                                                 name:HC_PG_Login_login
                                               object:nil];
  }
  return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.iCountedFlag = NO;
  [self addObserver:self forKeyPath:@"iCountedFlag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
  [self addLoactionButton];
  [self addAdvertisement];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
  if ([change objectForKey:@"old"] == [change objectForKey:@"new"]) {
    return;
  }
  if (self.iCountedFlag)
  {
    //自动展开
    [self.iDrawDownMenu show];
  }
  else
  {
    [self.iDrawDownMenu hide];
    [self.iDrawUpMenu hide];
  }
  [self addAnnotation];
}

- (void)readUserGoldData
{
  if (![CHCCommonInfoVO sharedManager].isLogin)
  {
    self.iGoldLabel.text=@"未登录";
  }
  else
  {
    self.iGoldLabel.text=[NSString stringWithFormat:@"%ld",
                          (long)[[CHCPGGoldManager sharedCHCPGGoldManager] readUserGoldCount]];
  }
}
- (void)login:(NSNotification *)aNotice
{
  [self.iController resetSqlManager];
  [self decideTheCountedFlag];
}
- (void)decideTheCountedFlag
{
  NSArray * countAry = [self.iController readCountNum];
  if (countAry.count == 0)
  {
    //add 未报数页面
    self.iCountedFlag = NO;
  }
  else
  {
    //add 已报数页面
    self.iCountedFlag = YES;
  }
}
- (void)addLoactionButton
{
  UIButton * locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  locationBtn.width = 30;
  locationBtn.height = 30;
  locationBtn.bottom = kScreenSize.height - 49 - 30;
  locationBtn.right = kScreenSize.width - 20;
  [locationBtn setImage:[UIImage imageNamed:@"count_location"] forState:UIControlStateNormal];
  [locationBtn setImage:[UIImage imageNamed:@"count_location_h"] forState:UIControlStateHighlighted];
  [locationBtn addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:locationBtn];
}
- (void)locationAction:(UIButton *)button
{
  [self getLocation];
}
- (void)addAdvertisement
{
  UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, -95 + 64, [UIScreen mainScreen].bounds.size.width, 95)];
  [self.view addSubview:contentView];
  
  CGRect frame = contentView.frame;
  frame.origin.y = 64;
  frame.size.height = 30;
  drawDownMenu * drawMenu = [drawDownMenu drawMenuView:contentView];
  self.iDrawDownMenu = drawMenu;
  drawMenu.frame = frame;
  [self.view addSubview:drawMenu];
  [drawMenu hide];
  drawMenu.hidden = YES;
  [self.view bringSubviewToFront:self.iNavBar];
  [self.view bringSubviewToFront:self.iTitleImage];
  [self.view bringSubviewToFront:self.iGoldImage];
  [self.view bringSubviewToFront:self.iGoldLabel];
}
- (void)addAvertContent
{
  CHCPGCountPromotionView * promotionView = [CHCPGCountPromotionView countPromotionViewWithFrame:self.iDrawDownMenu.contentView.bounds
                                                                                   promotionData:self.iController.iPromotionAry];
  promotionView.delegate = self;
  if (self.iDrawDownMenu.contentView.subviews) {
    for (UIView * view in self.iDrawDownMenu.contentView.subviews) {
      [view removeFromSuperview];
    }
  }
  [self.iDrawDownMenu.contentView addSubview:promotionView];
  if (self.iCountedFlag) {
//    [self.iDrawDownMenu show];
  }
}
- (void)addAnnotation
{
  [_mapView removeAnnotations:_mapView.annotations];
  CLLocationDegrees latitude = 0.0 ;
  CLLocationDegrees longtitude = 0.0 ;
  LocationManager * manager = [LocationManager sharedLocationManager];
  if (![manager.iLatitude isEqualToString:@""])
  {
    latitude = manager.iLatitude.doubleValue;
    longtitude = manager.iLongitude.doubleValue;
    if (_mapView.annotations.count == 0)
    {
      MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
      pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longtitude);
      [_mapView addAnnotation:pointAnnotation];
      [_mapView selectAnnotation:pointAnnotation animated:YES];
      [_mapView showAnnotations:@[pointAnnotation] animated:YES];
    }
  }
  else
  {
    [self getLocation];
  }
}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self readUserGoldData];
  __weak typeof(self)wSelf = self;
  [self.iController getPromotionCompletion:^(BOOL isSucceed, NSString *aDes)
   {
     if (isSucceed) {
       self.iDrawDownMenu.hidden = NO;
       [wSelf addAvertContent];
     }
     
   }];
  if (!_mapView) {
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)];
    _mapView.delegate = self;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];
  }
}
- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
//  if (!_mapView.annotations.count)
//  {
    [self addAnnotation];
//  }
  [self decideTheCountedFlag];
}
- (void)getLocation
{
  [[LocationManager sharedLocationManager] gecodeLocationCompeletionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
   {
     if (error)
     {
       HCLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
       
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:@"定位失败"
                                                   withIconImageName:nil];
       return;
     }
     if (location)
     {
       [_mapView setZoomLevel:10.14 animated:YES];
       if (_mapView.annotations.count != 0)
       {
         [_mapView removeAnnotations:_mapView.annotations];
       }
         MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
         pointAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
         [_mapView addAnnotation:pointAnnotation];
         [_mapView selectAnnotation:pointAnnotation animated:YES];
         [_mapView showAnnotations:@[pointAnnotation] animated:YES];
     }
   }];
}
#pragma mark - promotionDelegate
- (void)promotionViewDidSelectIndex:(NSInteger)index
{
  CHCPGCountPromotionVO * promotionVo = [self.iController.iPromotionAry objectAtIndex:index];
  NSString * url = nil;
  if ([promotionVo.artType isEqualToNumber:@(1)]) {
    url = promotionVo.url;
  }
  if ([promotionVo.artType isEqualToNumber:@(2)]) {
    if ([promotionVo.promotionType isEqualToNumber:@(1)]) {
      url = promotionVo.url;
    }
    else
    {
      url = promotionVo.netUrl;
    }
  }
  
  CHCPGWebViewController * aWeb = [[CHCPGWebViewController alloc] initWithUrlStr:url
                                                                     imageUrlStr:promotionVo.img
                                                                        titleStr:promotionVo.title
                                                                    infomationId:promotionVo.iHCid
                                                                         webType:EHCWebCirculate];
  aWeb.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:aWeb animated:YES];
}
#pragma mark - mapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
  MAPinAnnotationView * annotationView = nil;
  if ([annotation isKindOfClass:[MAPointAnnotation class]])
  {
    if (self.iCountedFlag) {
      static NSString *pointReuseIndentifier = @"countannotationReuseIndetifier";
      annotationView = (CHCPGCustomCountAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
      if (annotationView == nil)
      {
        annotationView = [[CHCPGCustomCountAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
      }
      ((CHCPGCustomCountAnnotationView *)annotationView).iDelegate = self;
    }
    else
    {
      static NSString *pointReuseIndentifier = @"nocountannotationReuseIndetifier";
      annotationView = (CHCPGCustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
      if (annotationView == nil)
      {
        annotationView = [[CHCPGCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
      }
      ((CHCPGCustomAnnotationView *)annotationView).iDelegate = self;
    }
    annotationView.pinColor = MAPinAnnotationColorRed;
    return annotationView;
  }
  return nil;
}

#pragma mark - calloutViewDelegate
- (void)submitFatPig:(NSString *)fatNum sow:(NSString *)sowNum
{
  __weak typeof(self)wSelf = self;
  if ([fatNum isEqualToString:@""] || [sowNum isEqualToString:@""]) {
    [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                  withShowingText:@"请填写存栏数"
                                                withIconImageName:nil];
    return;
  }
  self.iController.iCountVo.pigFatStock = @(fatNum.integerValue);
  self.iController.iCountVo.pigSowStock = @(sowNum.integerValue);
  self.iController.iCountVo.pigAdd = @(0);
  self.iController.iCountVo.pigDeath = @(0);
  self.iController.iCountVo.pigLittleStock = @(0);
  self.iController.iCountVo.fodder = @(0);
  NSDictionary * dataDic = [self.iController.iCountVo fillVoDictionary];
  [self.iController saveCountPigData:dataDic tableName:HCPG_SimpDiaryTable];
  
  [[CHCPGGoldManager sharedCHCPGGoldManager] showGoldGifWithType:EHCGoldCount
                                                     compeletion:^(BOOL compeleted, NSString *aDesc)
  {
    wSelf.iCountedFlag = YES;
  }];
  CHCPGUserDataSycnViewController *simpleDiaryUpLoad= ((AppDelegate *)([UIApplication sharedApplication].delegate)).iUserDataSyncController;
  [simpleDiaryUpLoad uploadSimplDiaryCompletion:^(BOOL isSucceed, NSString *aDes) {
    
    if (isSucceed) {
      
    }else{
//
    }
  }];
  
}

- (void)callOutViewTapAtion
{
  CHCPGCountOffViewController * avc = [[CHCPGCountOffViewController alloc] initWithDate:nil];
  avc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:avc animated:YES];
}
- (void)dealloc
{
  [self removeObserver:self forKeyPath:@"iCountedFlag"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

@interface CHCPGCountsHomeController ()
@property (nonatomic, strong) CHCSqliteManager * iSqliteManager;
@end

@implementation CHCPGCountsHomeController
- (instancetype)init
{
  if (self = [super init])
  {
    self.iPromotionAry = [NSMutableArray arrayWithCapacity:1];
    [self resetSqlManager];
    self.iCountVo = [[CHCPGCountPigVO alloc] init];
  }
  return self;
}
- (void)resetSqlManager
{
  if ([CHCCommonInfoVO isLogin])
  {
    NSString * path = [NSString stringWithFormat:@"%@/%@",
                       [CHCPGUserDataSycnController createUserPath],
                       @"database.db"];
    HCLog(@"%@",path);
    self.iSqliteManager = [CHCSqliteManager creatSqliteManager:path];
  }
}
- (NSArray *)readCountNum
{
  NSArray * rtnAry = nil;
  NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT 0,1",HCPG_SimpDiaryTable];
  rtnAry = [self.iSqliteManager executeQueryRtnAry:sql];
  HCLog(@"%ld",rtnAry.count);
  return rtnAry;
}
- (void)saveCountPigData:(NSDictionary *)data tableName:(NSString *)tableName
{
  NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
  [dataDic setObject:[CHCCommonInfoVO sharedManager].iHCid forKey:@"uid"];
  [dataDic setObject:@([DateFomatterTool getCurrentTimeStamp]) forKey:@"createAt"];
  [dataDic setObject:@(-1) forKey:@"id"];
  NSMutableString * updataSql = [NSMutableString string];
  
  [updataSql appendFormat:@"INSERT OR REPLACE INTO "];
  [updataSql appendFormat:@"'%@'",tableName?:@""];
  [updataSql appendFormat:@" ("];
  
  NSMutableString *keys = [NSMutableString stringWithString:@""];
  NSMutableString *values = [NSMutableString stringWithString:@""];
  [dataDic enumerateKeysAndObjectsUsingBlock:
   ^(id key, id obj, BOOL *stop)
   {
     [keys appendFormat:@"\"%@\" ,",key];
     [values appendFormat:@"\"%@\" ,",obj];
   }];
  [keys deleteCharactersInRange:NSMakeRange(keys.length-1, 1)];
  [values deleteCharactersInRange:NSMakeRange(values.length-1, 1)];
  
  [updataSql appendFormat:@"%@",keys];
  [updataSql appendFormat:@") VALUES ("];
  [updataSql appendFormat:@"%@",values];
  
  [updataSql appendFormat:@")"];
  [self.iSqliteManager openDB];
  [self.iSqliteManager beginTransaction];
  [self.iSqliteManager executeNotQuery:updataSql];
  
  [self.iSqliteManager commitTransaction];
  [self.iSqliteManager closeDB];

}
- (void)getPromotionCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_CountPromotionList];
  NSDictionary * param = @{};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
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
       [self.iPromotionAry removeAllObjects];
       [wSelf constructPromotionData:[aData objectForKey:@"data"]];
       if (aCompletion) {
         aCompletion(YES,nil);
       }
     }
   }];
}
- (void)constructPromotionData:(NSArray *)data
{
  [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    CHCPGCountPromotionVO * avo = [[CHCPGCountPromotionVO alloc] initWithDic:obj];
    [self.iPromotionAry addObject:avo];
  }];
}
@end
