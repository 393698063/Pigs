//
//  CHCPGProfessorHeaderView.m
//  Pigs
//
//  Created by Lemon-HEcom on 16/7/22.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGProfessorHeaderView.h"
#import "CHCPGAuthentifyViewController.h"

typedef enum
{
  EHCPGSupportTypeExpert = 0,
  EHCPGSupportTypeSale
}EHCPGSupportType;

@interface CHCPGProfessorHeaderView()
@property (nonatomic, weak) CHCPGSpportVo * iSalemanVo;
@property (nonatomic, weak) CHCPGSpportVo * iExpertVo;

@property (nonatomic, strong) UIWebView *iCallView;

@property (strong, nonatomic) IBOutlet UIImageView *iSaleIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *iSaleNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *iSaleCorpLabel;

@property (strong, nonatomic) IBOutlet UIImageView *iExpertIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *iExpertNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *iExpertCorpLabel;

@property (strong, nonatomic) IBOutlet UIImageView *iSaleOnlyIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *iSaleOnlyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *iSaleOnlyCorpLabel;

@property (strong, nonatomic) IBOutlet UILabel *iNoneInfoLabel;
@property (strong, nonatomic) IBOutlet UIButton *iNoneInfoBtn;

@property (strong, nonatomic) IBOutlet UIView *iSAEBaseView;
@property (strong, nonatomic) IBOutlet UIView *iIdentifyView;
@property (strong, nonatomic) IBOutlet UIView *iSaleExpertView;
@property (strong, nonatomic) IBOutlet UIView *iSaleView;

- (IBAction)iPhoneBtnAction:(UIButton *)sender;
- (IBAction)iProblemCategoryBtnAction:(UIButton *)sender;
- (IBAction)iIdentifyBtnAction:(UIButton *)sender;

@end

@implementation CHCPGProfessorHeaderView

+ (instancetype)viewFromXib
{
  CHCPGProfessorHeaderView *rtnView = nil;
  NSString* viewName = NSStringFromClass([self class]);
  NSArray *views = [[NSBundle mainBundle] loadNibNamed:viewName owner:nil options:nil];
  Class   targetClass = NSClassFromString(viewName);
  for (UIView *view in views)
  {
    if ([view isMemberOfClass:targetClass])
    {
      rtnView = (CHCPGProfessorHeaderView *)view;
      [rtnView dealWithUnits];
      break;
    }
  }
  
  [rtnView loadSaleData:nil expertData:nil];
  
  return rtnView;
}

- (IBAction)iPhoneBtnAction:(UIButton *)sender
{
  switch (sender.tag)
  {
    case 10301:
    case 10001:
    {
      NSString *phone = [NSString stringWithFormat:@"tel:%@",self.iSalemanVo.telphone];
      NSURL * phoneUrl = [NSURL URLWithString:phone];
      if (!self.iCallView)
      {
        self.iCallView = [[UIWebView alloc] initWithFrame:CGRectZero];
      }
      [self.iCallView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
      break;
    }
    case 10002:
    {
      NSString *phone = [NSString stringWithFormat:@"tel:%@",self.iExpertVo.telphone];
      NSURL * phoneUrl = [NSURL URLWithString:phone];
      if (!self.iCallView)
      {
        self.iCallView = [[UIWebView alloc] initWithFrame:CGRectZero];
      }
      [self.iCallView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
      break;
    }
    default:
      break;
  }
}

- (IBAction)iProblemCategoryBtnAction:(UIButton *)sender
{
  if ( self.iDelegate
      && [self.iDelegate respondsToSelector:@selector(didSelectProblemCategory:)] )
  {
    CHCPGProblemCategoryVO *aVO = [[CHCPGProblemCategoryVO alloc]init];
    aVO.iCategory = (EHCProblemCategory)(sender.tag-10100);
    
    UILabel *titleLabel = [self viewWithTag:sender.tag+100];
    aVO.iTitle = titleLabel.text;
    
    [self.iDelegate didSelectProblemCategory:aVO];
  }
}

- (IBAction)iIdentifyBtnAction:(UIButton *)sender
{
  if ([self isNeedReload])
  {
    if (self.iDelegate
        && [self.iDelegate respondsToSelector:@selector(needReloadViewData)])
    {
      [self.iDelegate needReloadViewData];
    }
  }
  else
  {
    if (self.iDelegate
        && [self.iDelegate respondsToSelector:@selector(enterToIdentifyView)])
    {
      [self.iDelegate enterToIdentifyView];
    }
  }
}

- (void)dealWithUnits
{
  [self makeBtnCorner:self.iNoneInfoBtn];
}

- (void)dealShowUnits
{
  CGSize screenSize = [UIScreen mainScreen].bounds.size;
  
  NSInteger type = [self viewType];;
  switch (type)
  {
    case 0:
    case 1:
    {
      [self.iSAEBaseView bringSubviewToFront:self.iIdentifyView];
      
      [self.iIdentifyView setHidden:NO];
      [self.iSaleView setHidden:YES];
      [self.iSaleExpertView setHidden:YES];
      
      [self setFrame:CGRectMake(0, 0, screenSize.width, HCPG_ProfessorDefaultHeight)];
      break;
    }
      
    case 2:
    {
      [self.iSAEBaseView bringSubviewToFront:self.iSaleView];
      
      [self.iIdentifyView setHidden:YES];
      [self.iSaleView setHidden:NO];
      [self.iSaleExpertView setHidden:YES];
      
      [self setFrame:CGRectMake(0, 0, screenSize.width, HCPG_ProfessorSaleOnlyHeight)];
      break;
    }
      
    case 3:
    default:
    {
      [self.iSAEBaseView bringSubviewToFront:self.iSaleExpertView];
      
      [self.iIdentifyView setHidden:YES];
      [self.iSaleView setHidden:YES];
      [self.iSaleExpertView setHidden:NO];
      
      [self setFrame:CGRectMake(0, 0, screenSize.width, HCPG_ProfessorDefaultHeight)];
      break;
    }
  }
  
}

- (NSInteger)viewType
{
  //!sale & !expert : type == 0;
  //!sale &  expert : type == 1;
  // sale & !expert : type == 2;
  // sale &  expert : type == 3;
  NSInteger type = ( [self haveSupport:EHCPGSupportTypeExpert]? (1<<0):0 )
                 | ( [self haveSupport:EHCPGSupportTypeSale]? (1<<1):0 );
  return type;
}

- (BOOL)haveSupport:(EHCPGSupportType)aType
{
  BOOL rtnValue = NO;
  
  switch (aType)
  {
    case EHCPGSupportTypeSale:
    {
      if (self.iSalemanVo.telphone.length > 0)
      {
        rtnValue = YES;
      }
      break;
    }
      
    case EHCPGSupportTypeExpert:
    {
      if (self.iExpertVo.telphone.length > 0)
      {
        rtnValue = YES;
      }
      break;
    }
      
    default:
      break;
  }
  
  return rtnValue;
}

- (void)makeBtnCorner:(UIButton *)aBtn
{
  [aBtn.layer setCornerRadius:3.0f]; //设置矩形四个圆角半径
  [aBtn.layer setBorderWidth:1.0]; //边框宽度
  
  UIColor *aColor = [aBtn titleColorForState:UIControlStateNormal];
  [aBtn.layer setBorderColor:aColor.CGColor];
}

- (void)loadSaleData:(CHCPGSpportVo *)aSalemanVo
          expertData:(CHCPGSpportVo *)aExpertVo
{
  self.iSalemanVo = aSalemanVo;
  self.iExpertVo = aExpertVo;
  
  NSCharacterSet * aCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"-_"];
  self.iSaleNameLabel.text = [[aSalemanVo.name componentsSeparatedByCharactersInSet:aCharacterSet] lastObject]?:@"";
  self.iSaleCorpLabel.text = @"";//@"新希望六和股份有限公司";
  self.iSaleOnlyNameLabel.text = [[aSalemanVo.name componentsSeparatedByCharactersInSet:aCharacterSet] lastObject]?:@"";
  self.iSaleOnlyCorpLabel.text = @"";//@"新希望六和股份有限公司";
  
  self.iExpertNameLabel.text = [[aExpertVo.name componentsSeparatedByCharactersInSet:aCharacterSet] lastObject]?:@"";
  self.iExpertCorpLabel.text = @"";//@"新希望六和股份有限公司";
  
  if ([self isNeedReload])
  {
    [self putReloadInfo];
  }
  else
  {
    [self putIdentifyInfo];
  }
  
  [self dealShowUnits];
}

- (void)putReloadInfo
{
  [self.iNoneInfoBtn setTitle:@"重试" forState:UIControlStateNormal];
  self.iNoneInfoLabel.text = @"加载失败...";
}

- (void)putIdentifyInfo
{
  [self.iNoneInfoBtn setTitle:@"马上认证" forState:UIControlStateNormal];
  self.iNoneInfoLabel.text = @"您尚未成功认证业务员手机号码，\n认证后会有相应的业务员和服务专家为您服务。";
}

- (BOOL)isNeedReload
{
  BOOL rtnValue = (!self.iSalemanVo);
  return rtnValue;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation CHCPGProblemCategoryVO
@end
