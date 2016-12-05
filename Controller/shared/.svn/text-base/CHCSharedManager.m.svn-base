//
//  CHCFYSharedView.m
//  FoodYou
//
//  Created by HEcom on 15/11/18.
//  Copyright © 2015年 AZLP. All rights reserved.
//
#define kScreenBound [UIScreen mainScreen].bounds
#import "CHCSharedManager.h"
#import "UIColor+Hex.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
//#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"

@interface CHCSharedManager ()<UMSocialUIDelegate>
@property(nonatomic, strong) CHCShareToUMModelHandler * iModelHandler;
@property (nonatomic, strong) CHCShareVO * iShareVo;
@property (nonatomic, copy) void(^iShareBlock)(EHCShareType type);
@end

@implementation CHCSharedManager
static CHCSharedManager * shareView;
+ (void)registShare
{
  //设置友盟appkey 564af74d67e58ea4e8001155
  [UMSocialData setAppKey:HC_Share_UMAppKey];
  //设置微信AppId、appSecret，分享url
  [UMSocialWechatHandler setWXAppId:HC_Share_WeiXinAppId
                          appSecret:HC_Share_WeixinAppSecret
                                url:HC_Share_Url];
  /*
   setWXAppId:@"wx6f119587583806ca"
   appSecret:@"e301459d6edf12895dc0892ee1069d6"
   */
  
  ////打开新浪微博的SSO开关，b
  //  设置新浪微博回调地址，
  //  这里必须要和你在新浪微博后台设置的回调地址一致。
  //  若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
//  [UMSocialSinaHandler openSSOWithRedirectURL:HC_Share_CallBackUrl];
  /*
   [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
   secret:@"04b48b094faeb16683c32669824ebdad"
   RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
   */
  
  //设置分享到QQ/Qzone的应用Id，和分享url 链接
  [UMSocialQQHandler setQQWithAppId:HC_Share_QQAppId
                             appKey:HC_share_QQAppKey
                                url:HC_Share_Url];
  //设置分享toasto的展示
  [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionCenter];
}
+ (id)defaultManager
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shareView = [[CHCSharedManager alloc] init];
    shareView.iShareVo = nil;
    shareView.iModelHandler = [[CHCShareToUMModelHandler alloc] init];
  });
  return shareView;
}

- (void)sharedMessage:(NSString *)message
             objectId:(NSNumber *)objectId
             category:(NSNumber *)category
                image:(UIImage *)image
                  url:(NSString *)url
              loction:(NSString *)location
                  avc:(UIViewController *)avc
{
  CHCShareVO *aVO = [[CHCShareVO alloc]init];
  aVO.message = message;
  aVO.objectId = objectId;
  aVO.category = category;
  aVO.image = image;
  aVO.url = url;
  aVO.location = location;
  aVO.avc = avc;
  
  [self sharedWithShareVO:aVO sharedBloc:nil];
}

- (void)sharedWithShareVO:(CHCShareVO *)aShareVO
               sharedBloc:(void(^)(EHCShareType type))iShareBlock;
{
  self.iShareVo = aShareVO;
  self.iShareBlock = iShareBlock;
  UIWindow * kWindow  = [UIApplication sharedApplication].keyWindow;
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenBound.size.width,kScreenBound.size.height)];
  view.backgroundColor = [UIColor blackColor];
  view.alpha = 0.0;
  view.tag = 10000;
  UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
  [view addGestureRecognizer:tap];
  [kWindow addSubview:view];
  
  UIView * shareToView = [self prepareSharedView];
  shareToView.alpha = 0;
  [UIView animateWithDuration:0.5 animations:^{
    shareToView.alpha = 1;
    view.alpha = 0.3;
  }];
}

- (UIView *)prepareSharedView
{
  UIWindow * kWindow  = [UIApplication sharedApplication].keyWindow;
  
  UIView * sharedToView = [[UIView alloc] init];
  CGFloat viewX = 35;
  CGFloat viewW = kScreenBound.size.width - 70;
  CGFloat viewH = 206;
  CGFloat viewY = 208;
  sharedToView.frame = CGRectMake(viewX, viewY, viewW, viewH);
  sharedToView.tag = 10001;
  sharedToView.layer.cornerRadius = 3.0f;
  sharedToView.clipsToBounds = YES;
  sharedToView.backgroundColor = [UIColor whiteColor];
  
  UILabel * sharedToLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, viewW - 20, 40)];
  sharedToLabel.text = @"分享到";
  sharedToLabel.font = [UIFont systemFontOfSize:14];
  sharedToLabel.textColor = [UIColor colorWithHex:0xff333333];
  [sharedToView addSubview:sharedToLabel];
  
  CGFloat lineX = 0;
  CGFloat lineY = CGRectGetMaxY(sharedToLabel.frame);
  CGFloat lineW = kScreenBound.size.width;
  CGFloat lineH = 0.5;
  UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
  topLine.backgroundColor = [UIColor colorWithHex:0xffd7dae3];
  [sharedToView addSubview:topLine];
  
  NSArray * imageArr = @[@"fenxiang_weixin",@"fenxiang_friend",@"fenxiang_qq",@"fenxiang_qzone"];
  NSArray * disableImageArr = @[@"weixin",@"weixin_pengyouquan",@"sg_weibozhihui",@"qqkongjian"];
  NSArray * labelNameArr = @[@"微信",@"朋友圈",@"QQ",@"空间"];
  NSArray * buttonActions = @[@"shareToWeiXin",@"shareToFried",@"shareToQq",@"shareToZone"];
  CGFloat buttonW = 48;
  CGFloat buttonY = CGRectGetMaxY(topLine.frame) + 25;
  CGFloat buttonPad = (kScreenBound.size.width - 70 - buttonW * 4 - 30)/3;
  for (int i = 0; i < 4; i ++) {
    SEL buttonAction = NSSelectorFromString(buttonActions[i]);
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15 + (buttonW + buttonPad) * i, buttonY, buttonW, buttonW);
    [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
    [button addTarget:self action:buttonAction forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat labelY = CGRectGetMaxY(button.frame) + 5;
    UILabel * objectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, buttonW, 15)];
    objectLabel.center = CGPointMake(button.center.x, objectLabel.center.y);
    objectLabel.text = labelNameArr[i];
    objectLabel.font = [UIFont systemFontOfSize:12];
    objectLabel.textAlignment = NSTextAlignmentCenter;
    
    if (![self respondsToSelector:buttonAction])
    {
      objectLabel.textColor = [UIColor colorWithHex:0xFFDCDCDC];
      [button setImage:[UIImage imageNamed:disableImageArr[i]] forState:UIControlStateDisabled];
      [button setEnabled:NO];
    }
    else
    {
      [button setEnabled:YES];
    }
    
    [sharedToView addSubview:button];
    [sharedToView addSubview:objectLabel];
  }
  
  CGFloat bLineX = 0;
  CGFloat bLineY = 206 - 50;
  CGFloat bLineW = kScreenBound.size.width - 70;
  CGFloat bLineH = 0.5;
  UIView * bLine = [[UIView alloc] initWithFrame:CGRectMake(bLineX, bLineY, bLineW, bLineH)];
  bLine.backgroundColor = [UIColor colorWithHex:0xffd7dae3];
  [sharedToView addSubview:bLine];
  
  CGFloat cButtonY = CGRectGetMaxY(bLine.frame);
  UIButton * cButton = [UIButton buttonWithType:UIButtonTypeCustom];
  cButton.frame = CGRectMake(0, cButtonY, kScreenBound.size.width - 70, 50);
  [cButton setTitleColor:[UIColor colorWithHex:0xff999999] forState:UIControlStateNormal];
  [cButton setTitle:@"取消" forState:UIControlStateNormal];
  [cButton setBackgroundColor:[UIColor colorWithHex:0xfff9f9f9]];
  [cButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
  [sharedToView addSubview:cButton];
  
  [kWindow addSubview:sharedToView];
  return sharedToView;
}
- (void)shareToWeiXin
{
  //分享统计时机为点击了图标
  self.iShareBlock(EHCShareWX);
  __weak typeof(self)wSelf = self;
  //设置微信好友title方法为
  [UMSocialData defaultData].extConfig.wechatSessionData.title = @"";
  //当分享消息类型为图文时，点击分享内容会跳转到预设的链接，设置方法如下
  [UMSocialData defaultData].extConfig.wechatSessionData.url = self.iShareVo.url;
  [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession]
                                                      content:self.iShareVo.message
                                                        image:self.iShareVo.image
                                                     location:nil
                                                  urlResource:nil
                                          presentedController:self.iShareVo.avc
                                                   completion:^(UMSocialResponseEntity *response)
   {
     if (response.responseCode == UMSResponseCodeSuccess) {
       HCLog(@"分享成功！");
       [wSelf cancelAction];
       
     }
   }];
  
}
- (void)shareToFried
{
  //分享统计时机为点击了图标
  self.iShareBlock(EHCShareWXCircle);
  __weak typeof(self)wSelf = self;
//  [UMSocialData defaultData].extConfig.wechatTimelineData.title = nil;
  [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.iShareVo.url;
  [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline]
                                                      content:self.iShareVo.message
                                                        image:self.iShareVo.image
                                                     location:nil
                                                  urlResource:nil
                                          presentedController:self.iShareVo.avc
                                                   completion:^(UMSocialResponseEntity *response)
   {
     if (response.responseCode == UMSResponseCodeSuccess) {
       HCLog(@"分享成功！");
//       wSelf.iShareBlock(EHCShareWXCircle);
       [wSelf cancelAction];
       
     }
   }];
  
  
}
- (void)shareToSina
{
  //
//  [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
//    HCLog(@"response is %@",response);
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina]
//                                                        content:contentStr
//                                                          image:self.iShareVo.image
//                                                       location:nil
//                                                    urlResource:nil
//                                            presentedController:self.iShareVo.avc
//                                                     completion:^(UMSocialResponseEntity *shareResponse)
//     {
//       NSLog(@"response is 3333");
//       if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//         HCLog(@"分享成功！");
//         [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES withShowingText:@"分享成功！" withIconImageName:nil];
//         [wSelf addShareWithObjectId:wSelf.iShareVo.objectId
//                            category:wSelf.iShareVo.category
//                          completion:^(BOOL isSucceed, NSString *aDesc)
//          {
//            [wSelf cancelAction];
//          }];
//       }
//       else if(shareResponse.responseCode == UMSResponseCodeFaild)
//       {
//         [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
//                                                       withShowingText:@"分享失败！"
//                                                     withIconImageName:nil];
//       }
//     }];
//  }];
  [[UMSocialControllerService defaultControllerService] setShareText:self.iShareVo.message
                                                          shareImage:self.iShareVo.image
                                                    socialUIDelegate:self];        //设置分享内容和回调对象
  [UMSocialSnsPlatformManager
   getSocialPlatformWithName:UMShareToSina].snsClickHandler(self.iShareVo.avc,
                                                            [UMSocialControllerService defaultControllerService],
                                                            YES);
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
  NSLog(@"response is 3333");
  if (response.responseCode == UMSResponseCodeSuccess) {
    HCLog(@"分享成功！");

      }
  else if(response.responseCode == UMSResponseCodeFaild)
  {

  }
}
- (void)shareToQq
{
  //分享统计时机为点击了图标
  self.iShareBlock(EHCShareQQ);
  __weak typeof(self)wSelf = self;
  NSString * content = @"";
  NSString * jumpUrl = self.iShareVo.url;
  //url为空会导致qq打开失败，添加一个空白的url
  if (![self.iShareVo.url isEqualToString:@""]) {
    [UMSocialData defaultData].extConfig.qqData.title = self.iShareVo.message;
    [UMSocialData defaultData].extConfig.qqData.url = jumpUrl;
  }
  else
  {
    content = self.iShareVo.message;
  }
  UIImage * shareImage = self.iShareVo.image;
  if (shareImage == nil) {
    shareImage = [UIImage imageNamed:@"guanyu_icon"];
  }
  
  [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ]
                                                      content:content
                                                        image:shareImage
                                                     location:nil
                                                  urlResource:nil
                                          presentedController:self.iShareVo.avc
                                                   completion:^(UMSocialResponseEntity *response)
   {
     if (response.responseCode == UMSResponseCodeSuccess) {
//       wSelf.iShareBlock(EHCShareQQ);
       NSLog(@"分享成功！");
       [wSelf cancelAction];
     }
   }];
//  [UMSocialData defaultData].extConfig.qzoneData.title = @"";
}
- (void)shareToZone
{
  //分享统计时机为点击了图标
  self.iShareBlock(EHCShareQZone);
  __weak typeof(self)wSelf = self;
  //分享的title
  [UMSocialData defaultData].extConfig.qzoneData.title = self.iShareVo.message;
  NSString * jumpUrl = self.iShareVo.url;
  //url为空会导致qq打开失败，添加一个空白的url
  if (![self.iShareVo.url isEqualToString:@""]) {
    [UMSocialData defaultData].extConfig.qzoneData.url = jumpUrl;
  }
  
  UIImage * shareImage = self.iShareVo.image;
  if (shareImage == nil) {
    shareImage = [UIImage imageNamed:@"guanyu_icon"];
  }
  [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone]
                                                      content:@""
                                                        image:shareImage
                                                     location:nil
                                                  urlResource:nil
                                          presentedController:self.iShareVo.avc
                                                   completion:^(UMSocialResponseEntity *response)
   {
     if (response.responseCode == UMSResponseCodeSuccess) {
//       wSelf.iShareBlock(EHCShareQZone);
       NSLog(@"分享成功！");
       [wSelf cancelAction];
     }
   }];
  [UMSocialData defaultData].extConfig.qzoneData.title = @"";
}
- (void)cancelAction
{
  UIWindow * kWindow = [UIApplication sharedApplication].keyWindow;
  for (int i = 0; i < 2; i ++) {
    UIView * view = [kWindow viewWithTag:10000 + i];
    [view removeFromSuperview];
  }
}

@end

@implementation CHCShareToUMModelHandler



@end

@implementation CHCShareVO

@end
