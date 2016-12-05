
/*!
 *	@abstract	旋转等待框
 *	@discussion	旋转等待框视图
 */
#import "CHCSpinnerView.h"
#import "CHCBaseAppDelegate.h"

@implementation CHCSpinnerView


#define NavigateBarHeight 44
#define kLabelFontSize 16.f
#define margin 20.0f
#define kPadding  4.f
#define HC_SHAREANNULARVIEW_FRAME CGRectMake(110.0f, 110.0f, 42.0f, 42.0f)

static CHCSpinnerView *sharedSpinnerView = nil;

@synthesize iLabel;
@synthesize iSize;
@synthesize iLabelText;
@synthesize isShow;


#pragma mark 生成自己的单例
+ (CHCSpinnerView *)sharedSpinnerView
{
  @synchronized(self) 
  {
  if (sharedSpinnerView == nil) 
  {
    sharedSpinnerView = [[CHCSpinnerView alloc] init];
  
    
    [sharedSpinnerView addShowingTextLabel];
    [sharedSpinnerView addSubview:[sharedSpinnerView creatAnnularView]];
     
    sharedSpinnerView.opaque = NO;
  }
  return sharedSpinnerView;
  }
}


- (UIActivityIndicatorView *)creatAnnularView
{
  {
    if (iShareAnnularView == nil) 
    {
      iShareAnnularView = [[UIActivityIndicatorView alloc] initWithFrame:HC_SHAREANNULARVIEW_FRAME];
      [iShareAnnularView setCenter:CGPointMake(160, 140)];//指定进度轮中心点
      
      [iShareAnnularView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
      
      [self addSubview:iShareAnnularView];
    }
    return iShareAnnularView;
  }

}

- (void)addShowingTextLabel {
  UILabel *aLabel = [[UILabel alloc] initWithFrame:self.bounds];
  self.iLabel = aLabel ;
  iLabel.adjustsFontSizeToFitWidth = NO;
  iLabel.textAlignment = NSTextAlignmentCenter;
  iLabel.opaque = NO;
  iLabel.backgroundColor = [UIColor clearColor];
  iLabel.textColor = [UIColor whiteColor];
  iLabel.font = [UIFont boldSystemFontOfSize:kLabelFontSize];
  iLabel.text = self.iLabelText;
  [self addSubview:iLabel];
}

- (UIWindow *)creatAlertLevelWindow
{
  if (iAlertLevelWindow == nil) 
  {
    iAlertLevelWindow = [[UIWindow alloc] init];
    iAlertLevelWindow.windowLevel = UIWindowLevelAlert-5.0f;
    iAlertLevelWindow.backgroundColor = [UIColor clearColor];
    
    //修改statusbar颜色
    CHCBaseViewController *aVC = [[CHCBaseViewController alloc]init];
    [aVC.view setAlpha:0.0f];
    iAlertLevelWindow.rootViewController = aVC;
  }
  return iAlertLevelWindow;
    
}

- (void)hiddenSpinnerView
{
  if(iAlertLevelWindow)
  {
    [iPreviouseKeyWindow makeKeyAndVisible];
    iPreviouseKeyWindow = nil;
    [iAlertLevelWindow setHidden:YES];
    [iAlertLevelWindow removeFromSuperview];
    iAlertLevelWindow = nil;
  }
  self.isShow = NO;
//  [[[CHCSpinnerView sharedSpinnerView] creatAnnularView] stopTimer];
  [[self creatAnnularView] stopAnimating];

}

#pragma mark 显示到windows中
- (void)showInWindowsIsFullScreen:(BOOL)isFullScreen withShowingText:(NSString *)aText
{
  if(!isShow)
  {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenSpinnerView) name:@"hiddenSpinnerViewBefore" object:nil];
    self.isShow = YES;
    UIWindow *window = [[CHCSpinnerView sharedSpinnerView] creatAlertLevelWindow];
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
    [[CHCSpinnerView sharedSpinnerView] showInView:window withShowingText:aText];
  
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

- (void)showInView:(UIView *)aView withShowingText:(NSString *)aText
{
  CHCSpinnerView *spinnerView= [CHCSpinnerView sharedSpinnerView];
//  [self creatAnnularView].iProgress = 0.00f;
//  [[self creatAnnularView] startTimer];
  [self addSubview:[self creatAnnularView]];
  [[self creatAnnularView] startAnimating];
  //修改当参数为NO时。spinner显示靠下的BUG
  [spinnerView setFrame:CGRectMake(0, 0, aView.bounds.size.width, aView.bounds.size.height)];
  [aView addSubview:spinnerView];
  [spinnerView.superview bringSubviewToFront:spinnerView];
  spinnerView.iLabelText = aText;
  [[CHCSpinnerView sharedSpinnerView] show];
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
	
  CGRect indicatorF = [[CHCSpinnerView sharedSpinnerView] creatAnnularView ].bounds;
  indicatorF.size.width = MIN(indicatorF.size.width, maxWidth);
  totalSize.width = MAX(totalSize.width, indicatorF.size.width);
  totalSize.height += indicatorF.size.height;
	
  CGSize labelSize = [iLabel.text sizeWithAttributes:@{NSFontAttributeName:iLabel.font}];
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
  [[CHCSpinnerView sharedSpinnerView] creatAnnularView ].frame = indicatorF;
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

@end
