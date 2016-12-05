//
//  CHCQuationPriceListView.m
//  Pigs
//
//  Created by wangbin on 16/5/16.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCQuationPriceListView.h"

@implementation CHCQuationPriceListView



+(instancetype)item
{

  return [[[NSBundle mainBundle]loadNibNamed:@"CHCQuationPriceListView" owner:nil options:nil] firstObject];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
