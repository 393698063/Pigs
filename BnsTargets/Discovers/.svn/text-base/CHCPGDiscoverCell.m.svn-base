//
//  CHCPGDiscoverCell.m
//  Pigs
//
//  Created by wangbin on 16/6/7.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGDiscoverCell.h"
#import "UIImageView+WebCache.h"
#import "CHCPGDisCoverHomeViewController.h"
#import "DateFomatterTool.h"
@interface CHCPGDiscoverCell()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *discoverImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation CHCPGDiscoverCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDiscoverListVO:(CHCPGDisCoverListVO *)discoverListVO{

  self.titleLabel.text=discoverListVO.title;
  [self.discoverImage sd_setImageWithURL:[NSURL URLWithString:[discoverListVO.img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"zhuge_default"]];
  self.timeLabel.text=[DateFomatterTool getDateStringFromTimeStamp:[discoverListVO.pubTime doubleValue]
                                                    WithDateFormat:@"MM-dd HH:mm"];
  self.discoverImage.clipsToBounds = YES;

  [self layoutIfNeeded];
  discoverListVO.cellHeight=CGRectGetMaxY(self.timeLabel.frame)+20;
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
