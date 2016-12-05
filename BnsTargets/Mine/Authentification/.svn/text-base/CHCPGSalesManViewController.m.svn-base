//
//  CHCPGSalesManViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/29.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGSalesManViewController.h"
#import "CHCPGMineHomeViewController.h"
#import "BnsMineDef.h"
#import "CHCPGAuthentifyViewController.h"
#import "CHCInputValidUtil.h"

@interface CHCPGSalesManViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *iNameField;
@property (weak, nonatomic) IBOutlet UITextField *iPhoneField;
@property (weak, nonatomic) IBOutlet UIButton *iCompleteButton;
@property (nonatomic, strong) CHCPGAuthentifyVO * iAuthentifyVo;
@property (nonatomic, strong) CHCPGSalesManController * iController;
@end

@implementation CHCPGSalesManViewController
@dynamic iController;
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = @"业务员信息";
}
- (instancetype)initWithAuthentifyVo:(CHCPGAuthentifyVO *)iAuthentifyVo
{
  if (self = [super init])
  {
    self.iAuthentifyVo = iAuthentifyVo;
  }
  return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.iNameField.text = self.iAuthentifyVo.bisName;
  self.iPhoneField.text = self.iAuthentifyVo.bisPhone;
}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if (self.iNameField.text.length && self.iPhoneField.text.length)
  {
    self.iCompleteButton.enabled = YES;
  }
  else
  {
    self.iCompleteButton.enabled = NO;
  }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  BOOL rtn = YES;
  if (![string isEqualToString:@""] && textField == self.iPhoneField) {
    rtn = [CHCInputValidUtil checkInteger:string];
  }
  return rtn;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChange:(UITextField *)textField
{
  if (self.iNameField.text.length && self.iPhoneField.text.length) {
    self.iCompleteButton.enabled = YES;
  }
  else
  {
    self.iCompleteButton.enabled = NO;
  }
  NSInteger length = 9;
  if (textField == self.iPhoneField) {
    length = 11;
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
  [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (IBAction)leftButtonAction:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)completAcion:(id)sender
{
  __weak typeof(self)wSelf =self;
  
  if (self.iPhoneField.text.length < 11) {
    [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                  withShowingText:@"验证手机号不通过!"
                                                withIconImageName:nil];
    return;
  }
  self.iAuthentifyVo.iManName = self.iNameField.text;
  self.iAuthentifyVo.iManPhone = self.iPhoneField.text;
  [self.iController authentifyWithAuthentifyVo:self.iAuthentifyVo
                                    completion:^(BOOL isSucceed, NSString *aDes)
   {
     if (isSucceed)
     {
       [[NSNotificationCenter defaultCenter] postNotificationName:HCPG_ExpertNeedFreshAuthentityInfo
                                                           object:nil];
       
       aDes = @"认证成功";
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:aDes
                                                   withIconImageName:nil];
       CHCPGAuthentifyViewController * avc = [[CHCPGAuthentifyViewController alloc] initWithAuthentify:wSelf.iAuthentifyVo];
       [wSelf.navigationController pushViewController:avc animated:YES];
     }
     else
     {
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:aDes withIconImageName:nil];
     }
   }];
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

@implementation CHCPGSalesManController

- (void)authentifyWithAuthentifyVo:(CHCPGAuthentifyVO *)authentigyVo
                        completion:(void (^)(BOOL, NSString *))aCompletion
{
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_MineAuthentify];
  NSDictionary * param = @{@"uid":[CHCCommonInfoVO sharedManager].iHCid,
                           @"farmProvince":authentigyVo.iProvice,
                           @"farmCity":authentigyVo.iCity,
                           @"farmCounty":authentigyVo.iCountry,
                           @"farmVillage":authentigyVo.iTown,
                           @"bisName":authentigyVo.iManName,
                           @"bisPhone":authentigyVo.iManPhone,
                           @"farmAddress":authentigyVo.iAddress};
  [self.iModelHandler postMethod:method parameters:param
                      completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     NSError * aError = error;
     if (aFlag != 0 && !aError)
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
       authentigyVo.farmProvince = authentigyVo.iProvice;
       authentigyVo.farmCity = authentigyVo.iCity;
       authentigyVo.farmCounty = authentigyVo.iCountry;
       authentigyVo.farmTownship = authentigyVo.iTown;
       authentigyVo.farmAddress = authentigyVo.iAddress;
       authentigyVo.bisName = authentigyVo.iManName;
       authentigyVo.bisPhone = authentigyVo.iManPhone;
       if (aCompletion) {
         aCompletion(YES,nil);
       }
     }
   }];
}
@end
