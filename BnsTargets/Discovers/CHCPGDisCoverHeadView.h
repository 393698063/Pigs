//
//  CHCPGDisCoverHeadView.h
//  Pigs
//
//  Created by wangbin on 16/6/6.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHCPGDisCoverHeadView : UIView

@property (weak, nonatomic) IBOutlet UIButton *activityButton;

+ (instancetype)headViewItem;

- (void)addTarget:(id)target action:(SEL)action;
@end
