//
//  CHCPGCustomCountedCallOutView.m
//  Pigs
//
//  Created by HEcom on 16/7/21.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGCustomCountedCallOutView.h"
#import "UIView+frame.h"

@implementation CHCPGCustomCountedCallOutView
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    self.backgroundColor = [UIColor clearColor];
    [self initSubViews];
  }
  return self;
}
- (void)initSubViews
{
  UIImageView * backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
  backImageView.image = [UIImage imageNamed:@"count_countedBack"];
  [self addSubview:backImageView];
  
  UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
  rightButton.width = 73;
  rightButton.height = 36;
  rightButton.top = backImageView.top;
  rightButton.right = backImageView.right;
  [rightButton setBackgroundImage:[UIImage imageNamed:@"count_bulbRight"] forState:UIControlStateNormal];
  [rightButton setTitle:@"去数猪" forState:UIControlStateNormal];
  [rightButton setImage:[UIImage imageNamed:@"count_access"] forState:UIControlStateNormal];
  [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
  [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
  [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
  [self addSubview:rightButton];
  UILabel * label = [[UILabel alloc] init];
  label.font = [UIFont systemFontOfSize:14];
  label.textAlignment = NSTextAlignmentCenter;
  label.text = @"数猪，得金币";
  label.left = backImageView.left;
  label.top = backImageView.top;
  label.height = rightButton.height;
  label.width = backImageView.width - rightButton.width;
  [self addSubview:label];
  
  self.iTapBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.iTapBUtton.frame = backImageView.frame;
  [self.iTapBUtton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:self.iTapBUtton];
}
- (void)tapAction:(UIButton *)button
{
  if ([self.delegate respondsToSelector:@selector(callOutViewTapAction)]) {
    [self.delegate callOutViewTapAction];
  }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
