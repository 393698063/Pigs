//
//  CHCPGGoldGif.m
//  Pigs
//
//  Created by HEcom on 16/5/18.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define kScreensize [UIScreen mainScreen].bounds.size
#import "CHCPGGoldGif.h"
#import "UIImageView+PlayGIF.h"
#import "CHCBaseAppDelegate.h"
#import "UIColor+Hex.h"
@implementation CHCPGGoldGif
+ (void)showWithMessage:(NSString *)message
{
  [self showWithMessage:message compeletion:nil];
}
+ (void)showWithMessage:(NSString *)message
            compeletion:(void (^)(BOOL compeleted, NSString * aDesc))aCompeletion
{
  UIWindow * mainWindow = ((CHCBaseAppDelegate *)[UIApplication sharedApplication].delegate).iWindow;
  UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreensize.width, kScreensize.height)];
  bgView.backgroundColor = [UIColor blackColor];
  bgView.alpha = 0.5;
  bgView.tag = 20000;
  [mainWindow addSubview:bgView];
  
  UIImage * goldBack = [UIImage imageNamed:@"goldBack"];
  CGRect backFrame = CGRectMake(0, 0, 0, 0);
  backFrame.size = goldBack.size;
  UIImageView * goldBackView = [[UIImageView alloc] initWithFrame:backFrame];
  goldBackView.center = mainWindow.center;
  goldBackView.image = goldBack;
  goldBackView.tag = 20001;
  [mainWindow addSubview:goldBackView];
  
  UIImage * goldAnima = [UIImage imageNamed:@"goldAnimate"];
  CGRect animaFrame = CGRectMake(0, 0, 0, 0);
  animaFrame.size = goldBack.size;
  UIImageView * animaView = [[UIImageView alloc] initWithFrame:backFrame];
  animaView.center = mainWindow.center;
  animaView.image = goldAnima;
  animaView.tag = 20002;
  [mainWindow addSubview:animaView];
  [self startAnimationWithView:animaView];
  
//  UIImage * gifImage = [UIImage sd_animatedGIFNamed:@"gold"];
  CGRect frame = CGRectMake(0, 0, 0, 0);
  frame.size = CGSizeMake(kScreensize.width, kScreensize.width);
  UIImageView * gifImageView = [[UIImageView alloc] initWithFrame:frame];
  gifImageView.center = mainWindow.center;
  gifImageView.tag = 20003;
//  gifImageView.image = gifImage;
  gifImageView.gifPath = [[NSBundle mainBundle] pathForResource:@"gold" ofType:@"gif"];
  [gifImageView startGIF];
  [mainWindow addSubview:gifImageView];
  
  CGFloat lableY = CGRectGetMinY(gifImageView.frame);
  UILabel * mLable = [[UILabel alloc] initWithFrame:CGRectMake(0, lableY - 15, kScreensize.width, 60)];
  mLable.tag = 20004;
  mLable.textAlignment = NSTextAlignmentCenter;
  mLable.textColor = [UIColor colorWithHex:0xffbd4ae2];
  mLable.font = [UIFont boldSystemFontOfSize:60];
  mLable.text = message;
  
  [mainWindow addSubview:mLable];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [gifImageView stopGIF];
    [self hideAnimation];
    if (aCompeletion)
    {
      aCompeletion(YES,nil);
    }
  });
}
+ (void)startAnimationWithView:(UIView *)view
{
  CABasicAnimation* rotationAnimation;
  rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
  rotationAnimation.duration = 3;
  rotationAnimation.cumulative = YES;
  rotationAnimation.repeatCount = MAXFLOAT;
  
  [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
+(void)hideAnimation
{
  UIWindow * mainWindow = ((CHCBaseAppDelegate *)[UIApplication sharedApplication].delegate).iWindow;
  for (int i = 0; i < 5; i++) {
    UIView * view = [mainWindow viewWithTag:20000 + i];
    [view removeFromSuperview];
    view = nil;
  }
}
@end
