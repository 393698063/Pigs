//
//  CHCHttpDef.h
//  NewHopeForAgency
//
//  Created by HEcom-PC on 15/7/14.
//  Copyright (c) 2015年 Hecom. All rights reserved.
//

#ifndef NewHopeForAgency_CHCHttpDef_h
#define NewHopeForAgency_CHCHttpDef_h

#define HC_UrlConnection_Info_Key @"HC_UrlConnection_Info_Key"

#define HC_UrlConnection_ProtocolType_Key @"HC_UrlConnection_ProtocolType_Key"
#define HC_UrlConnection_URL_Key @"HC_UrlConnection_URL_Key"
#define HC_UrlConnection_Port_Key @"HC_UrlConnection_Port_Key"

#define HC_UrlConnection_FileUrl_Prefix_Key @"HC_UrlConnection_FileUrl_Prefix_Key"

#define HC_UrlConnection_FileProtocolType_Key @"HC_UrlConnection_FileProtocolType_Key"
#define HC_UrlConnection_FileURL_Key @"HC_UrlConnection_FileURL_Key"
#define HC_UrlConnection_FilePort_Key @"HC_UrlConnection_FilePort_Key"

#define HC_UrlConnection_Service_Key @"HC_UrlConnection_Service_Key"

#define HC_UrlConnection_Cookie_Key @"HC_Cookie_Key"

static NSString *const HC_HTTPERROR_NilJsonOrObj_domain = @"error:20101";
static NSInteger const HC_HTTPERROR_NilJsonOrObj_code = 20101;

static NSInteger const HC_HTTPERROR_FlagNilOrEmptyError_code = 20102;
static NSInteger const HC_HTTPERROR_NilData_code = 20103;

static NSString *const HC_HTTPERROR_FlagNilOrEmptyError_userinfo = @"ReturnFlag";

static NSInteger const HC_HTTPERROR_NetworkError_flag = -20101;

typedef void(^THC_HTTP_CompletionBlock_Succeed)(NSDictionary *aDataDic, NSString *flag, NSString *desc);
typedef void(^THC_HTTP_CompletionBlock_Fail)(NSError *error);

static NSString *const HC_HTTP_ReturnKey_flag = @"result";
static NSString *const HC_HTTP_ReturnKey_desc = @"desc";

static NSString *const HC_LocalizedstringTable_FWHTTP = @"Framework_HTTPHandler";
#endif
