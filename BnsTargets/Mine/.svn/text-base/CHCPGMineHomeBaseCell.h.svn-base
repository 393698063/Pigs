//
//  CHCPGMineHomeBaseCell.h
//  Pigs
//
//  Created by HEcom on 16/4/26.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCCommonInfoVO.h"

typedef NS_ENUM(NSInteger, EHCCellTapType)
{
  EHCCellTapGetCoin,
  EHCCellTapMyWallet,
  EHCCellTapCollect,
  EHCCellTapAuthentify,
  EHCCellTapSuggest,
  EHCCellTapShare
};

typedef NS_ENUM(NSInteger,EHCMineHomeCellType)
{
  EHCMineHomeCellInfo,
  EHCMineHomeCellList
};
@interface CHCPGMineHomeBaseCell : UITableViewCell
@property (nonatomic,copy) void(^iActionblock)(EHCCellTapType type);
@property (nonatomic, strong) UIViewController * iViewController;
+ (id)cellWithTableView:(UITableView *)tableView;
- (void)loadData:(NSDictionary *)dict actionBlock:(void (^)(EHCCellTapType type))block;
+ (CGFloat)cellHeightWithType:(EHCMineHomeCellType)type;
@end
