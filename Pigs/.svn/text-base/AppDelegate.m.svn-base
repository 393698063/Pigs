//
//  AppDelegate.m
//  Pigs
//
//  Created by HEcom on 16/4/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "AppDelegate.h"
#import "CHCPGCountsHomeViewController.h"
#import "CHCPGDisCoverHomeViewController.h"
#import "CHCPGMineHomeViewController.h"
#import "CHCPGProfessorHomeViewController.h"
#import "CHCPGQuatationHomeViewController.h"
#import "UIColor+Hex.h"
#import "CHCAdvertisingManager.h"
#import "CHCPGLoginViewController.h"
#import "CHCPGGoldManager.h"
#import "CHCPGCommonDataSyncViewController.h"
#import "CHCPGGuideViewController.h"
#import "CHCReachability.h"
#import "LocationManagerDef.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "LocationManager.h"
#import "CHCSharedManager.h"
#import "UMSocialSnsService.h"
#import "UMMobClick/MobClick.h"
@interface AppDelegate ()<UITabBarControllerDelegate>
@property (nonatomic) CHCReachability *internetReachability;
@end

@implementation AppDelegate

- (void)configureAPIKey
{
  if ([LacationApiKey length] == 0)
  {
    NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
  }
  
  [MAMapServices sharedServices].apiKey = (NSString *)LacationApiKey;
  [AMapLocationServices sharedServices].apiKey = (NSString *)LacationApiKey;
}

- (void)umengTrack
{
  [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
  [MobClick setLogEnabled:YES];
  UMConfigInstance.appKey = HC_Share_UMAppKey;
  UMConfigInstance.secret = @"secretstringaldfkals_zhufuda";
  //渠道默认为appStore default: "App Store"*/
  //  UMConfigInstance.channelId = HCPG_APPStoreChanle;
  //发送模式默认为batch
  //  UMConfigInstance.ePolicy = BATCH;
  [MobClick startWithConfigure:UMConfigInstance];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.
  [self umengTrack];
  [self configureAPIKey];
  [CHCSharedManager registShare];
  [[LocationManager sharedLocationManager] gecodeLocationCompeletionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
    
  }];
  self.iCommonDataSyncController = [[CHCPGCommonDataSyncViewController alloc] init];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:HC_PG_Login_login object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:HC_PG_Login_logout object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncComonData) name:HCPG_UserSyncPopularData object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
  NSString *remoteHostName = @"www.baidu.com";
  self.hostReachability = [CHCReachability reachabilityWithHostName:remoteHostName];
  [self.hostReachability startNotifier];

  self.internetReachability = [CHCReachability reachabilityForInternetConnection];
  [self.internetReachability startNotifier];

  BOOL rtnValue = [super application:application didFinishLaunchingWithOptions:launchOptions];
  
  return rtnValue;
}
- (void) reachabilityChanged:(NSNotification *)note
{
  CHCReachability* curReach = [note object];
  NSParameterAssert([curReach isKindOfClass:[CHCReachability class]]);
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
  BOOL result = [UMSocialSnsService handleOpenURL:url];
  if (result == FALSE) {
    //调用其他SDK，例如支付宝SDK等
  }
  return result;
}
/**
 *  获取用户数据控制器
 *
 *  @return 用户数据管理控制器
 */
- (CHCPGUserDataSycnViewController *)iUserDataSyncController
{
  if (!_iUserDataSyncController) {
    _iUserDataSyncController = [[CHCPGUserDataSycnViewController alloc] init];
  }
  return _iUserDataSyncController;
}

#pragma mark - super method get first viewcontroller
- (UIViewController *)getFirstViewController
{
  UIViewController *rtnVC = nil;
  
  HCLog(@"%d",[CHCCommonInfoVO isSync]);
  if (![CHCCommonInfoVO isSync])
  {
    rtnVC = [[CHCPGCommonDataSyncViewController alloc] init];
    
  }
//  else if ([CHCPGGuideViewController isNeedShow])
//  {
//    rtnVC = [[CHCPGGuideViewController alloc] initWithImageAry:@[@"1",@"2",@"3"]
//                                                    completion:^(BOOL isEnd)
//             {
//               UIViewController *firstVC = [self getFirstViewController];
//               self.iWindow.rootViewController = firstVC;
//               [self.iWindow makeKeyAndVisible];
//             }];
//  }
  else
  {
    rtnVC = [self creatTabbarController];
  }
  
  return rtnVC;
}
- (void)readLoginInfo
{
  NSDictionary * aDataDic = [[NSUserDefaults standardUserDefaults] valueForKey:HC_CommonInfo_UserData];
  [[CHCCommonInfoVO sharedManager] putValueFromDic:aDataDic];
  if (aDataDic) {
    [CHCCommonInfoVO sync];
    [CHCCommonInfoVO login];
    [self.iUserDataSyncController sycnUserGoldDataCompletion:^(BOOL isSucceed, NSString *aDes)
    {
      if (isSucceed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HC_PG_Login_login object:nil];
      }
      else
      {
        
      }
    }];
  }
  else
  {
    [CHCCommonInfoVO logout];
  }
}
#pragma mark get tabbar VC
- (UIViewController *)creatTabbarController
{
  UIViewController *rtnVC = nil;
  UITabBarController *aTabbarController = [[UITabBarController alloc]init];
  [aTabbarController.tabBar setBackgroundColor:[UIColor colorWithHex:0xEFEFEF]];
  
  UIViewController *firstVC = [self createViewControllerWithClassName:NSStringFromClass([CHCPGQuatationHomeViewController class])
                                                                title:NSLocalizedStringFromTable(@"Quatation", BnsTargetApp, nil)
                                                                image:@"quatation_nor" selectedImage:@"quatation_sel"];
  UIViewController *secondVC= [self createViewControllerWithClassName:NSStringFromClass([CHCPGCountsHomeViewController class])
                                                                title:NSLocalizedStringFromTable(@"Count", BnsTargetApp, nil)
                                                                image:@"count_nor" selectedImage:@"count_sel"];
  UIViewController *thirdVC = [self createViewControllerWithClassName:NSStringFromClass([CHCPGProfessorHomeViewController class])
                                                                title:NSLocalizedStringFromTable(@"Professor", BnsTargetApp, nil)
                                                                image:@"expert_nor" selectedImage:@"exper_sel"];
  UIViewController *fourthVC= [self createViewControllerWithClassName:NSStringFromClass([CHCPGDisCoverHomeViewController class])
                                                                title:NSLocalizedStringFromTable(@"Discover", BnsTargetApp, nil)
                                                                image:@"discover_nor" selectedImage:@"discover_sel"];
  UIViewController *fiveVC = [self createViewControllerWithClassName:NSStringFromClass([CHCPGMineHomeViewController class])
                                                               title:NSLocalizedStringFromTable(@"Mine", BnsTargetApp, nil)
                                                               image:@"mine_nor" selectedImage:@"mine_sel"];
  
  NSMutableArray *viewControllers = [[NSMutableArray alloc]initWithObjects:
                                     firstVC,
                                     secondVC,
                                     thirdVC,
                                     fourthVC,
                                     fiveVC,
                                     nil];
  
  aTabbarController.viewControllers = viewControllers;
    aTabbarController.delegate = self;
  rtnVC = aTabbarController;
  return rtnVC;
}
- (UIViewController *)createViewControllerWithClassName:(NSString *)className
                                                  title:(NSString *)titleStr
                                                  image:(NSString *)image
                                          selectedImage:(NSString *)selectedImage
{
  CHCBaseViewController * avc = [[NSClassFromString(className) alloc] init];
//  avc.iTitleStr = titleStr;
  UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:avc];
  UIImage * tabItemImg = [UIImage imageNamed:image];
  UIImage * tabSelectImg = [UIImage imageNamed:selectedImage];
  NSString * tabbarTitle = titleStr;
  UITabBarItem * tabItem = [[UITabBarItem alloc] initWithTitle:tabbarTitle
                                                         image:tabItemImg
                                                 selectedImage:tabSelectImg];
  avc.navigationController.navigationBarHidden = YES;
  [self putTabbatItemAttributes:tabItem];
  nvc.tabBarItem = tabItem;
  return nvc;
}
- (void)putTabbatItemAttributes:(UITabBarItem *)aTabBarItem
{
  NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIColor colorWithHex:0xFF747474], NSForegroundColorAttributeName,
                              nil];
  [aTabBarItem setTitleTextAttributes:attributes
                             forState:UIControlStateNormal];
  
  NSDictionary *attributesSelect = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor colorWithHex:0xFFe15150], NSForegroundColorAttributeName,
                                    nil];
  [aTabBarItem setTitleTextAttributes:attributesSelect
                             forState:UIControlStateSelected];
  
  
  aTabBarItem.selectedImage = [aTabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  aTabBarItem.image = [aTabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController
{
  BOOL rtn = NO;
  NSInteger index = [tabBarController.childViewControllers indexOfObject:viewController];
  if (![CHCCommonInfoVO isLogin] && index != 0 && index != 3) {
      CHCPGLoginViewController * loginVc = [[CHCPGLoginViewController alloc] init];
      UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:loginVc];
      loginVc.navigationController.navigationBarHidden = YES;
    [tabBarController presentViewController:nvc animated:YES completion:nil];
  }
  else
  {
    rtn = YES;
  }
  return rtn;
}

- (void)putLoginInfo:(NSDictionary *)aDataDic
{
  if (aDataDic)
  {
    [[CHCCommonInfoVO sharedManager] putValueFromDic:aDataDic];
    [[NSUserDefaults standardUserDefaults] setObject:aDataDic forKey:HC_CommonInfo_UserData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [CHCCommonInfoVO login];
  }
  else
  {
    //else里面不要写其他信息，即post login:nil的时候不清空登录信息，只有postlogout的时候才清空登录信息
  }
}
- (void)syncComonData
{
  [self readLoginInfo];
  self.iWindow.rootViewController = [self getFirstViewController];
  [self.iWindow makeKeyAndVisible];
}

- (void)login:(NSNotification *)aNotice
{
  //同步
  [self.iUserDataSyncController syncUserOtherDataCompletion:^(BOOL isSucceed, NSString *aDes)
   {
     
   }];
  //上传咨询统计
  [self.iCommonDataSyncController upLoadInformationStatisticCompletion:^(BOOL isSucceed, NSString *aDes) {
    
  }];
  //上传用户本地数据
  [self.iUserDataSyncController upLoadUserLocalData];
  [[CHCPGGoldManager sharedCHCPGGoldManager] showGoldGifWithType:EHCGoldLogin];
}
- (void)logout:(NSNotification *)aNotice
{
  self.iUserDataSyncController = nil;
  [CHCPGGoldManager destroy];
  [self clearLoginInfo];
}
- (void)clearLoginInfo
{
  [[CHCCommonInfoVO sharedManager] putValueFromDic:nil];
  [[NSUserDefaults standardUserDefaults] setObject:nil forKey:HC_CommonInfo_UserData];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [CHCCommonInfoVO logout];
  ((UITabBarController *)self.iWindow.rootViewController).selectedIndex = 0;
}
- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
