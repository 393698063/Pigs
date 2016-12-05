//
//  CHCMEHouseKeeperConfigBaseCell.h
//  Eggs
//
//  Created by HEcom_wzy on 16/3/16.
//  Copyright © 2016年 Hecom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCBaseVO.h"

typedef enum
{
  EHCMEConfigCellTypeDefault = 0,
  EHCMEConfigCellTypeInput,  //可输入的cell
  EHCMEConfigCellTypeSelect,//下拉选择的cell
  EHCMEConfigCellTypeDatePick,//选择日期的cell
} EHCMEConfigCellType;
@interface CHCMEConfigBaseCell : UITableViewCell
@property (nonatomic, weak) CHCBaseVO *iViewVO;
-(NSString *)setShowValueWithValueArray:(NSArray *)aValueArray mutableSeparator:(NSString *)aSeparator;
+ (NSString *)cellReuseKey:(EHCMEConfigCellType)aType;
- (void)loadViewVO:(CHCBaseVO *)aVO;
- (void)cellSelected;

+ (CGFloat)heightForRow:(EHCMEConfigCellType)aType;
@end
