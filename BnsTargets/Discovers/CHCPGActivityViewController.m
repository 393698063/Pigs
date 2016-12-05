//
//  CHCPGActivityViewController.m
//  Pigs
//
//  Created by wangbin on 16/6/7.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGActivityViewController.h"
#import "BnsTargetDiscoverDef.h"
#import "CHCPGActivityCell.h"
#import "MJRefresh.h"
#import "CHCPGWebViewController.h"
#import "UIColor+Hex.h"
@interface CHCPGActivityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *iTableView;
@property (nonatomic,strong) CHCPGActivityController *iController;
@property (nonatomic,assign) int page;
@end

@implementation CHCPGActivityViewController
@dynamic iController;

static  NSString * const  noNetWorkToast= @"断网啦，请检查网络连接";
- (void)viewDidLoad {
    [super viewDidLoad];
  self.iNavBar.topItem.title = @"热门活动";
  self.iTableView.dataSource = self;
  self.iTableView.delegate = self;
  self.iTableView.estimatedRowHeight = 209;
  self.iController.footerRefreshEnd = NO;
  self.iTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  UIView *iTableViewLine=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 1)];
  iTableViewLine.backgroundColor=[UIColor colorWithHex:0xffd7dae3];
  self.iTableView.tableFooterView=iTableViewLine;

  self.page=0;
  self.iTableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [self headerRefresh];
  }];
  self.iTableView.footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    [self loadMoreData];
  }];

  [self.iTableView registerNib:[UINib nibWithNibName:@"CHCPGActivityCell"
                                              bundle:nil]
        forCellReuseIdentifier:@"cell"];
  [self.iController getDiscoverActivityWithPage:@(0)
                                         andTag:@(1)
                                     completion:^(BOOL isSucceed,
                                                  NSString *aDes) {
                               
                                       if (isSucceed)
                                       {
                                         [self.iTableView reloadData];
                                         [self hideNoNetWorkView];
                                       }else
                                       {
                                         [self showNoNetWorkView];
                                         [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                            withShowingText:noNetWorkToast
                                          withIconImageName:nil];
                                       }
                                
                                     }];
}
- (void)headerRefresh
{

  self.page=0;
[self.iController getDiscoverActivityWithPage:@(0)
                                       andTag:@(1)
                                   completion:^(BOOL isSucceed,
                                                NSString *aDes) {
  [self.iTableView.header endRefreshing];
  if (isSucceed) {
    [self.iTableView reloadData];
    [self hideNoNetWorkView];
  }else{

    [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                  withShowingText:noNetWorkToast
                                                withIconImageName:nil];
  }
                                     if (self.iController.footerRefreshEnd) {
                                       self.iTableView.footer.state = MJRefreshStateNoMoreData;
                                     }else{
                                       self.iTableView.footer.state=MJRefreshStateIdle;
                                     }
                                     
}];
   self.iTableView.footer.state = MJRefreshStatePulling;

}
- (void)noNetWorkButtonAction{
  
  [self headerRefresh];
}
- (BOOL)isNeedNoNetworkView
{
  
  return YES;
}
- (void)loadMoreData
{
  if (self.iController.footerRefreshEnd) {
    self.iTableView.footer.state = MJRefreshStateNoMoreData;
    return;
    
  }
[self.iController getDiscoverActivityWithPage:@(self.page+1)
                                       andTag:@(1)
                                   completion:^(BOOL isSucceed,
                                                NSString *aDes) {
  if (isSucceed)
  {
 
      self.page++;
      [self.iTableView reloadData];
  
    
  }else{
    
    [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                  withShowingText:noNetWorkToast
                                                withIconImageName:nil];
  }
     [self.iTableView.footer endRefreshing];
}];


}
- (BOOL)isNeedBaseViewTapAction
{
  return NO;
}

- (IBAction)backToDiscoverAction:(UIButton *)sender
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self tableView:self.iTableView cellForRowAtIndexPath:indexPath];
  
  CHCPGActivityVO *activityVO=self.iController.iActivityArray[indexPath.row];
  if (activityVO.cellHeight) {
     return activityVO.cellHeight;
  }else{
  
    return 220;
  }
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CHCPGActivityCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
  if (indexPath.row < self.iController.iActivityArray.count) {
    cell.activityVO=self.iController.iActivityArray[indexPath.row];
  }
 cell.selectionStyle=UITableViewCellSelectionStyleNone;
  return cell;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.iController.iActivityArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  CHCPGActivityVO *activityVO=self.iController.iActivityArray[indexPath.row];
  CHCPGWebViewController *iCHCWebView=[[CHCPGWebViewController alloc]initWithUrlStr:activityVO.url
                                                                        imageUrlStr:activityVO.img
                                                                           titleStr:activityVO.title
                                                                       infomationId:activityVO.iHCid
                                                                            webType:EHCWebDiscover];
  iCHCWebView.hidesBottomBarWhenPushed=YES;
  [self.navigationController pushViewController:iCHCWebView animated:YES];
}

@end

@interface CHCPGActivityController ()

@property (nonatomic,weak) CHCPGActivityViewController *iViewController;
@end

@implementation CHCPGActivityController
@dynamic iViewController;

- (void)getDiscoverActivityWithPage:(NSNumber *)page
                             andTag:(NSNumber *)tag
                         completion:(void (^)(BOOL, NSString *))aCompletion{
    __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_Discover_LeisureTime];
//  page=0?wSelf.firstId=:wSelf.firstId;
  NSDictionary *param=nil;
  if ([page intValue]==0) {
  param=@{@"pageNo":page,@"tag":tag,@"pageSize":@(10)};

  }else{
 param=@{@"pageNo":page,@"tag":tag,@"pageSize":@(10),@"firstId":@(wSelf.firstId)};

  
  }
   [self.iModelHandler postMethod:method
                      parameters:param
                      completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData) {
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
                          NSArray *array=aData[@"data"];
                          [wSelf.iTempActivityArray removeAllObjects];
                          if ([page intValue]==0)
                          {
                            [wSelf.iActivityArray removeAllObjects];
                              wSelf.footerRefreshEnd = NO;
                            for (NSDictionary *dict in array)
                            {
                              [self constructActivityWithDic:dict];
                            }
                            CHCPGActivityVO *activityVO=[wSelf.iTempActivityArray lastObject];
                            wSelf.firstId=[activityVO.iHCid intValue];
                            wSelf.iActivityArray=[NSMutableArray arrayWithArray:wSelf.iTempActivityArray];
                          }else
                          {
                            if (array.count==0) {
                              self.footerRefreshEnd = YES;
                            }
                            for (NSDictionary *dic in array)
                            {
                              [self constructActivityWithDic:dic];
                            }
                            [wSelf.iActivityArray addObjectsFromArray:wSelf.iTempActivityArray];
                          }
                          for (NSDictionary *dict in array) {
                            [self constructActivityWithDic:dict];
                          }
                          if (aCompletion)
                          {
                            aCompletion(YES,nil);
                          }
                        }
                      }];


}

- (void)constructActivityWithDic:(NSDictionary *)dict
{
  CHCPGActivityVO *activityVO = [[CHCPGActivityVO alloc]initWithDic:dict];
  [self.iTempActivityArray addObject:activityVO];
}

- (NSMutableArray *)iActivityArray
{
  if (_iActivityArray == nil)
  {
    _iActivityArray = [[NSMutableArray alloc]init];
  }
  return _iActivityArray;

}
- (NSMutableArray *)iTempActivityArray
{

  if (_iTempActivityArray == nil)
  {
    _iTempActivityArray = [[NSMutableArray alloc]init];
  }
  return _iTempActivityArray;
}
@end
@interface CHCPGActivityVO ()

@end
@implementation CHCPGActivityVO





@end