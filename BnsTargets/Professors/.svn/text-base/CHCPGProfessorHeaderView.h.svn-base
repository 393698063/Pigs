//
//  CHCPGProfessorHeaderView.h
//  Pigs
//
//  Created by Lemon-HEcom on 16/7/22.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCBaseVO.h"

static NSInteger const HCPG_ProfessorDefaultHeight = 388;
static NSInteger const HCPG_ProfessorSaleOnlyHeight = 351;

typedef enum
{
  EHCProblemCategory1 = 1,
  EHCProblemCategory2 = 2,
  EHCProblemCategory3 = 3,
  EHCProblemCategory4 = 4,
  EHCProblemCategory5 = 5,
  EHCProblemCategory6 = 6,
  EHCProblemCategory7 = 7,
  EHCProblemCategory8 = 8
}EHCProblemCategory;

@class CHCPGProblemCategoryVO;
@protocol MHCPGProfessorHeaderDelegate <NSObject>
@required
- (void)didSelectProblemCategory:(CHCPGProblemCategoryVO *)aCategoryVO;
- (void)enterToIdentifyView;
- (void)needReloadViewData;
@end

@class CHCPGSpportVo;
@interface CHCPGProfessorHeaderView : UIView
@property (weak, nonatomic) id<MHCPGProfessorHeaderDelegate> iDelegate;

+ (instancetype)viewFromXib;

- (void)loadSaleData:(CHCPGSpportVo *)aSalemanVo
          expertData:(CHCPGSpportVo *)aExpertVo;
@end

@interface CHCPGProblemCategoryVO : CHCBaseVO
@property (nonatomic, assign) EHCProblemCategory iCategory;
@property (nonatomic, strong) NSString *iTitle;
@end
