
#import <UIKit/UIKit.h>
#import "CHCAnnularView.h"

/*!
 *	@header	
 *	@abstract	等待旋转视图
 *	@discussion	使用单例模式
 *	@author	Lemon
 *	@copyright	Hecom
 *	@version	1.0 2015-06-29 14:45:23 Creation
 */
@interface CHCSpinnerView : UIView
{
  CGSize iSize;
  UILabel *iLabel;
  NSString *iLabelText;
  UIActivityIndicatorView *iShareAnnularView;
  UIWindow *iAlertLevelWindow;
  UIWindow *iPreviouseKeyWindow;
  BOOL isShow;
}

/*!
 *	@property
 *	@abstract	isShow	是否显示
 */
@property (nonatomic)  BOOL isShow;

/*!
 *	@property
 *	@abstract	iLabelText	等待框旋转时显示的文字
 */
@property (nonatomic,copy,setter = setILabelText:)  NSString *iLabelText;

/*!
 *	@property
 *	@abstract	iLabelText	文字框
 */
@property (nonatomic,strong)  UILabel *iLabel;

/*!
 *	@property
 *	@abstract	iSize	尺寸
 */
@property (assign) CGSize iSize;


/*!
 *	@method
 *	@abstract	获取单例的等待框
 *	@discussion	使用的是单例模式，注意在使用之后请隐藏
 *	@result	单例的等待框
 */
+ (CHCSpinnerView *)sharedSpinnerView;

/*!
 *	@method
 *	@abstract	显示框到windows中
 *	@discussion	
 *	@param 	isFullScreen 	是否全屏，否的话，不遮住状态栏和导航栏
 *	@param 	aText 	
 */
- (void)showInWindowsIsFullScreen:(BOOL)isFullScreen withShowingText:(NSString *)aText;

/*!
 *	@method
 *	@abstract	隐藏等待框
 *	@discussion	
 */
- (void)hiddenSpinnerView;

@end
