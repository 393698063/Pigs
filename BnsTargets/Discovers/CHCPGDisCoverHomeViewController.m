//
//  CHCPGDisCoverHomeViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGDisCoverHomeViewController.h"
#import "BnsTargetDiscoverDef.h"
#import "CHCPGDisCoverHeadView.h"
#import "UIColor+Hex.h"
#import "MJRefresh.h"
#import "CHCPGDiscoverCell.h"
#import "CHCPGActivityViewController.h"
#import "CHCPGWebViewController.h"
@interface CHCPGDisCoverHomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) CHCPGDisCoverHomeController *iController;
@property (nonatomic,assign) int page;
@property (weak, nonatomic) IBOutlet UITableView *iTableView;


@end

@implementation CHCPGDisCoverHomeViewController
@dynamic iController;
static  NSString * const  noNetWorkToast= @"断网啦，请检查网络连接";
- (BOOL)isNeedRightGestureRecognizer
{
  return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  self.page=0;
  self.iTableView.delegate = self;
  self.iTableView.dataSource = self;

  self.iTableView.separatorStyle=UITableViewCellSelectionStyleNone;
  UIView *iTableViewLine=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 1)];
  iTableViewLine.backgroundColor=[UIColor colorWithHex:0xffd7dae3];
  self.iTableView.tableFooterView=iTableViewLine;
  __weak typeof(self)wSelf = self;
  self.iTableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [wSelf headerRefresh];
  }];
  self.iTableView.footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    
    [wSelf loadMoreData];
  }];
  [self.iTableView registerNib:[UINib nibWithNibName:@"CHCPGDiscoverCell" bundle:nil] forCellReuseIdentifier:@"cell"];
  
  [self.iController getDiscoverLeisureTimeWithPage:@(0)
                                            andTag:@(0)
                                        completion:^(BOOL isSucceed, NSString *aDes)
   {
     if (isSucceed)
     {

       [self.iTableView reloadData];
       [self hideNoNetWorkView];
     }
     else
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
  self.page = 0;
  [self.iController getDiscoverLeisureTimeWithPage:@(0)
                                            andTag:@(0)
                                        completion:^(BOOL isSucceed, NSString *aDes)
                           {
                             [self.iTableView.header endRefreshing];
                           if (isSucceed)
                             {
                               [self hideNoNetWorkView];
                                [self.iTableView reloadData];
                              }
                                else
                              {
                         
            [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                          withShowingText:noNetWorkToast
                                                        withIconImageName:nil];
                                          }
                             if (self.iController.footerRefreshEnd)
                             {
                               self.iTableView.footer.state = MJRefreshStateNoMoreData;
                             }else
                             {
                               self.iTableView.footer.state = MJRefreshStateIdle;
                             }
                                        }];
  

  
}
- (void)loadMoreData
{
  if (self.iController.footerRefreshEnd) {
    self.iTableView.footer.state = MJRefreshStateNoMoreData;
    self.iTableView.footer.automaticallyHidden=YES;
    return;
  }
  [self.iController getDiscoverLeisureTimeWithPage:@(self.page+1)
                                            andTag:@(0)
                                        completion:^(BOOL isSucceed, NSString *aDes)
   {

     if (isSucceed)
     {
         self.page++;
       [self.iTableView reloadData];

     }else
     {
      [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES withShowingText:noNetWorkToast withIconImageName:nil];
     }
       [self.iTableView.footer endRefreshing];
   }];
  
  
}
- (void)noNetWorkButtonAction
{
  [self headerRefresh];
}
- (BOOL)isNeedNoNetworkView
{
  return YES;
}
- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  CHCPGDisCoverHeadView *iHeadView=[CHCPGDisCoverHeadView headViewItem];;
  iHeadView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90);
  [iHeadView addTarget:self action:@selector(hotActivityJumpAction)];
  self.iTableView.tableHeaderView=iHeadView;
}
- (void)hotActivityJumpAction
{
  CHCPGActivityViewController *iActivityVC=[[CHCPGActivityViewController alloc]init];
  [self.navigationController pushViewController:iActivityVC animated:YES];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *ID = @"cell";
  CHCPGDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (indexPath.row < [self.iController.iDiscoverArray count])
  {
    cell.discoverListVO = self.iController.iDiscoverArray[indexPath.row];
  }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.iController.iDiscoverArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

  return 220;


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  CHCPGDisCoverListVO *discoverVO=self.iController.iDiscoverArray[indexPath.row];
  CHCPGWebViewController *iCHCWebView=[[CHCPGWebViewController alloc]initWithUrlStr:discoverVO.url
                                                     imageUrlStr:discoverVO.img
                                                        titleStr:discoverVO.title
                                                    infomationId:discoverVO.iHCid
                                                         webType:EHCWebDiscover];
 iCHCWebView.hidesBottomBarWhenPushed=YES;
  [self.navigationController pushViewController:iCHCWebView animated:YES];
}
- (BOOL)isNeedBaseViewTapAction
{
  return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end

@interface CHCPGDisCoverHomeController()
@property (nonatomic,weak) CHCPGDisCoverHomeViewController *iViewController;
@end

@implementation CHCPGDisCoverHomeController
@dynamic iViewController;
- (void)getDiscoverLeisureTimeWithPage:(NSNumber *)page
                                andTag:(NSNumber *)tag
                            completion:(void (^)(BOOL, NSString *))aCompletion

{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_Discover_LeisureTime];
  NSDictionary *param=nil;
  if ([page intValue]==0) {
    param=@{@"pageNo":page,@"tag":tag,@"pageSize":@(10)};
  }else{
   param= @{@"pageNo":page,@"tag":tag,@"pageSize":@(10),@"firstId":@(wSelf.firstId)};
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
                          [wSelf.iTempDiscoverArray removeAllObjects];
                           NSArray *array=aData[@"data"];
                          if ([page intValue]==0) {
                            [wSelf.iDiscoverArray removeAllObjects];
                            self.footerRefreshEnd = NO;
                            for (NSDictionary *dict in array)
                            {
                              [wSelf constructLeisureTimeWithDic:dict];
                              
                            }
                            wSelf.iDiscoverArray=[NSMutableArray arrayWithArray:wSelf.iTempDiscoverArray];
                            CHCPGDisCoverListVO *discoverVO=[wSelf.iTempDiscoverArray lastObject];
                            wSelf.firstId=[discoverVO.iHCid intValue];
                          }else{
      
                            if (array.count == 0)
                            {
                              wSelf.footerRefreshEnd = YES;
                            }
                            for (NSDictionary *dict in array) {
                              [wSelf constructLeisureTimeWithDic:dict];
                            }
                          
                            [wSelf.iDiscoverArray addObjectsFromArray:wSelf.iTempDiscoverArray];
                           
                          }
                      
                          if (aCompletion)
                          {
                            aCompletion(YES,nil);
                          }
                        }
                        
                      }];
  
}
- (void)constructLeisureTimeWithDic:(NSDictionary *)dic
{
  CHCPGDisCoverListVO *discoverVO=[[CHCPGDisCoverListVO alloc]initWithDic:dic];
  [self.iTempDiscoverArray addObject:discoverVO];
  
}

- (NSMutableArray *)iTempDiscoverArray
{
  if (_iTempDiscoverArray==nil) {
    _iTempDiscoverArray=[[NSMutableArray alloc]init];
  }
  return _iTempDiscoverArray;

}
- (NSMutableArray *)iDiscoverArray
{
  if (_iDiscoverArray==nil) {
    _iDiscoverArray=[[NSMutableArray alloc]init];
  }
  return _iDiscoverArray;
}
@end

@implementation CHCPGDisCoverListVO

@end
