//
//  CHCPGQuatationHomeCell.m
//  Pigs
//
//  Created by wangbin on 16/5/9.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGQuatationHomeCell.h"

@implementation CHCPGQuatationHomeCell

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
  static NSString *cellID=@"cell";
  CHCPGQuatationHomeCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
  
  if (cell==nil)
  {
    cell=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CHCPGQuatationHomeCell class]) owner:nil options:nil] firstObject];
  }
  return cell;
}
- (void)addQuationInfoVO:(CHCQuationTableInfoVO *)quationinfoVO
{
  [self.featureImageView sd_setImageWithURL:[NSURL URLWithString:[quationinfoVO.logoLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"zhuge_default"]];
  self.featureImageView.clipsToBounds=YES;
  self.titleLabel.text=quationinfoVO.title;
  NSRange  range=NSMakeRange(5, 11);
  self.dateLabel.text= [quationinfoVO.date substringWithRange:range];
  self.readCountLabel.text=[NSString stringWithFormat:@"%d阅读",quationinfoVO.skillCount.intValue];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
