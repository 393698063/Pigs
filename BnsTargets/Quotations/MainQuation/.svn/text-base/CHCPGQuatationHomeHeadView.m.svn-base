//
//  CHCPGQuatationHomeHeadView.m
//  Pigs
//
//  Created by wangbin on 16/5/26.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGQuatationHomeHeadView.h"
#import   "CHCQuationButton.h"
#import "UIColor+Hex.h"
@implementation CHCPGQuatationHomeHeadView



- (void)createPriceViewInfoDataArray:(NSMutableArray *)dataArray
{
  CGFloat boundsWidth=[UIScreen mainScreen].bounds.size.width;
  CGFloat scaleItemFontWidth=18;
  if (boundsWidth==320) {
    
    scaleItemFontWidth=16;
  }else{
    scaleItemFontWidth=18;
  }
  
  //  报价表视图
  for (int index = 0; index < 6; index ++)
  {
    CHCQuationPriceItem *item=[CHCQuationPriceItem item];
    CGFloat  itemW=self.frame.size.width/3;
    CGFloat  itemH=70;
    CGFloat  itemX=index%2 *itemW;
    CGFloat  itemY=index/2 *itemH+150;
    if (dataArray.count==0)
    {
      return;
    }
    self.priceInfoVO=dataArray[index];
    
    item.frame=CGRectMake(itemX, itemY, itemW, itemH);
    [item createTitleLabelText:self.priceInfoVO.name];
    
    item.priceLabel.text=[NSString stringWithFormat:@"%.2f",[self.priceInfoVO.value floatValue]];
    if (index==5)
    {
      item.priceLabel.text=[NSString stringWithFormat:@"%.2f:1",[self.priceInfoVO.value floatValue]];
      item.priceLabel.font=[UIFont systemFontOfSize:scaleItemFontWidth];
    }
    if (index==3||index==4)
    {
      NSUInteger  rangeIndex=self.priceInfoVO.name.length-2;
      NSString  * subString=[self.priceInfoVO.name substringFromIndex:rangeIndex];
      [item createTitleLabelText:subString];
      NSString * subStringComposition=[self.priceInfoVO.name substringToIndex:rangeIndex];
      [item createCompositonLabel:subStringComposition];
      int changeValue=[self.priceInfoVO.value intValue]- [self.priceInfoVO.preValue intValue];
      item.priceLabel.text=[NSString stringWithFormat:@"%d",[self.priceInfoVO.value intValue]];
      
      if (changeValue > 0)
      {
        item.priceLabel.textColor=[UIColor redColor];
        item.changeLabel.text=[NSString stringWithFormat:@"+%d",changeValue];
        item.changeIconView.image=[UIImage imageNamed:@"hqsy_icon_up"];
      }
      else if (changeValue < 0)
      {
        item.priceLabel.textColor=[UIColor colorWithHex:0xff86c036];
        item.changeLabel.text=[NSString stringWithFormat:@"%d",changeValue];
        item.changeIconView.image=[UIImage imageNamed:@"hqsy_icon_down_"];
      }
      else
      {
        item.changeIconView.image=[UIImage imageNamed:@""];
        item.priceLabel.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        item.changeLabel.text=[NSString stringWithFormat:@"%d",changeValue];
        
      }
    }
    else
    {
      float changeValue=[self.priceInfoVO.value floatValue]- [self.priceInfoVO.preValue floatValue];
      
      if (changeValue > 0)
      {
        item.priceLabel.textColor=[UIColor redColor];
        item.changeLabel.text=[NSString stringWithFormat:@"+%.2f",changeValue];
        item.changeIconView.image=[UIImage imageNamed:@"hqsy_icon_up"];
      }
      else if (changeValue < 0)
      {
        item.priceLabel.textColor=[UIColor colorWithHex:0xff86c036];
        item.changeLabel.text=[NSString stringWithFormat:@"%.2f",changeValue];
        item.changeIconView.image=[UIImage imageNamed:@"hqsy_icon_down_"];
      }else{
        item.priceLabel.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        item.changeIconView.image=[UIImage imageNamed:@""];
        item.changeLabel.textColor=[UIColor grayColor];
        item.changeLabel.text=[NSString stringWithFormat:@"%.2f",changeValue];
      }
      [item.compositionLabel setHidden:YES];
      
    }
    item.changeLabel.textColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    item.backButton.tag=20+index;
    [item addTarget:self action:@selector(showPriceAction:)];
    
    [self.iPriceItemArray addObject:item];
    [self addSubview:item];
  }
  for (int index = 0; index < 4; index ++) {
    UIView *iCutLine=[[UIView alloc]initWithFrame:CGRectMake(0, 150+index*70, self.frame.size.width*2/3, 1)];
    iCutLine.backgroundColor=[UIColor colorWithHex:0xffd7dae3];
    [self addSubview:iCutLine];
  }
  for (int index = 1; index <3;  index++) {
    UIView *iVerticalLine=[[UIView alloc]initWithFrame:CGRectMake(index * self.frame.size.width/3, 150, 1, 210)];
    iVerticalLine.backgroundColor=[UIColor colorWithHex:0xffd7dae3];
    [self addSubview:iVerticalLine];
  }
  UIView *iTableViewLine=[[UIView alloc]initWithFrame:CGRectMake(0, 369, self.frame.size.width, 1)];
  iTableViewLine.backgroundColor=[UIColor colorWithHex:0xffd7dae3];
  [self addSubview:iTableViewLine];

  
}
- (void)loadPositionPriceDataWithDataArray:(NSMutableArray *)dataArray
{
  for (int index = 0; index < 6; index ++)
  {
    if (dataArray.count==0) {
      return;
    }
    if (self.iPriceItemArray.count==0) {
      return;
    }
    
    self.iPriceItem=self.iPriceItemArray[index];
    self.priceInfoVO=dataArray[index];
    [self.iPriceItem createTitleLabelText:self.priceInfoVO.name];
    self.iPriceItem.priceLabel.text=[NSString stringWithFormat:@"%.2f",[self.priceInfoVO.value floatValue]];
    if (index==5)
    {
      self.iPriceItem.priceLabel.text=[NSString stringWithFormat:@"%.2f:1",[self.priceInfoVO.value floatValue]];
    }
    if (index==3||index==4)
    {
      NSUInteger  rangeIndex=self.priceInfoVO.name.length-2;
      NSString  * subString=[self.priceInfoVO.name substringFromIndex:rangeIndex];
      [self.iPriceItem createTitleLabelText:subString];
      NSString * subStringComposition=[self.priceInfoVO.name substringToIndex:rangeIndex];
      [self.iPriceItem createCompositonLabel:subStringComposition];
      int changeValue=[self.priceInfoVO.value intValue]- [self.priceInfoVO.preValue intValue];
      self.iPriceItem.priceLabel.text=[NSString stringWithFormat:@"%d",[self.priceInfoVO.value intValue]];
      
      if (changeValue > 0)
      {
        self.iPriceItem.priceLabel.textColor=[UIColor redColor];
        self.iPriceItem.changeLabel.text=[NSString stringWithFormat:@"+%d",changeValue];
        self.iPriceItem.changeIconView.image=[UIImage imageNamed:@"hqsy_icon_up"];
      }else if (changeValue < 0)
      {
        self.iPriceItem.priceLabel.textColor=[UIColor colorWithHex:0xff86c036];
        self.iPriceItem.changeLabel.text=[NSString stringWithFormat:@"%d",changeValue];
        self.iPriceItem.changeIconView.image=[UIImage imageNamed:@"hqsy_icon_down_"];
      }else
      {
        self.iPriceItem.changeLabel.textColor=[UIColor grayColor];
        self.iPriceItem.changeIconView.image=[UIImage imageNamed:@""];
        self.iPriceItem.priceLabel.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.iPriceItem.changeLabel.text=[NSString stringWithFormat:@"%d",changeValue];
      }
    }else
    {
      float changeValue=[self.priceInfoVO.value floatValue]- [self.priceInfoVO.preValue floatValue];
      if (changeValue > 0)
      {
        self.iPriceItem.priceLabel.textColor=[UIColor redColor];
        self.iPriceItem.changeLabel.text=[NSString stringWithFormat:@"+%.2f",changeValue];
        self.iPriceItem.changeIconView.image=[UIImage imageNamed:@"hqsy_icon_up"];
      }else if (changeValue < 0){
        self.iPriceItem.priceLabel.textColor=[UIColor colorWithHex:0xff86c036];
        self.iPriceItem.changeLabel.text=[NSString stringWithFormat:@"%.2f",changeValue];
        self.iPriceItem.changeIconView.image=[UIImage imageNamed:@"hqsy_icon_down_"];
      }else{
        self.iPriceItem.priceLabel.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.iPriceItem.changeIconView.image=[UIImage imageNamed:@""];
        self.iPriceItem.changeLabel.textColor=[UIColor grayColor];
        self.iPriceItem.changeLabel.text=[NSString stringWithFormat:@"%.2f",changeValue];
      }
      [self.iPriceItem.compositionLabel setHidden:YES];
      
    }
    self.iPriceItem.changeLabel.textColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
  }
  [self layoutIfNeeded];
}
- (void)createTrendQuoteView{
  //趋势走向图
  for (int index = 0; index < 2; index ++)
  {
    CGFloat btnX=(self.frame.size.width/3)*2;
    CGFloat btnY=150+index*105;
    CGFloat btnW=self.frame.size.width/3;
    CGFloat btnH=105;
    NSArray *titleArr=@[@"趋势",@"报价"];
    NSArray *imageArray=@[@"hqsy_xs_icon",@"hqsy_jg_icon"];
    CHCQuationButton *button=[CHCQuationButton item];
    button.frame=CGRectMake(btnX, btnY, btnW, btnH);
    [button createTitleLabel:titleArr[index]];
    button.backButton.tag=26+index;
    [button createTitleImageView:imageArray[index]];
    [button addTarget:self action:@selector(showTrendAction:)];
    [self addSubview:button];
   
  }
  UIView *iLine=[[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width/3)*2, 255, self.frame.size.width/3, 1)];
  iLine.backgroundColor=[UIColor colorWithHex:0xffd7dae3];
  [self addSubview:iLine];
}
- (void)showPriceAction:(UIButton *)button
{  
  if ([_delegate respondsToSelector:@selector(getDetailViewTag:)]) {
    [_delegate getDetailViewTag:(int)button.tag];
    
  }

}
- (void)showTrendAction:(UIButton *)button{
  
  if ([_delegate respondsToSelector:@selector(getQuoteTrendViewTag:)]) {
    [_delegate getQuoteTrendViewTag:(int)button.tag];
  }
  
  
}
- (NSMutableArray *)iPriceItemArray{
  
  if (_iPriceItemArray==nil) {
    _iPriceItemArray=[[NSMutableArray alloc]init];
  }
  return _iPriceItemArray;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
