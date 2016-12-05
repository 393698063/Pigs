//
//  CHCMineSettingViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/27.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGMineSettingViewController.h"
#import "CHCPGAboutPigViewController.h"
#import "CHCSharedManager.h"
#import "CHCUpdateViewController.h"

@interface CHCPGMineSettingViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) CHCUpdateViewController * iUpdataController;
@end

@implementation CHCPGMineSettingViewController
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = @"设置";
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)switchVersion:(id)sender
{
  
}

- (IBAction)shareSoftWare:(id)sender
{
  /*
   shareVo.message = wSelf.iTitle;
   shareVo.objectId = wSelf.iInfomationId;
   shareVo.category = @(wSelf.iWebType);
   shareVo.image = image;
   shareVo.url = wSelf.iWebUrlStr;
   shareVo.avc = wSelf;

   */
  CHCShareVO * shareVo = [[CHCShareVO alloc] init];
  shareVo.message = @"安心养猪，快乐生活http://www.nhecom.cn/downlink";// @"安心养猪，快乐生活！https://itunes.apple.com/cn/app/shi-guang-she-she-qun-mei/id1063200840?mt=8&uo=4";//http://www.nhecom.com/downlink
  shareVo.url = @"http://www.nhecom.cn/downlink";
  shareVo.avc = self;
  
    [[CHCSharedManager defaultManager] sharedWithShareVO:shareVo sharedBloc:^(EHCShareType type) {
      
    }];
}
- (IBAction)testNewVersion:(id)sender
{
  self.iUpdataController = [[CHCUpdateViewController alloc] init];
  [[CHCSpinnerView sharedSpinnerView] showInWindowsIsFullScreen:YES
                                                withShowingText:NSLocalizedStringFromTable(@"Spinner_loading", @"Controller_MessageView", nil)];
  [self.iUpdataController checkVersionUpdateCompletion:^(BOOL isSucceed, NSString *aDes) {
    [[CHCSpinnerView sharedSpinnerView] hiddenSpinnerView];
  }];
}
- (IBAction)aboutPig:(id)sender {
  CHCPGAboutPigViewController * avc = [[CHCPGAboutPigViewController alloc] init];
  [self.navigationController pushViewController:avc animated:YES];
}
- (IBAction)quitOut:(id)sender {
  UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@""
                                                       message:@"退出当前帐户？"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确认退出", nil];
  [alertView show];
}
- (IBAction)leftButtonAction:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == alertView.cancelButtonIndex)
  {
    return;
  }
  [[NSNotificationCenter defaultCenter] postNotificationName:HC_PG_Login_logout object:nil];
  [self.navigationController popToRootViewControllerAnimated:YES];
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
