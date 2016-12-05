//
//  CHCMEHouseKeeperSelectCell.m
//  Eggs
//
//  Created by HEcom_wzy on 16/3/15.
//  Copyright © 2016年 Hecom. All rights reserved.
//

#import "CHCMEConfigSelectCell.h"
#import "CHCBaseConfigViewController.h"
#import "CHCBaseConfigSelectionViewController.h"
#import "CHCMEHouseKeeperBaseConfigViewController.h"

@interface CHCMEConfigSelectCell()
@property (nonatomic, weak) CHCBaseConfigVO *iViewVO;
@end

@implementation CHCMEConfigSelectCell
@dynamic iViewVO;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadViewVO:(CHCBaseVO *)aVO
{
  [super loadViewVO:aVO];
  
  self.iNameLabel.text = @"";
  self.iValueLabel.text = @"";
  CHCBaseConfigVO *aConfigVO = (CHCBaseConfigVO *)aVO;
  self.iNameLabel.text = aConfigVO.keyShowName;
  // 3、value的显示值
  self.iValueLabel.text = [self setShowValueWithValueArray:aConfigVO.valueArray 
                                          mutableSeparator:aConfigVO.mutableSelectSeparator];
}

-(void)cellSelected
{
  [super cellSelected];
  
  BOOL aMutiSelected = (self.iViewVO.selectType == EHCMESelectTypeMutiSelect);
  NSMutableArray *aMEDic = [[self.iViewVO.iVC.iController class] getDictionaryItemsWithItemCorrespondType:self.iViewVO.itemCorrespondType];
  // 根据对象内容，读取字典项

  for (id obj in self.iViewVO.valueIdArray) 
  {
    for (NSMutableDictionary *dict in aMEDic) 
    {
      NSString * valueId = [dict objectForKey:@"valueId"];
      if ([valueId isEqualToString:obj]) 
      {
        [dict setValue:@(1) forKey:@"valueSelected"];
      }
    }
  }
  // valueId\value\valueSelected
  [CHCBaseConfigSelectionViewController 
      enterConfigSelectVcWithSelectDictItems:aMEDic 
                                mutiSelected:aMutiSelected 
                                    titleStr:self.iViewVO.keyShowName
                                      pushVc:self.iViewVO.iVC 
                              selectComplete:^(NSArray *selectionInfo) {
    // 这里根据selectionInfo，给当前的选中状态赋值
    [self resetSelectedArrayInfoWithArray:selectionInfo];             
  }];
}

-(void)resetSelectedArrayInfoWithArray:(NSArray *)selectArray
{
  NSMutableArray *aValueArray = [NSMutableArray array];
  NSMutableArray *aValueIdArray = [NSMutableArray array];
  
  for (NSDictionary *dict in selectArray) 
  {
    if ([[dict objectForKey:@"valueSelected"] boolValue]) 
    {
      [aValueArray addObject:[dict objectForKey:@"value"]];
      [aValueIdArray addObject:[dict objectForKey:@"valueId"]];
    }
  }
  self.iViewVO.valueArray = aValueArray;
  self.iViewVO.valueIdArray = aValueIdArray;
  
  [(CHCBaseConfigController *)self.iViewVO.iVC.iController refreshCellDisplayInfoWithCellRowIndex:[self.iViewVO.rowIndex integerValue]];
  
  [self reloadValueLabelText];
  self.iViewVO.iVC.needAlertWhilePopVc = YES;
}

-(void)reloadValueLabelText
{
  if (self.iViewVO.valueArray.count > 0) 
  {
    NSMutableString *valueStr = [NSMutableString stringWithString:self.iViewVO.valueArray[0]];
    if (self.iViewVO.valueArray.count > 1) 
    {
      for (NSInteger i = 1; i < self.iViewVO.valueArray.count; i++) 
      {
        [valueStr appendString:[NSString stringWithFormat:@"%@%@", self.iViewVO.mutableSelectSeparator, self.iViewVO.valueArray[i]]];
      }
    }
    self.iValueLabel.text = valueStr;
  }
}

@end
