//
//  CHVPGCurrentLocationCell.m
//  Pigs
//
//  Created by HEcom on 16/5/10.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGCurrentLocationCell.h"
#import "UIColor+Hex.h"
#import "LocationManager.h"
#import "HcLog.h"

@interface CHCPGCurrentLocationCell ()
@property (weak, nonatomic) IBOutlet UIButton *iCurrentCityButton;

@end

@implementation CHCPGCurrentLocationCell
+ (id)currentLocationCellWithTableView:(UITableView *)tableView
{
  CHCPGCurrentLocationCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
  if (!cell) {
    cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
  }
  return cell;
}
- (void)loadData:(NSDictionary *)dict
{
  [self.iCurrentCityButton setTitle:[dict objectForKey:@"area"] forState:UIControlStateNormal];
}
- (void)awakeFromNib {
    // Initialization code
  self.iCurrentCityButton.layer.borderColor = [UIColor colorWithHex:0xffd7dae3].CGColor;
  self.iCurrentCityButton.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
