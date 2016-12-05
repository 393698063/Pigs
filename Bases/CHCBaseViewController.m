/*!
 @header CHCBaseViewController MVC基类
 @abstract 基类Base MVC，以及Base MVC使用的Util
 @author Created by HEcom-PC on 15/7/9.
 @version Copyright (c) 2015年 Hecom. All rights reserved.
 */
#define kScreenSize [UIScreen mainScreen].bounds.size

#import "CHCBaseViewController.h"
#import "CHCSpinnerView.h"
#import "UIColor+Hex.h"
#import "CHCNoNetWorkView.h"

static NSString *const HC_STR_VIEWCONTROLLER = @"ViewController";
static NSString *const HC_STR_CONTROLLER = @"Controller";
static NSString *const HC_STR_MODELHANDLER = @"ModelHandler";

#pragma mark - CHCBaseUtil
@interface CHCBaseUtil : NSObject 
+(NSString *)replaceSuffix:(NSString *)aSufStr
                   withStr:(NSString *)aStr
                   ofClass:(Class)aClass;
@end
@implementation CHCBaseUtil
//替换传入aClass后半部分，由（aSufStr）替换为（aStr）。并返回对应的className
//未找到对应类，则会自动寻找父类对应类
+(NSString *)replaceSuffix:(NSString *)aSufStr
                   withStr:(NSString *)aStr
                   ofClass:(Class)aClass
{
  NSString *rtnClassName = nil;
  Class aOriginalClass = aClass;
  
  while ( !rtnClassName
         && [aOriginalClass isSubclassOfClass:[NSObject class]] )
  {
    NSString *aOriginalName = NSStringFromClass(aOriginalClass);
    NSMutableString *mutableClassName = [NSMutableString stringWithString:aOriginalName];
    
    if ([mutableClassName hasSuffix:aSufStr])
    {
      NSUInteger aLength = mutableClassName.length;
      NSRange range = NSMakeRange(aLength-aSufStr.length, aSufStr.length);
      [mutableClassName replaceCharactersInRange:range withString:aStr];
    }
    else
    {
      mutableClassName = nil;
    }
    
    Class controllerClass = NSClassFromString(mutableClassName?:@"");
    if (controllerClass)
    {
      rtnClassName = mutableClassName;
    }
    aOriginalClass = [aOriginalClass superclass];
  }
  
  return rtnClassName;
}

@end

#pragma mark - CHCBaseViewController
@interface CHCBaseViewController()<UIGestureRecognizerDelegate>
{
  dispatch_once_t iOnceToken;
  CGFloat iKeyBoardHeight;
}
@property (nonatomic) dispatch_once_t iOnceToken;
@property (nonatomic) CGFloat iKeyBoardHeight;
@end

@implementation CHCBaseViewController
@synthesize iController;
@synthesize iTitleStr;
@synthesize iNavBar;
@synthesize iOnceToken;
@synthesize iKeyBoardHeight;

#pragma mark init&dealloc方法
- (instancetype)init
{
  self = [super init];
  if (self)
  {
    [self creatObjsWhenInitOnce];
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    [self creatObjsWhenInitOnce];
  }
  return self;
}

-(instancetype)initWithNibAndBundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:NSStringFromClass([self class])
                         bundle:nibBundleOrNil];
  if (self)
  {
    [self creatObjsWhenInitOnce];
  }
  return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil
                        bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  if (self)
  {
    [self creatObjsWhenInitOnce];
  }
  return self;
}

- (instancetype)initWithPipekey:(NSString *)aPipekey
{
  self = [super init];
  if (self)
  {
    [self creatController];
  }
  return self;
}

#pragma mark creat Objs When Init
- (void)creatObjsWhenInitOnce
{
  dispatch_once(&iOnceToken,
                ^{
                  self.iController = [self creatController];
                  self.iController.iViewController = self;
                  [self.iController putModelHandler];
                  [self setNeedsStatusBarAppearanceUpdate];
                  
                  [self creatObjsWhenInit];
                });
}

- (void)creatObjsWhenInit
{
  //需要子类复写
}

- (CHCBaseController *)creatController
{
  CHCBaseController *aObj = nil;
  
  NSString *aControllerName = [self creatControllerName];
  Class controllerClass = NSClassFromString(aControllerName?:@"");
  if (controllerClass)
  {
    aObj = [[controllerClass alloc]init];
  }
  
  return aObj;
}

-(NSString *)creatControllerName
{
  Class viewControllerClass = [self class];

  NSString *rtnControllerName = [CHCBaseUtil replaceSuffix:HC_STR_VIEWCONTROLLER
                                                     withStr:HC_STR_CONTROLLER
                                                     ofClass:viewControllerClass];
  
  return rtnControllerName;
}

- (void)showVC:(CHCBaseViewController *)aVC animation:(BOOL)animation
{
  [self.navigationController pushViewController:aVC animated:animation];
}

- (void)pushVC:(CHCBaseViewController *)aVC
{
  [self showVC:aVC animation:YES];
}

- (id)putData:(NSObject *)aInputData
{
  return aInputData;
}

- (void)reset
{
  
}

#pragma mark 复写系统方法
-(void)viewDidLoad
{
  [super viewDidLoad];
  
  self.iNavBar.topItem.title = self.iTitleStr;
  self.view.backgroundColor = [UIColor colorWithHex:0xffeff3fc];
  if ([self isNeedRightGestureRecognizer])
  {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
  }
  if ([self isNeedBaseViewTapAction])
  {
    [self addTapGesture];
  }
  if ([self isNeedNoNetworkView]) {
    [self addNoNetWrokView];
  }
}

- (BOOL)isNeedRightGestureRecognizer
{
  return NO;
}
//滑动页面
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
  if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
  {
    return NO;
  }
  else
  {
    return YES;
  }
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//  return UIStatusBarStyleLightContent;
//}

#pragma mark 处理键盘监听
- (BOOL)isNeedNoticeForKeyboard
{
  return NO;
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if ( [self isNeedNoticeForKeyboard] )
  {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
  }
}

- (NSString *)pageNameForCurPage
{
  NSString *str = [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), self.iTitleStr?:@""];
  return str;
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  if ([self isNeedNoticeForKeyboard])
  {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
  }
}

- (void)keyboardDidShow:(NSNotification *)aNotification
{
  //获取键盘的高度
  NSDictionary *userInfo = [aNotification userInfo];
  NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
  CGRect keyboardRect = [aValue CGRectValue];
  
  //键盘的纵坐标
  self.iKeyBoardHeight = keyboardRect.size.height;
  
  [self keyboard:keyboardRect beingShow:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
  //获取键盘的高度
  NSDictionary *userInfo = [aNotification userInfo];
  NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
  CGRect keyboardRect = [aValue CGRectValue];
  
  [self keyboard:keyboardRect beingShow:NO];
}

- (void)keyboard:(CGRect)aKeyboardFrame
       beingShow:(BOOL)isShowing
{
  
}

#pragma mark 给view添加点击结束编辑事件，默认返回YES
- (BOOL)isNeedBaseViewTapAction
{
  return YES;
}
/**
 *  是否需要添加无网页面
 *
 *  @return
 */
- (BOOL)isNeedNoNetworkView
{
  //override the method
  return NO;
}
- (void)addNoNetWrokView
{
  __weak typeof(self)wSelf = self;
  CHCNoNetWorkView * view = [CHCNoNetWorkView noNetWorkViewWithCallback:^{
    [wSelf noNetWorkButtonAction];
  }];
  view.translatesAutoresizingMaskIntoConstraints = NO;
  view.tag = 160624;
  view.hidden = YES;
  [self.view addSubview:view];

  NSArray * hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:NSDictionaryOfVariableBindings(view)];
  NSArray * vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[view]-0-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(view)];
  [self.view addConstraints:hConstraints];
  [self.view addConstraints:vConstraints];
}
- (void)showNoNetWorkView
{
  UIView * view = [self.view viewWithTag:160624];
  view.hidden = NO;
  [self.view bringSubviewToFront:view];
}
- (void)hideNoNetWorkView
{
  UIView * view = [self.view viewWithTag:160624];
  view.hidden = YES;
  [self.view sendSubviewToBack:view];
}
- (void)noNetWorkButtonAction
{
  //overwrite the method
}
//给View添加点击事件。
- (void)addTapGesture
{
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                       action:@selector(baseViewTapGestureAction:)];
  [self.view addGestureRecognizer:tap];
}

- (void)baseViewTapGestureAction:(id)sender
{
  [self inputFieldEndEditing:YES];
}

- (void)inputFieldEndEditing:(BOOL)aBool
{
  [self.view endEditing:aBool];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  return [textField resignFirstResponder];
}

#pragma mark tableview缩进
- (BOOL)isNeedDealTableViewBlankSeparator
{
  return YES;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isNeedDealTableViewBlankSeparator])
  {
    //去除分割线行左侧空白
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
      [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
      [cell setLayoutMargins:UIEdgeInsetsZero];
    }
  }
}

- (void)dealTableBlankSeparator:(UITableView *)aTableView
{
  //去除表头空白
  if ([aTableView respondsToSelector:@selector(setContentInset:)])
  {
    //[aTableView setContentInset:UIEdgeInsetsMake(-36, 0, 0, 0)];
  }
  //去除行分割线左侧空白
  if ([aTableView respondsToSelector:@selector(setSeparatorInset:)])
  {
    [aTableView setSeparatorInset:UIEdgeInsetsZero];
  }
  if ([aTableView respondsToSelector:@selector(setLayoutMargins:)])
  {
    [aTableView setLayoutMargins:UIEdgeInsetsZero];
  }
  
}

- (BOOL)isNeedBaseViewDragTableAction
{
  return NO;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if ([self isNeedBaseViewDragTableAction])
  {
    [self.view endEditing:YES];
  }
}

@end



#pragma mark - CHCBaseController
@implementation CHCBaseController
@synthesize iModelHandler;
@synthesize iViewController;

#pragma mark init&dealloc方法
- (instancetype)init
{
  self = [super init];
  if (self)
  {
    //self.iModelHandler = [self creatModelHandler];
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 为属性赋值
//为moduleHandler赋值，由外界调用
- (void)putModelHandler
{
  self.iModelHandler = [self creatModelHandler];
}

- (CHCBaseModelHandler *)creatModelHandler
{
  CHCBaseModelHandler *aObj = nil;
  
  NSString *aModelHandlerName = [self creatModelHandlerName];
  Class modelHandlerClass = NSClassFromString(aModelHandlerName?:@"");
  if (modelHandlerClass)
  {
    aObj = [[modelHandlerClass alloc]init];
  }
  
  return aObj;
}

-(NSString *)creatModelHandlerName
{
  NSString *rtnModelHandlerName = nil;
  
  if (self.iViewController)
  {
    Class controllerClass = [self.iViewController class];
    rtnModelHandlerName = [CHCBaseUtil replaceSuffix:HC_STR_VIEWCONTROLLER
                                             withStr:HC_STR_MODELHANDLER
                                             ofClass:controllerClass];
    
  }
  else
  {
    Class controllerClass = [self class];
    rtnModelHandlerName = [CHCBaseUtil replaceSuffix:HC_STR_CONTROLLER
                                             withStr:HC_STR_MODELHANDLER
                                             ofClass:controllerClass];
  }
  
  return rtnModelHandlerName;
}

- (void)reset
{
  
}
@end



#pragma mark - CHCBaseModelHandler
@implementation CHCBaseModelHandler

#pragma mark init&dealloc方法
- (void)dealloc
{
  [[self creatHttpHandler] cancelRequest];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reset
{
  
}

#pragma mark 获取HttpHandler
- (CHCHttpRequestHandler *)creatHttpHandler
{
  return [CHCHttpRequestHandler sharedInstance];
}

#pragma mark 发送网络请求
- (void)syncPostMethod:(NSString *)aServiceName
            parameters:(id)aParams
            completion:(THC_ReqCompletionBlock)completion
NS_DEPRECATED_IOS(1_0, 1_0, "Use syncPostMethod:parametersBlock:completion: instead");
{
  [self postMethod:aServiceName
   parametersBlock:
   ^id ()
   {
     return aParams;
   }
        completion:completion];
}

- (void)syncPostMethod:(NSString *)aServiceName
       parametersBlock:(id (^)())aParams
            completion:(THC_ReqCompletionBlock)completion
{
  CHCHttpRequestHandler *aHandler = [self creatHttpHandler];
  dispatch_async(aHandler.iSerialQueue,
                 ^{
                   dispatch_semaphore_wait(aHandler.iSemaphore, DISPATCH_TIME_FOREVER);
                   [self postMethod:aServiceName
                    parametersBlock:aParams
                         completion:
                    ^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
                    {
                      completion(aFlag, aDesc, error, aData);
                      dispatch_semaphore_signal(aHandler.iSemaphore);
                    }];
                 });
  
}

- (void)postMethod:(NSString *)aServiceName
        parameters:(id)aParams
        completion:(THC_ReqCompletionBlock)completion
{
  [self postMethod:aServiceName
   parametersBlock:
   ^id ()
   {
     return aParams;
   }
        completion:completion];
}


- (void)postMethod:(NSString *)aServiceName
   parametersBlock:(id (^)())aParamsBlock
        completion:(THC_ReqCompletionBlock)completion
{
  id reqData = nil;
  id aParams = nil;
  if (aParamsBlock)
  {
    aParams = aParamsBlock();
  }
  
  if ([aParams isKindOfClass:[CHCHttpMultiConstructor class]])
  {
    reqData = aParams;
  }
  else if ([aParams isKindOfClass:[CHCBaseVO class]])
  {
    CHCBaseVO *aReqVO = aParams;
    [aReqVO fillVoDictionary];
    reqData = aReqVO.voDictionary;
  }
  else if ([aParams isKindOfClass:[NSDictionary class]])
  {
    reqData = aParams;
  }
  else
  {
    reqData = nil;
  }
  
  if (reqData)
  {
    CHCHttpRequestHandler *aHandler = [self creatHttpHandler];
    [self shouldPostRequest:aHandler];
    
    //声明成功过返回Block
    void (^ aSucceed)(NSURLSessionDataTask *task, id responseObject) =
    ^(NSURLSessionDataTask *task, id responseObject)
    {
      [self willFinishPostRrequest:aHandler succeed:YES];
      
      //请求成功
      NSString *flag = [responseObject objectForKey:HC_HTTP_ReturnKey_flag];
      NSString *desc = [responseObject objectForKey:HC_HTTP_ReturnKey_desc];
      
      //flag 为空串或者nil，构造error返回。
      NSError *error = nil;
      if ( !flag )
      {
        flag = @"-1";
        NSString *domain = NSLocalizedStringFromTable(@"HTTPFlagError", HC_LocalizedstringTable_FWHTTP, nil);
        NSString *userInfo = [NSString stringWithFormat:@"The return flag is \"%@\"",flag];
        error = [NSError errorWithDomain:domain
                                    code:HC_HTTPERROR_FlagNilOrEmptyError_code
                                userInfo:@{HC_HTTPERROR_FlagNilOrEmptyError_userinfo:userInfo}];
      }
      
      //desc为nil转化为空串。
      if (!desc)
      {
        desc = @"";
      }
      
      //返回block
      completion( [flag integerValue], desc, error, responseObject );
      
      [self didFinishPostRrequest:aHandler succeed:YES];
      
    };
    
    //声明失败返回Block
    void (^ aFailure)(NSURLSessionDataTask *task, NSError *error) =
    ^(NSURLSessionDataTask *task, NSError *error)
    {
      [self willFinishPostRrequest:aHandler succeed:YES];
      
      NSString *domain = NSLocalizedStringFromTable(@"HTTPConnectError", HC_LocalizedstringTable_FWHTTP, nil);
      NSError *newError = [NSError errorWithDomain:domain code:error.code userInfo:error.userInfo];
      completion( HC_HTTPERROR_NetworkError_flag, domain, newError, nil );
      
      [self didFinishPostRrequest:aHandler succeed:NO];
      
    };
    
    //NSURLSessionDataTask *aTask =
    [aHandler HCPOST:aServiceName
          parameters:reqData
             success:aSucceed
             failure:aFailure];
    [self didPostRequest:aHandler];
    
  }
  else
  {
    NSString *domain = NSLocalizedStringFromTable(@"HTTPNilDataError", HC_LocalizedstringTable_FWHTTP, nil);
    NSError *newError = [NSError errorWithDomain:domain code:HC_HTTPERROR_NilData_code userInfo:nil];
    completion( HC_HTTPERROR_NetworkError_flag, nil, newError, nil );
  }
  
}

#pragma mark 网络请求切面处理
- (void)shouldPostRequest:(CHCHttpRequestHandler *)aHandler
{
  [[CHCSpinnerView sharedSpinnerView] showInWindowsIsFullScreen:YES
                                                withShowingText:NSLocalizedStringFromTable(@"Spinner_loading", @"Controller_MessageView", nil)];
}

- (void)didPostRequest:(CHCHttpRequestHandler *)aHandler
{
  
}

- (void)willFinishPostRrequest:(CHCHttpRequestHandler *)aHandler succeed:(BOOL)isSucceed
{
  [[CHCSpinnerView sharedSpinnerView]hiddenSpinnerView];
}

- (void)didFinishPostRrequest:(CHCHttpRequestHandler *)aHandler succeed:(BOOL)isSucceed
{
  
}

@end