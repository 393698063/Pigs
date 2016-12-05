//
//  CHCMessageView.m
//  NewHopeForAgency
//
//  Created by HEcom-PC on 15/7/14.
//  Copyright (c) 2015年 Hecom. All rights reserved.
//

#import "CHCMessageView.h"
#import "CHCBaseAppDelegate.h"
#import "NSString+frame.h"

static CHCMessageView *sharedMessageView = nil;

#define NavigateBarHeight 44
#define kLabelFontSize 16.f
#define margin 20.0f
#define kPadding  4.f
#define HC_SHAREANNULARVIEW_FRAME CGRectMake(110.0f, 110.0f, 42.0f, 42.0f)

@interface CHCMessageView()
{
  UITapGestureRecognizer *iDisMissTap;
}

@property (nonatomic, strong) UITapGestureRecognizer *iDisMissTap;
@end

@implementation CHCMessageView
@synthesize iLabel;
@synthesize iIconImageView;
@synthesize iLabelText;
@synthesize iSize;
@synthesize isShow;
@synthesize iDisMissTap;
@synthesize iDismissTimer;

#pragma mark 生成自己的单例
+ (CHCMessageView *)sharedMessageView
{
  @synchronized(self)
  {
    if (sharedMessageView == nil)
    {
      sharedMessageView = [[CHCMessageView alloc] init];
      
      
      [sharedMessageView addShowingTextLabel];
      [sharedMessageView addSubview:[sharedMessageView creatIconImageView]];
      sharedMessageView.opaque = NO;
    }
    return sharedMessageView;
  }
}

- (instancetype)init
{
  self = [super init];
  if (self)
  {
    [self addTapDismissGesture];
  }
  return self;
}

- (void)addTapDismissGesture
{
  if (!self.iDisMissTap)
  {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(dismissAction:)];
    self.iDisMissTap = tap;
    [self addGestureRecognizer:tap];
  }
}

- (void)addTimerDismiss
{
  if (!self.iDismissTimer)
  {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.9f
                                                      target:self
                                                    selector:@selector(dismissAction:)
                                                    userInfo:nil
                                                     repeats:NO];
    self.iDismissTimer = timer;
  }
}

- (void)dismissAction:(id)sender
{
  if (sender == self.iDisMissTap || sender == self.iDismissTimer)
  {
    [sharedMessageView hiddenSpinnerView];
  }
}

- (UIImageView *)creatIconImageView
{
  {
    if (iIconImageView == nil)
    {
      iIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return iIconImageView;
  }
  
}

- (void)addShowingTextLabel {
  UILabel *aLabel = [[UILabel alloc] initWithFrame:self.bounds];
  self.iLabel = aLabel ;
  iLabel.adjustsFontSizeToFitWidth = NO;
  iLabel.textAlignment = NSTextAlignmentCenter;
  iLabel.opaque = NO;
  self.iLabel.numberOfLines = 0;
  iLabel.backgroundColor = [UIColor clearColor];
  iLabel.textColor = [UIColor whiteColor];
  iLabel.font = [UIFont boldSystemFontOfSize:kLabelFontSize];
  iLabel.text = self.iLabelText;
  [self addSubview:iLabel];
}

- (UIWindow *)getAlertLevelWindow
{
  if (iAlertLevelWindow == nil)
  {
    iAlertLevelWindow = [[UIWindow alloc] init];
    iAlertLevelWindow.windowLevel = UIWindowLevelAlert-5.0f;
    iAlertLevelWindow.backgroundColor = [UIColor clearColor];
    
    //修改status bar 颜色
    CHCBaseViewController *aVC = [[CHCBaseViewController alloc]init];
    [aVC.view setAlpha:0.0f];
    iAlertLevelWindow.rootViewController = aVC;
  }
  return iAlertLevelWindow;
  
}

- (void)hiddenSpinnerView
{
  [self.iDismissTimer invalidate];
  self.iDismissTimer = nil;
  
  if(iAlertLevelWindow)
  {
    [iPreviouseKeyWindow makeKeyAndVisible];
    iPreviouseKeyWindow = nil;
    [iAlertLevelWindow setHidden:YES];
    [iAlertLevelWindow removeFromSuperview];
    iAlertLevelWindow = nil;
  }
  self.isShow = NO;
  
  UIImageView *iconImage = [[CHCMessageView sharedMessageView] creatIconImageView];
  [iconImage setFrame:CGRectZero];
  [iconImage setImage:nil];
}

#pragma mark 显示到windows中
- (void)showInWindowsIsFullScreen:(BOOL)isFullScreen
                  withShowingText:(NSString *)aMsg
                withIconImageName:(NSString *)aIconName
{
  if(!isShow)
  {
    [self addTimerDismiss];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenSpinnerView) name:@"hiddenSpinnerViewBefore" object:nil];
    self.isShow = YES;
    UIWindow *window = [[CHCMessageView sharedMessageView] getAlertLevelWindow];
    CGRect frameOfWindow;
    if(isFullScreen)
    {
      frameOfWindow = [[UIScreen mainScreen] bounds];
    }
    else
    {
      frameOfWindow = [[UIScreen mainScreen] applicationFrame];
      frameOfWindow.size.height = frameOfWindow.size.height - NavigateBarHeight;
      frameOfWindow.origin.y = frameOfWindow.origin.y + NavigateBarHeight;
    }
    
    window.frame = frameOfWindow;
    [[CHCMessageView sharedMessageView] showInView:window withShowingText:aMsg withIconImageName:aIconName];
    
    if ([([UIApplication sharedApplication].delegate) isKindOfClass:[CHCBaseAppDelegate class]])
    {
      iPreviouseKeyWindow = ((CHCBaseAppDelegate *)[UIApplication sharedApplication].delegate).iWindow;
    }
    else
    {
      iPreviouseKeyWindow = [UIApplication sharedApplication].keyWindow;
    }
    [window makeKeyAndVisible];
  }
}

- (void)show
{
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

- (void)showInView:(UIView *)aView withShowingText:(NSString *)aText withIconImageName:(NSString *)aIconName
{
  CHCMessageView *spinnerView= [CHCMessageView sharedMessageView];

  UIImage *image = [UIImage imageNamed:aIconName];
  if (image)
  {
    UIImageView *iconImage  = [self creatIconImageView];
    [iconImage setImage:[UIImage imageNamed:aIconName]];

    CGRect frame = iconImage.frame;
    frame.size = image.size;
    iconImage.frame = frame;
  }
  
  //修改当参数为NO时。spinner显示靠下的BUG
  [spinnerView setFrame:CGRectMake(0, 0, aView.bounds.size.width, aView.bounds.size.height)];
  [aView addSubview:spinnerView];
  [spinnerView.superview bringSubviewToFront:spinnerView];
  spinnerView.iLabelText = aText;
  [[CHCMessageView sharedMessageView] show];
}

- (void)setILabelText:(NSString *)aLabelText
{
  iLabelText = aLabelText;
  iLabel.text = aLabelText;
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGRect allRect = self.bounds;
  // Draw rounded HUD bacgroud rect
  CGRect boxRect = CGRectMake(roundf((allRect.size.width - iSize.width) / 2),
                              roundf((allRect.size.height - iSize.height) / 2) , iSize.width, iSize.height);
  float radius2 = 10.0f;
  CGContextBeginPath(context);
  CGContextSetGrayFillColor(context, 0.0f, 0.618f);
  CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius2, CGRectGetMinY(boxRect));
  CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius2, CGRectGetMinY(boxRect) + radius2, radius2, 3 * (float)M_PI / 2, 0, 0);
  CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius2, CGRectGetMaxY(boxRect) - radius2, radius2, 0, (float)M_PI / 2, 0);
  CGContextAddArc(context, CGRectGetMinX(boxRect) + radius2, CGRectGetMaxY(boxRect) - radius2, radius2, (float)M_PI / 2, (float)M_PI, 0);
  CGContextAddArc(context, CGRectGetMinX(boxRect) + radius2, CGRectGetMinY(boxRect) + radius2, radius2, (float)M_PI, 3 * (float)M_PI / 2, 0);
  CGContextClosePath(context);
  CGContextFillPath(context);
}

#pragma mark - Layout

- (void)layoutSubviews
{
  
  CGRect bounds = self.bounds;
  // Determine the total widt and height needed
  CGFloat maxWidth = bounds.size.width - 4 * margin;
  CGSize totalSize = CGSizeZero;
  
  CGRect indicatorF = [[CHCMessageView sharedMessageView] creatIconImageView ].bounds;
  indicatorF.size.width = MIN(indicatorF.size.width, maxWidth);
  totalSize.width = MAX(totalSize.width, indicatorF.size.width);
  totalSize.height += indicatorF.size.height;
  
  CGSize labelSize = [iLabel.text sizeWithAttributes:@{NSFontAttributeName:iLabel.font}];
  if (labelSize.width > maxWidth)
  {
    labelSize.width = maxWidth;
  }
  
  CGFloat labelSizeH = ceil([iLabel.text heightWithFont:self.iLabel.font withinWidth:labelSize.width]);
  labelSize.height = labelSizeH;
  
  labelSize.width = MIN(labelSize.width, maxWidth);
  totalSize.width = MAX(totalSize.width, labelSize.width);
  totalSize.height += labelSize.height;
  if (labelSize.height > 0.f && indicatorF.size.height > 0.f)
  {
    totalSize.height += kPadding;
  }
  
  if (labelSize.height > 0.f)
  {
    totalSize.height += kPadding;
  }
  
  totalSize.width += 2 * margin;
  totalSize.height += 2 * margin;
  // Position elements
  CGFloat yPos = roundf(((bounds.size.height - totalSize.height) / 2)) + margin;
  CGFloat xPos = 0;
  indicatorF.origin.y = yPos;
  indicatorF.origin.x = roundf((bounds.size.width - indicatorF.size.width) / 2) + xPos;
  [[CHCMessageView sharedMessageView] creatIconImageView ].frame = indicatorF;
  yPos += indicatorF.size.height;
  
  if (labelSize.height > 0.f && indicatorF.size.height > 0.f)
  {
    yPos += kPadding;
  }
  CGRect labelF;
  labelF.origin.y = yPos;
  labelF.origin.x = roundf((bounds.size.width - labelSize.width) / 2) + xPos;
  labelF.size = labelSize;
  iLabel.frame = labelF;
  
  self.iSize = totalSize;
  
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
