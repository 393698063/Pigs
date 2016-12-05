//
//  UITextField+InvisibleMenu.m
//  Eggs
//
//  Created by Lemon-HEcom on 16/3/31.
//  Copyright © 2016年 Hecom. All rights reserved.
//

#import "UITextField+EditLimit.h"

@implementation UITextField (EditLimit)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
  UIMenuController *menuController = [UIMenuController sharedMenuController];
  if (menuController)
  {
    [UIMenuController sharedMenuController].menuVisible = NO;
  }
  return NO;
}

@end
