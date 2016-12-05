//
//  CHCPGMineHomeFactory.m
//  Pigs
//
//  Created by HEcom on 16/6/27.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGMineHomeFactory.h"
#import "CHCPGMineHomeBaseCell.h"
#import "CHCPGMineHomeInfoCell.h"
#import "CHCPGMineHomeListCell.h"

@implementation CHCPGMineHomeFactory
+ (CHCPGMineHomeBaseCell *)cellFactofyWithTableView:(UITableView *)tableView
                                               data:(NSDictionary *)dict;
{
  CHCPGMineHomeBaseCell * cell = nil;
  NSInteger identify = [[dict objectForKey:@"identify"] integerValue];
  switch (identify) {
    case EHCMineHomeCellInfo:
    {
      cell = [CHCPGMineHomeInfoCell cellWithTableView:tableView];
      break;
    }
    case EHCMineHomeCellList:
    {
      cell = [CHCPGMineHomeListCell cellWithTableView:tableView];
      break;
    }
  }
  return cell;
}
@end
