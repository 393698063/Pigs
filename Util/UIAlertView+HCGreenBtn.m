//
//  HCAlert.m
//  FoodYou
//
//  Created by Lemon-HEcom on 15/11/27.
//  Copyright © 2015年 AZLP. All rights reserved.
//

#import "UIAlertView+HCGreenBtn.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface CHCAlertView : UIAlertView
{
  UIAlertController *iAlertController;
}
@property (nonatomic, strong)UIAlertController *iAlertController;
@end

@implementation CHCAlertView
@synthesize iAlertController;
@end

@implementation UIAlertView (WAAlertViewCategory)

#pragma mark show Green Button
- (instancetype)initNewWithTitle:(NSString *)title
                         message:(NSString *)message
                        delegate:(id<UIAlertViewDelegate>)delegate
               cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitles:(NSString *)otherButtonTitles, ...
{
  self = [self init];
  self = nil;
  
  NSMutableArray *otherBtnTitleAry = [[NSMutableArray alloc] init];
  [otherBtnTitleAry addObject:otherButtonTitles];
  va_list params;  //定义一个指向个数可变的参数列表指针；
  id argument;
  if (otherButtonTitles)
  {
    va_start(params, otherButtonTitles);
    while ((argument = va_arg(params, id)))
    {//返回参数列表中指针arg_ptr所指的参数，返回类型为type，并使指针arg_ptr指向参数列表中下一个参数
      [otherBtnTitleAry addObject:argument];
    }
    va_end(params);//释放列表指针≥®
  }
  
  self = [[CHCAlertView alloc]initNewWithTitle:title
                                       message:message
                                      delegate:delegate
                             cancelButtonTitle:cancelButtonTitle
                             otherButtonTitles:[otherBtnTitleAry componentsJoinedByString:@","],nil];
  
  __weak typeof(delegate) wDelegate = delegate;
  
  if (self)
  {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //cancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:
                                   ^(UIAlertAction * action)
                                   {
                                     if (wDelegate && [wDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
                                     {
                                       [wDelegate alertView:self clickedButtonAtIndex:self.cancelButtonIndex];
                                     }
                                   }];
    @try
    {
      [cancelAction setValue:[UIColor colorWithRed:126.0f/255.0f green:147.0f/255.0f blue:103.0f/255.0f alpha:1.0f]
                      forKey:@"titleTextColor"];
    }
    @catch (NSException *exception)
    {
      
    }
    
    [alertController addAction:cancelAction];
    
    //other actions
    [otherBtnTitleAry enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop)
     {
       UIAlertAction *aAction = [UIAlertAction actionWithTitle:obj
                                                         style:UIAlertActionStyleDefault
                                                       handler:
                                 ^(UIAlertAction * action)
                                 {
                                   if (wDelegate && [wDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
                                   {
                                     [wDelegate alertView:self clickedButtonAtIndex:self.cancelButtonIndex+1+idx];
                                   }
                                 }];
       
       @try
       {
         [aAction setValue:[UIColor colorWithRed:126.0f/255.0f green:147.0f/255.0f blue:103.0f/255.0f alpha:1.0f]
                    forKey:@"titleTextColor"];
       }
       @catch (NSException *exception)
       {
         
       }
       [alertController addAction:aAction];
     }];
    ((CHCAlertView *)self).iAlertController = alertController;
  }
  return self;
}

- (void)newShow
{
  UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
  UIViewController *viewController = keyWindow.rootViewController;
  if ([self.delegate isKindOfClass:[UIViewController class]])
  {
    viewController = self.delegate;
  }
  else if ([self.delegate isKindOfClass:NSClassFromString(@"CHCBaseController")])
  {
    @try
    {
      viewController = [self.delegate valueForKey:@"iViewController"];
    }
    @catch (NSException *exception)
    {
      
    }
  }
  
  [viewController presentViewController:((CHCAlertView *)self).iAlertController
                               animated:YES
                             completion:^
   {
     
   }];
}

#pragma mark 方法替换
static void replaceMethod(Class c, SEL old, SEL new)
{
  Method oldMethod = class_getInstanceMethod(c, old);
  Method newMethod = class_getInstanceMethod(c, new);
  method_exchangeImplementations(oldMethod, newMethod);
}

#pragma mark 开始方法替换
+ (void)startInstanceMonitor
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken,^
                {
                  NSString *systemVersionStr = [[UIDevice currentDevice] systemVersion];
                  float systemVersion =[systemVersionStr floatValue];
                  
                  if (systemVersion >= 8.0)
                  {
                    replaceMethod(UIAlertView.class,
                                  @selector(initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:),
                                  @selector(initNewWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:));
                    replaceMethod(UIAlertView.class,
                                  @selector(show),
                                  @selector(newShow));
                  }
                });
}


@end
