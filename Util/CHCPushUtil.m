/*!
 @class
 @abstract push操作类
 */

#import "CHCPushUtil.h"
#import "CHCStringUtil.h"
#import "CHCUFTool.h"

@implementation CHCPushUtil

#pragma mark 注册
+ (void)registerWithIsBadge:(BOOL)aIsBadge 
                WithIsAlert:(BOOL)aIsAlert 
                WithIsSound:(BOOL)aIsSound;
{
  if (HC_CURENT_OS_V >= 8.0f)
  {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|
                                                                                         UIUserNotificationTypeBadge|
                                                                                         UIUserNotificationTypeSound)
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
  }
  else
  {
    NSUInteger type = [self switchToTypeWithIsBadge:aIsBadge
                                        WithIsAlert:aIsAlert
                                        WithIsSound:aIsSound];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:type];
  }
}

//转化为系统的类别
+ (NSUInteger) switchToTypeWithIsBadge:(BOOL)aIsBadge 
                           WithIsAlert:(BOOL)aIsAlert 
                           WithIsSound:(BOOL)aIsSound;
{
  NSUInteger which = 0;
  if (aIsBadge) 
  {
    which = which | UIUserNotificationTypeBadge;
  }
  if (aIsAlert) 
  {
    which = which | UIUserNotificationTypeAlert;
  }
  if (aIsSound) 
  {
    which = which | UIUserNotificationTypeSound;
  }
  return which;
}

#pragma mark 注销
+ (void)unregister
{
  [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

#pragma  mark 保存deviceToken到NSUserDefaults中，并保存
+ (void)putDeviceTokenToNSUserDefaults:(NSData  *)aDeviceToken
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *tokenStr = [aDeviceToken description];
  NSString *pushToken = [[tokenStr
                            stringByReplacingOccurrencesOfString:@"<" withString:@""] 
                           stringByReplacingOccurrencesOfString:@">" withString:@""] ;
  [userDefaults setValue:pushToken forKey:@"DeviceToken"];
  [userDefaults synchronize];
}

#pragma  mark 从NSUserDefaults中获取deviceToken
+ (NSString *)getDeviceTokenFromNSUserDefaults
{
  NSString *deviceToken = nil;
  deviceToken = (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"];
  return deviceToken;
}
@end
