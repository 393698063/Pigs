//
//  NSString+frame.h
//  FoodYou
//
//  Created by HEcom on 15/10/8.
//  Copyright (c) 2015年 AZLP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (frame)
- (float) heightWithFont: (UIFont *) font withinWidth: (float) width;
- (float) widthWithFont: (UIFont *) font;
@end
