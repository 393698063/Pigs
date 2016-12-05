/*!
 @header CHCCommonInfoVO 通用信息vo
 @abstract 类似于登陆后获取的一些常驻内存的上下文信息 单例
 @author Created by sunset
 @version Copyright (c) 2012 __CHC__. All rights reserved.1.00 12-5-15 Creation
 */
#import <Foundation/Foundation.h>
#import "CHCBaseVO.h"
/*!
 @class
 @abstract 登陆后获取的一些常驻内存的上下文信息 单例
 */
static NSString *const HC_CommonInfo_UserData = @"HC_CommonInfo_UserData";
@interface CHCCommonInfoVO : CHCBaseVO
{
  
}
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *bisName;
@property (nonatomic, copy) NSString *bisPhone;
@property (nonatomic, strong) NSNumber * canRecommend;
@property (nonatomic, strong) NSNumber * certified;
@property (nonatomic, copy) NSString * certify;
@property (nonatomic, copy) NSString * certifyLink;
@property (nonatomic, strong) NSNumber * certifyType;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * commentStatus;
@property (nonatomic, copy) NSString * commentStatusDate ;
@property (nonatomic, copy) NSString * county;
@property (nonatomic, copy) NSString * createBy;
@property (nonatomic, strong) NSNumber * createDate;
@property (nonatomic, strong) NSNumber * dataSource;
@property (nonatomic, copy) NSString * deviceId;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * farmerMobile;
@property (nonatomic, copy) NSString * farmerName;
@property (nonatomic, strong) NSNumber * fdcertified;
@property (nonatomic, copy) NSString * gesturePwd;
@property (nonatomic, copy) NSString * headLink;
@property (nonatomic, strong) NSNumber * iHCid ;
@property (nonatomic, strong) NSNumber * isFarmer;
@property (nonatomic, strong) NSNumber * isVerified ;
@property (nonatomic, strong) NSNumber * latitude ;
@property (nonatomic, strong) NSNumber * longitude ;
@property (nonatomic, copy) NSString * mobile ;
@property (nonatomic, copy) NSString * modifyBy;
@property (nonatomic, strong) NSNumber * modifyDate ;
@property (nonatomic, copy) NSString * name ;
@property (nonatomic, copy) NSString * nickName ;
@property (nonatomic, strong) NSNumber * nowVersion ;
@property (nonatomic, strong) NSNumber * obtainGiftMoneyStatus;
@property (nonatomic, copy) NSString * password ;
@property (nonatomic, copy) NSString * province ;
@property (nonatomic, strong) NSNumber * sex ;
@property (nonatomic, strong) NSNumber * status ;
@property (nonatomic, copy) NSString * telArea ;
@property (nonatomic, copy) NSString * telExt;
@property (nonatomic, copy) NSString * telPhone ;
@property (nonatomic, copy) NSString * township;
@property (nonatomic, strong) NSNumber * userStatus;
@property (nonatomic, copy) NSString * zipCode;
@property (nonatomic, strong) NSNumber * experience;
@property (nonatomic, strong) NSNumber * gold;
@property (nonatomic, strong) NSNumber * level;
@property (nonatomic, copy) NSString * lottery_address;
@property (nonatomic, copy) NSString * lottery_times;
@property (nonatomic, strong) NSNumber * money;
@property (nonatomic, strong) NSNumber * skill;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isSync;
#pragma mark 获取单例
/*!
 @method
 @abstract 单例实例获取
 @discussion
 @result CHCCommonInfoVO
 */
+(CHCCommonInfoVO *)sharedManager;

/*!
 @method
 @abstract 查询是否登录
 @discussion
 @result
 */
+ (BOOL)isLogin;
+ (void)login;
+ (void)logout;
+ (void)sync;
+ (BOOL)isSync;
@end
