//
//  CHCPGCHooseAddressViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/21.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define kScreenSize [UIScreen mainScreen].bounds.size
#import "CHCPGCHooseAddressViewController.h"
#import "CHCSqliteManager.h"
#import "UIView+frame.h"
#import "UIColor+Hex.h"
#import "CHCPGCommonDataSyncViewController.h"

@interface CHCPGCHooseAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *iTableView;
@property (nonatomic, copy) void (^AddressBlock)(NSMutableArray * addressAry);
@property (nonatomic, strong) NSMutableArray * iAddressAry;
@property (nonatomic, strong) NSMutableArray * iProvices;
@property (nonatomic, strong) NSMutableArray * iCitys;
@property (nonatomic, strong) NSMutableArray * iTowns;
@property (nonatomic, strong) NSMutableArray * iStreets;
@property (nonatomic, strong) CHCSqliteManager * iManager;
@property (nonatomic, assign) NSInteger iLevel;
@property (nonatomic, strong) NSMutableArray * iSelectAddress;
@end

@implementation CHCPGCHooseAddressViewController

- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = @"选择地址";
}
- (BOOL)isNeedBaseViewTapAction
{
  return NO;
}
- (instancetype)initWithAddressBlock:(void (^)(NSMutableArray * addressAry))AddressBlock
{
  if (self = [super init]) {
    self.AddressBlock = AddressBlock;
    [self initAddress];
    self.iLevel = 1;
    self.iSelectAddress = [NSMutableArray arrayWithCapacity:1];
  }
  return self;
}
- (void)initAddress
{
  NSString * path = [NSString stringWithFormat:@"%@/%@",[CHCPGCommonDataSyncController creatCommonPath],@"area.db"];
  self.iManager = [[CHCSqliteManager alloc] initWithDataBasePath:path];
  self.iAddressAry = [NSMutableArray arrayWithCapacity:1];
  NSString * sqlStr = [NSString stringWithFormat:@"%@",@"select * from v30_md_area where level = 1 "];
  self.iProvices = [[self.iManager executeQueryRtnAry:sqlStr] mutableCopy];
  [self.iAddressAry addObject:_iProvices];
  
  _iCitys = [NSMutableArray arrayWithCapacity:1];
  [self.iAddressAry addObject:_iCitys];
  
  _iTowns = [NSMutableArray arrayWithCapacity:1];
  [self.iAddressAry addObject:_iTowns];
  
  _iStreets = [NSMutableArray arrayWithCapacity:1];
  [self.iAddressAry addObject:_iStreets];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSArray * ary = [self.iAddressAry objectAtIndex:self.iLevel - 1];
  return ary.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString * reuseIdentify = @"reuseID";
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentify];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:reuseIdentify];
  }
  NSArray * ary = [self.iAddressAry objectAtIndex:self.iLevel - 1];
  NSDictionary * dataDic = [ary objectAtIndex:indexPath.row];
  cell.textLabel.text = [dataDic objectForKey:@"name"];
  return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  CGFloat height = 40;
  if (self.iSelectAddress.count == 0)
  {
    height = 0.1;
  }
  return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
  UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, height,kScreenSize.width)];
  bgView.backgroundColor = [UIColor whiteColor];
  UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 0.5)];
  topLine.backgroundColor = [UIColor colorWithHex:0xffd7dae3];
  [bgView addSubview:topLine];

  UIView * botLine = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, kScreenSize.width, 0.5)];
  botLine.backgroundColor = [UIColor colorWithHex:0xffd7dae3];
  [bgView addSubview:botLine];
  UILabel * addressLabel = [[UILabel alloc] init];
  addressLabel.textColor = [UIColor colorWithHex:0xffcccccc];
  addressLabel.left = 10;
  addressLabel.top = 0;
  addressLabel.size = CGSizeMake(kScreenSize.width - 20, height - 1);
  if (self.iSelectAddress.count == 0) {
//    addressLabel.text = @"选择猪场所在地址";
  }
  else
  {
    NSMutableString * address = [NSMutableString string];
    [self.iSelectAddress enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      [address appendString:obj];
    }];
    addressLabel.text = address;
  }
  [bgView addSubview:addressLabel];
  return bgView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSArray * ary = [self.iAddressAry objectAtIndex:self.iLevel - 1];
  NSDictionary * dataDic = [ary objectAtIndex:indexPath.row];
  [self.iSelectAddress addObject:[dataDic objectForKey:@"name"]];
  //  if (self.iLevel < 4)
  //  {
  NSMutableArray * tmpAry = [NSMutableArray arrayWithCapacity:1];
  NSString * sqlStr = [NSString stringWithFormat:@"select * from v30_md_area where parent_code = '%@' ",dataDic[@"code"]];
  tmpAry = [[self.iManager executeQueryRtnAry:sqlStr] mutableCopy];
  if (tmpAry.count == 0)
  {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.AddressBlock(self.iSelectAddress);
    return;
  }
  else if (tmpAry.count == 1)
  {
    //      [self.iSelectAddress addObject:@""];
    self.iLevel ++;
    NSDictionary * tmpDic = [tmpAry lastObject];
    sqlStr = [NSString stringWithFormat:@"select * from v30_md_area where parent_code = '%@' ",tmpDic[@"code"]];
    tmpAry = [[self.iManager executeQueryRtnAry:sqlStr] mutableCopy];
  }
  self.iLevel ++;
  NSMutableArray * mAry = [self.iAddressAry objectAtIndex:self.iLevel - 1];
  [mAry removeAllObjects];
  [mAry addObjectsFromArray:tmpAry];;
  [self.iTableView reloadData];
  //  }
  
  //  else
  //  {
  //
  //    [self dismissViewControllerAnimated:YES completion:NO];
  //    self.AddressBlock(self.iSelectAddress);
  //  }
}

- (IBAction)leftButtonAction:(id)sender
{
  if (self.iLevel == 1) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
  else
  {
    self.iLevel --;
    [self.iSelectAddress removeLastObject];
    NSMutableArray * mAry = [self.iAddressAry objectAtIndex:self.iLevel - 1];
    if (mAry.count == 0) {
      self.iLevel --;
    }
    [self.iTableView reloadData];
  }
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
