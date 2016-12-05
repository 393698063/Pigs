//
//  HCAlert.m
//  FoodYou
//
//  Created by Lemon-HEcom on 15/11/27.
//  Copyright © 2015年 AZLP. All rights reserved.
//

#import "UITextField+NewSetText.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UITextField (NewSetText)

#pragma mark show Green Button
- (void)newSetText:(NSString *)aText
{
  [self performSelectorOnMainThread:@selector(newSetText:) withObject:aText waitUntilDone:YES];
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
                    replaceMethod(UITextField.class,
                                  @selector(setText:),
                                  @selector(newSetText:));
                });
}


@end
