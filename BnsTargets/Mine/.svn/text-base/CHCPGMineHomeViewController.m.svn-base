//
//  CHCPGMineHomeViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define kScreenSize [UIScreen mainScreen].bounds.size

#import "CHCPGMineHomeViewController.h"
#import "CHCPGMineHomeBaseCell.h"
#import "BnsMineDef.h"
#import "CHCCommonInfoVO.h"
#import "CHCPGMineSelfInfoViewController.h"
#import "CHCPGMineSettingViewController.h"
#import "CHCPGAuthentifyImmediateViewController.h"
#import "CHCPGAuthentifyViewController.h"
#import "CHCPGMineSuggestViewController.h"
#import "UIView+frame.h"
#import "UIColor+Hex.h"
#import "CHCPGMineGetCoinViewController.h"
#import "CHCPGGoldManager.h"
#import "CHCPGMineHomeFactory.h"
@interface CHCPGMineHomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *iTableView;
@property (nonatomic, strong) CHCPGMineHomeController * iController;

@end

@implementation CHCPGMineHomeViewController
@dynamic iController;
- (BOOL)isNeedBaseViewTapAction
{
  return NO;
}
- (BOOL)isNeedRightGestureRecognizer
{
  return YES;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAction:) name:HC_PG_Login_login object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goldChange:) name:HCPG_GoldChangeNotice object:nil];
  [self.iController getViewData];
//  [self.iController getMyCouponsInfoWithUid:[CHCCommonInfoVO sharedManager].iHCid
//                                 completion:^(BOOL isSucceed, NSString *aDes)
//   {
//     if (isSucceed) {
//       [self.iTableView reloadData];
//     }
//     else
//     {
//       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
//                                                     withShowingText:aDes withIconImageName:nil];
//     }
//   }];
  
}
- (void)loginAction:(NSNotification *)aNotice
{
  [self.iTableView reloadData];
}
- (void)goldChange:(NSNotification *)aNotice
{
  [self.iTableView reloadData];
}
- (void)dealloc
{
  
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.iController.iDataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSArray * ary = [self.iController.iDataArray objectAtIndex:section];
  
  return ary.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSArray * dataAry = [self.iController.iDataArray objectAtIndex:indexPath.section];
  NSDictionary * dict = [dataAry objectAtIndex:indexPath.row];
  CHCPGMineHomeBaseCell * cell = [CHCPGMineHomeFactory cellFactofyWithTableView:tableView
                                                                           data:dict];
  __weak typeof(self)wSelf = self;
  [cell loadData:dict actionBlock:^(EHCCellTapType type)
  {
    switch (type) {
      case EHCCellTapAuthentify:
      {
        [wSelf Authentification];
        break;
      }
      case EHCCellTapSuggest:
      {
        [wSelf suggest];
        break;
      }
      case EHCCellTapShare:
      {
        [wSelf share];
        break;
      }
      case EHCCellTapGetCoin:
      {
        [wSelf getCoin];
        break;
      }
      default:
        break;
    }
  }];
  return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSArray * ary = [self.iController.iDataArray objectAtIndex:indexPath.section];
  NSDictionary * dict = [ary objectAtIndex:indexPath.row];
  EHCMineHomeCellType type = [[dict objectForKey:@"identify"] integerValue];
  return [CHCPGMineHomeBaseCell cellHeightWithType:type];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  __weak typeof(self)wSelf = self;
  if (indexPath.section == 0) {
    CHCPGMineSelfInfoViewController * infoVc = [[CHCPGMineSelfInfoViewController alloc] initWithChangeBlock:^(BOOL isChanged)
    {
      NSIndexSet * set = [NSIndexSet indexSetWithIndex:indexPath.section];
      [wSelf.iTableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    }];
    infoVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoVc animated:YES];
  }
}
#pragma mark - cell action
- (void)getCoin
{
  CHCPGMineGetCoinViewController * gvc = [[CHCPGMineGetCoinViewController alloc] init];
  gvc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:gvc animated:YES];
}
- (void)myWallet
{
  [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                withShowingText:@"1" withIconImageName:nil];
}
- (void)collection
{
  [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                withShowingText:@"2" withIconImageName:nil];
}
- (void)Authentification
{
  CHCCommonInfoVO * userInfo = [CHCCommonInfoVO sharedManager];
  [self.iController getAuthentifyWithUid:userInfo.iHCid completion:^(BOOL isSucceed, NSString *aDes)
   {
     if (!isSucceed) {
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:aDes
                                                   withIconImageName:nil];
     }
  }];
}
- (void)suggest
{
  CHCPGMineSuggestViewController * svc = [[CHCPGMineSuggestViewController alloc] init];
  svc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:svc animated:YES];
}
- (void)share
{
  [self presentShareView];
}
- (void)presentShareView
{
  UIView * shareView = [[UIView alloc] initWithFrame:CGRectZero];
  shareView.size = kScreenSize;
  shareView.tag = 10001;
  shareView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:255*0.3/255.0];
  
  UIImageView * barcodeImageView = [[UIImageView alloc] init];
  NSString * path = [[NSBundle mainBundle] pathForResource:@"erweima_img@2x" ofType:@"png"];
  UIImage * barcodeImage = [UIImage imageWithContentsOfFile:path];
  barcodeImageView.size = barcodeImage.size;
  barcodeImageView.image = barcodeImage;
  barcodeImageView.center = shareView.center;
  
  [shareView addSubview:barcodeImageView];
  
  [self.tabBarController.view addSubview:shareView];
  
  UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelBtn.origin = CGPointMake(0, 0);
  cancelBtn.size = shareView.size;
  [cancelBtn addTarget:self action:@selector(cancelShareView:) forControlEvents:UIControlEventTouchUpInside];
  [shareView addSubview:cancelBtn];
}
- (void)cancelShareView:(UIButton *)button
{
  UIView * shareView = [self.tabBarController.view viewWithTag:10001];
  [shareView removeFromSuperview];
  shareView = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)iSetButtonAction:(id)sender
{
  CHCPGMineSettingViewController * svc = [[CHCPGMineSettingViewController alloc] init];
  svc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:svc animated:YES];
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

@interface CHCPGMineHomeController ()
@property (nonatomic, weak) CHCPGMineHomeViewController * iViewController;
@end
@implementation CHCPGMineHomeController
@dynamic iViewController;

- (instancetype)init
{
  if (self = [super init]) {
    self.iDataArray = [NSMutableArray arrayWithCapacity:1];
  }
  return self;
}
- (void)getViewData
{
  NSArray * dataAry = @[@[
                          @{
                            @"data":@[],
                            @"identify":@(EHCMineHomeCellInfo)}
                          ],
                        @[
                          @{@"data":@[
                                @{@"image":@"wode_icon02",@"title":@"认证",@"tapType":@(EHCCellTapAuthentify)},
                                @{@"image":@"wode_icon03",@"title":@"意见/建议",@"tapType":@(EHCCellTapSuggest)},
                                @{@"image":@"wode_icon04",@"title":@"推荐给朋友",@"tapType":@(EHCCellTapShare)},
                                @{@"image":@"wode_icon05",@"title":@"如何赚金币",@"tapType":@(EHCCellTapGetCoin)}
                                ],
                            @"identify":@(EHCMineHomeCellList)}
                          ]
                        ];
  [self.iDataArray addObjectsFromArray:dataAry];
}
- (void)getMyCouponsInfoWithUid:(NSNumber *)uid
                     completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_MineGetCoupons];
  NSDictionary * param = @{@"uid":uid};
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
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
- (void)getMyMoneyInfoWithUid:(NSNumber *)uid
                   completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_MineGetMoney];
  NSDictionary * param = @{@"uid":uid};
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
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}

- (void)getAuthentifyWithUid:(NSNumber *)uid completion:(void (^)(BOOL, NSString *))aCompletion
{
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_MineGetAuthentify];
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
@end

@implementation CHCPGAuthentifyVO


@end
