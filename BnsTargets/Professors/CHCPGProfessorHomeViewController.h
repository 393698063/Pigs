//
//  CHCPGProfessorHomeViewController.h
//  Pigs
//
//  Created by HEcom on 16/4/11.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"
#import "BnsProfessorDef.h"
#import "CHCPGAuthentifyViewController.h"

@interface CHCPGProfessorHomeViewController : CHCPGAuthentifyViewController

@end


@interface CHCPGProfessorHomeController : CHCPGAuthentifyController

@end

@interface CHCPGProblemListVO : CHCBaseVO
@property (nonatomic, strong) NSNumber *questionId;
@property (nonatomic, strong) NSString *questionTitle;
@property (nonatomic, strong) NSString *lastCommentName;
@property (nonatomic, strong) NSNumber *lastCommentTime;
@property (nonatomic, strong) NSString *lastCommentContent;
@property (nonatomic, strong) NSNumber *commentNum;
@end