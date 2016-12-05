//
//  CHCPGCountHistoryDiaryViewController.m
//  Pigs
//
//  Created by HEcom on 16/7/23.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGCountHistoryDiaryViewController.h"
#import "CHCPGCountHistoryCell.h"
#import "CHCPGUserDataSycnViewController.h"
#import "CHCSqliteManager.h"
#import "SynchronzeDef.h"
#import "DateFomatterTool.h"
#import "UIView+frame.h"
#import "CHCPGCountOffViewController.h"
#import "UWDatePickerView.h"
#import "UIColor+Hex.h"
#import "MJRefresh.h"

@interface CHCPGCountHistoryDiaryViewController ()<UITableViewDataSource,UITableViewDelegate,UWDatePickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *iTableView;
@property (nonatomic,strong) CHCPGCountHistoryDiaryController * iController;
@end

@implementation CHCPGCountHistoryDiaryViewController
@dynamic iController;
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = @"历史日记";
}
- (BOOL)isNeedBaseViewTapAction
{
  return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  [self refreshAction];
  self.iTableView.tableFooterView = [[UIView alloc] init];
  self.iTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
  self.iTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}
- (void)refreshAction
{
  self.iController.iPage = @(0);
  self.iController.iSize = @(20);
  [self.iController readHistoryDataWithPage:@(0) size:@(20) compeletion:^(BOOL isSucceed, NSString *aDesc, BOOL isMore)
  {
    if (isSucceed) {
      [self.iTableView reloadData];
    }
    [self.iTableView.header endRefreshing];
    self.iTableView.footer.state = MJRefreshStateIdle;
  }];
}
- (void)loadMore
{
  NSNumber * page = @(self.iController.iPage.integerValue + 1);
  NSNumber * size = self.iController.iSize;
  [self.iController readHistoryDataWithPage:page size:size compeletion:^(BOOL isSucceed, NSString *aDesc,BOOL isMore)
  {
    if (isSucceed)
    {
      [self.iTableView reloadData];
    }
    if (!isMore)
    {
      [self.iTableView.footer endRefreshingWithNoMoreData];
    }
    else
    {
      [self.iTableView.footer endRefreshing];
    }
  }];
}
#pragma mark - UITableViewD
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.iController.iDateStrAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CHCPGCountHistoryCell * cell = [CHCPGCountHistoryCell countHistoryCellWithTableView:tableView];
  NSString * dateStr = [self.iController.iDateStrAry objectAtIndex:indexPath.row];
  if (![self.iController.iDateStrAry.firstObject isEqualToString:dateStr]) {
    [cell hideTopLineView];
  }
  [cell loadDate:dateStr];
  return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 55.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 40.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView * backGroudView = [[UIView alloc] init];
  backGroudView.left = 0;
  backGroudView.top = 0;
  backGroudView.width = [UIScreen mainScreen].bounds.size.width;
  backGroudView.backgroundColor = [UIColor colorWithHex:0xffeff3fc];
  backGroudView.height = [self tableView:tableView heightForHeaderInSection:section];
  
  UIView * backView = [[UIView alloc] init];
  backView.left = 0;
  backView.top = 10;
  backView.width = [UIScreen mainScreen].bounds.size.width;
  backView.height = 40;
  backView.backgroundColor = [UIColor whiteColor];
  [backGroudView addSubview:backView];
  
  UIButton * timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [timeButton setBackgroundImage:[UIImage imageNamed:@"count_callendar"] forState:UIControlStateNormal];
  timeButton.left = 10;
  timeButton.top = 4;
  timeButton.width = 31;
  timeButton.height = 31;
  [backView addSubview:timeButton];
  
  UILabel * timeLabel = [[UILabel alloc] init];
  timeLabel.text = @"选择日期";
  timeLabel.left = CGRectGetMaxX(timeButton.frame) + 10;
  timeLabel.top = 5;
  timeLabel.width = 60;
  timeLabel.height = 17;
  timeLabel.centerY = timeButton.centerY;
  timeLabel.font = [UIFont systemFontOfSize:14];
  [backView addSubview:timeLabel];
  
  UIButton * tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
  tapButton.frame = CGRectMake(0, 0, backGroudView.width, backGroudView.height);
  [tapButton addTarget:self action:@selector(timeSelect:) forControlEvents:UIControlEventTouchUpInside];
  [backGroudView addSubview:tapButton];
  return backGroudView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary * dateDic = [self.iController.iDateFormatAry objectAtIndex:indexPath.row];
  NSNumber * dateForm = [dateDic objectForKey:@"createAt"];
  [self checkHistoryWithDate:dateForm];
}

- (void)timeSelect:(UIButton *)button
{
  UWDatePickerView * datePicker = [UWDatePickerView instanceDatePickerView];
  datePicker.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
  datePicker.delegate = self;
  [datePicker setMinDate:nil maxDate:[NSDate dateWithTimeIntervalSinceNow:-3600 * 24]];
  [self.view addSubview:datePicker];
}
#pragma mark - datePickeDelegate
- (void)getSelectDate:(NSString *)date
{
  if (!date) {
    return;
  }
  if ([self.iController.iDateStrAry containsObject:date])
  {
    NSInteger index = [self.iController.iDateStrAry indexOfObject:date];
    NSDictionary * dateDic = [self.iController.iDateFormatAry objectAtIndex:index];
    NSNumber * dateForm = [dateDic objectForKey:@"createAt"];
    [self checkHistoryWithDate:dateForm];
  }
  else
  {
    NSString * message = [NSString stringWithFormat:@"您在%@没有写日记",date];
    [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                  withShowingText:message
                                                withIconImageName:nil];
  }
}
- (void)checkHistoryWithDate:(NSNumber *)date
{
  CHCPGCountOffViewController * avc = [[CHCPGCountOffViewController alloc] initWithDate:date];
  [self.navigationController pushViewController:avc animated:YES];
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

@interface CHCPGCountHistoryDiaryController ()
@property (nonatomic, strong) CHCSqliteManager * iSqliteManager;
@end

@implementation CHCPGCountHistoryDiaryController
- (instancetype)init
{
  if (self = [super init]) {
    self.iDateFormatAry = [NSMutableArray arrayWithCapacity:1];
    self.iDateStrAry = [NSMutableArray arrayWithCapacity:1];
    NSString * path = [NSString stringWithFormat:@"%@/%@",
                       [CHCPGUserDataSycnController createUserPath],
                       @"database.db"];
    HCLog(@"%@",path);
    self.iSqliteManager = [CHCSqliteManager creatSqliteManager:path];
  }
  return self;
}
- (void)readHistoryDataWithPage:(NSNumber *)page
                           size:(NSNumber *)size
                    compeletion:(void (^)(BOOL isSucceed, NSString * aDesc,BOOL isMore))aCompeltion
{
  
  NSString * nowStr = [DateFomatterTool getDateStringFromDate:[NSDate date] dateFormatter:@"YYYY-MM-dd"];
  nowStr = [NSString stringWithFormat:@"%@%@",nowStr,@" 00:00:00"];
  NSNumber * nowDateF = [DateFomatterTool getTimeStampWithDateStr:nowStr dateFormat:@"YYYY-MM-dd HH:mm:ss"];
  NSString * sql = [NSString stringWithFormat:@"SELECT CREATEAT FROM %@ WHERE CAST (CREATEAT AS signed) <= %@ ORDER BY CAST (CREATEAT AS signed) DESC LIMIT %@,%@",
                    HCPG_SimpDiaryTable,nowDateF,@(page.integerValue * size.integerValue),size];
  NSArray * dateAry = [self.iSqliteManager executeQueryRtnAry:sql];
  if ([page isEqualToNumber:@(0)])
  {
    [self.iDateFormatAry removeAllObjects];
    [self.iDateStrAry removeAllObjects];
  }
  [self.iDateFormatAry addObjectsFromArray:dateAry];
  [dateAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
  {
    NSNumber * dateNum = [obj objectForKey:@"createAt"];
    NSString * dateStr = [DateFomatterTool getDateStringFromTimeStamp:dateNum.longLongValue WithDateFormat:@"YYYY-MM-dd"];
    [self.iDateStrAry addObject:dateStr];
  }];
  if (aCompeltion)
  {
    self.iPage = page;
    if (dateAry.count < size.integerValue) {
      aCompeltion(YES,nil,NO);
    }
    else
    {
      aCompeltion(YES,nil,YES);
    }
  }
//  if ([self.iDateStrAry containsObject:nowStr]) {
//    NSInteger index = [self.iDateStrAry indexOfObject:nowStr];
//    [self.iDateStrAry removeObject:nowStr];
//    [self.iDateFormatAry removeObjectAtIndex:index];
//  }
}

@end

