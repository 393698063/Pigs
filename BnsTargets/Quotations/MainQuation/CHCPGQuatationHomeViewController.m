//
//  CHCPGQuatationHomeViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//


#define MAIN_Screen [[UIScreen mainScreen]bounds].size
#import "BnsQuationDef.h"
#import "CHCQuationCityItem.h"
#import "CHCQuationBaseTableView.h"
#import "CHCQuationButton.h"
#import "CHCPGWebViewController.h"
#import "CHCQuationPriceItem.h"
#import "CHCQuationPriceListView.h"
#import "CHCPGQuatationHomeViewController.h"
#import "UIButton+Extension.h"
#import "CHCPGQuatationDetailViewController.h"
#import "CHCPGQutationChangeCityViewController.h"
#import "CHCPGQuatationHomeHeadView.h"
#import "CHCPGQuatationHomeCell.h"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "UIColor+Hex.h"
#import "UIView+frame.h"
#import "CHCSqliteManager.h"
#import "CHCPGCommonDataSyncViewController.h"
#import "CHCPGLoginViewController.h"
#import "CHCPGQuotePriceViewController.h"
#import "CHCPGPriceTrendViewController.h"
#import "CHCUpdateViewController.h"
#import "CHCPGGoldManager.h"
#import "CHCReachability.h"
#import "CHCNoNetWorkView.h"
@interface CHCPGQuatationHomeViewController ()<UIScrollViewDelegate,
                                                UITableViewDataSource,
                                                UITableViewDelegate,
                                                SDCycleScrollViewDelegate,
                                                getDetailViewDelegate,
                                                getDetailWebUrlDelegate,
                                                selectCityPriceListDelegate,
                                                trendSelectCityDelegate>

@property (nonatomic,strong) UIView *quotationView;                     //行情的view
@property (nonatomic,strong) NSMutableArray *iTopTitle;                  //存放行情等标签的文字
@property (nonatomic,strong) NSMutableArray *iTagTitle;                  //存放行情等标签的tag数组
@property (nonatomic,strong) NSMutableArray * iViewArray;                //保存行情外的其他视图
@property (nonatomic,strong) UILabel *iLineLabel;                         //行情等标签下面代表选中的横线
@property (nonatomic,strong) SDCycleScrollView *iScrollView;              //轮播图的封装控件
@property (nonatomic,strong) UITableView *iTableView;                     //行情的tableView
@property (nonatomic,copy)   NSString *cityString;                        //选中城市的名称
@property (nonatomic,copy)   NSString *iProvince;                         //选中城市省的名称
@property (nonatomic,assign) int page;                                     //当前行情的page
@property (nonatomic,strong) CHCPGWebViewController *iCHCWebView;          //详情页面  H5页面
@property (nonatomic,strong) CHCPGQuatationDetailViewController *CHCDetailVC;//价格列表的视图控制器
@property (nonatomic,strong) UIButton *starButton;                          //选中的button  用于保证只有一个button被选中
@property (nonatomic,assign) CGFloat margin;                              //标签中的选中横线距离屏幕左边的距离
@property (nonatomic,strong) CHCQuationBaseTableView *iBaseTableView;       //行情外标签的对象
@property (nonatomic,strong) NSMutableArray *iBaseTableViewArray;           //存放行情外标签的tableview
@property (nonatomic,strong) NSMutableArray *iBaseViewArray;                //存放行情外的标签的视图view
@property (nonatomic,strong) NSMutableArray *iPageArray;                    //存放每个标签页的page
@property (nonatomic,strong) CHCPGQuatationHomeHeadView *iHeadView;         //行情价格面板的额头视图
@property (nonatomic,strong) CHCQuationCityItem *item;                      //城市选择的自定义view
@property (nonatomic,strong) CHCQuationPriceInfoVO *priceInfoVO;             //价格面板的数据模型
@property (nonatomic,strong) CHCSqliteManager *iManager;                     //数据库的处理工具
@property (nonatomic,strong) CHCPGQuatationHomeController * iController;     //本视图控制器的业务类
@property (weak, nonatomic) IBOutlet UILabel *goldLabel;                     //用于显示金币的label
@property (nonatomic, assign) NSInteger scrollFlag;                          //用于行情滚动到最后一个标签继续滚动还会加载数据的判断
@property (nonatomic,strong) NSMutableArray *tagArray;                       //用于存放已经被加载过的tag
@property (nonatomic,strong) NSMutableArray *buttonTagArray;                  //存放button的tag数组
@property (nonatomic,assign) int readCountNumber;                            //资讯文章的阅读数
@property (nonatomic,strong) NSMutableArray *iReadCountNumber;               //存放每行资讯文章读取数的数组
@end

@implementation CHCPGQuatationHomeViewController

@dynamic iController;
@synthesize CHCDetailVC;
static  CGFloat  const NavHeight = 64;
static  CGFloat  const TabHeight = 50;
static  CGFloat  const TitleHeight = 30;
NSString * const  noNetWorkToast= @"断网啦，请检查网络连接";
static NSString * const HCPG_LocationDic = @"locationDic";
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
}

- (BOOL)isNeedRightGestureRecognizer
{
  return YES;
}
- (void)viewDidLoad{
  [super viewDidLoad];
  self.page=0;
  //  创建UI布局
  [self createUserInterface];
//  加载所有数据
  [self loadGlobalData];
//  [self checkVersion];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginIn:) name:HC_PG_Login_login object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut:) name:HC_PG_Login_logout object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goldChange:) name:HCPG_GoldChangeNotice object:nil];

}

- (void)loginIn:(NSNotification *)aNotice
{
  [self.iController readUserGoldData];
  [self.iController getDynamicPriceInfoWithUid:[CHCCommonInfoVO sharedManager].iHCid completion:^(BOOL isSucceed, NSString *aDes) {
    if (isSucceed) {
      if ([self.iController.area isEqualToString:@""])
      {
        self.item.cityLabel.text=@"全国";
      }else{
        self.item.cityLabel.text=self.iController.area;
      }
      self.cityString=self.item.cityLabel.text;
      [self.iHeadView createPriceViewInfoDataArray:self.iController.priceDataArray];
      [self showPriceViewInLine];
    }
  }];
}
- (void)loginOut:(NSNotification *)aNotice
{
  [self.iController readUserGoldData];
  [self loadPositionPriceData];
}
- (void)goldChange:(NSNotification *)notice
{
  [self.iController readUserGoldData];
}
#pragma mark 检查版本升级
- (void)checkVersion
{
  CHCUpdateViewController * upController = [[CHCUpdateViewController alloc] init];
  [upController checkVersionUpdateCompletion:^(BOOL isSucceed, NSString *aDes) {
    
  }];
}
/**
 * 跳转到资讯的详情页面
 */
- (void)getDetailTableInfoWebUrlWithContentPath:(NSString *)pathUrl
                                    imageUrlStr:(NSString *)imageUrlStr
                                    andTitleStr:(NSString *)titleStr
                                  informationId:(NSNumber *)informationId
{
  self.iCHCWebView=[[CHCPGWebViewController alloc]initWithUrlStr:pathUrl
                                                     imageUrlStr:imageUrlStr
                                                        titleStr:titleStr
                                                    infomationId:informationId
                                                         webType:EHCWebInfomation];
  self.iCHCWebView.hidesBottomBarWhenPushed=YES;
  [self.navigationController pushViewController:self.iCHCWebView animated:YES];
}
/**
 *  跳转到轮播图的详情页面
 */
- (void)getDetailScrollCircleWebUrlWithContentPath:(NSString *)pathUrl
                                       imageUrlStr:(NSString *)imageUrlStr
                                       andTitleStr:(NSString *)titleStr
                                     informationId:(NSNumber *)informationId
{
  self.iCHCWebView=[[CHCPGWebViewController alloc]initWithUrlStr:pathUrl
                                                     imageUrlStr:imageUrlStr
                                                        titleStr:titleStr
                                                    infomationId:informationId
                                                         webType:EHCWebCirculate];
  self.iCHCWebView.hidesBottomBarWhenPushed=YES;
  [self.navigationController pushViewController:self.iCHCWebView animated:YES];
}

- (BOOL)isNeedBaseViewTapAction
{
  return NO;
}

- (void)createUserInterface
{
  //  初始化滑动标题
  [self initializeSubViews];
  //  创建滑动视图模块
  [self createScrollSubviews];
  //  创建列表视图
  [self createTableView];
  //  创建轮播图
  [self createScrollImageView];
//  读取用户金币
  [self.iController readUserGoldData];
//  创建行情外的其他视图
  [self createBaseTableView];
//  创建选择城市的视图控件
    [self createCitySelectView];
}

- (void)loadGlobalData
{
  //  加载文章数据
  [self loadNewQuations];
//  加载价格信息
  [self loadPriceData];
}
- (void)loadPriceData
{
  [self hidePriceViewInOffLine];
  //  加载登录价格信息
  if ([CHCCommonInfoVO sharedManager].isLogin)
  {
    NSNumber *uid=[CHCCommonInfoVO sharedManager].iHCid;
    
    [self.iController getDynamicPriceInfoWithUid:uid
                                      completion:^(BOOL isSucceed, NSString *aDes)
    {
      if (isSucceed)
      {
        [self showPriceViewInLine];
        self.iProvince=@"";
        [self.iHeadView createPriceViewInfoDataArray:self.iController.priceDataArray];
        if ([self.iController.area isEqualToString:@""])
        {
          self.cityString=@"全国";
        }else
        {
          self.cityString=self.iController.area;
        }
        self.item.cityLabel.text=self.cityString;
      }
                                      }];
  }
  else{

    //  加载定位价格数据
    [self loadPositionPriceData];
  }
}
- (void)loadPositionPriceData
{
  /**
   *  如果上次定位的地理位置中的city为空，说明没有定位成功，需要重新定位
   */
  NSDictionary *locDic= [[NSUserDefaults standardUserDefaults] objectForKey:HCPG_LocationDic];
  
  if (locDic == nil||[locDic[@"iCity"] isEqualToString:@""]) {
    self.item.cityLabel.text = @"全国";
    self.cityString = @"全国";
    
    [self.iController getAreaDynamicPriceInfoWithCity:self.cityString completion:^(BOOL isSucceed, NSString *aDes) {
      if (isSucceed) {

  [self.iHeadView createPriceViewInfoDataArray:self.iController.priceDataArray];
          [self showPriceViewInLine];
    
      }
    }];
  }else
  {
    self.cityString = locDic[@"iCity"];
    self.iProvince = locDic[@"iProvice"];
    self.item.cityLabel.text =self.cityString;
    [self.iController getAreaDynamicPriceInfoWithCity:self.cityString completion:^(BOOL isSucceed, NSString *aDes) {
      if (isSucceed)
      {
        [self.iHeadView createPriceViewInfoDataArray:self.iController.priceDataArray];
        [self showPriceViewInLine];
      }
    }];
  }

}

/**
 *  用于断网情况下的隐藏价格面板
 */
- (void)hidePriceViewInOffLine
{
  NSMutableArray *subViewsArray=[NSMutableArray array];
  for (UIView *subViews in self.iHeadView.subviews)
  {
    [subViewsArray addObject:subViews];
  }
  [self.iHeadView removeAllSubviews];

  for (UIView *viewCLass in subViewsArray)
  {
    if ([viewCLass isKindOfClass:[SDCycleScrollView class]]) {
      [self.iHeadView addSubview:viewCLass];
    }
  }
  self.iHeadView.frame=CGRectMake(0, 0, MAIN_Screen.width, 120);
  self.iTableView.tableHeaderView=self.iHeadView;
  [self.view layoutSubviews];
}
/**
 *  用于有网情况下的显示价格面板
 */
- (void)showPriceViewInLine
{
  [self.iHeadView removeAllSubviews];
  [self createScrollImageView];
  self.iHeadView.frame=CGRectMake(0, 0, MAIN_Screen.width, 370);
    [self.iHeadView createTrendQuoteView];
  [self.iHeadView createPriceViewInfoDataArray:self.iController.priceDataArray];
  self.iTableView.tableHeaderView=self.iHeadView;
  [self.iHeadView addSubview:self.item];
  self.item.cityLabel.text=self.cityString;
  [self.view layoutSubviews];
}
/**
 *  加载文章资讯数据
 */
- (void)loadNewQuations
{
  [self.iController getArticleInfoWithPage:@(self.page)
                               withFirstId:NULL andArticleTag:@(2)
                                completion:^(BOOL isSucceed, NSString *aDes) {
                                  if (isSucceed)
                                  {
                                    [self.iTableView reloadData];
                                    self.iScrollView.imageURLStringsGroup=[NSArray arrayWithArray:self.iController.imageGroups];
                                    [self createScrollImageView];
                                    [self hideNoNetWorkView];
                                  }else
                                  {
                                    /**
                                     *  加载缓存数据
                                     */
                                    [self loadDataCache];                                  }
                                  
                                }];
  

 }

- (void)loadDataCache
{
  [self.iController.tableDataArray removeAllObjects];
  /**
   
   *  拼接查询数据库的请求参数
   */
  NSMutableArray *scrollDataSource=[NSMutableArray array];
  NSMutableArray *imageGroups=[NSMutableArray array];
  NSMutableArray *scrollTitleArray=[NSMutableArray array];
  NSMutableDictionary *param=[NSMutableDictionary dictionary];
  param[@"quationTag"]=@(2);
  param[@"isScroll"]=@(0);
  NSMutableArray *QuationDataCache=[CHCPGQuationDataCacheManager getQuationDataCacheWithParam:param];
  /**
   *  如果数据缓存有数据，就加载缓存数据
   */
  if (QuationDataCache.count!=0)
  {
    [self hideNoNetWorkView];
    for (NSDictionary *dic in QuationDataCache)
    {
      CHCQuationTableInfoVO *tableInfoVO=[[CHCQuationTableInfoVO alloc]initWithDic:dic];
      [self.iController.tableDataArray addObject:tableInfoVO];
    }
    NSArray *tableDataArray=[[self.iController.tableDataArray reverseObjectEnumerator] allObjects];
    self.iController.tableDataArray=[NSMutableArray arrayWithArray:tableDataArray];
    [self.iTableView reloadData];
    param[@"isScroll"]=@(1);
    NSMutableArray *scrollDataCache=[CHCPGQuationDataCacheManager getQuationDataCacheWithParam:param];
    for (NSDictionary *dict in scrollDataCache) {
      CHCQuationInfoVO *scrollInfoVO=[[CHCQuationInfoVO alloc]initWithDic:dict];
      [scrollDataSource addObject:scrollInfoVO];
      [imageGroups addObject:[scrollInfoVO.picture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
      [scrollTitleArray addObject:scrollInfoVO.title];
    }
    self.iController.scrollDataSource=[NSMutableArray arrayWithArray:scrollDataSource];
    self.iController.imageGroups=[NSMutableArray arrayWithArray:imageGroups];
    self.iController.scrollTitleArray=[NSMutableArray arrayWithArray:scrollTitleArray];
    self.iScrollView.imageURLStringsGroup=[NSArray arrayWithArray:self.iController.imageGroups];
    self.iScrollView.titlesGroup=[NSArray arrayWithArray:self.iController.scrollTitleArray];
    [self createScrollImageView];
  }else
  {
    /**
     *  如果没有缓存就显示无网页面
     */
    [self showNoNetWorkView];
    [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES withShowingText:noNetWorkToast withIconImageName:nil];
  }

}

/**
 *  添加无网页面
 */
- (void)addNoNetWrokView
{

  __weak typeof(self)wSelf = self;
  CHCNoNetWorkView * view = [CHCNoNetWorkView noNetWorkViewWithCallback:^{
    [wSelf noNetWorkButtonAction];
  }];
  view.translatesAutoresizingMaskIntoConstraints = NO;
  view.tag = 160624;
  view.hidden = YES;
  [self.view addSubview:view];
  
  NSArray * hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(view)];
  NSArray * vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-94-[view]-49-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(view)];
  [self.view addConstraints:hConstraints];
  [self.view addConstraints:vConstraints];
}
/**
 *  无网页面的点击方法
 */
- (void)noNetWorkButtonAction
{
  [self loadGlobalData];
  int a=self.iGlobalScrollView.contentOffset.x/MAIN_Screen.width;
  if (a>=1)
  {
    [self loadOtherBaseViewDataWithPageArrayIndex:a-1];
  }
  }
/**
 *  其他页面的无网页面的显示
 */
- (void)getNoNetworkViewShowInOffLine{
  
  [self showNoNetWorkView];
  
}
/**
 *  其他页面的无网页面的隐藏
 */
- (void)getHideNoNetworkShowInLine{
  [self hideNoNetWorkView];
}
- (BOOL)isNeedNoNetworkView{
  return YES;

}
/**
 *  创建滚动视图
 */
- (void)createScrollSubviews
{
  self.iGlobalScrollView=[[UIScrollView alloc]initWithFrame:(CGRectMake(0,
                                                                        TitleHeight+ NavHeight,
                                                                        MAIN_Screen.width,
                                                                        MAIN_Screen.height-TabHeight-NavHeight-TitleHeight))];
  self.iGlobalScrollView.delegate=self;
  self.iGlobalScrollView.showsHorizontalScrollIndicator=NO;
  self.iGlobalScrollView.showsVerticalScrollIndicator=NO;
  self.iGlobalScrollView.bounces=NO;
  self.iGlobalScrollView.pagingEnabled=YES;
  [self.view addSubview:self.iGlobalScrollView];
  self.quotationView=[[UIView alloc]initWithFrame:CGRectMake(0,
                                                             0,
                                                             MAIN_Screen.width,
                                                             MAIN_Screen.height-TabHeight-NavHeight-TitleHeight)];
  self.quotationView.backgroundColor=[UIColor colorWithHex:0xffeff3fc];
  self.quotationView.userInteractionEnabled=YES;
  [self.iGlobalScrollView addSubview:self.quotationView];
  self.iViewArray=[NSMutableArray array];
  for (int index = 0; index<self.iTopTitle.count; index++) {
    UIView *view=[[UIView alloc]init];
    [self.iViewArray addObject:view];
  }
  self.iGlobalScrollView.contentSize=CGSizeMake(5 * MAIN_Screen.width,
                                                MAIN_Screen.height-NavHeight-TitleHeight-TabHeight);
  for (int i = 0; i < self.iViewArray.count; i ++)
  {
    CGRect frame = CGRectMake( (i + 1) * MAIN_Screen.width,
                              0, MAIN_Screen.width,
                              MAIN_Screen.height-NavHeight-TitleHeight-TabHeight);
    UIView * subviews = self.iViewArray[i];
    subviews.backgroundColor=[UIColor colorWithHex:0xffeff3fc];
    subviews.userInteractionEnabled=YES;
    subviews.frame = frame;
    [self.iGlobalScrollView addSubview:subviews];
  }
}

/**
 *  初始化滑动标题栏
 */
- (void)initializeSubViews
{
  self.iTopTitle=[NSMutableArray array];
  self.iTagTitle=[NSMutableArray array];
  NSArray *titleArray=@[@"推荐",@"新闻",@"技术",@"政策",@"专栏"];
  self.iTopTitle=[NSMutableArray arrayWithArray:titleArray];
  NSArray *tagArray=@[@(2),@(7),@(4),@(1),@(5)];
  self.iTagTitle=[NSMutableArray arrayWithArray:tagArray];
  for (int index = 0; index < self.iTopTitle.count; index ++)
  {
    UIButton *iButton= [UIButton itemFrame:CGRectMake(index * (MAIN_Screen.width)/self.iTopTitle.count,
                                                      NavHeight ,
                                                      (MAIN_Screen.width)/self.iTopTitle.count,
                                                      TitleHeight)
                                 itemTitle:self.iTopTitle[index]
                                titleColor:[UIColor colorWithHex:0xffe15150]
                           backgroundColor:[UIColor whiteColor]
                                  withIcon:nil highIcon:nil
                                    target:self
                                    action:@selector(onSelectButtonSubViewsAction:)];
    iButton.titleEdgeInsets=UIEdgeInsetsMake(0, -3, 0, 0);
    iButton.tag=10+index;
    [iButton setTitleColor:[UIColor colorWithHex:0xffe15150] forState:UIControlStateSelected];
    iButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [iButton setTitleColor:[UIColor colorWithHex:0xff999999] forState:UIControlStateNormal];
    [self.view addSubview:iButton];
    UIView *iCutLine=[[UIView alloc]initWithFrame:CGRectMake(0, NavHeight-1, MAIN_Screen.width, 1)];
    iCutLine.backgroundColor=[UIColor colorWithHex:0xffeff3fc];
    [self.view addSubview:iCutLine];
    if (index==0) {
      [self onSelectButtonSubViewsAction:iButton];
    }
  }
  UIButton *button=(UIButton *)[self.view viewWithTag:10];
  UILabel * iSelect = [[UILabel alloc]initWithFrame:(CGRectMake(self.margin, 27+NavHeight, 28, 1.5))];
  iSelect.size = CGSizeMake(28, 1.5);
  iSelect.centerX=button.centerX;
  iSelect.backgroundColor = [UIColor colorWithHex:0xffe15150];
  self.iLineLabel = iSelect;
  [self.view addSubview:self.iLineLabel];
  self.buttonTagArray=[NSMutableArray array];
}
/**
 *  首页各个标签的点击方法
 *
 *  @param button 选中的button
 */
- (void)onSelectButtonSubViewsAction:(UIButton *)button
{
  
//  if (![self.buttonTagArray containsObject:@(button.tag)])
//  {
    if (button.tag==10) {
      [self loadGlobalData];
      }
    if (button.tag>10)
    {
      [self loadOtherBaseViewDataWithPageArrayIndex:(int)button.tag-11];
   
    }
       [self.buttonTagArray addObject:@(button.tag)];
//  }
 
  self.starButton.selected=NO;
  button.selected=YES;
  self.starButton=button;
  [UIView animateWithDuration:0.00001 animations:^{
    CGRect frame = self.iLineLabel.frame;
    frame.origin.x = button.frame.origin.x;
    if (self.iTopTitle.count  != button.tag - 9)
    {
      self.scrollFlag = 0;
    }
    else
    {
      self.scrollFlag = 1;
    }
    self.iGlobalScrollView.contentOffset = CGPointMake(frame.origin.x/ ((MAIN_Screen.width)/self.iTopTitle.count) * MAIN_Screen.width,
                                                       0);
    CGPoint centerLabel=CGPointMake(button.center.x, CGRectGetMaxY(button.frame)-3);
    self.iLineLabel.center=centerLabel;
    
  }];
}
/**
 *  创建tableView
 */
- (void)createTableView
{
  self.iTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                               0,
                                                               MAIN_Screen.width,
                                                               self.quotationView.frame.size.height)
                                              style:UITableViewStylePlain];
  self.iTableView.separatorStyle=UITableViewCellSelectionStyleNone;
  self.iTableView.delegate=self;
  self.iTableView.dataSource=self;
  self.iTableView.rowHeight=85;
  self.iTableView.showsHorizontalScrollIndicator=NO;
  self.iTableView.showsVerticalScrollIndicator=NO;
  self.iTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
  [self.quotationView addSubview:self.iTableView];
  self.iHeadView=[[CHCPGQuatationHomeHeadView alloc]initWithFrame:CGRectMake(0, 0,
                                                                             MAIN_Screen.width, 370)];

  self.iHeadView.delegate=self;
  [self.iHeadView createTrendQuoteView];

  self.iHeadView.backgroundColor=[UIColor colorWithHex:0xffeff3fc];
  
  self.iTableView.tableHeaderView=self.iHeadView;
  self.iTableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [self refreshData];
  }];
  self.iTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    [self loadMoreData];
  }];
  self.iTableView.tableFooterView=[[UIView alloc]init];
}
/**
 *  行情页面的下拉刷新过程
 */
-(void)refreshData
{
  self.page = 0;

  [self.iController getArticleInfoWithPage:@(self.page) withFirstId:NULL andArticleTag:@(2)
                                completion:^(BOOL isSucceed, NSString *aDes) {
    if (isSucceed)
    {
      self.item.cityLabel.text=self.cityString;
      [self.iTableView reloadData];
      [self createScrollImageView];
      [self hidePriceViewInOffLine];
      [self loadPriceData];
      [self showPriceViewInLine];
    }else
    {

      [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES
                                                   withShowingText:noNetWorkToast
                                                 withIconImageName:nil];
     
        [self  hidePriceViewInOffLine];
        [self createScrollImageView];
      
    }
                                  if (self.iController.footerRefreshEnd) {
                                    self.iTableView.footer.state = MJRefreshStateNoMoreData;
                                  }else{
                                    self.iTableView.footer.state = MJRefreshStateIdle;
                                  }
    [self.iTableView.header endRefreshing];
  }];
}
/**
 *  行情页面的下拉加载过程
 */
-(void)loadMoreData
{
  /**
   *  说明没有数据,调整下拉刷新的状态
   */
  if (self.iController.footerRefreshEnd) {
    self.iTableView.footer.state=MJRefreshStateNoMoreData;
    return;
  }
  [self.iController getArticleInfoWithPage:@(self.page+1) withFirstId:NULL
                             andArticleTag:@(2) completion:^(BOOL isSucceed, NSString *aDes) {
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

/**
 *  创建tableView头视图中的滚动视图
 */
- (void)createScrollImageView
{
  self.iScrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,
                                                                          MAIN_Screen.width, 110)
   
                                          imageURLStringsGroup:self.iController.imageGroups];

   self.iScrollView.delegate=self;
  
 
  self.iScrollView.titlesGroup=self.iController.scrollTitleArray;
  self.iScrollView.infiniteLoop=YES;
  self.iScrollView.autoScroll = YES;
  self.iScrollView.autoScrollTimeInterval=5;
  self.iScrollView.pageControlStyle=   SDCycleScrollViewPageContolStyleClassic;
  self.iScrollView.userInteractionEnabled=YES;
  [self.iHeadView addSubview:self.iScrollView];
}
/**
 *  创建选择城市的view
 */
- (void)createCitySelectView
{
  self.item=[CHCQuationCityItem item];
  self.item.frame=CGRectMake(0, 120, MAIN_Screen.width, TitleHeight);
  [self.item addTarget:self action:@selector(citySelectAction)];
  [self.iHeadView addSubview:self.item];
}
/**
 *  选择城市的点击方法
 */
- (void)citySelectAction
{
  CHCPGQutationChangeCityViewController *cityVC=[[CHCPGQutationChangeCityViewController alloc]
                                                 initWithCityChooseBlock:^(NSDictionary *selectCity) {
                                    
    [self.iController getAreaDynamicPriceInfoWithCity:[selectCity objectForKey:@"area"] completion:^(BOOL isSucceed,
                                                                              NSString *aDes) {

      if (isSucceed)
      {
        [self.iHeadView createPriceViewInfoDataArray:self.iController.priceDataArray];
        self.cityString=[selectCity objectForKey:@"area"];
        self.iProvince=[selectCity objectForKey:@"parent"];
        self.item.cityLabel.text=self.cityString;
      }else
      {
        [self hidePriceViewInOffLine];
        [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES withShowingText:noNetWorkToast withIconImageName:nil];
      }

    }];
  }];
  cityVC.hidesBottomBarWhenPushed=YES;
  [self.navigationController pushViewController:cityVC animated:YES];
}
/**
 *  价格面板的点击方法
 *
 *  @param buttonTag 选中的button
 */
- (void)getDetailViewTag:(int)buttonTag
{
  CHCPGQuatationDetailViewController *detailVC=[[CHCPGQuatationDetailViewController alloc]init];
  detailVC.iCityString=self.cityString;
  detailVC.delegate=self;
  detailVC.hidesBottomBarWhenPushed=YES;
  [self.navigationController pushViewController:detailVC animated:YES];
  switch (buttonTag) {
    case 20:
      detailVC.nameTag=0;
      detailVC.priceUnitString=@"价格(元/公斤)";
      detailVC.changeUnitString=@"涨幅(元)";
      break;
    case 21:
      detailVC.nameTag=1;
      detailVC.priceUnitString=@"价格(元/公斤)";
      detailVC.changeUnitString=@"涨幅(元)";
      break;
    case 22:
      detailVC.nameTag=2;
      detailVC.priceUnitString=@"价格(元/公斤)";
      detailVC.changeUnitString=@"涨幅(元)";
      break;
    case 23:
      detailVC.nameTag=5;
      detailVC.priceUnitString=@"价格(元/吨)";
      detailVC.changeUnitString=@"涨幅(元)";
      break;
    case 24:
      detailVC.nameTag=4;
      detailVC.priceUnitString=@"价格(元/吨)";
      detailVC.changeUnitString=@"涨幅(元)";
      break;
    case 25:
      detailVC.nameTag=3;
      detailVC.priceUnitString=@"比例";
      detailVC.changeUnitString=@"涨幅";
      break;
    default:
      break;
  }
}
#pragma mark   价格列表的回调代理
- (void)getSelectRegionCity:(NSString *)selectCity
{
  self.item.cityLabel.text=selectCity;
  self.cityString=selectCity;
  [self.iController getAreaDynamicPriceInfoWithCity:selectCity
                                         completion:^(BOOL isSucceed, NSString *aDes) {

                                             if (isSucceed) {
                                               [self.iHeadView createPriceViewInfoDataArray:self.iController.priceDataArray];
                                             }else{
                                             
                                               [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES withShowingText:noNetWorkToast withIconImageName:nil];
                                             
                                             }
                                           
                                       
                                         }];
  
}
///趋势报价走向的点击事件
- (void)getQuoteTrendViewTag:(int)buttonTag
{
  switch (buttonTag) {
    case 26:
    {
     {
        CHCPGPriceTrendViewController *iTrendVC=[[CHCPGPriceTrendViewController alloc]init];
        iTrendVC.cityString=self.cityString;
        iTrendVC.provinceString=self.iProvince;
        iTrendVC.hidesBottomBarWhenPushed=YES;
        iTrendVC.delegate=self;
        [self.navigationController pushViewController:iTrendVC animated:YES];
      }
    }
      break;
    case 27:{
      if ([CHCCommonInfoVO sharedManager].isLogin) {
        CHCPGQuotePriceViewController *iPriceView=[[CHCPGQuotePriceViewController alloc]init];
        iPriceView.quoteCityString=self.cityString;
        iPriceView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:iPriceView animated:YES];
      }else{
        CHCPGLoginViewController * loginVc = [[CHCPGLoginViewController alloc] init];
        UINavigationController * nvc = [[UINavigationController alloc]
                                        initWithRootViewController:loginVc];
        loginVc.navigationController.navigationBarHidden = YES;
        [self presentViewController:nvc animated:YES completion:nil];
      }
    }
      break;
    default:
      break;
  }
}
#pragma mark  趋势的回调代理方法
- (void)getTrendSelectCity:(NSString *)city andProvince:(NSString *)province
{
[self.iController getAreaDynamicPriceInfoWithCity:city completion:^(BOOL isSucceed, NSString *aDes) {
  
  self.item.cityLabel.text = city;
  self.cityString = city;
  self.iProvince = province;
  [self.iHeadView createPriceViewInfoDataArray:self.iController.priceDataArray];
  
}];
}

#pragma mark 其他行情页面的刷新
- (void)getArticlePageHeaderRefreshWith:(int)quationTag
{
  int index=0;
  switch (quationTag) {
    case 7:
      index=0;
      break;
    case 4:
      index=1;
      break;
    case 1:
      index=2;
      break;
    case 5:
      index=3;
      break;
    default:
      break;
  }

  CHCQuationBaseTableView *iBaseView=self.iBaseViewArray[index];
  iBaseView.iBasePage=0;
  [self.iController getArticleInfoWithPage:@(0)
                               withFirstId:NULL
                             andArticleTag:@(quationTag)
                                completion:^(BOOL isSucceed, NSString *aDes)
   {
     
     UITableView *tableView=self.iBaseTableView.iTableView;
     if (isSucceed)
     {
       [tableView reloadData];
     }else{
     
       [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES withShowingText:noNetWorkToast withIconImageName:nil];
     }
     [iBaseView createScrollViewWithImageGroups:self.iBaseTableView.imageGroups andTitleArray:self.iBaseTableView.iTitleArray];
     if (self.iController.footerRefreshEnd) {
       iBaseView.iTableView.footer.state = MJRefreshStateNoMoreData;
     }else{
       iBaseView.iTableView.footer.state = MJRefreshStateIdle;
     }
     [tableView.header endRefreshing];
   }];
  
}
- (void)getArticlePageFooterRefreshWith:(int)quationTag
{
  int index=0;
  switch (quationTag) {
    case 7:
      index=0;
      break;
    case 4:
      index=1;
      break;
    case 1:
      index=2;
      break;
    case 5:
      index=3;
      break;
    default:
      break;
  }
  CHCQuationBaseTableView *iBaseView=self.iBaseViewArray[index];
  iBaseView.iBasePage=[self.iPageArray[index] intValue];
  if (self.iController.footerRefreshEnd) {
    iBaseView.iTableView.footer.state = MJRefreshStateNoMoreData;
    return;
  }
  
  [self.iController getArticleInfoWithPage:@(iBaseView.iBasePage+1)
                               withFirstId:NULL
                             andArticleTag:@(quationTag)
                                completion:^(BOOL isSucceed, NSString *aDes) {
                                  
                                  UITableView *tableView=self.iBaseTableViewArray[index];
                                  if (isSucceed) {
                                    iBaseView.iBasePage++;
                                    [tableView reloadData];
                                    self.iPageArray[index]=@(iBaseView.iBasePage);
                                  }else{
                                    [[CHCMessageView sharedMessageView]showInWindowsIsFullScreen:YES withShowingText:noNetWorkToast withIconImageName:nil];
                                  }
                                     [tableView.footer endRefreshing];
                                }];
}

#pragma mark   tableView的代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CHCPGQuatationHomeCell *quationCell=[CHCPGQuatationHomeCell
                                       cellWithTableView:tableView];
  CHCQuationTableInfoVO *tableInfoVO=nil;
  if (indexPath.row<[self.iController.tableDataArray count])
  {
    tableInfoVO =self.iController.tableDataArray[indexPath.row];
    [quationCell addQuationInfoVO:self.iController.tableDataArray[indexPath.row]];

  }
  self.readCountNumber = tableInfoVO.skillCount.intValue;
  [self.iReadCountNumber addObject:@(self.readCountNumber)];
  quationCell.selectionStyle=UITableViewCellSeparatorStyleNone;
  return quationCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.iController.tableDataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.iController.tableDataArray.count == 0)
  {
    return;
  }
  CHCQuationTableInfoVO *quationInfo=self.iController.tableDataArray[indexPath.row];
  CHCPGWebViewController *iCHCWebView=[[CHCPGWebViewController alloc]initWithUrlStr:quationInfo.informationLink
                                                                        imageUrlStr:quationInfo.logoLink
                                                                           titleStr:quationInfo.title
                                                                       infomationId:quationInfo.iHCid
                                                                            webType:EHCWebInfomation];
  
  CHCPGQuatationHomeCell *cell=[tableView cellForRowAtIndexPath:indexPath];
  int readCountNumber=[self.iReadCountNumber[indexPath.row] intValue];
  readCountNumber=readCountNumber+1;
  [self.iReadCountNumber replaceObjectAtIndex:indexPath.row withObject:@(readCountNumber)];
  cell.readCountLabel.text=[NSString stringWithFormat:@"%d阅读",readCountNumber];
  iCHCWebView.hidesBottomBarWhenPushed=YES;
  [self.navigationController pushViewController:iCHCWebView animated:YES];
  cell.selected=NO;
}

#pragma mark   轮播图的代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
  CHCQuationInfoVO *quationInfoVO=self.iController.scrollDataSource[index];
  CHCPGWebViewController *CHCWebView=[[CHCPGWebViewController alloc]initWithUrlStr:quationInfoVO.content
                                                                       imageUrlStr:quationInfoVO.picture
                                                                          titleStr:quationInfoVO.title
                                                                      infomationId:quationInfoVO.iHCid
                                                                           webType:EHCWebCirculate];
  CHCWebView.hidesBottomBarWhenPushed=YES;
  [self.navigationController pushViewController:CHCWebView animated:YES];
}

/**
 *  添加点击button以及label
 */
- (void)createBaseTableView
{
  self.iBaseTableViewArray=[NSMutableArray array];
  self.iBaseViewArray=[NSMutableArray array];
  self.iPageArray=[NSMutableArray array];
  for (int index = 0; index<self.iTopTitle.count-1; index++)
  {
    CHCQuationBaseTableView *aBaseTableView=[[CHCQuationBaseTableView alloc]initWithFrame:self.quotationView.frame];
    aBaseTableView.delegate=self;
    [self.iViewArray[index] addSubview:aBaseTableView];
    aBaseTableView.quationTag=[self.iTagTitle[index+1] intValue];
    aBaseTableView.iBasePage=0;
    [self.iPageArray addObject:@(aBaseTableView.iBasePage)];
    [self.iBaseViewArray addObject:aBaseTableView];
    UITableView *tableView=[aBaseTableView createTableView];
    [self.iBaseTableViewArray addObject:tableView];
  }
    self.tagArray=[NSMutableArray array];
}
#pragma mark  加载行情外的其他页面网络数据
- (void)loadOtherBaseViewDataWithPageArrayIndex:(int)arrayIndex;
{
         CHCQuationBaseTableView *iBaseView=self.iBaseViewArray[arrayIndex];

//  iBaseView.dataSourceTable=[NSMutableArray arrayWithArray:self.iBaseTableView.dataSourceTable];
  [self.iController getArticleInfoWithPage:self.iPageArray[arrayIndex]
                               withFirstId:NULL
                             andArticleTag:self.iTagTitle[arrayIndex+1]
                                completion:^(BOOL isSucceed, NSString *aDes) {
                                  if (isSucceed) {
                                    [self hideNoNetWorkView];
                                    [iBaseView.iTableView reloadData];
                                    [iBaseView createScrollViewWithImageGroups:self.iBaseTableView.imageGroups andTitleArray:self.iBaseTableView.iTitleArray];
                                  }else{
                                    [iBaseView loadQuationDataCache];

                                  }
                                }];
    [self.iBaseTableView.dataSourceTable removeAllObjects];
  
}

#pragma mark   scrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  CGFloat oneWith = scrollView.contentSize.width/5;
  if (scrollView.contentOffset.x == scrollView.contentSize.width - oneWith) {
    self.scrollFlag +=1;
  }
  else
  {
    self.scrollFlag = 0;
  }
  if (self.scrollFlag >= 2) {
    return;
  }
  CGRect frame = self.iLineLabel.frame;
  frame.origin.x = scrollView.contentOffset.x/MAIN_Screen.width * (MAIN_Screen.width)/self.iTopTitle.count;
  int a = scrollView.contentOffset.x/scrollView.frame.size.width;

  
  UIButton *iButton=(UIButton *)[self.view viewWithTag:a+10];
  self.starButton.selected=NO;
  iButton.selected=YES;
  self.starButton=iButton;
  [iButton setTitleColor:[UIColor colorWithHex:0xffe15150] forState:UIControlStateSelected];
  frame.origin.x = scrollView.contentOffset.x/MAIN_Screen.width * (MAIN_Screen.width)/self.iTopTitle.count+self.margin;
  self.iLineLabel.centerX=iButton.centerX;
  self.iLineLabel.centerY=CGRectGetMaxY(iButton.frame)-3;
  if (a > 0) {
//      CHCQuationBaseTableView *iBaseView = self.iBaseViewArray[a-1];
//        [iBaseView createScrollViewWithImageGroups:iBaseView.imageGroups andTitleArray:iBaseView.iTitleArray];
//    iBaseView.iScrollView.mainView.scrollEnabled=YES;
    
  }else{
//    [self createScrollImageView];
//    self.iScrollView.mainView.scrollEnabled=YES;
  
  }
  if ( ![self.tagArray containsObject:@(a)]) {
    if (a > 0) {
      [self loadOtherBaseViewDataWithPageArrayIndex:a-1];

      [self.tagArray addObject:@(a)];
    }
  }
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//  
//    int a = scrollView.contentOffset.x/scrollView.frame.size.width;
//  if (a > 0) {
//    CHCQuationBaseTableView *iBaseView = self.iBaseViewArray[a-1];
////    if (iBaseView.iScrollView.mainView.contentOffset.x<0||iBaseView.iScrollView.mainView.contentOffset.x>(self.iController.imageGroups.count-1) *iBaseView.iScrollView.frame.size.width)
////    {
////      iBaseView.iScrollView.mainView.scrollEnabled=NO;
////       iBaseView.iScrollView.delegate=nil;
////    }else{
////      iBaseView.iScrollView.mainView.scrollEnabled=YES;
////      iBaseView.iScrollView.delegate=self;
////    }
//    if (iBaseView.iScrollView.isScrolled==YES) {
//      iBaseView.iScrollView.mainView.scrollEnabled=YES;
//            iBaseView.iScrollView.delegate=self;
//    }else{
//      iBaseView.iScrollView.mainView.scrollEnabled=NO;
////             iBaseView.iScrollView.delegate=nil;
//    
//    }
//  }else{
//    if (self.iScrollView.isScrolled)
//    {
//        self.iScrollView.mainView.scrollEnabled=YES;
//      self.iScrollView.delegate=self;
//    }else{
//      self.iScrollView.mainView.scrollEnabled=NO;
////      self.iScrollView.delegate=nil;
//
////
//    }
//  }
//
//  }
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//  int a = scrollView.contentOffset.x/scrollView.frame.size.width;
//  if (a > 0&&(scrollView.contentOffset.x==a *scrollView.frame.size.width)) {
//    CHCQuationBaseTableView *iBaseView = self.iBaseViewArray[a-1];
//    [iBaseView createScrollViewWithImageGroups:iBaseView.imageGroups andTitleArray:iBaseView.iTitleArray];
//    iBaseView.iScrollView.mainView.scrollEnabled=YES;
//    
//  }else{
//        [self createScrollImageView];
//    self.iScrollView.mainView.scrollEnabled=YES;
//    
//  }
//
//
//}
- (NSMutableArray *)iReadCountNumber{

  if (_iReadCountNumber==nil) {
    _iReadCountNumber=[[NSMutableArray alloc]init];
  }
  return _iReadCountNumber;

}

@end


@interface CHCPGQuatationHomeController()

@property (nonatomic,weak)CHCPGQuatationHomeViewController *iViewController;
@property (nonatomic,strong) CHCSqliteManager *iSqliteManager;
@end

@implementation CHCPGQuatationHomeController

@dynamic iViewController;


/**
 *  获取文章列表
 *
 *  @param page        页数
 *  @param firstID     缓存用
 *  @param tag         页面数值
 *  @param aCompletion 回调
 */
- (void)getArticleInfoWithPage:(NSNumber *)page withFirstId:(NSNumber *)firstID andArticleTag:(NSNumber *)tag
                    completion:(void(^)(BOOL isSucceed,
                        NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_ArticleGetCode];
  NSDictionary *param=@{@"category":@(-1),@"page":page,@"pageSize":@(10),@"tag":tag};
  [self.iModelHandler postMethod:method parameters:param completion:^(NSInteger aFlag, NSString *aDesc,
                                                                      NSError *error, NSDictionary *aData)
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
       [wSelf.tableDataSource removeAllObjects];
   
       int index=0;
       switch ([tag intValue]) {
         case 7:
           index=0;
           break;
         case 4:
           index=1;
           break;
         case 1:
           index=2;
           break;
         case 5:
           index=3;
           break;
         default:
           break;
       }
       NSMutableArray *imageUrlGroup=[NSMutableArray array];
      NSMutableArray *titleArray=[NSMutableArray array];
       NSMutableArray *scrollDataArray=[NSMutableArray array];
       if (![tag isEqualToNumber:@(2)])
       {
         wSelf.iViewController.iBaseTableView=wSelf.iViewController.iBaseViewArray[index];
       }
       if ([page intValue]>0)
       {
         NSArray *freshArray=aData[@"data"];
         if (freshArray.count == 0) {
           wSelf.footerRefreshEnd = YES;
         }
         for (NSDictionary *dic in freshArray)
         {
           [wSelf constructScrollData:dic];
           [wSelf.tableDataSource addObject:wSelf.tableInfoVO];
         }
         if ([tag isEqualToNumber:@(2)])
         {
           [wSelf.tableDataArray addObjectsFromArray:wSelf.tableDataSource];
         }else{
           [wSelf.iViewController.iBaseTableView.dataSourceTable addObjectsFromArray:wSelf.tableDataSource];
         }
       }else{
         wSelf.footerRefreshEnd = NO;
         if ([tag isEqualToNumber:@(2)])
         {
           [wSelf.tableDataArray removeAllObjects];
         }else{
           [wSelf.iViewController.iBaseTableView.dataSourceTable removeAllObjects];
         }
         NSArray *imageScrollArray=aData[@"adList"];
         
         [CHCPGQuationDataCacheManager saveQuationDataCaches:imageScrollArray withIsScrollData:1 andQuationTag:[tag intValue]];

         for (NSDictionary *dict in imageScrollArray)
         {
           [wSelf constructScrollData:dict];
           NSString * imageStr = [wSelf.quationinfoVO.picture stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
           [imageUrlGroup addObject:imageStr];
           [scrollDataArray addObject:wSelf.quationinfoVO];
           [titleArray addObject:wSelf.quationinfoVO.title];
         }
         NSArray *imageArr=[[imageUrlGroup reverseObjectEnumerator] allObjects];
         NSArray *titleArr=[[titleArray reverseObjectEnumerator] allObjects];
         NSArray *scrollDataArr=[[scrollDataArray reverseObjectEnumerator] allObjects];
         if ([tag isEqualToNumber:@(2)])
         {
           self.imageGroups=[NSMutableArray arrayWithArray:imageArr];
           self.scrollTitleArray=[NSMutableArray arrayWithArray:titleArr];
           self.scrollDataSource =[NSMutableArray arrayWithArray:scrollDataArr];

         }
         else{
           self.iViewController.iBaseTableView.imageGroups=[NSMutableArray
                                                                                 arrayWithArray:
                                                                                 imageArr];
           self.iViewController.iBaseTableView.scrollDataArray = [NSMutableArray arrayWithArray:scrollDataArr];
           self.iViewController.iBaseTableView.iTitleArray=[NSMutableArray arrayWithArray:titleArr];
         }
         NSArray *tableInfoArray=aData[@"data"];
         [CHCPGQuationDataCacheManager saveQuationDataCaches:tableInfoArray withIsScrollData:0 andQuationTag:[tag intValue]];
         for (NSDictionary *dic in tableInfoArray)
         {
           [wSelf constructScrollData:dic];
           [wSelf.tableDataSource addObject:wSelf.tableInfoVO];
         }
        
         if ([tag isEqualToNumber:@(2)])
         {
           [wSelf.tableDataArray addObjectsFromArray:wSelf.tableDataSource];
         }
         else{
           if (wSelf.tableDataSource.count==0) {
             return ;
           }
           [wSelf.iViewController.iBaseTableView.dataSourceTable addObjectsFromArray:wSelf.tableDataSource];
           
         }
       }
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
}
/**
 *  根据用户的注册的猪场地址获取动态价格
 *
 *  @param uid         用户名
 *  @param aCompletion 回调
 */

- (void)getDynamicPriceInfoWithUid:(NSNumber *)uid completion:(void (^)(BOOL, NSString *))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_DynamicPriceCode];
  NSDictionary *param=@{@"uid":uid};
  
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
                          [wSelf.priceDataArray removeAllObjects];
                          NSDictionary *dict=aData[@"data"];
                          wSelf.area=dict[@"area"];
                          NSArray *listArray=dict[@"list"];
                        for (NSDictionary *dic in listArray)
                          {
                            NSArray *data=dic[@"data"];
                            if ([data isKindOfClass:[NSArray class]]) {
                              NSUserDefaults * myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.hecom.xinyun.GROUP150811A"];
                              [myDefaults setObject:data forKey:@"data"];
                              [myDefaults synchronize];
                            }
                            for (NSDictionary *dic1 in data)
                            {
                              [wSelf constructPriceData:dic1];
                              [wSelf.priceDataArray addObject:wSelf.priceInfoVO];
                            }
                          }
                          if (aCompletion)
                          {
                            aCompletion(YES,nil);
                          }
                        }
                        
                      }];
  
}
/**
 *  获取地区动态价格列表
 *
 *  @param city        定位的城市
 *  @param aCompletion 回调
 */
- (void)getAreaDynamicPriceInfoWithCity:(NSString *)city
                             completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  __weak typeof(self)wSelf = self;
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_RegionDynamicPrice];
  
  if (city==nil)
  {
    city=@"全国";
  }
  NSDictionary *param=@{@"city":city};
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
       [wSelf.priceDataArray removeAllObjects];
       NSDictionary *dict=aData[@"data"];
       NSArray *listArray=dict[@"list"];
      
       for (NSDictionary *dic in listArray) {
         NSArray *data=dic[@"data"];
         if ([data isKindOfClass:[NSArray class]]) {
           NSUserDefaults * myDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.hecom.xinyun.GROUP150811A"];
           [myDefaults setObject:data forKey:@"data"];
           [myDefaults synchronize];
         }
         
         for (NSDictionary *dic1 in data) {
           [wSelf constructPriceData:dic1];
           [wSelf.priceDataArray addObject:wSelf.priceInfoVO];
         }
       }
       if (aCompletion)
       {
         aCompletion(YES,nil);
       }
     }
   }];
  
}

/**
 * 获取地理位置,反地理编码
 */
- (void )getLocation
{  
  [[LocationManager sharedLocationManager] gecodeLocationCompeletionBlock:^(CLLocation *location,
                                                                            AMapLocationReGeocode *regeocode,
                                                                            NSError *error) {
    
    if (error)
    {
      HCLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
      
      if (error.code == AMapLocationErrorLocateFailed)
      {
        return;
      }
    }
    if (location)
    {
      if      (regeocode)
      {
        NSString * city = regeocode.city?[NSString stringWithFormat:@" %@",regeocode.city]:regeocode.district;
        self.iAddressArr=city;
      }
      else
      {
      }
    }
  }];
  
}
- (void)constructScrollData:(NSDictionary *)dict
{
  self.quationinfoVO=[[CHCQuationInfoVO alloc]initWithDic:dict];
  self.tableInfoVO=[[CHCQuationTableInfoVO alloc]initWithDic:dict];
}
- (void)constructScrollTableData:(NSArray *)array
{
  [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    CHCQuationInfoVO *quationInfo=[[CHCQuationInfoVO alloc]init];
    CHCQuationTableInfoVO *tableInfoVO=[[CHCQuationTableInfoVO alloc]init];
    [self.tableDataSource addObject:tableInfoVO];
    [self.scrollDataArray addObject:quationInfo];
  }];
}

- (void)constructPriceData:(NSDictionary *)dict
{
  self.priceInfoVO=[[CHCQuationPriceInfoVO alloc]initWithDic:dict];
}

- (void)readUserGoldData
{
  if (![CHCCommonInfoVO sharedManager].isLogin) {
    self.iViewController.goldLabel.text=@"未登录";
  }
  else
  {
    self.iViewController.goldLabel.text=[NSString stringWithFormat:@"%ld",
                                         (long)[[CHCPGGoldManager sharedCHCPGGoldManager] readUserGoldCount]];
  }
}
#pragma mark  NSMutableArray的懒加载
- (NSMutableArray *)imageGroups
{
  if (_imageGroups == nil)
  {
    _imageGroups = [[NSMutableArray alloc]init];
  }
  return _imageGroups;
  
}
- (NSMutableArray *)scrollDataArray
{
  if (_scrollDataArray == nil) {
    _scrollDataArray = [[NSMutableArray alloc]init];
  }
  return _scrollDataArray;
  
}
- (NSMutableArray *)tableDataArray
{
  if (_tableDataArray == nil)
  {
    _tableDataArray = [[NSMutableArray alloc]init];
  }
  return _tableDataArray;
}
- (NSMutableArray *)priceDataArray
{
  if (_priceDataArray == nil) {
    _priceDataArray = [[NSMutableArray alloc]init];
  }
  return _priceDataArray;
  
}

- (NSMutableArray *)tableDataSource{
  if (_tableDataSource==nil) {
    _tableDataSource=[[NSMutableArray alloc]init];
  }
  return _tableDataSource;
}

- (NSMutableArray *)scrollTitleArray{
  
  if (_scrollTitleArray == nil) {
    _scrollTitleArray = [[NSMutableArray alloc]init];
  }
  return _scrollTitleArray;
}
- (NSMutableArray *)scrollDataSource{

  if (_scrollDataSource == nil) {
    _scrollDataSource = [[NSMutableArray alloc]init];
  }
      return _scrollDataSource;
}
@end
