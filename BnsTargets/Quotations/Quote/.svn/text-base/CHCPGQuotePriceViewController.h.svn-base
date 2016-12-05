//
//  CHCPGQuotePriceViewController.h
//  Pigs
//
//  Created by wangbin on 16/5/18.
//  Copyright © 2016年 HEcom. All rights reserved.
//


#import "CHCBaseViewController.h"
#import "DateFomatterTool.h"
//#import "CHCPGQuotePriceVO.h"
static NSString *const HCPG_PriceDiary= @"HCPG_PriceDiary";

@interface CHCPGQuotePriceViewController : CHCBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *citySelectLabel;

@property (weak, nonatomic) IBOutlet UITextField *outSideThreeMember;


@property (weak, nonatomic) IBOutlet UITextField *insideThreeMember;

@property (weak, nonatomic) IBOutlet UITextField *nativeMixPig;

@property (nonatomic,assign)  int  iQuoteTag;
@property (nonatomic,copy) NSString *quoteCityString;
@end

@class CHCPGQuotePriceVO;

@interface CHCPGQuotePriceController : CHCBaseController
/**
 *  保存报价的信息到数据库
 *
 *  @param priceVO
 */
- (void)saveInfoStatisticWithQuotePriceVO:(CHCPGQuotePriceVO *)priceVO;
@end


@interface CHCPGQuotePriceVO : CHCBaseVO;

@property (nonatomic,strong) NSNumber *price;
@property (nonatomic,copy)   NSString *mobile;
@property (nonatomic,strong) NSNumber *pigType;
@property (nonatomic,copy)   NSString *province;
@property (nonatomic,copy)   NSString *city;
@property (nonatomic,copy)   NSString *county;
@property (nonatomic,copy)   NSString *township;
@property (nonatomic,strong) NSNumber *createAt;

@end

