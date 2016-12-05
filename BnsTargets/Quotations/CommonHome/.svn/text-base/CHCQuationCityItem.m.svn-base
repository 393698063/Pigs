//
//  CHCQuationCityItem.m
//  Pigs
//
//  Created by wangbin on 16/5/12.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCQuationCityItem.h"

@implementation CHCQuationCityItem

+(instancetype)item{


  return [[[NSBundle mainBundle]loadNibNamed:@"CHCQuationCityItem" owner:nil options:nil] firstObject];
  


}

- (void)addTarget:(id)target action:(SEL)action{


  [self.backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];


}

- (void)createCityLabel:(NSString *)text{


  self.cityLabel.text=text;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
