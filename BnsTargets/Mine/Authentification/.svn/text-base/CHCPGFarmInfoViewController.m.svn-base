//
//  CHCPGFarmInfoViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/29.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGFarmInfoViewController.h"
#import "LocationManager.h"
#import "CHCPGCHooseAddressViewController.h"
#import "CHCCommonInfoVO.h"
#import "BnsMineDef.h"
#import "CHCPGMineHomeViewController.h"
#import "CHCPGSalesManViewController.h"

@interface CHCPGFarmInfoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *iFarmAddressField;
@property (weak, nonatomic) IBOutlet UITextField *iDetailFarmField;
@property (weak, nonatomic) IBOutlet UIButton *iNextButton;
@property (nonatomic, strong) CHCPGAuthentifyVO * iAuthentifyVo;
@end

@implementation CHCPGFarmInfoViewController

- (void)creatObjsWhenInit
{
  self.iTitleStr = @"猪场信息";
}
- (instancetype)initWithAuthentify:(CHCPGAuthentifyVO *)iAuthentifyVo
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
  if ([self.iAuthentifyVo.farmProvince isEqualToString:@""])
  {
    LocationManager * manager = [LocationManager sharedLocationManager];
    if (manager.iProvice &&![manager.iProvice isEqualToString:@""]) {
      NSMutableString * addressStr = [NSMutableString stringWithFormat:@"%@",manager.iProvice];
      NSString * city = manager.iCity;
      [addressStr appendFormat:@"%@",city];
      [addressStr appendFormat:@" %@",manager.iCounty];
      [addressStr appendFormat:@" %@",manager.iTownship];
      self.iFarmAddressField.text = addressStr;
      
      self.iAuthentifyVo.iProvice = manager.iProvice;
      self.iAuthentifyVo.iCity = manager.iCity;
      self.iAuthentifyVo.iCountry = manager.iCounty;
      self.iAuthentifyVo.iTown = manager.iTownship;
    }
    else
    {
      [self getLocation];
    }
  }
  else
  {
    NSMutableString * addressStr = [NSMutableString stringWithFormat:@"%@",self.iAuthentifyVo.farmProvince];
    NSString * city = self.iAuthentifyVo.farmCity?[NSString stringWithFormat:@" %@",self.iAuthentifyVo.farmCity]:@"";
    [addressStr appendFormat:@"%@",city];
    [addressStr appendFormat:@" %@",self.iAuthentifyVo.farmCounty];
    [addressStr appendFormat:@" %@",self.iAuthentifyVo.farmTownship];
    self.iFarmAddressField.text = addressStr;
    
    self.iAuthentifyVo.iProvice = self.iAuthentifyVo.farmProvince;
    self.iAuthentifyVo.iCity = self.iAuthentifyVo.farmCity;
    self.iAuthentifyVo.iCountry = self.iAuthentifyVo.farmCounty;
    self.iAuthentifyVo.iTown = self.iAuthentifyVo.farmTownship;
  }
  self.iDetailFarmField.text = self.iAuthentifyVo.farmAddress;
}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if (self.iFarmAddressField.text.length && self.iDetailFarmField.text.length) {
    self.iNextButton.enabled = YES;
  }
  else
  {
    self.iNextButton.enabled = NO;
  }
}
- (void)getLocation
{
  [[CHCSpinnerView sharedSpinnerView] showInWindowsIsFullScreen:YES
                                                withShowingText:@"定位中..."];
  [[LocationManager sharedLocationManager] gecodeLocationCompeletionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
   {
     [[CHCSpinnerView sharedSpinnerView] hiddenSpinnerView];
     if (error)
     {
       HCLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
       
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:@"定位失败"
                                                   withIconImageName:nil];
//       if (error.code == AMapLocationErrorLocateFailed)
//       {
       
         return;
//       }
     }
     if (location)
     {
       if (regeocode)
       {
         NSMutableString * addressStr = [NSMutableString stringWithFormat:@"%@",regeocode.province];
         if (regeocode.city) {
           NSString * city = regeocode.city?[NSString stringWithFormat:@" %@",regeocode.city]:@"";
           [addressStr appendFormat:@"%@",city];
           [addressStr appendFormat:@" %@",regeocode.district];
           [addressStr appendFormat:@" %@",regeocode.township];
           self.iFarmAddressField.text = addressStr;
           
           self.iAuthentifyVo.iProvice = regeocode.province;
           self.iAuthentifyVo.iCity = regeocode.city?:@"";
           self.iAuthentifyVo.iCountry = regeocode.district;
           self.iAuthentifyVo.iTown = regeocode.township;
         }
         else
         {
           [addressStr appendFormat:@" %@",regeocode.district];
           [addressStr appendFormat:@" %@",regeocode.township];
           self.iFarmAddressField.text = addressStr;
           
           self.iAuthentifyVo.iProvice = regeocode.province;
           self.iAuthentifyVo.iCity = regeocode.district;
           self.iAuthentifyVo.iCountry = regeocode.township;
           self.iAuthentifyVo.iTown = @"";
         }
       }
     }
   }];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChange:(UITextField *)textField
{
  if (self.iFarmAddressField.text.length && self.iDetailFarmField.text.length) {
    self.iNextButton.enabled = YES;
  }
  else
  {
    self.iNextButton.enabled = NO;
  }
  NSInteger length = 20;
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
- (IBAction)selectAddress:(id)sender
{
  CHCPGCHooseAddressViewController * avc =
  [[CHCPGCHooseAddressViewController alloc] initWithAddressBlock:^(NSMutableArray *addressAry)
   {
     NSMutableString * addresStr = [NSMutableString string];
     [addressAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
      {
        switch (idx) {
          case 0:
          {
            [addresStr appendString:obj];
            self.iAuthentifyVo.iProvice = obj;
            break;
          }
          case 1:
          {
            self.iAuthentifyVo.iCity = obj;
            if ([obj isEqualToString:@""])
            {
              break;
            }
            [addresStr appendFormat:@" %@",obj];
            break;
          }
          case 2:
          {
            self.iAuthentifyVo.iCountry = obj;
            [addresStr appendFormat:@" %@",obj];
            break;
          }
          case 3:
          {
            self.iAuthentifyVo.iTown = obj;
            [addresStr appendFormat:@" %@",obj];
            break;
          }
          default:
            break;
        }
      }];
     self.iFarmAddressField.text = addresStr;
   }];
  [self.navigationController presentViewController:avc animated:YES completion:nil];
}

- (IBAction)locateButtonAction:(id)sender
{
  [self getLocation];
}
- (IBAction)nextButtonAction:(id)sender
{
  self.iAuthentifyVo.iAddress = self.iDetailFarmField.text;
  CHCPGSalesManViewController * svc = [[CHCPGSalesManViewController alloc] initWithAuthentifyVo:self.iAuthentifyVo];
  [self.navigationController pushViewController:svc animated:YES];
}

- (IBAction)leftButtonAction:(id)sender
{
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


