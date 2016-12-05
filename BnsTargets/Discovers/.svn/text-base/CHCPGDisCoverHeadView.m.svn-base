//
//  CHCPGDisCoverHeadView.m
//  Pigs
//
//  Created by wangbin on 16/6/6.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGDisCoverHeadView.h"

@implementation CHCPGDisCoverHeadView

+ (instancetype)headViewItem{

return [[[NSBundle mainBundle]loadNibNamed:@"CHCPGDisCoverHeadView"
                                     owner:nil
                                   options:nil
         ] firstObject];
  
}

- (void)addTarget:(id)target action:(SEL)action{
  [self.activityButton addTarget:target
                          action:action
                forControlEvents:UIControlEventTouchUpInside];

}
@end
