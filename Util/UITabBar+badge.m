//
//  UITabBar+badge.m
//  Eggs
//
//  Created by libing on 16/4/6.
//  Copyright © 2016年 Hecom. All rights reserved.
//

#import "UITabBar+badge.h"
#define TabbarItemNums 3.0    //tabbar的数量 如果是5个设置为5.0
@implementation UITabBar (badge)
//显示小红点
- (void)showBadgeOnItemIndex:(int)index withNum:(NSString *)num
{
  //移除之前的小红点
  [self removeBadgeOnItemIndex:index];
  if ([num intValue] > 0)
  {
    //新建小红点
    UILabel *badgeView = [[UILabel alloc]init];
    badgeView.textColor = [UIColor whiteColor];
    badgeView.tag = 888 + index;
    badgeView.textAlignment = NSTextAlignmentCenter;
    badgeView.font = [UIFont boldSystemFontOfSize:10];
    badgeView.layer.cornerRadius = 7;//圆形
    badgeView.layer.masksToBounds = YES;
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 14, 14);//圆形大小为16
    
    if ([num intValue]< 100)
    {
      [badgeView setText:[NSString stringWithFormat:@"%@", num]];
    }
    else
    {
      badgeView.text = @"99+";
    }
    CGRect rect = [badgeView.text boundingRectWithSize:CGSizeMake(100, 20)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName : badgeView.font}
                                               context:nil];
    CGRect badgeRect = badgeView.frame;
    if (rect.size.width > 11)
    {
      badgeRect.size.width = rect.size.width + 4;
    }
    else
    {
      badgeRect.size.width = 14;
    }
    badgeView.frame = badgeRect;
    [self addSubview:badgeView];
  }
}
//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
  //移除小红点
  [self removeBadgeOnItemIndex:index];
}
//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
  //按照tag值进行移除
  for (UILabel *subView in self.subviews) {
    if (subView.tag == 888+index) {
      [subView removeFromSuperview];
    }
  }
}
@end
