//
//  CHCPGQutationChangeCityViewController.m
//  Pigs
//
//  Created by HEcom on 16/5/9.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define kScreenSize [UIScreen mainScreen].bounds.size
#import "CHCPGQutationChangeCityViewController.h"
#import "CHCSqliteManager.h"
#import "CHCPGCommonDataSyncViewController.h"
#import "NSString+Extensional.h"
#import "CHCPGCurrentLocationCell.h"
#import "UIColor+Hex.h"
#import "UIView+frame.h"
#import "LocationManager.h"

@interface CHCPGQutationChangeCityViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *iTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iTableViewBotConstraint;
@property (nonatomic, weak) UITextField * iSearBar;
@property (nonatomic, assign) BOOL iSearchFlag;
@property (nonatomic, strong) CHCPGQutationChangeCityController * iController;
@property (nonatomic, copy) void(^iChooseBlock)(NSDictionary * selectCity);
@end

@implementation CHCPGQutationChangeCityViewController
@dynamic iController;
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = @"选择城市";
}
- (BOOL)isNeedBaseViewTapAction
{
  return NO;
}
- (BOOL)isNeedNoticeForKeyboard
{
  return YES;
}
- (instancetype)initWithCityChooseBlock:(void (^)(NSDictionary * selectCity))iChooseBlock
{
  if (self = [super init])
  {
    self.iChooseBlock = iChooseBlock;
  }
  return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  UIView * searView = [self createSearchView];
  self.iSearBar = (UITextField *)([searView viewWithTag:10001]);
  self.iTableView.tableHeaderView = searView;
  self.iTableView.sectionIndexColor = [UIColor colorWithHex:0xffd7dae3];
  self.iTableView.sectionIndexBackgroundColor = [UIColor clearColor];
  [self.iController getLocationCompletion:^(BOOL isCompleted) {
    [self.iTableView reloadData];
  }];
}
- (UIView *)createSearchView
{
  UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
  bgView.backgroundColor = [UIColor clearColor];
  
  UITextField * searBar = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, kScreenSize.width - 20, 40)];
  searBar.tag = 10001;
  searBar.delegate = self;
  UIImageView * searchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
  searchView.contentMode = UIViewContentModeCenter;
  searchView.image = [UIImage imageNamed:@"xzcs_sousuo_"];
  searBar.leftView = searchView;
  searBar.leftViewMode = UITextFieldViewModeAlways;
  searBar.placeholder = @"搜索";
  searBar.backgroundColor = [UIColor whiteColor];
  searBar.layer.borderColor = [UIColor colorWithHex:0xffd7dae3].CGColor;
  searBar.layer.borderWidth = 0.5f;
  searBar.clearButtonMode = UITextFieldViewModeWhileEditing;
  [bgView addSubview:searBar];
  return bgView;
}
#pragma mark - UITableViewDelegate
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
  return self.iController.iCityTitleAry;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  NSArray * ary = self.iController.iCityTitleAry;
  if (self.iSearchFlag == YES) {
    ary = self.iController.iCityTitleResultAry;
  }
  NSString * title = @"";
  if (section != 0) {
    title = [ary objectAtIndex:section - 1];
  }
  return title;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
  HCLog(@"===%@  ===%ld",title,(long)index);
  NSInteger countIndex = 0;
  if (self.iSearchFlag == YES) {
    countIndex = 0;
  }
  else
  {
    countIndex = index + 1;
  }
  return countIndex;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView * header = nil;
  if (section != 0) {
    header = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    header.size = CGSizeMake(kScreenSize.width, height);
    header.backgroundColor = [UIColor colorWithHex:0xffeff3fc];
    
    if (section != 1) {
      UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 0.5)];
      topLine.backgroundColor = [UIColor colorWithHex:0xffd7dae3];
      [header addSubview:topLine];
    }
    
    UIView * botLine = [[UIView alloc] initWithFrame:CGRectZero];
    botLine.height = 0.5;
    botLine.width = kScreenSize.width;
    botLine.bottom = height;
    botLine.backgroundColor = [UIColor colorWithHex:0xffd7dae3];
    [header addSubview:botLine];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.5, kScreenSize.width - 20, height - 1)];
    NSString * title = [self tableView:tableView titleForHeaderInSection:section];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithHex:0xff333333];
    [header addSubview:titleLabel];
  }
  return header;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  NSArray * ary = self.iController.iCityDataAry;
  if (self.iSearchFlag == YES) {
    ary = self.iController.iCityResultAry;
  }
  return ary.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger  count = 1;
  NSArray * ary = self.iController.iCityDataAry;
  if (self.iSearchFlag == YES) {
    ary = self.iController.iCityResultAry;
  }

  if (section != 0) {
      NSArray * countAry = ary[section - 1];
    count = countAry.count;
  }
  else
  {
    if ([[self.iController.iLocationDict objectForKey:@"parent"] isEqualToString:@""])
    {
      count = 0;
    }
  }
  return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  CGFloat height = 0.1f;
  if (section != 0) {
    height = 25.0f;
  }
  return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@""];
  if (indexPath.section == 0) {
   cell = [CHCPGCurrentLocationCell currentLocationCellWithTableView:tableView];
    [((CHCPGCurrentLocationCell *)cell) loadData:self.iController.iLocationDict];
  }
  else
  {
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
      
    }
    NSArray * ary = self.iController.iCityDataAry;
    if (self.iSearchFlag == YES) {
      ary = self.iController.iCityResultAry;
    }
    NSArray * citys = [ary objectAtIndex:indexPath.section - 1];
    NSDictionary * city = [citys objectAtIndex:indexPath.row];
    cell.textLabel.text = [city objectForKey:@"area"];
  }
  return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat height = 44.0f;
  if (indexPath.section == 0) {
    
    height = 95.0f;
  }
  return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0) {
    self.iChooseBlock(self.iController.iLocationDict);
  }
  else
  {
    NSArray * ary = self.iController.iCityDataAry;
    if (self.iSearchFlag == YES) {
      ary = self.iController.iCityResultAry;
    }
    NSArray * dataAry = [ary objectAtIndex:indexPath.section - 1];
    NSDictionary * dataDic = [dataAry objectAtIndex:indexPath.row];
    self.iChooseBlock(dataDic);
  }
  [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - KeyboardDelegate
- (void)keyboard:(CGRect)aKeyboardFrame beingShow:(BOOL)isShowing
{
  if (isShowing) {
//    self.iResultTableViewBotConstraint.constant = aKeyboardFrame.size.height;
  }
  else
  {
//    self.iResultTableViewBotConstraint.constant = 0;
  }
  [self.view updateConstraintsIfNeeded];
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//  if (self.iSearchFlag == YES) {
//    [self.view endEditing:YES];
//    [self.iController.iCityResultAry removeAllObjects];
//    [self.iController.iCityTitleResultAry removeAllObjects];
//    [self.iController.iCityTitleResultAry addObjectsFromArray:self.iController.iCityTitleAry];
//    [self.iController.iCityResultAry addObjectsFromArray:self.iController.iCityDataAry];
//    self.iSearchFlag = NO;
//    [self.iTableView reloadData];
//  }
//}
#pragma mark - UITextFielDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  BOOL rtn = YES;
//  if (textField != self.iSearBar) {
//    [self.view bringSubviewToFront:self.iResultTableView];
//    [self.iSearBar becomeFirstResponder];
//    rtn = NO;
//  }
  self.iSearchFlag = YES;
  [self.iTableView reloadData];
  return rtn;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChange:(UITextField *)textField
{
  NSString * lang = [textField.textInputMode primaryLanguage];//键盘输入模式
  if ([lang isEqualToString:@"zh-Hans"]) {
    UITextRange * selectRange = [textField markedTextRange];
    
    UITextPosition * position = [textField positionFromPosition:selectRange.start offset:0];
    
    if (!position)
    {
      if (textField.text.length > 30)
      {
        textField.text = [textField.text substringToIndex:30];
      }
      [self searWithString:textField.text];
    }
  }
  else
  {
    if (textField.text.length > 30)
    {
      textField.text = [textField.text substringToIndex:30];
    }
    [self searWithString:textField.text];
  }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [textField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)searWithString:(NSString *)searStr
{
  NSString * noSpace = [searStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if ([noSpace isEqualToString:@""]) {
    self.iController.iCityTitleResultAry = [self.iController.iCityTitleAry mutableCopy];
    self.iController.iCityResultAry = [self.iController.iCityDataAry mutableCopy];
    [self.iTableView reloadData];
    return;
  }
  [self.iController.iCityResultAry removeAllObjects];
  [self.iController.iCityTitleResultAry removeAllObjects];
  NSString * pinyin = [[searStr pinyinForSort:NO] uppercaseString];
  NSString * firstCharactor = [pinyin substringToIndex:1];
  char charector = [firstCharactor characterAtIndex:0];
  if ((charector >= 65 && charector <= 90) ||
      (charector >= 97 && charector <= 122)) {
  [self.iController.iCityTitleResultAry addObject:firstCharactor];
  NSInteger index = [self.iController.iCityTitleAry indexOfObject:firstCharactor];
  NSArray * selectCity = [self.iController.iCityDataAry objectAtIndex:index];
  __block NSMutableArray * resultAry = [NSMutableArray arrayWithCapacity:1];
  [selectCity enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
   {
     NSDictionary * cityDic = (NSDictionary *)obj;
     NSString * cityName = [cityDic objectForKey:@"area"];
     NSString * cityPinyin = [[cityDic objectForKey:@"pinyin"] uppercaseString];
     if ([cityPinyin hasPrefix:[searStr uppercaseString]] || [cityName hasPrefix:searStr]) {
       [resultAry addObject:cityDic];
     }
  }];
    if (resultAry.count != 0) {
      [self.iController.iCityResultAry addObject:resultAry];
    }
  
  }
  [self.iTableView reloadData];
}
- (IBAction)leftButtonAcion:(id)sender
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

@interface CHCPGQutationChangeCityController ()
@property (nonatomic, strong) CHCSqliteManager * iManager;
@end

@implementation CHCPGQutationChangeCityController

- (instancetype)init
{
  if (self = [super init]) {
    self.iLocationDict = [NSMutableDictionary dictionaryWithObjects:@[@"",@""] forKeys:@[@"area",@"parent"]];
    [self prepareCityAry];
    [self prepareCityData];
  }
  return self;
}
- (void)getLocationCompletion:(void(^)(BOOL isCompleted))aCompletion
{
//  LocationManager * manager = [LocationManager sharedLocationManager];
//  if (manager.iProvice) {
//    [self.iLocationDict setObject:manager.iProvice forKey:@"parent"];
//    [self.iLocationDict setObject:manager.iCity forKey:@"area"];
//    if (aCompletion) {
//      aCompletion(YES);
//    }
//  }
//  else
//  {
    [[LocationManager sharedLocationManager] gecodeLocationCompeletionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
     {
       
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
         if (regeocode)
         {
           [self.iLocationDict setObject:regeocode.city?:regeocode.district forKey:@"area"];
           [self.iLocationDict setObject:regeocode.province forKey:@"parent"];
           if (aCompletion) {
             aCompletion(YES);
           }
         }
       }
     }];
//  }
  
}
- (void)prepareCityAry
{
  self.iCityDataAry = [NSMutableArray arrayWithCapacity:1];
  self.iCityTitleAry = [NSMutableArray arrayWithCapacity:1];
  self.iCityResultAry = [NSMutableArray arrayWithCapacity:1];
  for (char c = 'A'; c <= 'Z'; c ++) {
//    if (c != 'I' && c != 'O' && c != 'U' && c != 'V') {
      NSString * title = [NSString stringWithFormat:@"%c",c];
      [self.iCityTitleAry addObject:title];
      NSMutableArray * citys = [NSMutableArray arrayWithCapacity:1];
      [self.iCityDataAry addObject:citys];
//    }
  }
//  self.iCityResultAry = [self.iCityDataAry mutableCopy];
  self.iCityTitleResultAry = [self.iCityTitleAry mutableCopy];
}
- (void)prepareCityData
{
  NSString * path = [NSString stringWithFormat:@"%@/%@",[CHCPGCommonDataSyncController creatCommonPath],@"area.db"];
  self.iManager = [[CHCSqliteManager alloc] initWithDataBasePath:path];
  
  NSString * sqlStr = [NSString stringWithFormat:@"%@",@"select * from v30_md_popularArea where level = 2 and parent NOT IN ('海外','全国','宁夏回族','新疆维吾尔自治区','台湾','香港特别行政区','澳门特别行政区')"];
  NSArray * mDataAry = [self.iManager executeQueryRtnAry:sqlStr];
  NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES];
  NSArray * descriptorAry = @[descriptor];
  NSArray * dataAry = [mDataAry sortedArrayUsingDescriptors:descriptorAry];
  [self sortDataByFirstCharacter:dataAry];
  [self.iCityResultAry addObjectsFromArray:self.iCityDataAry];
}
- (void)sortDataByFirstCharacter:(NSArray *)dataAry
{
  FUNCBEGIN;
  [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary * dataDic = (NSDictionary *)obj;
    NSString * fCharactor = [self first:[dataDic objectForKey:@"pinyin"]];//[self firstCharactor:[dataDic objectForKey:@"area"]];
    NSInteger  index = [self.iCityTitleAry indexOfObject:fCharactor];
    NSMutableArray * citys = [self.iCityDataAry objectAtIndex:index];
    [citys addObject:obj];
  }];
  FUNCEND;
}
//此方法速度速度较慢
- (NSString *)firstCharactor:(NSString *)aString
{
  //转成了可变字符串
  NSMutableString *str = [NSMutableString stringWithString:aString];
  //先转换为带声调的拼音
  CFStringTransform((__bridge CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
  //再转换为不带声调的拼音
  CFStringTransform((__bridge CFMutableStringRef)str,NULL, kCFStringTransformStripCombiningMarks,NO);
  //转化为大写拼音
  NSString *pinYin = [str capitalizedString];
  HCLog(@"%@",pinYin);
//  获取并返回首字母
  return [pinYin substringToIndex:1];
  return @"A";
}
//此方法速度较快
- (NSString *)first:(NSString *)aString
{
  NSString * str = [aString pinyinForSort:NO];
  
  NSString * Cp = [str capitalizedString];
  
  return [Cp substringToIndex:1];
}
@end
