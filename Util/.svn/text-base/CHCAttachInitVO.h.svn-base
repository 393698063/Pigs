//
//  HCAttachInitVO.h
//  CollaborationTask
//
//  Created by Lemon on 13-5-25.
//  Copyright (c) 2013年 yonyou. All rights reserved.
//

#import "CHCBaseVO.h"



@interface CHCAttachInitVO : CHCBaseVO
{
  BOOL iIsHavePhoto;
  BOOL iIsHaveCamera;
  BOOL iIsHaveDocument;
  NSMutableArray *iRankAry;
  BOOL iIsEditImage;
}

typedef enum
{
  EHCPhotoEvent = 0,
  EHCCameraEvent = 1,
  EHCDocumentEvent = 2,
  EHCDefaultEvent = 3
}THCAttachmentEvent;


@property (nonatomic, assign, readonly) BOOL iIsHavePhoto;
@property (nonatomic, assign, readonly) BOOL iIsHaveCamera;
@property (nonatomic, assign, readonly) BOOL iIsHaveDocument;
@property (nonatomic, strong, readonly) NSMutableArray *iRankAry;
@property (nonatomic, assign) BOOL iIsEditImage;
-(id)init;
-(void)setIIsHaveCamera:(BOOL)aIsHaveCamera;
-(void)setIIsHavePhoto:(BOOL)aIsHavePhoto;
-(void)setIIsHaveDocument:(BOOL)aIsHaveDocument;
@end
