//
//  CHCPGWebViewController.h
//  Pigs
//
//  Created by HEcom on 16/5/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

static NSString * const URL_INFORMATION_WEB = @"/jsp/comment.jsp";
static NSString * const URL_QUESTIONDETAIL_WEB = @"/jsp/questionDetail.jsp";

typedef NS_ENUM(NSInteger, EHCWebType)
{
  EHCWebInfomation = 1,//资讯
  EHCWebCirculate = 2,//轮播图
  EHCWebCoutPig = 3,//数猪上边的广告条
  EHCWebExpert = 4,//专家病症
  EHCWebDiscover = 5,//发现
  EHCWebExpertDetail = 6,//专家病症详情
  EHCWebAnswerDetail = 7//专家问答详情
};

static NSString *const HCPG_InfoStatisticTable = @"HCPG_InfoStatistics";//资讯统计表

@interface CHCPGWebViewController : CHCBaseViewController
/**
 *  初始化web
 *
 *  @param urlStr       web的url
 *  @param imageUrlStr  分享时的图片
 *  @param title        web标题
 *  @param infomationId web的咨询的id
 *  @param webType      web的类型
 *
 *  @return web
 */
- (instancetype)initWithUrlStr:(NSString *)urlStr
                      imageUrlStr:(NSString *)imageUrlStr
                      titleStr:(NSString *)title
                  infomationId:(NSNumber *)infomationId
                       webType:(EHCWebType)webType;
+ (NSString *)createWebBaseUrl;
@end

@class CHCPGWebStatisticVO;
@interface CHCPGWebController : CHCBaseController
- (void)saveInfoStatisticWithStatisticVo:(CHCPGWebStatisticVO *)statisticVo;

@end

@interface CHCPGWebStatisticVO : CHCBaseVO
@property (nonatomic, strong) NSNumber * informationId;
@property (nonatomic, strong) NSNumber * enter;
@property (nonatomic, strong) NSNumber * wxFriend;
@property (nonatomic, strong) NSNumber * wxFriendCircle;
@property (nonatomic, strong) NSNumber * dingding;
@property (nonatomic, strong) NSNumber * statisticstype;
@property (nonatomic, strong) NSNumber * uid;
@end
