//
//  CHCAdvertisingManager.m
//  Pigs
//
//  Created by HEcom on 16/4/14.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#pragma mark - 用于获取KeyChain的相关参数
#define KEYCHAIN_DEVICEID_ACCOUNT @"DeviceIdUsedInZFD"
#define APP_IDENTIFER @"GWVZTB7XL3"
#define BUNDLE_ID_INFO [[NSBundle mainBundle] bundleIdentifier]

#import "CHCAdvertisingManager.h"
#import "KeychainItemWrapper.h"
#import <AdSupport/AdSupport.h>


@implementation CHCAdvertisingManager

//DEFINE_SINGLETON_FOR_CLASS(CHCAdvertisingManager)

+ (NSString *)getDeviceId
{
  // 访问钥匙串，获取该帐号的DeviceId
  
  // 获取KeyChain
  
  NSString *accessGroup = [NSString stringWithFormat:@"%@.%@", APP_IDENTIFER, BUNDLE_ID_INFO];
  
  KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc]
                                  initWithIdentifier:KEYCHAIN_DEVICEID_ACCOUNT
                                  accessGroup:accessGroup];
  
  //从keychain里取出帐号密码
  NSString *uuidStr = [wrapper objectForKey:(__bridge id)kSecValueData];
  
  // keyChain中没有
  if (uuidStr == nil || uuidStr.length == 0) {
    
    // 钥匙串未请求到DeviceId，依据广告标识，创建DeviceId
    uuidStr = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    
    // 保存DeviceId到钥匙串
    [wrapper setObject:KEYCHAIN_DEVICEID_ACCOUNT forKey:(id)CFBridgingRelease(kSecAttrAccount)];
    [wrapper setObject:uuidStr forKey:(id)CFBridgingRelease(kSecValueData)];
    
  }
  
  return uuidStr;
}

@end
