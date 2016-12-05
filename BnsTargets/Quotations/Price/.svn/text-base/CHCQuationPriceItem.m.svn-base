//
//  CHCQuationPriceItem.m
//  Pigs
//
//  Created by wangbin on 16/5/10.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCQuationPriceItem.h"



@implementation CHCQuationPriceItem


+ (instancetype)item{
  
  
  return [[[NSBundle mainBundle] loadNibNamed:@"CHCQuationPriceItem" owner:nil options:nil] firstObject];
  
  
  
}



- (void)awakeFromNib
{
  self.autoresizingMask = UIViewAutoresizingNone;
}


- (void)createTitleLabelText:(NSString *)text{
  
  
  self.titleLabel.text=text;
  
}
- (void)createPriceLabelText:(NSString *)text{
  
  self.priceLabel.text=text;
  
}


- (void)createCompositonLabel:(NSString *)text{
  
  
  self.compositionLabel.text=text;
  
}
- (void)addTarget:(id)target action:(SEL)action{
  
  
  [self.backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

  
  
  
}
- (void)createPriceItemWithPriceInfo:(CHCQuationPriceInfoVO *)priceInfoVO{





}

- (NSMutableArray *)dataArray{

  if (_dataArray==nil) {
    _dataArray=[[NSMutableArray alloc]init];
  }

  return _dataArray;
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
