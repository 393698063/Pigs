//
//  CHCPGRegistViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/20.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGRegistViewController.h"
#import "LocationManager.h"
#import "CHCPGCHooseAddressViewController.h"
#import "BnsLoginDef.h"
#import "CHCAdvertisingManager.h"
#import "CHCCommonInfoVO.h"
#import "AppDelegate.h"
#import "CHCPGUserDataSycnViewController.h"
#import "CHCPGGoldManager.h"

@interface CHCPGRegistViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *iDetailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *iNameField;
@property (weak, nonatomic) IBOutlet UITextField *iAddressField;
@property (weak, nonatomic) IBOutlet UIButton *iCompleteButton;
@property (nonatomic, copy) NSString * iMobile;
@property (nonatomic, strong) CHCPGRegistVO * iRegistVo;
@property (nonatomic, strong) CHCPGRegistController * iController;
@end

@implementation CHCPGRegistViewController
@dynamic iController;
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = @"新用户注册";
}
- (instancetype)initWithMobile:(NSString *)mobile
{
  if (self = [super init]) {
    _iMobile = mobile;
    self.iRegistVo = [[CHCPGRegistVO alloc] init];
    self.iRegistVo.mobile = mobile;
    self.iRegistVo.isFarmer = @"0";
  }
  return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 [self.iAddressField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
  LocationManager * manager = [LocationManager sharedLocationManager];
  NSMutableString * addressStr = [NSMutableString string];
  if (manager.iProvice && ![manager.iProvice isEqualToString:@""]) {
    self.iRegistVo.latitude = manager.iLatitude;
    self.iRegistVo.longitude = manager.iLongitude;
    self.iRegistVo.locaProvince = manager.iProvice;
    self.iRegistVo.farmProvince = manager.iProvice;
    self.iRegistVo.locaCity = manager.iCity;
    self.iRegistVo.farmCity = manager.iCity;
    self.iRegistVo.locaCounty = manager.iCounty;
    self.iRegistVo.farmCounty = manager.iCounty;
    self.iRegistVo.locaTownship = manager.iTownship;
    self.iRegistVo.farmVillage = manager.iTownship;
    [[CHCSpinnerView sharedSpinnerView] hiddenSpinnerView];
    [addressStr appendFormat:@"%@",manager.iProvice];
    [addressStr appendFormat:@" %@",manager.iCity?:@""];
    [addressStr appendFormat:@" %@",manager.iCounty?:@""];
    [addressStr appendFormat:@" %@",manager.iTownship?:@""];
    self.iAddressField.text = addressStr;
  }
  else
  {
    [self getLocation];
  }
}
- (void)getLocation
{
  [[CHCSpinnerView sharedSpinnerView] showInWindowsIsFullScreen:YES withShowingText:@"定位中..."];
  NSMutableString * addressStr = [NSMutableString string];
  [[LocationManager sharedLocationManager] gecodeLocationCompeletionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
   {
     [[CHCSpinnerView sharedSpinnerView] hiddenSpinnerView];
     if (error)
     {
       HCLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
       
       //       if (error.code == AMapLocationErrorLocateFailed)
       //       {
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:@"定位失败"
                                                   withIconImageName:nil];
       return;
       //       }
     }
     if (location)
     {
       self.iRegistVo.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
       self.iRegistVo.longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
       if (regeocode)
       {
         [addressStr appendFormat:@"%@",regeocode.province];
         self.iRegistVo.locaProvince = regeocode.province?:@"";
         self.iRegistVo.farmProvince = regeocode.province?:@"";
         if (regeocode.city)
         {
           NSString * city = regeocode.city;
           [addressStr appendFormat:@"%@",city];
           self.iRegistVo.locaCity = city;
           self.iRegistVo.farmCity = city;
           [addressStr appendFormat:@" %@",regeocode.district];
           self.iRegistVo.locaCounty = regeocode.district?:@"";
           self.iRegistVo.farmCounty = regeocode.district?:@"";
           [addressStr appendFormat:@" %@",regeocode.township];
           self.iRegistVo.locaTownship = regeocode.township?:@"";
           self.iRegistVo.farmVillage = regeocode.township?:@"";
         }
         else
         {
           self.iRegistVo.locaCity = regeocode.district;
           self.iRegistVo.farmCity = regeocode.district;
           [addressStr appendFormat:@" %@",regeocode.district];
           
           self.iRegistVo.locaCounty = regeocode.township;
           self.iRegistVo.farmCounty = regeocode.township;
           [addressStr appendFormat:@" %@",regeocode.township];
           
           self.iRegistVo.locaTownship = @"";
           self.iRegistVo.farmVillage = @"";
         }
         self.iAddressField.text = addressStr;
       }
     }
   }];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
  if ([keyPath isEqualToString:@"text"]) {
    [self textFieldDidChange:nil];
  }
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChange:(UITextField *)textField
{
  BOOL nameflag = self.iNameField.text.length;
  BOOL addressFlag = self.iAddressField.text.length;
  BOOL detailFlag = self.iDetailAddressField.text.length;
  if (nameflag && addressFlag && detailFlag) {
    self.iCompleteButton.enabled = YES;
  }
  else
  {
    self.iCompleteButton.enabled = NO;
  }
  
  NSInteger length = 9;
  if (textField == self.iDetailAddressField) {
    length = 20;
  }
  NSString * toatStr = [NSString stringWithFormat:@"已超过%ld个字了",(long)length];
  NSString * lang = [textField.textInputMode primaryLanguage];//键盘输入模式
  if ([lang isEqualToString:@"zh-Hans"]) {
    UITextRange * selectRange = [textField markedTextRange];
    
    UITextPosition * position = [textField positionFromPosition:selectRange.start offset:0];
    
    if (!position) {
      if (textField.text.length > length)
      {
        textField.text = [textField.text substringToIndex:length];
        [textField resignFirstResponder];
        [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                      withShowingText:toatStr
                                                    withIconImageName:@""];
      }
    }
  }
  else
  {
    if (textField.text.length > length) {
      textField.text = [textField.text substringToIndex:length];
      [textField resignFirstResponder];
      [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                    withShowingText:toatStr
                                                  withIconImageName:@""];
    }
  }
  
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [textField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (IBAction)iSelectAddressAction:(id)sender
{
  CHCPGCHooseAddressViewController * avc = [[CHCPGCHooseAddressViewController alloc] initWithAddressBlock:^(NSMutableArray *addressAry)
  {
    NSMutableString * addresStr = [NSMutableString string];
    [addressAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
      switch (idx)
      {
        case 0:
        {
          [addresStr appendString:obj];
          self.iRegistVo.farmProvince = obj;
          break;
        }
        case 1:
        {
          self.iRegistVo.farmCity = obj;
          [addresStr appendFormat:@" %@",obj];
          break;
        }
        case 2:
        {
          self.iRegistVo.farmCounty = obj;
          [addresStr appendFormat:@" %@",obj];
          break;
        }
        case 3:
        {
          self.iRegistVo.farmVillage = obj;
          [addresStr appendFormat:@" %@",obj];
          break;
        }
        default:
          break;
      }
    }];
    self.iAddressField.text = addresStr;
  }];
  [self.navigationController presentViewController:avc animated:YES completion:nil];
}
- (IBAction)locationButtonAction:(id)sender
{
  [self getLocation];
}

- (IBAction)iCompleteButtonAction:(id)sender
{
  [self.view endEditing:YES];
  NSString * advertse = [CHCAdvertisingManager getDeviceId];
  self.iRegistVo.deviceId = advertse;
  self.iRegistVo.userName = [self.iNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  self.iRegistVo.farmAddress = [self.iDetailAddressField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if ([self.iRegistVo.userName isEqualToString:@""]) {
    [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                  withShowingText:@"用户名不能为空"
                                                withIconImageName:nil];
    return;
  }
  if ([self.iRegistVo.farmAddress isEqualToString:@""]) {
    [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                  withShowingText:@"详细地址不能为空"
                                                withIconImageName:nil];
    return;
  }
  [self.iController implenentRegistWithRegistVo:self.iRegistVo
                                     completion:^(BOOL isSucceed, NSString *aDes)
   {
     if (isSucceed)
     {
       
     }
     else
     {
       [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES
                                                    withShowingText:aDes
                                                  withIconImageName:nil];
     }
   }];
}
- (IBAction)leftButtonAction:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc
{
  [self.iAddressField removeObserver:self forKeyPath:@"text"];
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

@interface CHCPGRegistController ()
@property (nonatomic, strong) CHCPGUserDataSycnViewController * iUserDataSyncController;
@property (nonatomic, weak) CHCPGRegistViewController * iViewController;
@end

@implementation CHCPGRegistController
@dynamic iViewController;
- (instancetype)init
{
  if (self = [super init]) {
    
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
- (void)implementRegistWithMobile:(NSString *)mobile
                          useName:(NSString *)userName
                         isFarmer:(NSString *)isFarmer
                     farmerMobile:(NSString *)farmerMobile
                recommendTelphone:(NSString *)recommendTelphone
                         deviceId:(NSString *)deviceId
                       completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_LoginRegist];
  NSDictionary * param = @{@"mobile":mobile,@"userName":userName,@"isFarmer":isFarmer,
                           @"farmerMobile":farmerMobile,@"recommendTelphone":recommendTelphone,
                           @"deviceId":deviceId};
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
       [CHCCommonInfoVO sharedManager].iHCid = aData[@"uid"];
       [wSelf.iUserDataSyncController sycnUserGoldDataCompletion:^(BOOL isSucceed, NSString *aDes)
        {
          if (isSucceed) {
            [wSelf excuteQueryWithUid:aData[@"uid"] tables:@[@"user",@"userInfo"]];
          }
          else
          {
            //同步数据失败处理
          }
        }];
       
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
- (void)implenentRegistWithRegistVo:(CHCPGRegistVO *)registVo
                         completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_LoginRegist];
  [[CHCSpinnerView sharedSpinnerView] showInWindowsIsFullScreen:YES
                                                withShowingText:NSLocalizedStringFromTable(@"Spinner_loading", @"Controller_MessageView", nil)];
  [self.iModelHandler postMethod:method parameters:registVo completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     NSError *aError = error;
     if(aFlag != 0 && !aError)
     {
       aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     
     if (aError)
     {
       //该手机号码已经注册，flag ＝ 1,人数超限2，
       if (aFlag == 1) {
         [CHCCommonInfoVO sharedManager].iHCid = aData[@"uid"];
         [wSelf.iUserDataSyncController sycnUserGoldDataCompletion:^(BOOL isSucceed, NSString *aDes)
          {
            if (isSucceed)
            {
              [wSelf excuteQueryWithUid:aData[@"uid"] tables:@[@"user",@"userInfo"]];
            }
            else
            {
              //同步数据失败处理
            }
          }];
         if (aCompletion)
         {
           aCompletion(YES,nil);
         }
       }
       else
       {
         if (aCompletion)
         {
           [[CHCSpinnerView sharedSpinnerView] hiddenSpinnerView];
           aCompletion(NO,[aError domain]);
         }
       }
     }
     else
     {
       [CHCCommonInfoVO sharedManager].iHCid = aData[@"uid"];
       [wSelf.iUserDataSyncController sycnUserGoldDataCompletion:^(BOOL isSucceed, NSString *aDes)
        {
          if (isSucceed) {
            [wSelf excuteQueryWithUid:aData[@"uid"] tables:@[@"user",@"userInfo"]];
          }
          else
          {
            //同步数据失败处理
          }
        }];
       
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
- (void)excuteQueryWithUid:(NSNumber *)uid tables:(NSArray *)tables
{
  [self queryTablesWithUid:uid tables:tables
                completion:^(BOOL isSucceed, NSString *aDes)
   {
     [[CHCSpinnerView sharedSpinnerView] hiddenSpinnerView];
     if (isSucceed) {
       
       [[CHCPGGoldManager sharedCHCPGGoldManager] showGoldGifWithType:EHCGoldRegist
                                                          compeletion:^(BOOL compeleted, NSString *aDesc)
        {
          [self.iViewController dismissViewControllerAnimated:YES completion:nil];
          //登录成功
          [[NSNotificationCenter defaultCenter] postNotificationName:HC_PG_Login_login object:nil];
        }];
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
       [dataDic addEntriesFromDictionary:[aData valueForKeyPath:@"data.userInfo"]];
       [((AppDelegate *)[UIApplication sharedApplication].delegate) putLoginInfo:dataDic];
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
@end

@implementation CHCPGRegistModelHandler

- (void)shouldPostRequest:(CHCHttpRequestHandler *)aHandler
{
  
}
- (void)willFinishPostRrequest:(CHCHttpRequestHandler *)aHandler succeed:(BOOL)isSucceed
{
  
}

@end

@implementation CHCPGRegistVO


@end
