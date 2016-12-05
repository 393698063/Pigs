//
//  CHCPGQutationChangeCityViewController.h
//  Pigs
//
//  Created by HEcom on 16/5/9.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

@interface CHCPGQutationChangeCityViewController : CHCBaseViewController
- (instancetype)initWithCityChooseBlock:(void(^)(NSDictionary * selectCity))iChooseBlock;
@end

@interface CHCPGQutationChangeCityController : CHCBaseController
@property (nonatomic, strong) NSMutableDictionary * iLocationDict;
@property (nonatomic, strong) NSMutableArray * iCityDataAry;
@property (nonatomic, strong) NSMutableArray * iCityTitleAry;
@property (nonatomic, strong) NSMutableArray * iCityResultAry;
@property (nonatomic, strong) NSMutableArray * iCityTitleResultAry;

- (void)getLocationCompletion:(void(^)(BOOL isCompleted))aCompletion;
@end