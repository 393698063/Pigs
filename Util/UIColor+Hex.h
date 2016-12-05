//
//  UIColor+Hex.h
//  FoodYou
//
//  Created by HEcom on 15/9/28.
//  Copyright (c) 2015年 AZLP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor *)colorWithHex:(uint) hex;
+ (UIColor *)colorWithHex:(uint) hex andAlpha:(float) alpha;
@end
