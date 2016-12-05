//
//  CHCPGMineHomeActionCell.m
//  Pigs
//
//  Created by HEcom on 16/4/25.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#import "CHCPGMineHomeActionCell.h"

@interface CHCPGMineHomeActionCell ()

@end

@implementation CHCPGMineHomeActionCell

- (void)loadData:(NSDictionary *)dict actionBlock:(void (^)(EHCCellTapType type))block
{
  [super loadData:dict actionBlock:block];
}

- (IBAction)iCollectAcion:(id)sender
{
  self.iActionblock(EHCCellTapCollect);
}
- (IBAction)iCertifyAction:(id)sender
{
  self.iActionblock(EHCCellTapAuthentify);
}
- (IBAction)iSuggestAction:(id)sender
{
  self.iActionblock(EHCCellTapSuggest);
}
- (IBAction)iShareAction:(id)sender
{
  self.iActionblock(EHCCellTapShare);
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
