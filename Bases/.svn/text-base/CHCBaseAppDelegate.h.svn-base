/*!
 @header CHCBaseViewController MVC基类
 @abstract 基类Base MVC，以及Base MVC使用的Util
 @author Created by Lemon-HEcom on 15/9/7.
 @version Copyright (c) 2015年 Hecom. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "CHCBaseViewController.h"

/*!
 @class
 @abstract AppDelegate的基类
 */
@interface CHCBaseAppDelegate : UIResponder <UIApplicationDelegate>
{
  UIWindow *iWindow;
}

#pragma mark property list
/*!
 @property
 @abstract V所持有的C
 */
@property (strong, nonatomic) UIWindow *iWindow;

#pragma mark method list
/*!
 @method
 @abstract 获取首页的方法，需要子类复写
 @discussion
 @result
 */
- (UIViewController *)getFirstViewController;

/*!
 @method
 @abstract 是否开启push功能，需要子类复写
 @discussion
 @result
 */
- (BOOL)isNeedPushFunc;

@end
