//
//  CHCPGMineHomeActionView.m
//  Pigs
//
//  Created by HEcom on 16/6/27.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGMineHomeActionView.h"

@interface CHCPGMineHomeActionView ()
@property (weak, nonatomic) IBOutlet UIImageView *iIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *iTitle;
@property (nonatomic, strong) NSDictionary * iDataDic;
@end

@implementation CHCPGMineHomeActionView

+ (id)mineHomeActionView
{
  CHCPGMineHomeActionView * view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                 owner:nil options:nil].lastObject;
  return view;
}
- (void)loadDataWithDict:(NSDictionary *)dict
{
  self.iDataDic = dict;
  self.iIconImageView.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
  self.iTitle.text = [dict objectForKey:@"title"];
  
}
- (IBAction)tapAction:(id)sender
{
  if ([self.delegate respondsToSelector:@selector(homeListTapActionWithType:)]) {
    [self.delegate homeListTapActionWithType:[[self.iDataDic objectForKey:@"tapType"] integerValue] ];
  }
}

@end
