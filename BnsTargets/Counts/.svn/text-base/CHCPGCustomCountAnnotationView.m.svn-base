//
//  CHCPGCustomCountAnnotationView.m
//  Pigs
//
//  Created by HEcom on 16/7/21.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#define kcalloutWidth 176
#define kcalloutHeight 44

#import "CHCPGCustomCountAnnotationView.h"
#import "CHCPGCustomCountedCallOutView.h"

@interface CHCPGCustomCountAnnotationView ()<CustomCountedCallOutViewDelegate>
@property (nonatomic, strong,readwrite) CHCPGCustomCountedCallOutView * calloutView;
@end

@implementation CHCPGCustomCountAnnotationView
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  if (self.selected == selected) {
    return;
  }
  if (selected) {
    if (self.calloutView == nil) {
      self.calloutView = [[CHCPGCustomCountedCallOutView alloc] initWithFrame:CGRectMake(0, 0, kcalloutWidth, kcalloutHeight)];
      self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                            -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
      self.calloutView.delegate = self;
      [self addSubview:self.calloutView];
    }
  }
  else
  {
    //    [self.calloutView removeFromSuperview];
  }
  [super setSelected:selected animated:animated];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  UIView *view = [super hitTest:point withEvent:event];
  if (view == nil)
  {
    CGPoint tempoint = [self.calloutView.iTapBUtton convertPoint:point fromView:self];
    if (CGRectContainsPoint(self.calloutView.iTapBUtton.bounds, tempoint))
    {
      view = self.calloutView.iTapBUtton;
    }
  }
  return view;
}

#pragma mark - CustomCountedCallOutViewDelegate
- (void)callOutViewTapAction
{
  if ([self.iDelegate respondsToSelector:@selector(callOutViewTapAtion)]) {
    [self.iDelegate callOutViewTapAtion];
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
