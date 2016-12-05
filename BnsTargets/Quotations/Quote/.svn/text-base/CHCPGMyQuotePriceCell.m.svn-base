//
//  CHCPGMyQuotePriceCell.m
//  Pigs
//
//  Created by wangbin on 16/5/23.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGMyQuotePriceCell.h"
#import "DateFomatterTool.h"
@interface CHCPGMyQuotePriceCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *varietyLabel;

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end


@implementation CHCPGMyQuotePriceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)addPriceInfoVO:(CHCPGMyQuotePriceInfoVO *)priceInfoVO{
  self.priceInfoVO=priceInfoVO;
  self.dateLabel.text=[DateFomatterTool getDateStringFromTimeStamp:[priceInfoVO.createAt doubleValue] WithDateFormat:@"MM-dd"];
  self.priceLabel.text=[NSString stringWithFormat:@"%.2f",[priceInfoVO.price doubleValue]];
  if (priceInfoVO.township.length==0) {
    self.regionLabel.text=priceInfoVO.county;
  }else{
  self.regionLabel.text=priceInfoVO.township;
  }
  if ([priceInfoVO.pigType intValue]==1) {
      self.varietyLabel.text=@"外三元";
  }
  else if ([priceInfoVO.pigType intValue]==2){
  
  self.varietyLabel.text=@"内三元";
    
  }
  if ([priceInfoVO.pigType intValue]==3) {
    self.varietyLabel.text=@"土杂猪";
  }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
