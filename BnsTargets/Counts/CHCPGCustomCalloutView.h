//
//  CHCPGCustomCalloutView.h
//  Pigs
//
//  Created by HEcom on 16/7/14.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomCallOutViewDelegate <NSObject>
@optional
- (void)submitFatPig:(NSString *)fatNum sow:(NSString *)sowNum;

@end

@interface CHCPGCustomCalloutView : UIView
@property (nonatomic, strong) UITextField * iFatPigCountField;
@property (nonatomic, strong) UITextField * iSowCountField;
@property (nonatomic, strong) UIButton * iSubmitButton;
@property (nonatomic, weak) id<CustomCallOutViewDelegate>delegate;
@end
