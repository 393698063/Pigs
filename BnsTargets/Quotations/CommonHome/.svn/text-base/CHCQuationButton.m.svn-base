//
//  CHCQuationButton.m
//  Pigs
//
//  Created by wangbin on 16/5/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCQuationButton.h"

@implementation CHCQuationButton


+ (instancetype)item{


  return [[[NSBundle mainBundle] loadNibNamed:@"CHCQuationButton" owner:nil options:nil] firstObject];
  

}
- (void)addTarget:(id)target action:(SEL)action{


  
  [self.backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];


}
- (void)createTitleImageView:(NSString *)imageView{

  self.titleImageView.image=[UIImage imageNamed:imageView];
  self.titleImageView.contentMode=UIViewContentModeScaleAspectFit;
  


}
- (void)createTitleLabel:(NSString *)label{

  self.titleLabel.text=label;


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
