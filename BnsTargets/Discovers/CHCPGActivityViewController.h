//
//  CHCPGActivityViewController.h
//  Pigs
//
//  Created by wangbin on 16/6/7.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

@interface CHCPGActivityViewController : CHCBaseViewController

@end

@interface CHCPGActivityController : CHCBaseController

@property (nonatomic,strong) NSMutableArray *iActivityArray;
@property (nonatomic,strong) NSMutableArray *iTempActivityArray;
@property (nonatomic,assign) BOOL footerRefreshEnd;
@property (nonatomic,assign) int firstId;
- (void)getDiscoverActivityWithPage:(NSNumber *)page
                                andTag:(NSNumber *)tag
                            completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion;


@end


@interface CHCPGActivityVO : CHCBaseVO

@property (nonatomic,strong) NSNumber *activityTimeBegin;
@property (nonatomic,strong) NSNumber *activityTimeEnd;
@property (nonatomic,strong) NSNumber *artComment;
@property (nonatomic,strong) NSNumber *artType;
@property (nonatomic,strong) NSNumber *iHCid;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,strong) NSNumber *pubTime;
@property (nonatomic,strong) NSNumber *stage;
@property (nonatomic,strong) NSNumber *status;
@property (nonatomic,strong) NSNumber *tag;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,assign) CGFloat  cellHeight;
@property (nonatomic,assign) CGRect  titleImageFrame;
@property (nonatomic,assign) CGRect  titleLabelFrame;


@end