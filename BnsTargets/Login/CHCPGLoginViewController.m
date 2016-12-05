//
//  CHCPGLoginViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/13.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGLoginViewController.h"
#import "BnsLoginDef.h"
#import "UIView+frame.h"
#import "CHCPGRegistViewController.h"
#import "AppDelegate.h"
#import "CHCAdvertisingManager.h"
#import "CHCPGUserDataSycnViewController.h"
#import "CHCInputValidUtil.h"

@interface CHCPGLoginViewController ()<UITextFieldDelegate>
{
  NSTimer * _iTimer;
}
@property (weak, nonatomic) IBOutlet UITextField *iPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *iCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *iCodeButton;
@property (nonatomic, assign) NSInteger iLeftTime;
@property (nonatomic, assign) BOOL isCanLogin;
@property (nonatomic, strong) CHCPGLoginController * iController;
@end

@implementation CHCPGLoginViewController
@dynamic iController;
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = NSLocalizedStringFromTable(@"LoginTitle", HCPG_LoginString, nil);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  [self adjustTextField:self.iPhoneTextField];
  [self adjustTextField:self.iCodeTextField];
}

- (void)adjustTextField:(UITextField *)textField
{
  UIView * leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 60)];
  leftview.backgroundColor = [UIColor clearColor];
  textField.leftView = leftview;
  textField.leftViewMode = UITextFieldViewModeAlways;
}
- (void)startReadTime
{
  self.iLeftTime = 60;
  [self readLeftTime:nil];
  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(readLeftTime:) userInfo:nil repeats:YES];
}

- (void)readLeftTime:(NSTimer *)aTimer
{
  if (self.iLeftTime <= 1)
  {
    [aTimer invalidate];
    aTimer = nil;
    self.iLeftTime = 0;
    [self.iCodeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.iCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
    [self.iCodeButton setEnabled:YES];
  }
  else
  {
    self.iLeftTime--;
    [self.iCodeButton setEnabled:NO];
    [self.iCodeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    NSString *btnTitle = [NSString stringWithFormat:@"重发(%ds)",(int)self.iLeftTime];
    [self.iCodeButton setTitle:btnTitle forState:UIControlStateDisabled];
  }
}


- (IBAction)getButtonAction:(id)sender
{
  if (self.iPhoneTextField.text.length < 11) {
    [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                  withShowingText:@"请输入正确手机号"
                                                withIconImageName:nil];
    return;
  }
  __weak typeof(self)wSelf = self;
  self.isCanLogin = YES;
  [self.view endEditing:YES];
  [self.iController getVerifyCodeWithMobilPhone:self.iPhoneTextField.text
                                     completion:^(BOOL isSucceed, NSString *aDes)
   {
     if (!isSucceed) {
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:aDes
                                                   withIconImageName:nil];
     }
     else
     {
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:@"发送短信验证码成功"
                                                   withIconImageName:nil];
       [wSelf startReadTime];
     }
     
   }];
}
#pragma mark - UITextFiedDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  BOOL rtn = YES;
  if (![string isEqualToString:@""]) {
    rtn = [CHCInputValidUtil checkInteger:string];
  }
  return rtn;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChange:(UITextField *)textField
{
  if (self.iPhoneTextField.text.length > 11) {
    self.iPhoneTextField.text = [self.iPhoneTextField.text substringToIndex:11];
  }
  if (self.iCodeTextField.text.length >4) {
    self.iCodeTextField.text = [self.iCodeTextField.text substringToIndex:4];
  }
  if (self.iCodeTextField.text.length == 4 &&
      self.iPhoneTextField.text.length == 11 &&
      self.isCanLogin)
  {
    [self.view endEditing:YES];
    [self.iController validityVerifyCodeWithMobil:self.iPhoneTextField.text
                                       verifyCode:self.iCodeTextField.text
                                       completion:^(BOOL isSucceed, NSString *aDes)
     {
       if (isSucceed) {
         
       }
       else
       {
         self.iCodeTextField.text = @"";
//         self.isCanLogin = NO;
         [[CHCSpinnerView sharedSpinnerView] hiddenSpinnerView];
         [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                       withShowingText:aDes
                                                     withIconImageName:nil];
       }
     }];
  }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [textField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)leftButtonAction:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
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

@interface CHCPGLoginController ()
@property (nonatomic, weak) CHCPGLoginViewController * iViewController;
@property (nonatomic, strong) CHCPGUserDataSycnViewController * iUserDataSyncController;
@end

@implementation CHCPGLoginController
@dynamic iViewController;
- (instancetype)init
{
  if (self = [super init])
  {
    
      }
  return self;
}
- (CHCPGUserDataSycnViewController *)iUserDataSyncController
{
  if (!_iUserDataSyncController)
  {
    _iUserDataSyncController = [[CHCPGUserDataSycnViewController alloc] init];
  }
  return _iUserDataSyncController;
}
- (void)getVerifyCodeWithMobilPhone:(NSString *)mobile
                         completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  [[CHCSpinnerView sharedSpinnerView] showInWindowsIsFullScreen:YES
                                                withShowingText:NSLocalizedStringFromTable(@"Spinner_loading", @"Controller_MessageView", nil)];
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_loginGetCode];
  NSDictionary * param = @{@"reqSource":@"0",@"mobile":mobile};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
  {
    [[CHCSpinnerView sharedSpinnerView] hiddenSpinnerView];
    NSError *aError = error;
    if(aFlag != 0 && !aError)
    {
      aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
    }
    
    if (aError)
    {
      if (aCompletion)
      {
        aCompletion(NO,[aError domain]);
      }
    }
    else
    {
      if (aCompletion)
      {
        aCompletion(YES,nil);
      }
    }
  }];
}
- (void)validityVerifyCodeWithMobil:(NSString *)mobile
                         verifyCode:(NSString *)verifyCode
                         completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;
{
  [[CHCSpinnerView sharedSpinnerView] showInWindowsIsFullScreen:YES
                                                withShowingText:NSLocalizedStringFromTable(@"Spinner_loading", @"Controller_MessageView", nil)];
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_LoginVerifyCode];
  NSDictionary * param = @{@"verifyCode":verifyCode,@"mobile":mobile};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     if (aFlag == -1 && [mobile isEqualToString:HCPGSuperPhone])
     {
       [CHCCommonInfoVO sharedManager].iHCid = @(10031011);
       [wSelf.iUserDataSyncController sycnUserGoldDataCompletion:^(BOOL isSucceed, NSString *aDes) {
         if (isSucceed) {
           [wSelf goLoginWithMobile:mobile deviceId:[CHCAdvertisingManager getDeviceId]];
         }
       }];
       
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
         return ;
     }
     NSError *aError = error;
     if(aFlag != 0 && !aError)
     {
       aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     
     if (aError)
     {
       if (aCompletion)
       {
         aCompletion(NO,[aError domain]);
       }
     }
     else
     {
       //uid ＝ －1用户没有注册过，进行注册
       NSNumber * uid = [aData objectForKey:@"uid"];
       if (uid.integerValue == -1) {
         [[CHCSpinnerView sharedSpinnerView] hiddenSpinnerView];
         CHCPGRegistViewController * registVc = [[CHCPGRegistViewController alloc] initWithMobile:mobile];
         [self.iViewController.navigationController pushViewController:registVc animated:YES];
       }
       else
       {
         [CHCCommonInfoVO sharedManager].iHCid = uid;
         [wSelf.iUserDataSyncController sycnUserGoldDataCompletion:^(BOOL isSucceed, NSString *aDes) {
           if (isSucceed) {
             [wSelf goLoginWithMobile:mobile deviceId:[CHCAdvertisingManager getDeviceId]];
           }
         }];
         
         if (aCompletion)
         {
           aCompletion(YES,nil);
         }
       }
     }
   }];
}

- (void)goLoginWithMobile:(NSString *)mobile deviceId:(NSString *)deviceId
{
  [self loginWithMobile:mobile deviceId:deviceId
             completion:^(BOOL isSucceed, NSString *aDes)
   {
     if (isSucceed) {
      
     }
     else
     {
       
     }
   }];
}

- (void)loginWithMobile:(NSString *)mobile
               deviceId:(NSString *)deviceId
             completion:(void (^)(BOOL, NSString *))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_LoginLogin];
  NSDictionary * param = @{@"deviceId":deviceId,@"mobile":mobile};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     NSError *aError = error;
     if(aFlag != 0 && !aError)
     {
       aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     
     if (aError)
     {
       if (aCompletion)
       {
         aCompletion(NO,[aError domain]);
       }
     }
     else
     {
       [wSelf excuteQueryWithUid:[aData valueForKeyPath:@"data.id"] tables:@[@"user",@"userInfo"]];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}

- (void)excuteQueryWithUid:(NSNumber *)uid tables:(NSArray *)tables
{
  __weak typeof(self)wSelf = self;
  [self queryTablesWithUid:uid tables:tables
                completion:^(BOOL isSucceed, NSString *aDes)
   {
     [[CHCSpinnerView sharedSpinnerView] hiddenSpinnerView];
     if (isSucceed)
     {
       [wSelf.iViewController dismissViewControllerAnimated:YES completion:nil];
       //登录成功
       [[NSNotificationCenter defaultCenter] postNotificationName:HC_PG_Login_login object:nil];
     }
   }];
}
- (void)queryTablesWithUid:(NSNumber *)uid
                    tables:(NSArray *)tables
                completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_LoginQueryTables];
  NSDictionary * param = @{@"uid":uid,@"tables":tables};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     NSError *aError = error;
     if(aFlag != 0 && !aError)
     {
       aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     if (aError)
     {
       if (aCompletion)
       {
         aCompletion(NO,[aError domain]);
       }
     }
     else
     {
       NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithDictionary:[aData valueForKeyPath:@"data.user"]];
       NSDictionary * uInfoDic = [aData valueForKeyPath:@"data.userInfo"];
       if ([uInfoDic isKindOfClass:[NSDictionary class]]) {
          [dataDic addEntriesFromDictionary:[aData valueForKeyPath:@"data.userInfo"]];
       }
       [((AppDelegate *)[UIApplication sharedApplication].delegate) putLoginInfo:dataDic];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
@end

@implementation CHCPGLoginModelHandler

- (void)shouldPostRequest:(CHCHttpRequestHandler *)aHandler
{
  
}
- (void)willFinishPostRrequest:(CHCHttpRequestHandler *)aHandler succeed:(BOOL)isSucceed
{

}
@end
