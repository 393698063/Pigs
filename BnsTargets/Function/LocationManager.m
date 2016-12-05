//
//  LocationManager.m
//  Pigs
//
//  Created by HEcom on 16/4/15.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "LocationManager.h"
#import "HCLog.h"
@interface LocationManager ()<AMapLocationManagerDelegate>
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

static NSString * const HCPG_LocationDic = @"locationDic";
@implementation LocationManager
DEFINE_SINGLETON_FOR_CLASS(LocationManager)

//- (instancetype)init
//{
//  if (self = [super init]) {
//    
//  }
//  return self;
//}
#pragma mark - Action Handle

- (void)configLocationManager
{
  
  self.locationManager = [[AMapLocationManager alloc] init];
  
  [self.locationManager setDelegate:self];
  
  [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
  
  [self.locationManager setPausesLocationUpdatesAutomatically:NO];
  
//  [self.locationManager setAllowsBackgroundLocationUpdates:YES];
  
  [self.locationManager setLocationTimeout:6];
  
  [self.locationManager setReGeocodeTimeout:3];
}

- (void)cleanUpAction
{
  [self.locationManager stopUpdatingLocation];
  
  [self.locationManager setDelegate:nil];
  
}
/*
 *返回地理反编码
 */
- (void)gecodeLocationCompeletionBlock:(AMapLocatingCompletionBlock)completion;
{
  [self.locationManager requestLocationWithReGeocode:YES completionBlock:^
   (CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
  {
    if (completion) {
      completion(location, regeocode, error);
    }
    if (error)
    {
      HCLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
      
      if (error.code == AMapLocationErrorLocateFailed)
      {
        return;
      }
    }
    if (location)
    {
      self.iLatitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
      self.iLongitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
      if (regeocode)
      {
        self.iProvice = regeocode.province?:@"";
        if (regeocode.city) {
          NSString * city = regeocode.city;
          self.iCity = city;
          self.iCounty= regeocode.district?:@"";
          self.iTownship = regeocode.township?:@"";
        }
        else
        {
          self.iCity = regeocode.district;

          self.iCounty = regeocode.township;
          self.iTownship = @"";
        }
        NSMutableDictionary * locationDic = [self.voDictionary mutableCopy];
        [locationDic removeObjectForKey:@"completion"];
        [locationDic removeObjectForKey:@"locationManager"];
        [[NSUserDefaults standardUserDefaults] setObject:locationDic forKey:HCPG_LocationDic];
        [[NSUserDefaults standardUserDefaults] synchronize];
      }
      
    }
  }];
}
/*
 *直接返回经纬度
 */
- (void)loacationCompeletionBlock:(AMapLocatingCompletionBlock)completion;
{
  [self.locationManager requestLocationWithReGeocode:NO completionBlock:completion];
}
- (instancetype)init
{
  if (self = [super init]) {
    [self configLocationManager];
    NSDictionary * locationDic = [[NSUserDefaults standardUserDefaults] objectForKey:HCPG_LocationDic];
    if (locationDic) {
      [self putValueFromDic:locationDic];
    }
  }
  return self;
}
@end
