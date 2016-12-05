//
//  CHCPGNoNetWorkView.m
//  Pigs
//
//  Created by HEcom on 16/6/24.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCNoNetWorkView.h"

@interface CHCNoNetWorkView ()
@property (nonatomic, copy) void((^iCallBackBlock)());
@end

@implementation CHCNoNetWorkView

+ (id)noNetWorkViewWithCallback:(void((^)()))callBackBlock;
{
  CHCNoNetWorkView * view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
  view.iCallBackBlock = callBackBlock;
  return view;
}

- (IBAction)buttonAction:(id)sender
{
  self.iCallBackBlock();
}

@end
