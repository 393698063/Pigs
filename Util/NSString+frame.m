//
//  NSString+frame.m
//  FoodYou
//
//  Created by HEcom on 15/10/8.
//  Copyright (c) 2015年 AZLP. All rights reserved.
//

#import "NSString+frame.h"

@implementation NSString (frame)
- (float) heightWithFont: (UIFont *) font withinWidth: (float) width
{
  CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
  
  return textRect.size.height;
}
- (float) widthWithFont: (UIFont *) font
{
  CGRect textRect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, font.pointSize)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
  
  return textRect.size.width;
}
@end
