//
//  CHCPGQuatationHomeHeadView.h
//  Pigs
//
//  Created by wangbin on 16/5/26.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCQuationPriceInfoVO.h"
#import "CHCQuationPriceItem.h"
@protocol getDetailViewDelegate <NSObject>

- (void)getDetailViewTag:(int)buttonTag;

- (void)getQuoteTrendViewTag:(int)buttonTag;
@end

@interface CHCPGQuatationHomeHeadView : UIView


@property (nonatomic,strong)CHCQuationPriceInfoVO *priceInfoVO;
@property (nonatomic,strong) CHCQuationPriceItem *iPriceItem;
@property (nonatomic,strong) NSMutableArray * iPriceItemArray;
@property (nonatomic,weak)id<getDetailViewDelegate>delegate;
- (void)createPriceViewInfoDataArray:(NSMutableArray *)dataArray;
- (void)loadPositionPriceDataWithDataArray:(NSMutableArray *)dataArray;
- (void)createTrendQuoteView;
@end
