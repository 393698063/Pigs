//
//  CHCPGProfessorHomeViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGProfessorHomeViewController.h"
#import "CHCPGProfessorHeaderView.h"
#import "CHCPGWebViewController.h"
#import "CHCPGProfessorAnswerListCell.h"
#import "CHCPGAuthentifyImmediateViewController.h"
#import "CHCPGGoldManager.h"


@interface CHCPGProfessorHomeController()
@property (nonatomic, strong) CHCPGAuthentifyVO *iAuthentifyVo;

- (void)reqQuestionlistWithPage:(NSNumber *)aPageCount
                           size:(NSNumber *)aPageSize
                     completion:(void (^)(BOOL succeed, NSString *aDesc, NSArray *aDataAry))aCompletion;

- (void)getAuthentifyWithUid:(NSNumber *)uid
                  completion:(void (^)(BOOL, NSString *))aCompletion;

@end


@interface CHCPGProfessorHomeViewController ()<MHCPGProfessorHeaderDelegate>
@property (strong, nonatomic) IBOutlet UILabel *iGoldLabel;
@property (nonatomic, strong) CHCPGProfessorHomeController *iController;
@property (nonatomic, strong) CHCPGProfessorHeaderView *iHeaderView;
@property (nonatomic, assign) BOOL iIsNeedFreshAuthentifyInfo;
@end

@implementation CHCPGProfessorHomeViewController
@dynamic iController;

-(void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  [self makeNeedFresh:YES];
  self.iTitleStr = @"";
}

-(void)viewDidLoad
{
  [super viewDidLoad];
  self.iHeaderView = [CHCPGProfessorHeaderView viewFromXib];
  self.iHeaderView.iDelegate = self;
  
  UIView *aView = [[UIView alloc]initWithFrame:self.iHeaderView.frame];
  [aView addSubview:self.iHeaderView];
  self.iFreshTableView.tableHeaderView = aView;
  
  self.iFreshTableView.estimatedRowHeight = 100.0f;
  self.iFreshTableView.rowHeight = UITableViewAutomaticDimension;
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(login:)
                                               name:HC_PG_Login_login
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(logout:)
                                               name:HC_PG_Login_logout
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(needFreshAuthentifyInfo)
                                               name:HCPG_ExpertNeedFreshAuthentityInfo
                                             object:nil];
}

- (BOOL)isNeedBaseViewTapAction
{
  return NO;
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self readUserGoldData];
  
  if (self.iIsNeedFreshAuthentifyInfo)
  {
    [self.iHeaderView loadSaleData:nil
                        expertData:nil];
    self.iIsNeedFreshAuthentifyInfo = NO;
    [self freshView];
  }
}

- (void)readUserGoldData
{
  if (![CHCCommonInfoVO sharedManager].isLogin)
  {
    self.iGoldLabel.text=@"未登录";
  }
  else
  {
    self.iGoldLabel.text=[NSString stringWithFormat:@"%ld",
                          (long)[[CHCPGGoldManager sharedCHCPGGoldManager] readUserGoldCount]];
  }
}

- (void)login:(NSNotification *)aNotice
{
  self.iIsNeedFreshAuthentifyInfo = YES;
  [self needFreshWhildDidAppear];
}

- (void)logout:(NSNotification *)aNotice
{
  self.iController.iSalemanVo = nil;
  self.iController.iExpertVo = nil;
}

- (void)needFreshAuthentifyInfo
{
  self.iIsNeedFreshAuthentifyInfo = YES;
}

- (BOOL)isNeedNoNetworkView
{
  return YES;
}

- (void)didSelectProblemCategory:(CHCPGProblemCategoryVO *)aCategoryVO
{
  NSString *url = [NSString stringWithFormat:@"jsp/symptomList.jsp?symptomType=%d",aCategoryVO.iCategory];
  CHCPGWebViewController *aWebView=[[CHCPGWebViewController alloc]initWithUrlStr:url
                                                                     imageUrlStr:nil
                                                                        titleStr:aCategoryVO.iTitle?:@""
                                                                    infomationId:nil
                                                                         webType:EHCWebExpert];
  [aWebView setHidesBottomBarWhenPushed:YES];
  [self.navigationController pushViewController:aWebView animated:YES];
}

- (void)needReloadViewData
{
  [self freshView];
}

- (void)enterToIdentifyView
{
  CHCCommonInfoVO * userInfo = [CHCCommonInfoVO sharedManager];
  [self.iController getAuthentifyWithUid:userInfo.iHCid
                              completion:
   ^(BOOL isSucceed, NSString *aDes)
   {
     if (!isSucceed)
     {
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:aDes
                                                   withIconImageName:nil];
     }
   }];
}

- (NSNumber *)defaultPageSize
{
  return @(10);
}

- (NSNumber *)defaultStartPage
{
  return @(1);
}

- (void)tableView:(UITableView *)tableView
         loadPage:(NSInteger)aPageNO
         pageSize:(NSInteger)aPageSize
          isFresh:(BOOL)aIsFresh
       completion:(THC_FreshTable_CompletionBlock)aCompletionBlock;
{
  [self.iController reqQuestionlistWithPage:@(aPageNO)
                                       size:@(aPageSize)
                                 completion:
   ^(BOOL succeed, NSString *aDesc, NSArray *aDataAry)
  {
    if (aCompletionBlock)
    {
      aCompletionBlock(succeed,aDesc,aDataAry,nil);
    }
  }];
}

-     (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
  return 0.1f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CHCPGProblemListVO *aObj = (CHCPGProblemListVO *)[self objectAtIndexPath:indexPath];
  
  static NSString *const reuseID = @"CHCPGProfessorAnswerListCell";
  CHCPGProfessorAnswerListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
  if (!cell)
  {
    cell = [[[NSBundle mainBundle]loadNibNamed:@"CHCPGProfessorAnswerListCell"
                                         owner:nil
                                       options:nil]lastObject];
  }
  
  [cell loadDataVO:aObj];
  
  return cell;
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  CHCPGProblemListVO *aVO = (CHCPGProblemListVO *)[self objectAtIndexPath:indexPath];
  CHCPGWebViewController *aWebView = [[CHCPGWebViewController alloc]initWithUrlStr:@""
                                                                       imageUrlStr:nil
                                                                          titleStr:@"问题详情"
                                                                      infomationId:aVO.questionId
                                                                           webType:EHCWebAnswerDetail];
  [aWebView setHidesBottomBarWhenPushed:YES];
  [self.navigationController pushViewController:aWebView animated:YES];
}

- (void)setTheViewData
{
  [self.iHeaderView loadSaleData:self.iController.iSalemanVo
                      expertData:self.iController.iExpertVo];
  self.iFreshTableView.tableHeaderView = self.iHeaderView;
}

- (void)didReceiveMemoryWarning
{
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

@implementation CHCPGProfessorHomeController

- (void)getAuthentifyWithUid:(NSNumber *)uid completion:(void (^)(BOOL, NSString *))aCompletion
{
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_ExpertAuthentify];
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
       self.iAuthentifyVo = [[CHCPGAuthentifyVO alloc] initWithDic:[aData valueForKeyPath:@"data"]];
       UIViewController * avc = nil;
       //bisName&bisPhone都为空时 到马上认证
       if ([[aData valueForKeyPath:@"data.bisName" ] isEqualToString:@""]
           && [[aData valueForKeyPath:@"data.bisPhone"] isEqualToString:@""])
       {
         avc = [[CHCPGAuthentifyImmediateViewController alloc] initWithAuthentify:self.iAuthentifyVo];
       }
       else
       {
         avc = [[CHCPGAuthentifyViewController alloc] initWithAuthentify:self.iAuthentifyVo];
       }
       avc.hidesBottomBarWhenPushed = YES;
       [self.iViewController.navigationController pushViewController:avc animated:YES];
       if (aCompletion) {
         aCompletion(YES,nil);
       }
     }
   }];
}

- (void)reqQuestionlistWithPage:(NSNumber *)aPageCount
                           size:(NSNumber *)aPageSize
                     completion:(void (^)(BOOL succeed, NSString *aDesc, NSArray *aDataAry))aCompletion
{
  NSString *path = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_ExpertQuestionList];
  [self.iModelHandler postMethod:path
                      parameters:@{@"page":aPageCount?:@"",
                                   @"pageSize":aPageSize?:@"",
                                   @"channelSource":@(3)}
                      completion:
   ^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
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
        aCompletion(NO,[aError domain],nil);
      }
    }
    else
    {
      NSArray *dataAry = [self constructQuestionList:aData[@"data"]];
      if (aCompletion)
      {
        aCompletion(YES,nil,dataAry);
      }
    }
  }];
}

- (NSArray *)constructQuestionList:(NSArray *)aResArray
{
  NSMutableArray *rtnAry = [NSMutableArray arrayWithCapacity:1];
  
  if ([aResArray count] > 0)
  {
    [aResArray enumerateObjectsUsingBlock:
     ^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
      NSDictionary *aDic = obj;
      CHCPGProblemListVO *aVO = [[CHCPGProblemListVO alloc]initWithDic:aDic];
      [rtnAry addObject:aVO];
    }];
  }
  
  return rtnAry;
}

@end

@implementation CHCPGProblemListVO
@end
