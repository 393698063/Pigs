//
//  CustomAlertView.h
//  BiaoZhun4
//
//  Created by 王飞 on 15/6/8.
//  Copyright (c) 2015年 Hecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomAlertView;

@protocol CustomAlertViewDelegate <NSObject>

- (void)customAlertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

// 支持消息对齐
@interface CustomAlertView : NSObject

@property (nonatomic, assign) id<CustomAlertViewDelegate> delegate;

- (id)initWithTitle:(NSString *)title
        description:(NSString *)description
       desAlignment:(NSTextAlignment)desAlignment
       cancelButton:(NSString *)cancelButton
           okButton:(NSString *)okButton
        cancelBlock:(void(^)(void))cancelBlock
            okBlock:(void(^)(void))okBlock
           delegate:(id<CustomAlertViewDelegate>)delegate;

+ (void)showAlertViewWithTitle:(NSString *)title
                   description:(NSString *)description
                  desAlignment:(NSTextAlignment)desAlignment
                  cancelButton:(NSString *)cancelButton
                      okButton:(NSString *)okButton
                   cancelBlock:(void(^)(void))cancelBlock
                       okBlock:(void(^)(void))okBlock
                      delegate:(id<CustomAlertViewDelegate>)delegate;

- (void)show;

@end
