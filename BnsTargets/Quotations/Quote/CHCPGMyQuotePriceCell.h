//
//  CHCPGMyQuotePriceCell.h
//  Pigs
//
//  Created by wangbin on 16/5/23.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCPGMyQuotePriceInfoVO.h"
@interface CHCPGMyQuotePriceCell : UITableViewCell

@property (nonatomic,strong) CHCPGMyQuotePriceInfoVO *priceInfoVO;
- (void)addPriceInfoVO:(CHCPGMyQuotePriceInfoVO *)priceInfoVO;
@end
