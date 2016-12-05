//
//  HCBaseAppDelegate.m
//  FoodYou
//
//  Created by Lemon-HEcom on 15/9/7.
//  Copyright (c) 2015年 AZLP. All rights reserved.
//

#import "CHCBaseAppDelegate.h"
#import "AppDef.h"


@implementation CHCBaseAppDelegate
@synthesize iWindow;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSDictionary *lastHttpConnectInfoDic = nil;//[[NSUserDefaults standardUserDefaults] objectForKey:HC_UrlConnection_Info_Key];
  if ( lastHttpConnectInfoDic == nil )
  {
    lastHttpConnectInfoDic = @{
                               HC_UrlConnection_ProtocolType_Key:HC_UrlConnection_ProtocolType,
                               HC_UrlConnection_URL_Key:HC_UrlConnection_URL,
                               HC_UrlConnection_Port_Key:HC_UrlConnection_Port,
                               HC_UrlConnection_FileProtocolType_Key:HC_UrlConnection_FileProtocolType,
                               HC_UrlConnection_FileURL_Key:HC_UrlConnection_FileURL,
                               HC_UrlConnection_FilePort_Key:HC_UrlConnection_FilePort,
                               HC_UrlConnection_Service_Key:HC_UrlConnection_Service};
    
    [[NSUserDefaults standardUserDefaults] setObject:lastHttpConnectInfoDic forKey:HC_UrlConnection_Info_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  
  [self loadCookies];
  
  UIScreen *screen = [UIScreen mainScreen];
  self.iWindow = [[UIWindow alloc]initWithFrame:screen.bounds];
  
  UIViewController *aVC = [self getFirstViewController];
  self.iWindow.rootViewController = aVC;
  
  [self.iWindow makeKeyAndVisible];
  // Override point for customization after application launch.
  return YES;
}

- (void)loadCookies
{
  NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:HC_UrlConnection_Cookie_Key];
  if([cookiesdata length])
  {
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
    NSHTTPCookie *cookie;
    for (cookie in cookies)
    {
      [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
  }
}

- (UIViewController *)getFirstViewController
{
  return nil;
}
#pragma mark - remotePush
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
  NSLog(@"userinfo:%@",userInfo);
  NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
   NSLog(@"Registfail%@",error);
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
  NSLog(@"%@",deviceToken);//这里的Token就是我们设备要告诉服务端的Token码
//  [CHCPushUtil putDeviceTokenToNSUserDefaults:deviceToken];
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
