//
//  AppDef.h
//  NewHopeForAgency
//
//  Created by HEcom-PC on 15/7/14.
//  Copyright (c) 2015年 Hecom. All rights reserved.
//

#import "CHCBaseAppDef.h"

#define HC_UrlConnection_ProtocolType @"http://"
#define HC_UrlConnection_URL @"mobile.nhecom.cn"  //@"192.168.0.26:8080"//@"192.168.37.82" //  @"mobile.nhecom.cn"
#define HC_UrlConnection_Port @"80" //@"7681" //@"38080" //    @"80"//@"8089"// @"18031" // @"8033" //
#define HC_UrlConnection_Service @"/mobile-1.0-SNAPSHOT"//
#define HC_UrlConnection_UploadService @"/statServer-1.0"//上传服务

#define HC_UrlConnection_FileProtocolType @"http://"
#define HC_UrlConnection_FileURL @"mobile.nhecom.cn"  //@"218.240.51.115" // @"101.200.72.78" //  @"foodtime.hecom.cn" // @"10.0.9.232" // @"10.0.1.26" // @"220.181.105.91" //
#define HC_UrlConnection_FilePort  @"80" //@"7681" //@"7188" //  @"80" // @"18031" // @"8033" //
#define HC_UrlConnection_FileProject @"zhufuda"
#define HC_UrlConnection_ImageFile @"/image"


static NSString *const BnsTargetApp = @"BnsTargetApp";
#define HC_PackageName @"IFoodU"
//FoodYou  表示iOS99（AppStore更新地址）com.newhope.izhailp.FoodYou
//IFoodU，表示iOS299（企业发布地址）com.newhopeliuhe.IFoodU

//友盟统计渠道ID
static NSString *const HCPG_APPStoreChanle = @"App Store";
static NSString *const HCPG_OtherChanle = @"OhterChanleId";

//http://218.240.51.115:48080
//#define HC_UrlConnection_URL @"10.0.0.3"//@"218.240.51.115"//@"10.0.9.232";//@"10.0.1.26";@"220.181.105.91";//
//#define HC_UrlConnection_Port @"8080"//@"8089"//@"18031";@"8033";//


#define HC_NHFA_DataBaseBD_FileName @"database"

//app名称
#define HC_App_Name NSLocalizedStringFromTable(@"AppName", @"app", nil)

#define HC_AliPay_PartnerID @"2088121048985424"
#define HC_AliPay_SellerID @"az_hr@newhope.cn"
#define HC_AliPay_Schemes @"FoodYou"
//该define同LoginViewController中define的HC_VCAction_NHFALoginVC_FirstVCWhenOpen
//表示开启app的时候打开HC_VCAction_NHFALoginVC_FirstVCWhenOpen动作对应的界面。
////该动作实际上是BnsVCManager专门为开启app的时候定制的。
//#define HC_VCActionKey_NHFA_FirstVC @"HC_VCAction_NHFALoginVC_FirstVCWhenOpen"
//
////客户管理首页vcaction
//#define HC_VCActionKey_NHFA_CustomOrg @"HC_VCActionKey_WorkFirst_CustomOrg"
////账单管理首页vcaction
//#define HC_VCActionKey_NHFA_BillOrg @"HC_VCActionKey_WorkFirst_BillOrg"

/*
 qq
 APP ID1105286424
 APP KEYu2H2fW1sSANApDr1
 
 weixin
 AppID：wxcb18a37d7ac8cf33
 AppSecret：de5e103c79ad89f3b103efdd85d00f6a
 
 gaode
 734590ba8fa29deef97c700c0cd7b7f5
 */
static NSString *const HC_PG_Login_login = @"HC_PG_Login_login";
static NSString *const HC_PG_Login_logout = @"HC_PG_Login_logout";
