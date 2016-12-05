//
//  CHCAliPayUtil.h
//  FoodYou
//
//  Created by Lemon-HEcom on 15/11/19.
//  Copyright © 2015年 AZLP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCBaseVO.h"

#pragma mark Util
@class CHCAliPayVO;
@class CHCAliDescVO;
@interface CHCAliPayUtil : NSObject

+ (void)pay:(CHCAliPayVO *)product
       desc:(CHCAliDescVO *)aDescVO
 completion:(void (^)(BOOL isCallBack, NSString *desc, NSDictionary *resultDic))completion;

@end


#pragma mark VO
@interface CHCAliPayVO : CHCBaseVO
{
  NSString *iPrice;
  NSString *iSubject;
  NSString *iBody;
  NSString *iOrderId;
}

@property (nonatomic, copy) NSString *iPrice;
@property (nonatomic, copy) NSString *iSubject;
@property (nonatomic, copy) NSString *iBody;
@property (nonatomic, copy) NSString *iOrderId;
@property (nonatomic, copy) NSString *iOutContext;

@end


@interface CHCAliDescVO : CHCBaseVO
{
  NSString *iNotifyUrl;
  NSString *iItBPay;
  NSString *iOutContextJson;
}
@property (nonatomic, strong) NSString *iNotifyUrl;
@property (nonatomic, strong) NSString *iItBPay;
@property (nonatomic, strong) NSString *iOutContextJson;
@end