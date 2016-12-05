//
//  CHCUpdateViewController.m
//  FoodYou
//
//  Created by Lemon-HEcom on 16/1/28.
//  Copyright © 2016年 AZLP. All rights reserved.
//

#import "CHCUpdateViewController.h"
#import "AppDef.h"
#import "CustomAlertView.h"

@interface CHCUpdateViewController ()
@property (nonatomic, strong)CHCUpdateController *iController;
@end

@implementation CHCUpdateViewController
@dynamic iController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkVersionUpdateCompletion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
{
  [self.iController versionUpdateCompletion:aCompletion];
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

@interface CHCUpdateController()<CustomAlertViewDelegate>
@property (nonatomic, strong) CHCUpdateVO *iUpdateVO;
@property (nonatomic, strong) CustomAlertView * alertView;
@end

@implementation CHCUpdateController

- (void)versionUpdateCompletion:(void (^)(BOOL isSucceed, NSString * aDesc))aCompletion
{
  NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
  NSString * version = [infoDict objectForKey:@"CFBundleShortVersionString"];
  NSString * bundleId = @"com.newhope.izhailp.FoodYou";//[infoDict objectForKey:@"CFBundleIdentifier"];
  NSString *method = [NSString stringWithFormat:upDataMethod,bundleId];
  
  NSDictionary *dataDic = @{};
  
  [self.iModelHandler postMethod:method
                      parameters:dataDic
                      completion:
   ^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     if (aCompletion) {
       aCompletion(YES,nil);
     }
     if (aData) {
       if ([aData objectForKey:@"resultCount"]) {
         NSArray * results = [aData objectForKey:@"results"];
         NSDictionary * appInfoDic = [results firstObject];
         
         CHCUpdateVO * upDataVo = [[CHCUpdateVO alloc] init];
         upDataVo.version = [appInfoDic objectForKey:@"version"];
         upDataVo.downlink = [appInfoDic objectForKey:@"trackViewUrl"];
         upDataVo.desc = @"测试";
         upDataVo.upgrade = @(0);
         upDataVo.force = @(0);
         
         self.iUpdateVO = upDataVo;
         if ([version compare:upDataVo.version] != NSOrderedDescending)
         {
           upDataVo.upgrade = @(1);
           [self updateAction:upDataVo];
         }
         else
         {
           self.iUpdateVO = nil;
         }
       }
     }
   }];
}

- (void)updateAction:(CHCUpdateVO *)aVO
{
  if (aVO.upgrade.integerValue == 1 && aVO.downlink.length >0)
  {
    if (aVO.desc.length == 0)
    {
      //容错代码
      aVO.desc = @"发现新版本,请检查更新!";
    }
    NSString *title = [NSString stringWithFormat:@"发现新版本 %@",aVO.version];
    self.alertView = [[CustomAlertView alloc] initWithTitle:title
  description:self.iUpdateVO.desc
  desAlignment:NSTextAlignmentCenter
  cancelButton:@"暂时不用" okButton:@"立即更新"
  cancelBlock:^{
    
  } okBlock:^{
    NSString *url = self.iUpdateVO.downlink;
    //@"itms-services://?action=download-manifest&url=https://v40.hecom.cn/plist/cockpit.plist";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
  } delegate:self];
    [self.alertView show];
  }
  else
  {
    [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES
                                                 withShowingText:@"没有检测到新版本"
                                               withIconImageName:nil];
  }
}

- (void)customAlertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1)
  {
    NSString *url = self.iUpdateVO.downlink;
    //@"itms-services://?action=download-manifest&url=https://v40.hecom.cn/plist/cockpit.plist";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
  }
}
@end

@implementation CHCUpdateModelHandler


- (void)shouldPostRequest:(CHCHttpRequestHandler *)aHandler
{
//    [[CHCSpinnerView sharedSpinnerView] showInWindowsIsFullScreen:YES
//                                                  withShowingText:NSLocalizedStringFromTable(@"Spinner_loading", @"Controller_MessageView", nil)];
}

@end

@implementation CHCUpdateVO

@end
