//
//  AppDelegate.h
//  Pigs
//
//  Created by HEcom on 16/4/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseAppDelegate.h"
#import "CHCPGUserDataSycnViewController.h"
#import "CHCPGCommonDataSyncViewController.h"

@class CHCReachability;
@interface AppDelegate : CHCBaseAppDelegate
@property (nonatomic, strong) CHCPGUserDataSycnViewController * iUserDataSyncController;
@property (nonatomic, strong) CHCPGCommonDataSyncViewController * iCommonDataSyncController;
@property (nonatomic) CHCReachability *hostReachability;
- (void)putLoginInfo:(NSDictionary *)aDataDic;
- (void)clearLoginInfo;
@end

/*
 *数据同步的三个过程
 *1 在app启动的时候同步地区，标签等公共数据
 *2 在登录，注册后同步金币规则，金币纪录的数据,再发登录成功的通知
 *3 在登录注册成功后同步日记等纪录
 *4 不能使用同一个userDataSyncViewController实例是因为数据库不是同一个
 */

