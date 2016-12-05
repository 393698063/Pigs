//
//  CHCPGWebViewController.m
//  Pigs
//
//  Created by HEcom on 16/5/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define kScreenSize [UIScreen mainScreen].bounds.size
#import "CHCPGWebViewController.h"
#import "CHCStringUtil.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIImageView+WebCache.h"
#import "CHCSharedManager.h"
#import "CHCSqliteManager.h"
#import "CHCPGCommonDataSyncViewController.h"
#import "CHCPGLoginViewController.h"
#import "CHCReachability.h"
#import "AppDelegate.h"

@interface CHCPGWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *iShareAction;
@property (nonatomic, strong) UIWebView * iWebView;
@property (nonatomic, copy) NSString * iWebUrlStr;
@property (nonatomic, copy) NSString * iTitle;
@property (nonatomic, strong) NSNumber * iInfomationId;
@property (nonatomic, strong) NSString * imageUrlStr;
@property (nonatomic, assign) EHCWebType  iWebType;
@property (nonatomic, strong) CHCPGWebController * iController;
@property (nonatomic, strong) CHCPGCommonDataSyncViewController * iCommonDataSyncController;
@property (nonatomic, strong) JSContext * iContext;
@end

@implementation CHCPGWebViewController
@dynamic iController;
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = @"详情";
}
- (BOOL)isNeedNoNetworkView
{
  return YES;
}

- (instancetype)initWithUrlStr:(NSString *)urlStr
                   imageUrlStr:(NSString *)imageUrlStr
                      titleStr:(NSString *)title
                  infomationId:(NSNumber *)infomationId
                       webType:(EHCWebType)webType;
{
  if (self = [super init])
  {
    self.iWebUrlStr = urlStr;
    self.iTitle = title;
    self.iInfomationId = infomationId;
    self.iWebType = webType;
    self.imageUrlStr = imageUrlStr;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccees:) name:HC_PG_Login_login object:nil];
  [self loadWebView];
  [self loadRequest];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    CHCPGWebStatisticVO * statisticVo = [[CHCPGWebStatisticVO alloc] init];
    statisticVo.informationId = self.iInfomationId;
    statisticVo.enter = @(1);
    statisticVo.wxFriend = @(0);
    statisticVo.wxFriendCircle = @(0);
    statisticVo.dingding = @(0);
    statisticVo.statisticstype = @(self.iWebType);
    statisticVo.uid = [CHCCommonInfoVO sharedManager].iHCid?:@(0);
    [self.iController saveInfoStatisticWithStatisticVo:statisticVo];
    self.iCommonDataSyncController = [[CHCPGCommonDataSyncViewController alloc] init];
    [self.iCommonDataSyncController upLoadInformationStatisticCompletion:^(BOOL isSucceed, NSString *aDes) {
      
    }];
  });
  
  if ( self.iWebType == EHCWebExpert
      || self.iWebType == EHCWebExpertDetail
      || self.iWebType == EHCWebAnswerDetail )
  {
    [self.iShareAction setHidden:YES];
    self.iTitleStr = self.iTitle;
    self.iNavBar.topItem.title = self.iTitleStr;
  }
  //  UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
  //  button.frame = CGRectMake(10, 100, 100, 100);
  //  button.backgroundColor = [UIColor redColor];
  //  [button addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchUpInside];
  //  [self.view addSubview:button];
  //  [self.view bringSubviewToFront:button];
}
- (void)loadRequest
{
  NSURLRequest * request = nil;
  if ( self.iWebType == EHCWebCirculate
      || self.iWebType == EHCWebDiscover
      || self.iWebType == EHCWebExpertDetail )
  {
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.iWebUrlStr]];
  }
  else if ( self.iWebType == EHCWebExpert )
  {
    request = [self createNormalRequestWithUrl:self.iWebUrlStr];
  }
  else if ( self.iWebType == EHCWebAnswerDetail )
  {
    request = [self createRequestWithUrl:self.iWebUrlStr
                              questionId:self.iInfomationId
                                 webType:self.iWebType];
  }
  else
  {
    request = [self createRequestWithUrl:self.iWebUrlStr
                                   title:self.iTitle
                            infomationId:self.iInfomationId
                                 webType:self.iWebType];
  }
  [self.iWebView loadRequest:request];
}
- (void)reachabilityChanged:(NSNotification *)notification
{
  self.iContext = [self.iWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
  CHCReachability *curReachability = [notification object];
  NSParameterAssert([curReachability isKindOfClass:[CHCReachability class]]);
  NetworkStatus curStatus = [curReachability currentReachabilityStatus];
  if (self.iContext)
  {
    if(curStatus == NotReachable)
    {
      NSString * jsStr = @"onNetworkChanged('NO')";
      [self.iContext evaluateScript:jsStr];
    }
    else
    {
      NSString * jsStr = @"onNetworkChanged('YES')";
      [self.iContext evaluateScript:jsStr];
    }
  }
}

- (NSURLRequest *)createNormalRequestWithUrl:(NSString *)urlStr
{
  NSURLRequest * request = nil;
  NSString * webStr = [NSString stringWithFormat:@"%@%@:%@/%@/%@",
                       HC_UrlConnection_FileProtocolType,
                       HC_UrlConnection_FileURL,
                       HC_UrlConnection_FilePort,
                       @"mobile-1.0-SNAPSHOT",
                       urlStr];
  
  request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:webStr]];
  return request;
}

- (NSURLRequest *)createRequestWithUrl:(NSString *)urlStr
                            questionId:(NSNumber *)aQuestionId
                               webType:(EHCWebType)webType
{
  NSURLRequest * request = nil;
  CHCCommonInfoVO * userInfo = [CHCCommonInfoVO sharedManager];
  NSMutableString * webStr = [NSMutableString stringWithString:[[self class] createWebBaseUrl]];
  [webStr appendString:URL_QUESTIONDETAIL_WEB];
  [webStr appendString:@"?questionId="];
  [webStr appendString:[aQuestionId description]];
  [webStr appendString:@"&uid="];
  [webStr appendFormat:@"%@",userInfo.iHCid?:@(0)];
  [webStr appendString:@"&channelSource=3"];
  [webStr appendString:@"&nickName="];
  [webStr appendString:[CHCStringUtil urlEncodedString:[self getNickName]]];
  [webStr appendString:@"&headLink="];
  [webStr appendString:[self getHeadLink]];
  
  HCLog(@"%@",webStr);
  
  request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:webStr]];
  return request;
}

- (NSURLRequest *)createRequestWithUrl:(NSString *)urlStr
                                 title:(NSString *)title
                          infomationId:(NSNumber *)infomationId
                               webType:(EHCWebType)webType
{
  NSURLRequest * request = nil;
  CHCCommonInfoVO * userInfo = [CHCCommonInfoVO sharedManager];
  NSMutableString * webStr = [NSMutableString stringWithString:[[self class] createWebBaseUrl]];
  [webStr appendString:URL_INFORMATION_WEB];
  [webStr appendString:@"?href="];
  [webStr appendString:urlStr];
  [webStr appendString:@"&title="];
  [webStr appendString:[CHCStringUtil urlEncodedString:title]];
  [webStr appendString:@"&informationId="];
  [webStr appendFormat:@"%@",infomationId];
  [webStr appendString:@"&uid="];
  [webStr appendFormat:@"%@",userInfo.iHCid?:@(0)];
  [webStr appendString:@"&channelSource=1"];
  [webStr appendString:@"&nickName="];
  [webStr appendString:[CHCStringUtil urlEncodedString:[self getNickName]]];
  [webStr appendString:@"&headLink="];
  [webStr appendString:[self getHeadLink]];
  
  HCLog(@"%@",webStr);
  
  request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:webStr]];
  return request;
}
- (NSString *)getHeadLink
{
  NSString * headLink = @"";
  CHCCommonInfoVO * userInfo = [CHCCommonInfoVO sharedManager];
  if (![userInfo.headLink isEqualToString:@""]) {
    headLink = [NSString stringWithFormat:@"%@%@:%@/%@/%@",HC_UrlConnection_FileProtocolType,
                HC_UrlConnection_FileURL,
                HC_UrlConnection_FilePort,
                @"image",
                userInfo.headLink];
  }
  return headLink;
}
- (NSString *)getNickName
{
  NSString * nickName = @"匿名网友";
  CHCCommonInfoVO * userInfo = [CHCCommonInfoVO sharedManager];
  if(![userInfo.nickName isEqualToString:@""])
  {
    nickName = userInfo.nickName;
  }
  else if (![userInfo.province isEqualToString:@""])
  {
    nickName = [NSString stringWithFormat:@"%@%@%@",userInfo.province,userInfo.city,@"网友"];
  }
  return nickName;
}
- (void)loadWebView
{
  UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64)];
  [self.view addSubview:webView];
  webView.delegate = self;
  self.iWebView = webView;
}
- (void)noNetWorkButtonAction
{
  [self hideNoNetWorkView];
  [self loadRequest];
}
#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  HCLog(@"%@",[error domain]);
  [self showNoNetWorkView];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
  return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
  HCLog(@"stat:%@",webView.request.URL);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  [self hideNoNetWorkView];
  HCLog(@"finish:%@",webView.request.URL);
  self.iContext = [self.iWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
  
  __weak typeof(self)wSelf = self;
  self.iContext[@"funcs"] = ^()
  {
    CHCPGLoginViewController * loginVc = [[CHCPGLoginViewController alloc] init];
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:loginVc];
    loginVc.navigationController.navigationBarHidden = YES;
    [wSelf.navigationController presentViewController:nvc animated:YES completion:nil];
  };
  NSObject *a = [[NSObject alloc]init];
  self.iContext[@"android"] = a;
  [self.iContext evaluateScript:@"android.login=funcs;"];
  
  if (self.iWebType == EHCWebExpert)
  {
    self.iContext[@"funcs"] = ^(NSString *aJson)
    {
      NSData * data = [aJson dataUsingEncoding:NSUTF8StringEncoding];
      NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
      
      NSString *url = [dict objectForKey:@"url"];
      NSString *title = [dict objectForKey:@"title"];
      CHCPGWebViewController *aDetailVC = [[CHCPGWebViewController alloc]initWithUrlStr:url
                                                                            imageUrlStr:nil
                                                                               titleStr:title
                                                                           infomationId:nil
                                                                                webType:EHCWebExpertDetail];
      [wSelf.navigationController pushViewController:aDetailVC animated:YES];
    };
    NSObject *a = [[NSObject alloc]init];
    self.iContext[@"android"] = a;
    [self.iContext evaluateScript:@"android.openWindow=funcs;"];
  }
}
- (void)testAction
{
  [self loginSuccees:nil];
}
- (void)loginSuccees:(NSNotification *)aNotice
{
  CHCCommonInfoVO * userInfo = [CHCCommonInfoVO sharedManager];
  NSDictionary * dict = @{@"uid":userInfo.iHCid,@"nickName":[self getNickName],@"headLink":[self getHeadLink]};
  NSString * paramStr = [self getJsonStrWithDict:dict];
  NSString *jsStr1 = [NSString stringWithFormat:@"loginSuccess(%@)",paramStr];
  HCLog(@"jsStr ------ = %@",jsStr1);
  [self.iContext evaluateScript:jsStr1];
}
+ (NSString *)createWebBaseUrl
{
  NSURL * baseUrl = [CHCHttpRequestHandler creatBaseURL];
  return [NSString stringWithFormat:@"%@%@",[baseUrl absoluteString],HC_UrlConnection_Service];
}
- (NSString *)getJsonStrWithDict:(NSDictionary *)dict
{
  NSData * data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
  NSString * jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  //  jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
  //  jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"\\\\/"];
  return jsonStr;
}
- (IBAction)iShareAction:(id)sender
{
  UIImageView * shareImageView = [[UIImageView alloc] init];
  __weak typeof(self)wSelf = self;
  NSString * imageStr = [self.imageUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  [shareImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
   {
     CHCShareVO * shareVo = [[CHCShareVO alloc] init];
     shareVo.message = wSelf.iTitle;
     shareVo.objectId = wSelf.iInfomationId;
     shareVo.category = @(wSelf.iWebType);
     shareVo.image = image;
     shareVo.url = wSelf.iWebUrlStr;
     shareVo.avc = wSelf;
     [[CHCSharedManager defaultManager] sharedWithShareVO:shareVo
                                               sharedBloc:^(EHCShareType type)
      {
        CHCPGWebStatisticVO * statisticVo = [[CHCPGWebStatisticVO alloc] init];
        statisticVo.informationId = self.iInfomationId;
        statisticVo.enter = @(0);
        statisticVo.wxFriend = @(0);
        statisticVo.wxFriendCircle = @(0);
        statisticVo.dingding = @(0);
        statisticVo.statisticstype = @(self.iWebType);
        statisticVo.uid = [CHCCommonInfoVO sharedManager].iHCid?:@(0);
        switch (type) {
          case EHCShareWX:
          {
            statisticVo.wxFriend = @(1);
            break;
          }
          case EHCShareWXCircle:
          {
            statisticVo.wxFriendCircle = @(1);
            break;
          }
          case EHCShareQQ:
          {
            
            break;
          }
          case EHCShareQZone:
          {
            break;
          }
          default:
            break;
        }
        [wSelf.iController saveInfoStatisticWithStatisticVo:statisticVo];
      }];
   }];
}

- (IBAction)iQuiteAction:(id)sender
{
  //清除cookies
  NSHTTPCookie *cookie;
  NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  for (cookie in [storage cookies])
  {
    [storage deleteCookie:cookie];
  }
  
  [[NSURLCache sharedURLCache] removeAllCachedResponses];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

@interface CHCPGWebController ()
@property (nonatomic, strong) CHCSqliteManager * iManager;
@end

@implementation CHCPGWebController

- (void)saveInfoStatisticWithStatisticVo:(CHCPGWebStatisticVO *)statisticVo;
{
  
  NSString * path = [CHCPGCommonDataSyncController creatCommonPath];
  NSString * tablePath = [NSString stringWithFormat:@"%@/%@",path,@"area.db"];
  self.iManager = [[CHCSqliteManager alloc] initWithDataBasePath:tablePath];
  NSString * sqlStr = [NSString stringWithFormat:@"select * from %@ where uid = %@ and informationId = %@",
                       HCPG_InfoStatisticTable,
                       [CHCCommonInfoVO sharedManager].iHCid?:@(0),
                       statisticVo.informationId];
  
  NSArray * ary = [self.iManager executeQueryRtnAry:sqlStr];
  [self.iManager openDB];
  [self.iManager beginTransaction];
  if (![ary count]) {
    NSMutableString * insertSql = [NSMutableString string];
    [insertSql appendFormat:@"insert into %@",HCPG_InfoStatisticTable];
    [insertSql appendFormat:@" ("];
    
    NSMutableString *keys = [NSMutableString stringWithString:@""];
    NSMutableString *values = [NSMutableString stringWithString:@""];
    NSDictionary * dict = [statisticVo fillVoDictionary];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)
     {
       [keys appendFormat:@"\"%@\" ,",key];
       [values appendFormat:@"%@ ,",obj];
     }];
    [keys deleteCharactersInRange:NSMakeRange(keys.length-1, 1)];
    [values deleteCharactersInRange:NSMakeRange(values.length-1, 1)];
    [insertSql appendString:keys];
    [insertSql appendString:@")"];
    [insertSql appendString:@"values ("];
    [insertSql appendString:values];
    [insertSql appendString:@")"];
    [self.iManager executeNotQuery:insertSql];
    
  }
  else
  {
    NSString * updateStr = [NSString stringWithFormat:@"update %@ set enter = enter + %@,wxFriend = wxFriend + %@,wxFriendCircle = wxFriendCircle + %@,dingding = dingding + %@ where informationId = %@ and uid = %@",
                            HCPG_InfoStatisticTable,
                            statisticVo.enter,
                            statisticVo.wxFriend,
                            statisticVo.wxFriendCircle,
                            statisticVo.dingding,
                            statisticVo.informationId,
                            [CHCCommonInfoVO sharedManager].iHCid?:@(0)];
    [self.iManager executeNotQuery:updateStr];
  }
  [self.iManager commitTransaction];
  [self.iManager closeDB];
}

@end

@implementation CHCPGWebStatisticVO


@end
