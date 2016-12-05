//
//  CHCPGCountHistoryCell.m
//  Pigs
//
//  Created by HEcom on 16/7/27.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGCountHistoryCell.h"

@interface CHCPGCountHistoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *iTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *iTopLineView;
@end

@implementation CHCPGCountHistoryCell
+ (id)countHistoryCellWithTableView:(UITableView *)tableView
{
  CHCPGCountHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
  if (!cell) {
    cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
  }
  return cell;
}
- (void)loadDate:(NSString *)date
{
  self.iTimeLabel.text = date;
}
- (void)hideTopLineView
{
  self.iTopLineView.hidden = YES;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
