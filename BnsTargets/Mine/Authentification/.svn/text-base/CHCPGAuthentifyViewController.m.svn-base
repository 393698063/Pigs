//
//  CHCPGAuthentifyViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/28.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGAuthentifyViewController.h"
#import "BnsMineDef.h"
#import "NSString+frame.h"
#import "CHCPGFarmInfoViewController.h"

@interface CHCPGAuthentifyViewController ()

@property (weak, nonatomic) IBOutlet UIView *iSaleManView;
@property (weak, nonatomic) IBOutlet UIView *iProfessorView;
@property (weak, nonatomic) IBOutlet UILabel *iSaleManNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iSaleManLabelWithConstraint;
@property (weak, nonatomic) IBOutlet UILabel *iSaleManJobLabel;
@property (weak, nonatomic) IBOutlet UILabel *iProfessorNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iProfessorNameLabelWithConstraint;
@property (weak, nonatomic) IBOutlet UILabel *iProfessorJobLabel;
@property (nonatomic, strong) CHCPGAuthentifyController * iController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iButtonTopConstraint;
@property (nonatomic, strong) UIWebView * iCallView;
@property (nonatomic, strong) CHCPGAuthentifyVO * iAuthentifyVo;
@end

@implementation CHCPGAuthentifyViewController
@dynamic iController;
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = @"认证";
}
- (instancetype)initWithAuthentify:(CHCPGAuthentifyVO *)iAuthentifyVo
{
  if (self = [super init])
  {
    self.iAuthentifyVo = iAuthentifyVo;
  }
  return self;
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [self freshView];
}

- (void)freshView
{
  CHCCommonInfoVO * userInfo = [CHCCommonInfoVO sharedManager];
  __weak typeof(self)wSelf = self;
  [self.iController getSupportWithUid:userInfo.iHCid completion:^(BOOL isSucceed, NSString *aDes)
   {
     if (isSucceed) {
       [wSelf setTheViewData];
     }
     else
     {
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:aDes
                                                   withIconImageName:nil];
     }
   }];
}
- (void)setTheViewData
{
  NSCharacterSet * characterSet = [NSCharacterSet characterSetWithCharactersInString:@"-_"];
  NSArray * saleNames = [self.iController.iSalemanVo.name componentsSeparatedByCharactersInSet:characterSet];
  if (saleNames.count == 1)
  {
    NSString * name = [saleNames lastObject];
    self.iSaleManNameLabel.text = name;
  }
  else if (saleNames.count == 2)
  {
    NSString * name = [saleNames lastObject];
    self.iSaleManLabelWithConstraint.constant = [name widthWithFont:self.iSaleManNameLabel.font];
    self.iSaleManNameLabel.text = name;
    self.iSaleManJobLabel.text = [saleNames firstObject];
  }
  
  if ([self.iController.iExpertVo.name isEqualToString:@""]) {
    self.iProfessorView.hidden = YES;
    self.iButtonTopConstraint.constant -= 101;
  }
  else
  {
    NSCharacterSet * eCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"-_"];
    NSArray * expertNames = [self.iController.iExpertVo.name componentsSeparatedByCharactersInSet:eCharacterSet];
    if (expertNames.count == 1) {
      NSString * name = [expertNames lastObject];
      self.iProfessorNameLabelWithConstraint.constant = [name widthWithFont:self.iProfessorNameLabel.font];
      self.iProfessorNameLabel.text = name;
    }
    else if (expertNames.count == 2)
    {
      NSString * name = [expertNames lastObject];
      self.iProfessorNameLabelWithConstraint.constant = [name widthWithFont:self.iProfessorNameLabel.font];
      self.iProfessorNameLabel.text = name;
      
      self.iProfessorJobLabel.text = [expertNames firstObject];
    }
  }
  
}
- (IBAction)callSaleMan:(id)sender
{
  NSURL * phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.iController.iSalemanVo.telphone]];
  if (!self.iCallView) {
    self.iCallView = [[UIWebView alloc] initWithFrame:CGRectZero];
  }
  [self.iCallView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
}

- (IBAction)callProfessor:(id)sender
{
  NSURL * phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.iController.iExpertVo.telphone]];
  if (!self.iCallView) {
    self.iCallView = [[UIWebView alloc] initWithFrame:CGRectZero];
  }
  [self.iCallView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
}
- (IBAction)reAuthentify:(id)sender
{
  CHCPGFarmInfoViewController * fvc = [[CHCPGFarmInfoViewController alloc] initWithAuthentify:self.iAuthentifyVo];
  [self.navigationController pushViewController:fvc animated:YES];
}

- (IBAction)leftButtonAction:(id)sender
{
  [[NSNotificationCenter defaultCenter] postNotificationName:HCPG_ExpertNeedFreshAuthentityInfo
                                                      object:nil];
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

@implementation CHCPGAuthentifyController

- (void)getSupportWithUid:(NSNumber *)uid
               completion:(void (^)(BOOL, NSString *))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_MineGetSupport];
  NSDictionary * param = @{@"uid":uid};
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
       [wSelf constructData:aData[@"support"]];
       if (aCompletion) {
         aCompletion(YES,nil);
       }
     }
   }];
}
- (void)constructData:(NSDictionary *)dict
{
  self.iExpertVo = [[CHCPGSpportVo alloc] initWithDic:dict[@"expert"]];
  self.iSalemanVo = [[CHCPGSpportVo alloc] initWithDic:dict[@"salesman"]];
}
@end

@implementation CHCPGSpportVo


@end
