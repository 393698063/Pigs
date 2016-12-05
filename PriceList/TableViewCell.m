//
//  TableViewCell.m
//  Pigs
//
//  Created by Jorgon on 2016/11/10.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "TableViewCell.h"


@interface TableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *iNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *iChange;

@end

@implementation TableViewCell
+ (id)cellWithTableView:(UITableView *)tableView
{
  TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
  if (!cell) {
    cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
  }
  return cell;
}
- (void)loadData:(NSDictionary *)dataDic
{
  self.iNameLabel.text = [dataDic objectForKey:@"name"];
  self.iChange.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"value"]];
  CGFloat cureent = [[dataDic objectForKey:@"value"] floatValue];
  CGFloat previous = [[dataDic objectForKey:@"preValue"] floatValue];
  
  self.iPriceLabel.text = [NSString stringWithFormat:@"%.2f",cureent - previous];
  CGFloat value = [self.iPriceLabel.text floatValue];
  if (value > 0) {
    self.iPriceLabel.textColor = [UIColor redColor];
  }
  else if (value == 0)
  {
    self.iPriceLabel.textColor = [UIColor whiteColor];
  }
  else
  {
    self.iPriceLabel.textColor = [UIColor greenColor];
  }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
