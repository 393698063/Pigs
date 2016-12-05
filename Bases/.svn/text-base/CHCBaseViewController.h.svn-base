/*!
 @header CHCBaseViewController MVC基类
 @abstract 基类Base MVC，以及Base MVC使用的Util
 @author Created by HEcom-PC on 15/7/9.
 @version Copyright (c) 2015年 Hecom. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "HCLog.h"
#import "AppDef.h"
#import "CHCBaseAppDef.h"

#import "CHCHttpRequestHandler.h"
#import "CHCHttpMultiConstructor.h"

#import "CHCCommonInfoVO.h"

#import "CHCSpinnerView.h"
#import "CHCMessageView.h"

#pragma mark - CHCBaseViewController
@class CHCBaseController;

/*!
 @class
 @abstract ViewController的基类
 */
@interface CHCBaseViewController : UIViewController
{
  CHCBaseController *iController;
  NSString *iTitleStr;
  __weak UINavigationBar *iNavBar;
}

#pragma mark property list
/*!
 @property
 @abstract V所持有的C
 */
@property (nonatomic, strong)CHCBaseController *iController;

/*!
 @property
 @abstract 界面的title，ViewDidload的时候，将其显示在nav上面
 */
@property (nonatomic, strong)NSString *iTitleStr;

/*!
 @property
 @abstract 界面的navbar，需要子类关联xib上的navbar
 */
@property (nonatomic, weak) IBOutlet UINavigationBar *iNavBar;

#pragma mark method list
/*!
 @method
 @abstract 初始化方法
 @discussion
 @param nibBundleOrNil bundle name
 @result
 */
- (instancetype)initWithNibAndBundle:(NSBundle *)nibBundleOrNil;

/*!
 @method
 @abstract deprecated
 */
- (instancetype)initWithPipekey:(NSString *)aPipekey __deprecated_msg("Method deprecated.");
- (id)putData:(NSObject *)aInputData __deprecated_msg("Method deprecated.");

/*!
 @method
 @abstract push方式展示下级界面
 @discussion
 @param aVC 需要被push的界面
 @param animation 是否有动画，默认为YES
 @result
 */
- (void)showVC:(CHCBaseViewController *)aVC animation:(BOOL)animation;
- (void)pushVC:(CHCBaseViewController *)aVC;

/*!
 @method
 @abstract 返回yes则在self.view上添加结束编辑的点击事件。
 @discussion
 @result BOOL 是否需要在self.view上添加结束编辑的点击事件
 */
- (BOOL)isNeedBaseViewTapAction;

/**
 *  是否需要添加返回手势，一般在根控制器复写这个方法
 *
 *  @return yes 需要
 */
- (BOOL)isNeedRightGestureRecognizer;
/*!
 @method
 @abstract init的时候被调用的方法，用于为属性赋值
 @discussion
 @warning 子类复写必须调用super，否则会导致无法自动建立MVC关系
 @result
 */
- (void)creatObjsWhenInit;

/*!
 @method
 @abstract View使用，获取对应Controller的名称
 @discussion
 @result NSString Controller对应的类名
 */
- (NSString *)creatControllerName;

/*!
 @method
 @abstract 返回YES，则在回处理tableview在iOS7之后分割线出现的空白。
 @discussion
 @result NSString Controller对应的类名
 */
- (BOOL)isNeedDealTableViewBlankSeparator;
/*!
 @method
 @abstract 返回YES，则在回处理tableview在iOS7之后分割线出现的空白。
 @discussion
 @param aTableView 与isNeedDealTableViewBlankSeparator一起使用，
                    去掉tableview分割线左端空白
 @result NSString Controller对应的类名
 */
- (void)dealTableBlankSeparator:(UITableView *)aTableView;

/*!
 @method
 @abstract 返回YES，则会添加键盘监听。
 @discussion
 @result NSString Controller对应的类名
 */
- (BOOL)isNeedNoticeForKeyboard;

/**
 *  添加无网络页面
 */
- (void)addNoNetWrokView;
/**
 *  是否需要添加无网页面
 *
 *  @return
 */
- (BOOL)isNeedNoNetworkView;
/**
 *  展示无网页面
 */
- (void)showNoNetWorkView;
/**
 *  隐藏无网页面
 */
- (void)hideNoNetWorkView;
/**
 *  无网页面点击事件
 */
- (void)noNetWorkButtonAction;
/*!
 @method
 @abstract 键盘监听调用的方法，需要子类复写
 @discussion
 @param aKeyboardFrame 键盘的frame
 @param isShowing YES表示弹出键盘，NO表示收起键盘
 @result NSString Controller对应的类名
 */
- (void)keyboard:(CGRect)aKeyboardFrame beingShow:(BOOL)isShowing;

/*!
 @method
 @abstract unused
 */
- (void)reset __unused;
- (NSString *)pageNameForCurPage __unused;

@end



#pragma mark - CHCBaseController
@class CHCBaseModelHandler;

/*!
 @class
 @abstract Controller的基类
 */
@interface CHCBaseController : NSObject
{
  CHCBaseModelHandler *iModelHandler;
  __weak CHCBaseViewController *iViewController;
}

#pragma mark property list
/*!
 @property
 @abstract Controller对应的ModuleHandler
 */
@property (nonatomic, strong) CHCBaseModelHandler *iModelHandler;

/*!
 @property
 @abstract Controller对应的View，弱引用
 */
@property (nonatomic, weak) CHCBaseViewController *iViewController;

#pragma mark method list

/*!
 @method
 @abstract 创建M，并且由C强持有，需要主动调用。目前V创建C之后会主动调用该方法
 @discussion
 @result
 */
- (void)putModelHandler;

/*!
 @method
 @abstract Controller使用，获取对应ModuleHandler的名称
 @discussion
 @result NSString ModuleHandler对应的类名
 */
- (NSString *)creatModelHandlerName;

/*!
 @method
 @abstract unused
 */
- (void)reset __unused;
@end



#pragma mark - CHCBaseModelHandler

/*!
 @class
 @abstract ModuleHandler的基类
 */
@interface CHCBaseModelHandler : NSObject

#pragma mark property list

#pragma mark method list
- (void)reset __unused;
/*!
 @method
 @abstract 获取Http实例，默认为单例，非必要情况不建议子类复写
 @discussion
 @result CHCHttpRequestHandler Http单例，每次网络请求时调用
 */
- (CHCHttpRequestHandler *)creatHttpHandler;

/*!
 @method
 @abstract 串行请求发送，约定请求以串行发送。
 @discussion
 @warning 此方法有别于sync的Http请求
 @param aServiceName 方法名，可以不带URL和端口。若aServiceName带URL和端口，则优先被使用。
 @param aParams 参数，支持dic，VO，fileVO
 @param completion 请求完成返回Block
 @result
 */
- (void)syncPostMethod:(NSString *)aServiceName
            parameters:(id)aParams
            completion:(THC_ReqCompletionBlock)completion
NS_DEPRECATED_IOS(1_0, 1_0, "Use syncPostMethod:parametersBlock:completion: instead");

/*!
 @method
 @abstract 串行请求发送，约定请求以串行发送。
 @discussion
 @warning 此方法有别于sync的Http请求
 @param aServiceName 方法名，可以不带URL和端口。若aServiceName带URL和端口，则优先被使用。
 @param aParams 参数，支持dic，VO，fileVO
 @param completion 请求完成返回Block
 @result
 */
- (void)syncPostMethod:(NSString *)aServiceName
       parametersBlock:(id (^)())aParams
            completion:(THC_ReqCompletionBlock)completion;

/*!
 @method
 @abstract 发送请求，可同时调用多次并行发送请求
 @discussion
 @param aServiceName 方法名，可以不带URL和端口。若aServiceName带URL和端口，则优先被使用。
 @param aParams 参数，支持dic，VO，fileVO
 @param completion 请求完成返回Block
 @result
 */
- (void)postMethod:(NSString *)aServiceName
        parameters:(id)aParams
        completion:(THC_ReqCompletionBlock)completion;

/*!
 @method
 @abstract 将要发送Http请求，可由子类复写，展示spinner
 @discussion
 @param aHandler 网络请求Handler
 @result
 */
- (void)shouldPostRequest:(CHCHttpRequestHandler *)aHandler;

/*!
 @method
 @abstract 已经发送Http请求，可由子类复写，do nothing
 @discussion
 @param aHandler 网络请求Handler
 @result
 */
- (void)didPostRequest:(CHCHttpRequestHandler *)aHandler;

/*!
 @method
 @abstract 将要发送Http请求，可由子类复写，展示spinner
 @discussion
 @param aHandler 网络请求Handler
 @param isSucceed 请求是否成功
 @result
 */
- (void)willFinishPostRrequest:(CHCHttpRequestHandler *)aHandler succeed:(BOOL)isSucceed;

/*!
 @method
 @abstract 将要发送Http请求，可由子类复写，do nothing
 @discussion
 @param aHandler 网络请求Handler
 @param isSucceed 请求是否成功
 @result
 */
- (void)didFinishPostRrequest:(CHCHttpRequestHandler *)aHandler succeed:(BOOL)isSucceed;

@end
