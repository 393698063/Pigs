//
//  UIButton+Extension.m
//  Pigs
//
//  Created by wangbin on 16/5/6.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)


+ (UIButton *)itemFrame:(CGRect)frame itemTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor withIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action{
  
  UIButton *button = [[UIButton alloc]initWithFrame:frame];
  button.backgroundColor=backgroundColor;
  [button setTitle:title forState:UIControlStateNormal];
  
  [button setTitleColor:titleColor forState:UIControlStateNormal];
  
  [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
  
  [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  return button;
  
  
  
  
}

@end
