//
//  CHCPGActivityCell.m
//  Pigs
//
//  Created by wangbin on 16/6/8.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGActivityCell.h"
#import "UIImageView+WebCache.h"
#import "DateFomatterTool.h"
@interface CHCPGActivityCell()

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;

@end


@implementation CHCPGActivityCell

- (void)awakeFromNib {
  self.titleLabel.preferredMaxLayoutWidth=[UIScreen mainScreen].bounds.size.width-20;
}

- (void)setActivityVO:(CHCPGActivityVO *)activityVO{
  [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:[activityVO.img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]placeholderImage:[UIImage imageNamed:@"zhuge_default"]];
  self.titleLabel.text=activityVO.title;
  NSString *timeBegin=[DateFomatterTool getDateStringFromTimeStamp:[activityVO.activityTimeBegin doubleValue] WithDateFormat:@"MM月dd日 HH:mm"];
  NSString *timeEnd=[DateFomatterTool getDateStringFromTimeStamp:[activityVO.activityTimeEnd doubleValue] WithDateFormat:@"MM月dd日 HH:mm"];
  self.activityTimeLabel.text=[NSString stringWithFormat:@"%@ - %@",timeBegin,timeEnd];
  self.titleImageView.clipsToBounds = YES;
  [self layoutIfNeeded];
  activityVO.cellHeight=CGRectGetMaxY(self.activityTimeLabel.frame)+20;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
