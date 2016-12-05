//
//  CHCPGDisCoverHomeViewController.h
//  Pigs
//
//  Created by HEcom on 16/4/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

@interface CHCPGDisCoverHomeViewController : CHCBaseViewController

@end


@interface CHCPGDisCoverHomeController : CHCBaseController

@property (nonatomic,strong) NSMutableArray *iDiscoverArray;
@property (nonatomic,strong) NSMutableArray *iTempDiscoverArray;
@property (nonatomic,assign) BOOL footerRefreshEnd;
@property (nonatomic,assign) int firstId;
- (void)getDiscoverLeisureTimeWithPage:(NSNumber *)page
                                 andTag:(NSNumber *)tag
                             completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;

@end

@interface CHCPGDisCoverListVO : CHCBaseVO

@property (nonatomic,strong) NSNumber *activityTimeBegin;
@property (nonatomic,strong) NSNumber *activityTimeEnd;
@property (nonatomic,strong) NSNumber *artComment;
@property (nonatomic,strong) NSNumber *artType;
@property (nonatomic,strong) NSNumber *iHCid;
@property (nonatomic,copy)   NSString *img;
@property (nonatomic,strong) NSNumber *pubTime;
@property (nonatomic,strong) NSNumber *stage;
@property (nonatomic,strong) NSNumber *status;
@property (nonatomic,strong) NSNumber *tag;
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,copy)   NSString *url;
@property (nonatomic,assign) CGFloat cellHeight;

@end