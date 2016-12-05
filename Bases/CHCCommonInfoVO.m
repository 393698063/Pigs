/*!
 @header HCCommonInfoVO
 @abstract 类似于登陆后获取的一些常驻内存的上下文信息 单例
 @author Created by sunset 
 @version Copyright (c) 2012 __wa__. All rights reserved.1.00 12-5-15 Creation 
 */

#import "CHCCommonInfoVO.h"

@interface CHCCommonInfoVO()
//@property (assign,nonatomic) NSInteger iAccountType;
@end

@implementation CHCCommonInfoVO
static NSString *HC_HTTP_COMVO_GRPID = @"groupid";
static NSString *HC_HTTP_COMVO_USRID = @"usrid";
    //单例实例
static CHCCommonInfoVO *sharedInstance = nil;

//@synthesize iHCid;
//@synthesize farm_county;
//@synthesize is_owner;
//@synthesize mailing_detail;
//@synthesize phone;
//@synthesize mailing_address;
//@synthesize coins;
//@synthesize identification;
//@synthesize farm_poultry_type;
//@synthesize farm_house_num;
//@synthesize head_picture;
//@synthesize must_fill_farm;
//@synthesize farm_id;
//@synthesize farm_province;
//@synthesize farm_address;
//@synthesize farm_city;
//@synthesize pwd;
//@synthesize name;
@synthesize isLogin;

/*!
 @method
 @abstract 单例实例获取
 @discussion
 @result CHCCommonInfoVO
 */
+(id)sharedManager
{
  @synchronized(self) 
  {
    if(sharedInstance == nil)
    {
      sharedInstance = [[self alloc] init];
    }
  }
  return sharedInstance;
}

+ (BOOL)isLogin
{
  BOOL islogin = NO;
  if ([CHCCommonInfoVO sharedManager].isLogin)
  {
    islogin = YES;
  }
  return islogin;
}

+ (void)login
{
  [CHCCommonInfoVO sharedManager].isLogin = YES;
}

+ (void)logout
{
  [CHCCommonInfoVO sharedManager].isLogin = NO;
  [CHCCommonInfoVO sharedManager].iHCid = @(0);
}
+ (void)sync
{
  [CHCCommonInfoVO sharedManager].isSync = YES;
}
+ (BOOL)isSync
{
  BOOL rtn = NO;
  if ([CHCCommonInfoVO sharedManager].isSync) {
    rtn = YES;
  }
  return rtn;
}
/*!
 @method
 @abstract 根据servicecode查询 获取groupid和userid
 @discussion 
 @result NSDictionary
 */
//-(NSDictionary *)getGroupIDAndUserIDByServiceCode:(NSString *)aServiceCode
//{
//  NSDictionary *comminfoDict = [sharedInstance.iSCWithInfoDictionary valueForKey:aServiceCode];
//  NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
//  [tempDict setValue:[comminfoDict valueForKey:@"groupID"] forKey:@"groupID"];
//  [tempDict setValue:[comminfoDict valueForKey:@"userID"] forKey:@"userID"];
//  NSDictionary *rtnDict = [NSDictionary dictionaryWithDictionary:tempDict];
//  return rtnDict;
//}
//
//+(NSDictionary *)getDefaultEmptyGroupIDAndUserID
//{
//  NSDictionary *rtnDict = [NSDictionary dictionaryWithObjectsAndKeys:@"",HC_HTTP_COMVO_GRPID,@"",HC_HTTP_COMVO_USRID,nil];
//  return rtnDict;
//}
//
//+(void)setAccountType:(NSInteger)anAccountType
//{
//  sharedInstance.iAccountType=anAccountType;
//}
//
//
//-(NSString *)getAttSizeWithServiceCode:(NSString *)aServiceCode
//{
//    return [iAttSizeDic valueForKey:aServiceCode];
//}
@end
