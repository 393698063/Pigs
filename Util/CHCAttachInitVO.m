//
//  CHCAttachInitVO.m
//  CollaborationTask
//
//  Created by Lemon on 13-5-25.
//  Copyright (c) 2013年 yonyou. All rights reserved.
//

#import "CHCAttachInitVO.h"

@implementation CHCAttachInitVO
@synthesize iIsHavePhoto;
@synthesize iIsHaveCamera;
@synthesize iIsHaveDocument;
@synthesize iRankAry;
@synthesize iIsEditImage;

- (id)init
{
  self = [super init];
  if (self)
  {
    iIsHavePhoto = NO;
    iIsHaveCamera = YES;
    iIsHaveDocument = NO;
    iIsEditImage = YES;
    iRankAry = [[NSMutableArray alloc]initWithCapacity:1];
    [iRankAry addObject:[NSString stringWithFormat:@"%d",EHCCameraEvent]];
  }
  return self;
}

-(BOOL)InsertRank:(THCAttachmentEvent)aEventType
{
  for (int i=0; i<[iRankAry count]; i++)
  {
    int EventNum = [[iRankAry objectAtIndex:i]intValue];
    if (aEventType<EventNum)
    {
      [iRankAry insertObject:[NSString stringWithFormat:@"%d",aEventType] atIndex:i];
      return YES;
    }
  }
  [iRankAry addObject:[NSString stringWithFormat:@"%d",aEventType]];
  return YES;
}

-(BOOL)RemoveRank:(THCAttachmentEvent)aEventType
{
  for (int i=0; i<[iRankAry count]; i++)
  {
    int EventNum = [[iRankAry objectAtIndex:i]intValue];
    if (aEventType == EventNum)
    {
      [iRankAry removeObjectAtIndex:i];
      return YES;
    }
  }
  return NO;
}

-(void)setIIsHaveCamera:(BOOL)aIsHaveCamera
{
  if (aIsHaveCamera == !iIsHaveCamera)
  {
    if (iIsHaveCamera)
    {
      [self RemoveRank:EHCCameraEvent];
    }
    else
    {
      [self InsertRank:EHCCameraEvent];
    }
  }
  iIsHaveCamera = aIsHaveCamera;
}

-(void)setIIsHavePhoto:(BOOL)aIsHavePhoto
{
  if (aIsHavePhoto == !iIsHavePhoto)
  {
    if (iIsHavePhoto)
    {
      [self RemoveRank:EHCPhotoEvent];
    }
    else
    {
      [self InsertRank:EHCPhotoEvent];
    }
  }
  iIsHavePhoto = aIsHavePhoto;
}

-(void)setIIsHaveDocument:(BOOL)aIsHaveDocument
{
  if (aIsHaveDocument == !iIsHaveDocument)
  {
    if (iIsHaveDocument)
    {
      [self RemoveRank:EHCDocumentEvent];
    }
    else
    {
      [self InsertRank:EHCDocumentEvent];
    }
  }
  iIsHaveDocument = aIsHaveDocument;
}

@end
