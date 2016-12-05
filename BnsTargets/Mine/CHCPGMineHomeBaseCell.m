//
//  CHCPGMineHomeBaseCell.m
//  Pigs
//
//  Created by HEcom on 16/4/26.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGMineHomeBaseCell.h"

@implementation CHCPGMineHomeBaseCell

+ (id)cellWithTableView:(UITableView *)tableView
{
  CHCPGMineHomeBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
  if (!cell) {
    cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                         owner:nil
                                       options:nil].lastObject;
  }
  return cell;
}
- (void)loadData:(NSDictionary *)dict actionBlock:(void (^)(EHCCellTapType))block
{
  self.iActionblock = block;
}
+ (CGFloat)cellHeightWithType:(EHCMineHomeCellType)type
{
  CGFloat height = 0;
  switch (type) {
    case EHCMineHomeCellInfo:
      height = 130.0f;
      break;
     case EHCMineHomeCellList:
      height = 80.0f;//[UIScreen mainScreen].bounds.size.width /4;
      break;
    default:
      break;
  }
  return height;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
