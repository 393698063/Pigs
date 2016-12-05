//
//  CHCPGQuotePriceViewController.m
//  Pigs
//
//  Created by wangbin on 16/5/18.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define MAIN_Screen [[UIScreen mainScreen]bounds].size
#import "BnsQuationDef.h"
#import "CHCQuotePriceHeadView.h"
#import "CHCPGCHooseAddressViewController.h"
#import "CHCPGQuotePriceViewController.h"
#import "CHCPGMyQuotePriceViewController.h"
#import "CHCPGUserDataSycnViewController.h"
#import "CHCPGPriceTrendViewController.h"
#import "CHCSqliteManager.h"
#import "CHCPGGoldManager.h"
#import "AppDelegate.h"
#import "CHCInputValidUtil.h"
#import "CustomAlertView.h"
#import "LocationManager.h"
@interface CHCPGQuotePriceViewController ()<UITextFieldDelegate,CustomAlertViewDelegate>

@property (nonatomic,strong) UITableView *iTableView;
@property (nonatomic,strong) UIView *iHeadView;
@property (nonatomic,copy) NSString *iOutsideThreeMember;//外三元的输入价格
@property (nonatomic,copy) NSString *iInsideThreeMember;//内三元的输入价格
@property (nonatomic,copy) NSString *iNativeMixPig;//土杂猪的输入价格
@property (nonatomic,strong) NSMutableArray *iSelectAddress;//保存报猪价的时候的地址信息
@property (nonatomic, strong) CHCPGQuotePriceController * iController;
@property (nonatomic,strong) CHCPGQuotePriceVO *priceVO;
@property (nonatomic,strong) CHCPGGoldManager *iGoldManager;//涉及到金币的工具类
@property (nonatomic, strong) CustomAlertView * alertView;//当没有报价的时候退出当前界面的提醒
@property (nonatomic,assign) int decimalNumber;//当前的小数
@property (weak, nonatomic) IBOutlet UIView *inputQuoteView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputLayOut;//用于保证报猪价的button不会被键盘所遮盖


@end

@implementation CHCPGQuotePriceViewController

@dynamic iController;
static NSString * const HCPG_LocationDic = @"locationDic";
- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSDictionary *locDic= [[NSUserDefaults standardUserDefaults] objectForKey:HCPG_LocationDic];
  
  if (locDic == nil||[locDic[@"iCity"] isEqualToString:@""])
  {
    self.citySelectLabel.text=@"点击选择区域";

    [self getLocalAddress];
    }
  else
  {
    self.citySelectLabel.text=locDic[@"iCounty"];
  }
}
/**
 *  获得定位地址
 */
- (void)getLocalAddress
{
  [[LocationManager sharedLocationManager]gecodeLocationCompeletionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
    
    if (error)
    {
      HCLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
      self.citySelectLabel.text=@"点击选择区域";

    }
    if (location)
    {
          if (regeocode)
      {
      
        if (regeocode.township)
        {
          self.citySelectLabel.text=regeocode.township;
        }
        else
        {
          self.citySelectLabel.text=regeocode.district;
        }
      }
    }
  }];
}

- (IBAction)goMyPriceAction:(id)sender
{
  CHCPGMyQuotePriceViewController *myPriceView=[[CHCPGMyQuotePriceViewController alloc]init];
  [self.navigationController pushViewController:myPriceView animated:YES];
  myPriceView.hidesBottomBarWhenPushed=YES;
}

- (IBAction)goBackAction:(id)sender
{
self.alertView=[[CustomAlertView alloc]initWithTitle:@"提示" description:@"您确定放弃录入的数据？" desAlignment:NSTextAlignmentCenter cancelButton:@"取消" okButton:@"确定" cancelBlock:^{
  
} okBlock:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
} delegate:self];
  
   [self.alertView show];
}
- (void)customAlertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

  if (buttonIndex==1)
  {
     [self.navigationController popToRootViewControllerAnimated:YES];
  }
  
}
- (IBAction)submitPigPriceAction:(id)sender
{
  if (![self.citySelectLabel.text isEqualToString:@"点击选择区域"])
  {
  if (self.outSideThreeMember.text.length==0&&self.insideThreeMember.text.length==0&&self.nativeMixPig.text.length==0) {
    [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES withShowingText:@"请输入价格" withIconImageName:nil];
  }else{
    CHCPGQuotePriceVO *priceVO=[[CHCPGQuotePriceVO alloc]init];
    self.priceVO=priceVO;
    if (self.outSideThreeMember.text.length!=0) {
      self.decimalNumber=0;
      self.outSideThreeMember.delegate=self;
      self.priceVO.pigType=@(1);
      self.priceVO.price=@([self.outSideThreeMember.text floatValue]);
      [self traverseSelectRegionMyPrice];
      self.iQuoteTag=0;
      if (self.iSelectAddress.count==0) {
        [self traverseUidQuoteMyPrice];
      }
      [self.iController saveInfoStatisticWithQuotePriceVO:priceVO];
    }
    if (self.insideThreeMember.text.length!=0)
    {
         self.decimalNumber=0;
      priceVO.pigType=@(2);
      priceVO.price=@([self.insideThreeMember.text floatValue]);
      self.iQuoteTag=1;
      [self traverseSelectRegionMyPrice];
      if (self.iSelectAddress.count==0) {
        [self traverseUidQuoteMyPrice];
      }
      [self.iController saveInfoStatisticWithQuotePriceVO:priceVO];
    }
    if (self.nativeMixPig.text.length!=0) {
         self.decimalNumber=0;
      priceVO.pigType=@(3);
      priceVO.price=@([self.nativeMixPig.text floatValue]);
      self.iQuoteTag=2;
      [self traverseSelectRegionMyPrice];
      if (self.iSelectAddress.count==0) {
        [self traverseUidQuoteMyPrice];
      }
      [self.iController saveInfoStatisticWithQuotePriceVO:priceVO];
    }

    [self.view endEditing:YES];
        self.iGoldManager=[[CHCPGGoldManager alloc]init];
    [self.iGoldManager showGoldGifWithType:EHCGoldQuote compeletion:^(BOOL compeleted, NSString *aDesc) {
     
    }];
     [self.navigationController popViewControllerAnimated:YES];
    CHCPGUserDataSycnViewController *quoteSync= ((AppDelegate *)([UIApplication sharedApplication].delegate)).iUserDataSyncController;
    [quoteSync upLoadPriceDiaryCompletion:^(BOOL isSucceed, NSString *aDes) {
      
      if (isSucceed) {
        [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES withShowingText:@"报价成功" withIconImageName:nil];

      }else{
      [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES withShowingText:@"断网啦,请检查网络连接" withIconImageName:nil];
      }
    }];
  }
  }else
  {
  [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES withShowingText:@"请选择报价区域" withIconImageName:nil
   ];
  }
  /**
   *  将当前报猪价所填写的品种放到系统单例里面
   *
   *  @param self.iQuoteTag 选中的品种
   *
   *  @return
   */
  [[NSUserDefaults standardUserDefaults] setObject:@(self.iQuoteTag) forKey:@"kQuoteSelectItem"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)textFieldDidChanged:(UITextField *)textField
{
  if (self.outSideThreeMember.text.length > 8)
  {
    self.outSideThreeMember.text=[self.outSideThreeMember.text substringToIndex:8];
  }
  if (self.insideThreeMember.text.length > 8)
  {
    self.insideThreeMember.text = [self.insideThreeMember.text substringToIndex:8];
  }
  if (self.nativeMixPig.text.length>8)
  {
    self.nativeMixPig.text=[self.nativeMixPig.text substringToIndex:8];
  }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
  /**
   *  当手机的类型是iphone4的时候需要在输入猪价的时候将这个view向上移动
   */
  if (MAIN_Screen.height==480)
  {
    [UIView animateWithDuration:10.0 delay:0.2 options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
      self.inputLayOut.constant=141-70;
    } completion:^(BOOL finished) {
      
    }];
  }

  
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
  /**
   *  结束编辑的时候将当前view放到原位
   */
  [UIView animateWithDuration:10 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
    self.inputLayOut.constant=141;
  } completion:^(BOOL finished) {
    
  }];


}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}
- (void)traverseUidQuoteMyPrice
{
   NSDictionary *locDic= [[NSUserDefaults standardUserDefaults] objectForKey:HCPG_LocationDic];
  self.priceVO.province=locDic[@"iProvice"];
  self.priceVO.city=locDic[@"iCity"];
  self.priceVO.county=locDic[@"iCounty"];
  self.priceVO.township=locDic[@"iTownship"];

}
- (void)traverseSelectRegionMyPrice
{
  self.priceVO.mobile=[CHCCommonInfoVO sharedManager].mobile;
  self.priceVO.province=self.iSelectAddress[0];
  self.priceVO.city=self.iSelectAddress[1];
  self.priceVO.county=self.iSelectAddress[2];
  
  if (self.iSelectAddress.count==3)
  {
    self.priceVO.township=@"";
  }
  else{
    self.priceVO.township=self.iSelectAddress[3];
  }
  
}
- (IBAction)selectCityAction:(id)sender
{
  CHCPGCHooseAddressViewController *iHooseVC=[[CHCPGCHooseAddressViewController alloc]
                                              initWithAddressBlock:^(NSMutableArray *addressAry) {
    self.iSelectAddress=addressAry;
    self.citySelectLabel.text=addressAry[addressAry.count-1];
    
  }];
  [self.navigationController presentViewController:iHooseVC animated:YES completion:nil];
}

/**
 *  用于限制所输入字符的数据类型保证只能是数字和小数点,并且小数点只有一个
 *
 *  @param textField 当前的textField
 *  @param range     要改变的范围
 *  @param string    输入的字符
 *
 *  @return <#return value description#>
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
  BOOL rtn = YES;
  if ([string isEqualToString:@""]) {
    return YES;
  }
  rtn = [CHCInputValidUtil checkNormalString:string];
  if ([string isEqualToString:@"."]) {
    rtn = YES;
  }
  if ([futureString containsString:@"."])
  {
    if ([string containsString:@"."])
    {
      rtn = NO;
    }
    else
    {
      NSRange indexRange = [futureString rangeOfString:@"."];
      if (futureString.length - indexRange.location == 3)
      {
        rtn = NO;
      }
    }
  }
  else
  {
    if (!futureString.length && [string isEqualToString:@"."])
    {
      rtn = NO;
    }
  }
  return rtn;
}
@end


@interface CHCPGQuotePriceController()

@property (nonatomic,strong) CHCSqliteManager *iManager;
@property (nonatomic,strong) CHCPGQuotePriceVO *priceVO;
@property (nonatomic,weak) CHCPGQuotePriceViewController *iViewController;
@end

@implementation CHCPGQuotePriceController
@dynamic iViewController;

- (void)saveInfoStatisticWithQuotePriceVO:(CHCPGQuotePriceVO *)priceVO{
  
  NSString *path=[CHCPGUserDataSycnController createUserPath];
  NSString *tablePath=[NSString stringWithFormat:@"%@/%@",path,@"database.db"];
  self.iManager = [[CHCSqliteManager alloc]initWithDataBasePath:tablePath];
  [self.iManager openDB];
  [self.iManager beginTransaction];
  NSMutableString *insertSql=[NSMutableString string];
  [insertSql appendFormat:@"insert into %@",HCPG_PriceDiary];
  [insertSql appendFormat:@" ("];
  NSMutableString *keys = [NSMutableString stringWithString:@""];
  NSMutableString *values = [NSMutableString stringWithString:@""];
  NSMutableDictionary * dict =[NSMutableDictionary dictionaryWithDictionary:[priceVO fillVoDictionary]];
  double createTimeAt=[DateFomatterTool getCurrentTimeStamp];
  NSNumber *createAt= [NSNumber numberWithDouble:createTimeAt] ;
  NSDictionary *dictTime=@{@"createAt":createAt};
  [dict addEntriesFromDictionary:dictTime];
  [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    [keys appendFormat:@"\"%@\" ,",key];
    [values appendFormat:@"\"%@\" ,",obj];
  }];
  [keys deleteCharactersInRange:NSMakeRange(keys.length-1, 1)];
  [values deleteCharactersInRange:NSMakeRange(values.length-1, 1)];
  [insertSql appendString:keys];
  [insertSql appendString:@")"];
  [insertSql appendString:@"values ("];
  [insertSql appendString:values];
  [insertSql appendString:@")"];
  [self.iManager executeNotQuery:insertSql];
  [self.iManager commitTransaction];
  [self.iManager closeDB];
  
}

@end


@implementation CHCPGQuotePriceVO


@end



