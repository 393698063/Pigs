//
//  CHCAliPayUtil.m
//  FoodYou
//
//  Created by Lemon-HEcom on 15/11/19.
//  Copyright © 2015年 AZLP. All rights reserved.
//

#import "CHCAliPayUtil.h"
#import "AppDef.h"
#import <UIKit/UIKit.h>
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HCLog.h"

static NSString *const HC_AliPay_RSA_Private = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOI8Kiu3OMlBEOpYl/OMludVNFFOdAVDJyDgeMhLzOLbpSGKZvQCLWYwGphXMGGCJn5OMPTcvQzxElRSu7DuVhFU7y7/XdOYu5JIHRgim4TjPhOtOgJPnVGdehIslNNqUECNl2WwfEn0kr3HsFhxAXNvxWJ7tK+WXJg0r71zh39rAgMBAAECgYEAxBFcgvKR9mm7nT4Wwu7PQcHoS6bwijb+zFF+nCiFcv7lCEKIo2TXr7507h5yQa+oaMKfTzeXaIXtWsMxA1Arqcx60AK3nolFM3T5Z9kuL9NlVTFoJm/i56bifd1EGNFi4tXbGt1HZhrY002oz+N/hINCZ/vTnSfmw5ppDFKlbjECQQD1CpHAf0Kh+W12UTG2beFRlCkYNRBqXuXstf3AFKiHxnF2FOmW6CFEpgjQIZJzlT8VXuUEB3Tqi+EbrAAOIY7HAkEA7FpJOXZhlIeVPxCvbpysfsFcMkBgp8Aj1m+810tg+UGFfrKlPWs34mauGtk8AU0x5dAdghTDoQ+8tVkzusG2PQJAFRla4XNTvnSmqzhkimu9qfOS8kWnazFOpOoqtj5RIJfCr0MvtdG5A5s0SQ+K967TJrjsCUPHGmb+9A4EVzMmgwJBAKb/fDGPxY7O5dMzlOEQ7oh5Uw1mk2SzzB6dwM5WQmSbuRk2XK6y7T+Y0XfC+jTpOFJq5A6fYUKR/gIczwIsEPkCQHIGXalET/s+Q9StecN1YlWla4asLaW9tA/yn1ty3PWyW5MrSiRKtRkw9uSvJ8LYDyQj8Y0OEu3+V2QkCK5D4/M=";

@implementation CHCAliPayUtil

+ (void)pay:(CHCAliPayVO *)product
       desc:(CHCAliDescVO *)aDescVO
 completion:(void (^)(BOOL isCallBack, NSString *desc, NSDictionary *resultDic))completion
{
  /*
   *商户的唯一的parnter和seller。
   *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
   */
  
  /*============================================================================*/
  /*=======================需要填写商户app申请的===================================*/
  /*============================================================================*/
  NSString *partner = HC_AliPay_PartnerID;
  NSString *seller = HC_AliPay_SellerID;
  NSString *privateKey = HC_AliPay_RSA_Private;
  //@"MIICXQIBAAKBgQDiPCortzjJQRDqWJfzjJbnVTRRTnQFQycg4HjIS8zi26Uhimb0Ai1mMBqYVzBhgiZ+TjD03L0M8RJUUruw7lYRVO8u/13TmLuSSB0YIpuE4z4TrToCT51RnXoSLJTTalBAjZdlsHxJ9JK9x7BYcQFzb8Vie7SvllyYNK+9c4d/awIDAQABAoGBAMQRXILykfZpu50+FsLuz0HB6Eum8Io2/sxRfpwohXL+5QhCiKNk16++dO4eckGvqGjCn083l2iF7VrDMQNQK6nMetACt56JRTN0+WfZLi/TZVUxaCZv4uem4n3dRBjRYuLV2xrdR2Ya2NNNqM/jf4SDQmf7050n5sOaaQxSpW4xAkEA9QqRwH9CofltdlExtm3hUZQpGDUQal7l7LX9wBSoh8ZxdhTplughRKYI0CGSc5U/FV7lBAd06ovhG6wADiGOxwJBAOxaSTl2YZSHlT8Qr26crH7BXDJAYKfAI9ZvvNdLYPlBhX6ypT1rN+JmrhrZPAFNMeXQHYIUw6EPvLVZM7rBtj0CQBUZWuFzU750pqs4ZIprvanzkvJFp2sxTqTqKrY+USCXwq9DL7XRuQObNEkPiveu0ya47AlDxxpm/vQOBFczJoMCQQCm/3wxj8WOzuXTM5ThEO6IeVMNZpNks8wencDOVkJkm7kZNlyusu0/mNF3wvo06ThSauQOn2FCkf4CHM8CLBD5AkByBl2pRE/7PkPUrXnDdWJVpWuGrC2lvbQP8p9bctz1sluTK0okSrUZMPbkryfC2A8kI/GNDhLt/ldkJAiuQ+Pz";
  /*============================================================================*/
  /*============================================================================*/
  /*============================================================================*/
  
  //partner和seller获取失败,提示
  if ([partner length] == 0 ||
      [seller length] == 0 ||
      [privateKey length] == 0)
  {
    if (completion)
    {
      completion(NO, @"无法支付，请联系管理员", nil);
    }
  }
  else
  {
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = product.iOrderId; //订单ID（由商家自行制定）
    order.productName = product.iSubject; //商品标题
    order.productDescription = product.iBody; //商品描述
    order.amount = product.iPrice;//[NSString stringWithFormat:@"%.2f",product.iPrice]; //商品价格
    order.notifyURL =  aDescVO.iNotifyUrl; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.showUrl = @"m.alipay.com";
    
    if ( ![[self class] isStringEmptyOrNil:aDescVO.iItBPay] )
    {
      order.itBPay = aDescVO.iItBPay;
    }
    else
    {
      order.itBPay = @"30m";
    }
    
    if ( ![[self class] isStringEmptyOrNil:aDescVO.iOutContextJson] )
    {
      order.extraParams = @{@"out_context":aDescVO.iOutContextJson};
    }
    else
    {
      order.extraParams = nil;
    }
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    HCLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil)
    {
      
      orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                     orderSpec, signedString, @"RSA"];
      
      //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
      NSString *appScheme = HC_AliPay_Schemes;
      
      [[AlipaySDK defaultService] payOrder:orderString
                                fromScheme:appScheme
                                  callback:
       ^(NSDictionary *resultDic)
       {
         HCLog(@"reslut = %@",resultDic);
         if (completion)
         {
           completion(YES, nil, resultDic);
         }
       }];
      
    }
  }
}

+ (BOOL)isStringEmptyOrNil:(NSString *)aString
{
  BOOL rtnValue = NO;
  if ( !aString
    || [aString isEqualToString:@""] )
  {
    rtnValue = YES;
  }
  return rtnValue;
}
@end

@implementation CHCAliPayVO
@synthesize iBody;
@synthesize iOrderId;
@synthesize iPrice;
@synthesize iSubject;

@end

@implementation CHCAliDescVO
@synthesize iItBPay;
@synthesize iNotifyUrl;
@synthesize iOutContextJson;
@end