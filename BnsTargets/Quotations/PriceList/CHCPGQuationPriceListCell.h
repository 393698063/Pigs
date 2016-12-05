//
//  CHCPGQuationPriceListCell.h
//  Pigs
//
//  Created by wangbin on 16/5/17.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCQuatationPriceListInfoVO.h"
#import "CHCQuationPriceListView.h"
@interface CHCPGQuationPriceListCell : UITableViewCell

@property (nonatomic,strong) CHCQuationPriceListView *item;


@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;



@property (weak, nonatomic) IBOutlet UILabel *changeLabel;


@property (nonatomic,copy) NSString *nameString;

@property (nonatomic,strong) NSMutableArray *dateArray;
@property (nonatomic,strong) NSMutableArray *valueArray;

@end
