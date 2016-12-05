//
//  CHCMessageView.h
//  NewHopeForAgency
//
//  Created by HEcom-PC on 15/7/14.
//  Copyright (c) 2015年 Hecom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHCMessageView : UIView
{
  BOOL isShow;
  CGSize iSize;
  UILabel *iLabel;
  NSString *iLabelText;
  UIImageView *iIconImageView;
  UIWindow *iAlertLevelWindow;
  UIWindow *iPreviouseKeyWindow;
  NSTimer *iDismissTimer;
}


/*!
 *	@property
 *	@abstract	isShow	是否显示
 */
@property (nonatomic)  BOOL isShow;

/*!
 *	@property
 *	@abstract	iSize	尺寸
 */
@property (assign) CGSize iSize;

/*!
 *	@property
 *	@abstract	iLabelText	文字框
 */
@property (nonatomic,strong)  UILabel *iLabel;

/*!
 *	@property
 *	@abstract	iLabelText	等待框旋转时显示的文字
 */
@property (nonatomic,strong)  NSString *iLabelText;

/*!
 *	@property
 *	@abstract	iImageView 显示的图片
 */
@property (nonatomic,strong)  UIImageView *iIconImageView;

/*!
 *	@property
 *	@abstract	iImageView 显示的图片
 */
@property (nonatomic,strong) NSTimer *iDismissTimer;

/*!
 *	@method
 *	@abstract	显示框到windows中
 *	@discussion
 *  @param  isFullScreen 是否全屏，否的话，不遮住状态栏和导航栏
 *	@param 	aMsg 	需要显示的消息
 *	@param 	aIconName 消息对应的iCon
 */
- (void)showInWindowsIsFullScreen:(BOOL)isFullScreen
                  withShowingText:(NSString *)aMsg
                withIconImageName:(NSString *)aIconName;

/*!
 *	@method
 *	@abstract	隐藏等待框
 *	@discussion
 */
- (void)hiddenSpinnerView;

/*!
 *	@method
 *	@abstract	获取单例的等待框
 *	@discussion	使用的是单例模式，注意在使用之后请隐藏
 *	@result	单例的等待框
 */
+ (CHCMessageView *)sharedMessageView;

@end
