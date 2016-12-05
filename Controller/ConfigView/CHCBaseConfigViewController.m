//
//  CHCBaseConfigViewController.m
//  Eggs
//
//  Created by HEcom_wzy on 16/3/14.
//  Copyright © 2016年 Hecom. All rights reserved.
//

#import "CHCBaseConfigViewController.h"
#import "CHCSqliteManager.h"
#import "CHCMEUserDataViewController.h"
#import "CHCSqliteManager.h"

@interface CHCBaseConfigViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)CHCBaseConfigController *iController;

@end

@implementation CHCBaseConfigViewController
@dynamic iController;

-(instancetype)init
{
  self = [super init];
  if (self) {
    [self creatObjsWhenInit];
    
  }
  
  return self;
}

-(BOOL)isNeedBaseViewTapAction
{
  return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
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

#pragma mark - tableView的代理方法和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.iController.iConfigArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = nil;
  
  CHCBaseConfigVO *aVO = [self.iController.iConfigArray objectAtIndex:indexPath.row];
  aVO.rowIndex = @(indexPath.row);
  NSString *reuseID = aVO.correspondCellName;
  
  cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
  if (!cell)
  {
    cell = [[[NSBundle mainBundle]loadNibNamed:reuseID owner:nil options:nil]lastObject];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone; 
  [(CHCMEConfigBaseCell *)cell loadViewVO:aVO];
  
  if (!cell)
  {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
  }
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.view endEditing:YES];
  CHCBaseConfigVO *baseConfigVO = self.iController.iConfigArray[indexPath.row];
  if ([baseConfigVO.enableEdit integerValue] == 1) 
  {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [(CHCMEConfigBaseCell *)cell cellSelected];
  }
}

-(void)reloadCellData
{
  
}

@end

@interface CHCBaseConfigController()
@property (nonatomic, weak)CHCBaseConfigViewController *iViewController;
@property (nonatomic, copy) NSString * iConfigPlistName;
@end

@implementation CHCBaseConfigController
@dynamic iViewController;

-(NSString *)getConfigTableTypeStringWith:(EHCHouseKeeperConfigType)aConfigType
{
  return nil;
}

-(void)getCellsCorrespondConfigVOFromConfigWithConfigType:(EHCHouseKeeperConfigType)aConfigType configPlistName:(NSString *)aConfigPlistName
{
  _iConfigArray = [NSMutableArray array];
  [self setConfigPlistName:aConfigPlistName];
  NSString *aPlistPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.iConfigPlistName];
  NSMutableArray *aConfig=[NSMutableArray arrayWithContentsOfFile:aPlistPath];
  
  for (id obj in aConfig)
  {
    NSString *tableType = [obj objectForKey:@"tableType"];
    NSString *currentTableType = [self getConfigTableTypeStringWith:aConfigType];
    if (tableType && [tableType isEqualToString:currentTableType]) 
    {
      NSArray *cellItems = [obj objectForKey:@"cellItems"];
      [cellItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CHCBaseConfigVO *aBaseVO = [[CHCBaseConfigVO alloc] initWithDic:obj];
        aBaseVO.enableChangeByOtherChange = YES;
        aBaseVO.iVC = self.iViewController;
        [self.iConfigArray addObject:aBaseVO];
      }];
      break;
    }
  }
}

- (void)setConfigPlistName:(NSString *)aConfigPlistName
{
  _iConfigPlistName = aConfigPlistName;
}

+(NSMutableArray * )getDictionaryItemsWithItemCorrespondType:(NSString *)aItemCorrespondType
{
  return nil;
}

- (void)dealWithInputValueDictInfo
{
  
  for (CHCBaseConfigVO *baseConfigVO in self.iConfigArray) 
  {
    
    if (baseConfigVO.codeKey && baseConfigVO.codeKey.length > 0) 
    {
      // 这里用于给IdArray赋值
      NSString *idArrStr = [self.iInputValueDict objectForKey:baseConfigVO.codeKey];
      if (idArrStr && ![idArrStr isKindOfClass:[NSNull class]]) 
      {
        if (baseConfigVO.mutableSelectSeparator && baseConfigVO.mutableSelectSeparator.length > 0) 
        {
          NSArray *idArray = [idArrStr componentsSeparatedByString:baseConfigVO.mutableSelectSeparator];
          baseConfigVO.valueIdArray = idArray;
        }
        else
        {
          baseConfigVO.valueIdArray = @[idArrStr];
        }
      }
      else
      {
        baseConfigVO.valueIdArray = nil;
      }
    }
    
    if (baseConfigVO.valueKey && baseConfigVO.valueKey.length > 0) 
    {
      NSString *valueArrStr = ([[self.iInputValueDict objectForKey:baseConfigVO.valueKey] isKindOfClass: [NSNull class]]) ? nil : [self.iInputValueDict objectForKey:baseConfigVO.valueKey];
      if (valueArrStr) 
      {
        if (baseConfigVO.mutableSelectSeparator && baseConfigVO.mutableSelectSeparator.length > 0) 
        {
          NSArray *valueArray = [valueArrStr componentsSeparatedByString:baseConfigVO.mutableSelectSeparator];
          baseConfigVO.valueArray = valueArray;
        }
        else
        {
          baseConfigVO.valueArray = @[valueArrStr];
        }
      }
      else
      {
        baseConfigVO.valueArray = nil;
      }
    }
    
    if (baseConfigVO.valueIdArray && baseConfigVO.valueIdArray.count > 0) 
    {
      [self putBaseConfigVOValueArrayWith:baseConfigVO];
    }
  }
}

-(void)putBaseConfigVOValueArrayWith:(CHCBaseConfigVO *)aBaseConfigVO
{
  
}

#pragma mark - 数据的正确性及有效性校验
-(NSString *)judgeInputInfoRightAndValidity
{
  // 数据的有效性校验，判断输入的数据是否合理
  for (CHCBaseConfigVO *baseVO in self.iConfigArray) 
  {
    NSString *judgeStr = [self judgeOneItemRightAndValidity:baseVO];
    if (judgeStr.length > 0) 
    {
      return judgeStr;
    }
  }
  
  return @"";
}

-(NSString *)judgeOneItemRightAndValidity:(CHCBaseConfigVO *)baseVO
{
  if ([baseVO.needCheckFilled integerValue] == 1 && baseVO.valueArray.count == 0) 
  {
    return [NSString stringWithFormat:@"%@不能为空", baseVO.keyShowName];
  }
  
  return @"";
}

#pragma mark - 获取要上传的参数
-(NSMutableDictionary *)getUploadParameters
{
  NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
  for (CHCBaseConfigVO *baseConfig in self.iConfigArray) 
  {
    /*
     获取要上传的参数，方法如下：
      首先判断当前有没有valueId，如果有valueId，则只上传valueId对应的key；
      如果没有valueId，则需要上传value对应的信息
     */

    if (baseConfig.valueIdArray && baseConfig.valueIdArray.count > 0) 
    {
      [parameter setObject:baseConfig.valueIdArray[0] forKey:baseConfig.codeKey];
    }
    if (baseConfig.valueArray && baseConfig.valueArray.count > 0)
    {
      [parameter setObject:baseConfig.valueArray[0] forKey:baseConfig.valueKey];
    }
  }
  
  return parameter;
}

-(void)refreshRelatedDataWithBaseConfigVO:(CHCBaseConfigVO *)aConfigVO
{
  
}

#pragma mark - 选择selectCell的时候，需要刷新当前的显示信息
-(void)refreshCellDisplayInfoWithCellRowIndex:(NSInteger)aCellIndex
{
  
}

#pragma mark - 判断相关的控件是否能根据当前空间的变化而变化
-(void)refreshRelatedDataCanChangedInfoWithBaseConfigVO:(CHCBaseConfigVO *)aConfigVO
{
  
}

@end

@implementation CHCBaseConfigVO



@end
