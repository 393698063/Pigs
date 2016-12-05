//
//  CHCFYSharedView.h
//  FoodYou
//
//  Created by HEcom on 15/11/18.
//  Copyright © 2015年 AZLP. All rights reserved.
//
/*
 分享时的几个不友好的因素
 *title属性的效果不一致
 qq空间和微信不设置标题,标题就默认显示内容了.就是说内容重复显示了2次
 微信朋友圈如果设置了标题,那么内容就不显示了
 新浪微博没这个功能
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CHCBaseViewController.h"
#import "BnsTarget_Share.h"

typedef NS_ENUM(NSInteger,EHCShareType)
{
  EHCShareWX,
  EHCShareWXCircle,
  EHCShareQQ,
  EHCShareQZone
};

@class CHCShareVO;
//@class CHCBaseModelHandler;
@interface CHCSharedManager : NSObject
+ (void)registShare;
+ (id)defaultManager;
- (void)sharedMessage:(NSString *)message
             objectId:(NSNumber *)objectId
             category:(NSNumber *)category
                image:(UIImage *)image
                  url:(NSString *)url
              loction:(NSString *)location
                  avc:(UIViewController *)avc;

- (void)sharedWithShareVO:(CHCShareVO *)aShareVO
               sharedBloc:(void(^)(EHCShareType type))iShareBlock;
@end

@interface CHCShareToUMModelHandler : CHCBaseModelHandler

@end

@interface CHCShareVO : CHCBaseVO
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic, strong) NSNumber *category;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) UIViewController *avc;
@property (nonatomic, copy) NSString * iName;
@end