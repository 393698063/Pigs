//
//  CHCPGCustomAnnotationView.m
//  Pigs
//
//  Created by HEcom on 16/7/15.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define kcalloutWidth 195
#define kcalloutHeight 184

#import "CHCPGCustomAnnotationView.h"
#import "CHCPGCustomCalloutView.h"

@interface CHCPGCustomAnnotationView ()<CustomCallOutViewDelegate>
@property (nonatomic, strong,readwrite) CHCPGCustomCalloutView * calloutView;
@end

@implementation CHCPGCustomAnnotationView

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  NSLog(@"%@",self.superview.superview);
  if (self.selected == selected) {
    return;
  }
  if (selected) {
    if (self.calloutView == nil) {
      self.calloutView = [[CHCPGCustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kcalloutWidth, kcalloutHeight)];
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

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  UIView *view = [super hitTest:point withEvent:event];
  if (view == nil)
  {
    CGPoint tempoint = [self.calloutView.iFatPigCountField convertPoint:point fromView:self];
    if (CGRectContainsPoint(self.calloutView.iFatPigCountField.bounds, tempoint))
    {
      view = self.calloutView.iFatPigCountField;
    }
    else if (CGRectContainsPoint(self.calloutView.iSowCountField.bounds,
                                 [self.calloutView.iSowCountField convertPoint:point fromView:self]))
    {
      view = self.calloutView.iSowCountField;
    }
    else if (CGRectContainsPoint(self.calloutView.iSubmitButton.bounds,
                                 [self.calloutView.iSubmitButton convertPoint:point fromView:self]))
    {
      view = self.calloutView.iSubmitButton;
    }
  }
  return view;
}
#pragma mark - CustomCallOutViewDelegate
- (void)submitFatPig:(NSString *)fatNum sow:(NSString *)sowNum
{
  if ([self.iDelegate respondsToSelector:@selector(submitFatPig:sow:)])
  {
    [self.iDelegate submitFatPig:fatNum sow:sowNum];
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
