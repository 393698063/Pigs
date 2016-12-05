//
//  BnsLoginDef.h
//  Pigs
//
//  Created by HEcom on 16/4/13.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#import "AppDef.h"
#ifndef BnsLoginDef_h
#define BnsLoginDef_h

#define HCPG_LoginString @"BnsLoginString"
#define HCPGSuperPhone @"20160705432"
#define MAIN_Screen [[UIScreen mainScreen]bounds].size
#define NavigaHeight   64
#define TabbarHeight   49
static NSString *const HCPG_loginGetCode = @"/login/getIdentifyingCode.do";//获取验证码接口
static NSString *const HCPG_LoginVerifyCode = @"/login/validateIdentifyingCode.do";//验证验证码
static NSString *const HCPG_LoginLogin = @"/login/login.do";//登录

static NSString *const HCPG_LoginRegist = @"/login/regist.do";//注册接口
static NSString *const HCPG_LoginQueryTables = @"/download/queryTables.do";//获取用户信息

#endif /* BnsLoginDef_h */
