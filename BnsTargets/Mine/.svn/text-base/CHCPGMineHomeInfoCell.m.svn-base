//
//  CHCPGMineHomeInfoCell.m
//  Pigs
//
//  Created by HEcom on 16/4/25.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGMineHomeInfoCell.h"
#import "UIView+frame.h"
#import "CHCCommonInfoVO.h"
#import "UIImageView+WebCache.h"
#import "AppDef.h"
#import "CHCMessageView.h"
@interface CHCPGMineHomeInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *iNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iPhoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *iCoinLabel;
@end

@implementation CHCPGMineHomeInfoCell

- (void)loadData:(NSDictionary *)dict actionBlock:(void (^)(EHCCellTapType))block
{
  [super loadData:dict actionBlock:block];
  CHCCommonInfoVO * userInfo = [CHCCommonInfoVO sharedManager];
  NSString * iconStr = [NSString stringWithFormat:@"%@%@:%@/%@/%@",HC_UrlConnection_FileProtocolType,
                        HC_UrlConnection_FileURL,
                        HC_UrlConnection_FilePort,
                        @"image",
                        userInfo.headLink];
  [self.iIconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr]
                         placeholderImage:[UIImage imageNamed:@"wode_img"]];
  self.iNameLabel.text = userInfo.name;
  self.iPhoneLabel.text = userInfo.mobile;
  self.iCoinLabel.text = [NSString stringWithFormat:@"%@ 金币",userInfo.gold?:@"0"];
}

- (IBAction)iCouponAction:(id)sender
{
  [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                withShowingText:@"敬请期待！"
                                              withIconImageName:nil];
}
- (IBAction)iWalletAction:(id)sender
{
  [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                withShowingText:@"敬请期待！"
                                              withIconImageName:nil];
}

- (void)awakeFromNib
{
  self.iIconImageView.layer.cornerRadius = self.iIconImageView.width * 0.5;
  self.iIconImageView.clipsToBounds = YES;
}

@end
