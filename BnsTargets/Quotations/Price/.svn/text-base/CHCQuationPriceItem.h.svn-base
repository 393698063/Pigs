//
//  CHCQuationPriceItem.h
//  Pigs
//
//  Created by wangbin on 16/5/10.
//  Copyright © 2016年 HEcom. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "CHCQuationPriceInfoVO.h"

typedef NS_ENUM(NSInteger, PriceListButtonType){

  OutsideThreeMember= 1,//外三元
  InsideThreeMember = 2,//内三元
  NativeMixPig = 3,//土杂猪
  CornPriceButton = 4,//玉米
  soyBeanPriceButton = 5,//豆粕
  PigFoodRatio= 6,//猪粮比

};



@interface CHCQuationPriceItem : UIView


@property (nonatomic,strong) CHCQuationPriceInfoVO *priceInfoVO;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UIButton *backButton;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UIImageView *changeIconView;



@property (weak, nonatomic) IBOutlet UILabel *changeLabel;

@property (weak, nonatomic) IBOutlet UILabel *compositionLabel;

@property (nonatomic,assign) float changeValue;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

+ (instancetype)item;


- (void)createPriceItemWithPriceInfo:(CHCQuationPriceInfoVO *)priceInfoVO withPriceType:(PriceListButtonType)priceType;

- (void)createPriceItemWithPriceInfo:(CHCQuationPriceInfoVO *)priceInfoVO;
- (void)createTitleLabelText:(NSString *)text;
- (void)createPriceLabelText:(NSString *)text;

- (void)createCompositonLabel:(NSString *)text;

- (void)addTarget:(id)target action:(SEL)action;

@end
