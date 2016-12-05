//
//  CHCPGMineHomeAccountCell.m
//  Pigs
//
//  Created by HEcom on 16/4/25.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGMineHomeAccountCell.h"

@interface CHCPGMineHomeAccountCell ()
@property (weak, nonatomic) IBOutlet UILabel *iCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *iTicketLabel;
@property (weak, nonatomic) IBOutlet UILabel *iCashLabel;

@end

@implementation CHCPGMineHomeAccountCell

- (void)loadData:(NSDictionary *)dict actionBlock:(void (^)(EHCCellTapType type))block
{
  [super loadData:dict actionBlock:block];
  CHCCommonInfoVO * userInfo = [CHCCommonInfoVO sharedManager];
  self.iCoinLabel.text = [NSString stringWithFormat:@"%@",userInfo.gold?:@"0"];
  self.iCashLabel.text = [NSString stringWithFormat:@"%@",userInfo.money?:@"0"];
  self.iTicketLabel.text = [NSString stringWithFormat:@"%@",dict[@"count"]?:@"0"];
}

- (IBAction)iGetCoinAction:(id)sender
{
  self.iActionblock(EHCCellTapGetCoin);
}

- (IBAction)iWalletAction:(id)sender
{
  self.iActionblock(EHCCellTapMyWallet);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
