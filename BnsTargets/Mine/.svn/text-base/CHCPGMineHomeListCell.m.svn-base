//
//  CHCPGMineHomeListCell.m
//  Pigs
//
//  Created by HEcom on 16/6/27.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#define kScreenSize [UIScreen mainScreen].bounds.size

#import "CHCPGMineHomeListCell.h"
#import "CHCPGMineHomeActionView.h"

@interface CHCPGMineHomeListCell ()<MineHomeActionProtocol>
@property (nonatomic, strong) NSMutableArray * iActionViews;
@end

@implementation CHCPGMineHomeListCell

- (void)loadData:(NSDictionary *)dict actionBlock:(void (^)(EHCCellTapType))block
{
  [super loadData:dict actionBlock:block];
  self.iViewController = [dict objectForKey:@"vc"];
  NSArray * datas = [dict objectForKey:@"data"];
  for (int i = 0; i < datas.count; i ++) {
    CHCPGMineHomeActionView * view = [self.iActionViews objectAtIndex:i];
    [view loadDataWithDict:[datas objectAtIndex:i]];
  }
}
- (CGFloat)cellHeight
{
  return kScreenSize.width / 4;
}
- (void)homeListTapActionWithType:(NSInteger)type
{
  self.iActionblock(type);
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  CGFloat viewW = kScreenSize.width / 4;
  CGFloat viewH = 80;
  for (int i = 0; i < 4; i ++) {
    CHCPGMineHomeActionView * view = [self.iActionViews objectAtIndex:i];
    view.frame = CGRectMake(i * viewW, 0, viewW, viewH);
  }
}
- (void)awakeFromNib {
    // Initialization code
  self.iActionViews = [NSMutableArray arrayWithCapacity:1];
  for (int i = 0; i < 4; i ++) {
    CHCPGMineHomeActionView * view = [CHCPGMineHomeActionView mineHomeActionView];
    view.delegate = self;
    [self.contentView addSubview:view];
    [self.iActionViews addObject:view];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
