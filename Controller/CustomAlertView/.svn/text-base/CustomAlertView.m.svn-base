//
//  CustomAlertView.m
//  BiaoZhun4
//
//  Created by 王飞 on 15/6/8.
//  Copyright (c) 2015年 Hecom. All rights reserved.
//

#import "CustomAlertView.h"

@interface StatusBarShowController : UIViewController

@end

@implementation StatusBarShowController

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationPortrait)
        return UIInterfaceOrientationMaskPortrait;
    else if (orientation == UIInterfaceOrientationLandscapeLeft)
        return UIInterfaceOrientationMaskLandscapeLeft;
    else if (orientation == UIInterfaceOrientationLandscapeRight)
        return UIInterfaceOrientationMaskLandscapeRight;
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
        return UIInterfaceOrientationMaskPortraitUpsideDown;

    return UIInterfaceOrientationMaskPortrait;
}

@end

@interface CustomAlertView () {
    NSString *_title;
    NSString *_description;
    NSTextAlignment _desAlignment;
    
    NSString *_cancelButtonName;
    NSString *_okButtonName;
    
    UIWindow *_contentWindow;
    UIAlertController *_alertController;
}

@property (nonatomic, copy) void(^cancelBlock)(void);
@property (nonatomic, copy) void(^okBlock)(void);

@end

@implementation CustomAlertView

- (id)initWithTitle:(NSString *)title
        description:(NSString *)description
       desAlignment:(NSTextAlignment)desAlignment
       cancelButton:(NSString *)cancelButton
           okButton:(NSString *)okButton
        cancelBlock:(void(^)(void))cancelBlock
            okBlock:(void(^)(void))okBlock
           delegate:(id<CustomAlertViewDelegate>)delegate {
    if (self = [super init]) {
        _title = title;
        _description = description;
        _desAlignment = desAlignment;
        _cancelButtonName = cancelButton;
        _okButtonName = okButton;
        self.cancelBlock = cancelBlock;
        self.okBlock = okBlock;
        self.delegate = delegate;
    }
    
    return self;
}

+ (void)showAlertViewWithTitle:(NSString *)title
                   description:(NSString *)description
                  desAlignment:(NSTextAlignment)desAlignment
                  cancelButton:(NSString *)cancelButton
                      okButton:(NSString *)okButton
                   cancelBlock:(void(^)(void))cancelBlock
                       okBlock:(void(^)(void))okBlock
                      delegate:(id<CustomAlertViewDelegate>)delegate {
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:title description:description desAlignment:desAlignment cancelButton:cancelButton okButton:okButton cancelBlock:cancelBlock okBlock:okBlock delegate:delegate];
    
    [alertView show];
}

- (void)dealloc {
    _contentWindow = nil;
}

- (void)show {
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_title message:_description preferredStyle:UIAlertControllerStyleAlert];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = _desAlignment;
        paragraphStyle.lineSpacing = 5.0f;
        NSDictionary *attributes = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                     NSParagraphStyleAttributeName: paragraphStyle
                                     };
        NSMutableAttributedString *attributedMessage = [[NSMutableAttributedString alloc] initWithString:_description];
        [attributedMessage addAttributes:attributes range:NSMakeRange(0, _description.length)];
        [alertController setValue:attributedMessage forKey:@"attributedMessage"];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:_cancelButtonName style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self handleCancelButton:alertController];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:_okButtonName style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self handleOkButton:alertController];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        
        _contentWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _contentWindow.backgroundColor = [UIColor clearColor];
        _contentWindow.windowLevel = UIWindowLevelAlert;
        [_contentWindow makeKeyAndVisible];
        
        StatusBarShowController *baseVC = [[StatusBarShowController alloc] init];
        baseVC.view.backgroundColor = [UIColor clearColor];
        _contentWindow.rootViewController = baseVC;

        [_contentWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        _alertController = alertController;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        [_alertController.view addGestureRecognizer:tapGesture];
    }
    else {
        UIAlertView *tmpAlertView = [[UIAlertView alloc] initWithTitle:_title message:_description delegate:self cancelButtonTitle:_cancelButtonName otherButtonTitles:_okButtonName, nil];
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            CGSize size = [_description sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(240, 1000) lineBreakMode:NSLineBreakByTruncatingTail];
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, size.height)];
            textLabel.font = [UIFont systemFontOfSize:15];
            textLabel.textColor = [UIColor blackColor];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            textLabel.numberOfLines = 0;
            textLabel.textAlignment = NSTextAlignmentLeft;
            textLabel.text = _description;
            [tmpAlertView setValue:textLabel forKey:@"accessoryView"];
            
            //这个地方别忘了把alertview的message设为空
            tmpAlertView.message = @"";
        }
        
        [tmpAlertView show];
    }
}

- (void)tapView:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:_alertController.view];
    CGRect frame = _alertController.view.frame;
    CGRect chancelBtnFrame = CGRectMake(0, CGRectGetHeight(frame) - 44, CGRectGetWidth(frame) / 2, 44);
    CGRect okBtnFrame = CGRectMake(CGRectGetWidth(frame) / 2, CGRectGetHeight(frame) - 44, CGRectGetWidth(frame) / 2, 44);
    
    if (CGRectContainsPoint(chancelBtnFrame, point)) {
        [self handleCancelButton:_alertController];
    }
    else if (CGRectContainsPoint(okBtnFrame, point)) {
        [self handleOkButton:_alertController];
    }
    else {
        [self handleCancelButton:_alertController];
    }
}

- (void)handleCancelButton:(UIAlertController *)alertController {
    if (_cancelBlock) {
        _cancelBlock();
    }
    [alertController dismissViewControllerAnimated:YES completion:nil];
    _contentWindow.hidden = YES;
    _contentWindow = nil;
}

- (void)handleOkButton:(UIAlertController *)alertController {
    if (_okBlock) {
        _okBlock();
    }
    [alertController dismissViewControllerAnimated:YES completion:nil];
    _contentWindow.hidden = YES;
    _contentWindow = nil;
}

#pragma mark -
#pragma mark - alert delegate
- (void) willPresentAlertView:(UIAlertView *)alertView {
    //由于不希望标题也居左
    NSInteger labelIndex = 1;
    //在ios7.0一下版本这个方法是可以的
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        for (UIView *subView in alertView.subviews)
        {
            
            if ([subView isKindOfClass: [UILabel class]])
            {
                if (labelIndex > 1)
                {
                    UILabel *tmpLabel = (UILabel *)subView;
                    tmpLabel.textAlignment = NSTextAlignmentLeft;
                }
                //过滤掉标题
                labelIndex ++;
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_delegate &&
        [_delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [_delegate customAlertView:self clickedButtonAtIndex:buttonIndex];
    }
}

@end
