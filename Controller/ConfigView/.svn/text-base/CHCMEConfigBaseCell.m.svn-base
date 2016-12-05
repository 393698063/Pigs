//
//  CHCMEHouseKeeperConfigBaseCell.m
//  Eggs
//
//  Created by HEcom_wzy on 16/3/16.
//  Copyright © 2016年 Hecom. All rights reserved.
//

#import "CHCMEConfigBaseCell.h"
//#import "CHCBaseConfigViewController.h"

@interface CHCMEConfigBaseCell()

@end

@implementation CHCMEConfigBaseCell
//@dynamic iViewVO;
static NSString const* HC_ME_CHCMEConfigDefultCell = @"CHCMEConfigDefultCell";
static NSString const* HC_ME_CHCMEConfigInputCell = @"CHCMEConfigInputCell";
static NSString const* HC_ME_CHCMEConfigSelectCell = @"CHCMEConfigSelectCell";
static NSString const* HC_ME_CHCMEConfigDatePickCell = @"CHCMEConfigDatePickCell";

+ (CGFloat)heightForRow:(EHCMEConfigCellType)aType
{
  CGFloat rtnValue = 48.0f;
  switch (aType)
  {
    case EHCMEConfigCellTypeInput:
    {
      rtnValue = 44.0f;
      break;
    }
    case EHCMEConfigCellTypeSelect:
    {
      rtnValue = 44.0f;
      break;
    }
    case EHCMEConfigCellTypeDatePick:
    {
      rtnValue = 44.0f;
      break;
    } 
    default:
      break;
  }
  return rtnValue;
}

+ (NSString *)cellReuseKey:(EHCMEConfigCellType)aType
{
  NSString *rtnValue = nil;
  switch (aType)
  {
    case EHCMEConfigCellTypeInput:
    {
      rtnValue = (NSString *)HC_ME_CHCMEConfigInputCell;
      break;
    }
    case EHCMEConfigCellTypeSelect:
    {
      rtnValue = (NSString *)HC_ME_CHCMEConfigInputCell;
      break;
    }
    case EHCMEConfigCellTypeDatePick:
    {
      rtnValue = (NSString *)HC_ME_CHCMEConfigDatePickCell;
    }
    default:
      rtnValue = (NSString *)HC_ME_CHCMEConfigDefultCell;
      break;
  }
  return rtnValue;
}

-(void)loadViewVO:(CHCBaseVO *)aVO
{
  self.iViewVO = (CHCBaseVO *)aVO;
}

-(NSString *)setShowValueWithValueArray:(NSArray *)aValueArray mutableSeparator:(NSString *)aSeparator
{
  NSString *showValue;
  if (!aValueArray || aValueArray.count == 0) 
  {
    showValue = @"";
  }
  else if (aValueArray.count == 1) 
  {
    showValue = [self calculateStringValueWith:aValueArray[0]];
  }
  else
  {
    NSMutableString *appendValue = [NSMutableString stringWithString:[self calculateStringValueWith:aValueArray[0]]];
    for (int i = 1; i < aValueArray.count; i++) {
      [appendValue appendString:aSeparator];
      [appendValue appendString:[self calculateStringValueWith:aValueArray[i]]];
    }
  }
  
  return showValue;
}

-(NSString *)calculateStringValueWith:(id)aObject
{
  if ([aObject isKindOfClass:[NSString class]]) 
  {
    return aObject;
  }
  else
  {
    return [aObject stringValue];
  }
}

- (void)cellSelected
{
  
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
