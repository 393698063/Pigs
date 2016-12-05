//
//  CHCAttachmentBtn.m
//  CollaborationTask
//
//  Created by Lemon on 13-4-3.
//  Copyright (c) 2013年 yonyou. All rights reserved.
//

#import "CHCAttachmentAdd.h"
#import "CHCImageClipingViewController.h"
@interface CHCAttachmentAdd()
@property (nonatomic,copy) void (^iCompletion)(NSError *aError);
@property (nonatomic, strong) UIImagePickerController *iPicker;
@end

@implementation CHCAttachmentAdd
@synthesize iDelegate;
@synthesize iFilePath;
@synthesize iCompression;
@synthesize iSuperViewController;
@synthesize iInitVO;
@synthesize isCompress;

+ (BOOL)   setBtnAction:(UIButton *)aBtn
           withDelegate:(id<MHCPhotoSelectDelegate>)aDelegate
withSuperViewController:(UIViewController *)aSuperView
{
  if (aBtn && aDelegate && aSuperView)
  {
    CHCAttachmentAdd *addController = [[CHCAttachmentAdd alloc]
                                       initWithSuperViewController:aSuperView];
    addController.iDelegate = aDelegate;
    [aBtn addTarget:addController
             action:@selector(triggerAttachAddEvent:)
   forControlEvents:UIControlEventTouchUpInside];
    return YES;
  }
  return NO;
}

- (void)saveImageToAlbum:(UIImage *)aImage
           completeBlock:(void (^)(NSError *aError))aCompletion
{
  self.iCompletion = aCompletion;
  UIImageWriteToSavedPhotosAlbum(aImage,
                                 self,
                                 @selector(image:didFinishSavingWithError:contextInfo:),
                                 nil);
}

- (void)               image: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo
{
  if (self.iCompletion)
  {
    self.iCompletion(error);
  }
}

#pragma mark -
#pragma mark 2种init方法
- (id)initWithSuperViewController:(UIViewController *)aSuperViewController
{
  self = [super init];
  if (self)
  {
    iSuperViewController = aSuperViewController;
    iInitVO = [[CHCAttachInitVO alloc]init];
    self.iCompression = 1.0f;
    self.isCompress = YES;
  }
  return self;
}

- (id)initWithSuperViewController:(UIViewController *)aSuperViewController
                       withInitVO:(CHCAttachInitVO *)aInitVO
                     withFilePath:(NSString *)aFilePath
{
  self = [super init];
  if (self)
  {
    iSuperViewController = aSuperViewController;
    self.iInitVO = aInitVO;
    self.iFilePath = aFilePath;
    self.iCompression = 1.0f;
    self.isCompress = YES;
  }
  return self;
}

#pragma mark -
#pragma mark 触发事件方法！
- (void)triggerAttachAddEvent:(id)sender
{
  [self.iSuperViewController.view endEditing:YES];
  
  if ([self.iInitVO.iRankAry count] < 1)
  {
    return;
  }
  else if ([self.iInitVO.iRankAry count] == 1)
  {
    [self actionSheet:nil clickedButtonAtIndex:0];
  }
  else
  {
    UIActionSheet *aActionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedStringFromTable(@"GetAttachment", @"Util_AttachmentAdd", nil)
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    for (int i=0; i<[self.iInitVO.iRankAry count]; i++)
    {
      int eventType = [[self.iInitVO.iRankAry objectAtIndex:i] intValue];
      if (eventType == EHCPhotoEvent)
      {
        [aActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"ChoosePhotos", @"Util_AttachmentAdd", nil)];
      }
      else if (eventType == EHCCameraEvent)
      {
        [aActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"ChooseCamera", @"Util_AttachmentAdd", nil)];
      }
      else if (eventType == EHCDocumentEvent)
      {
        [aActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"ChooseLocalFiles", @"Util_AttachmentAdd", nil)];
      }
      else
      {
        ;
      }
    }
    [aActionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"ActionSheetCancelBtn", @"Util_AttachmentAdd", nil)];
    aActionSheet.cancelButtonIndex = aActionSheet.numberOfButtons-1;
    if (iSuperViewController && iSuperViewController.view)
    {
      [aActionSheet showInView:self.iSuperViewController.view];
    }
  }
}

#pragma mark -
#pragma mark UIActionSheetDelegate代理
- (void) actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
  int eventType =EHCDefaultEvent;
  if (self.iInitVO && buttonIndex<[self.iInitVO.iRankAry count])
  {
    eventType = [[self.iInitVO.iRankAry objectAtIndex:buttonIndex] intValue];
  }
  
  if (eventType == EHCPhotoEvent)
  {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
      picker.delegate = self;
      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      [self.iSuperViewController presentViewController:picker animated:YES completion:nil];
    }
    else
    {
      UIAlertView *aAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"cantPhoto", @"Util_AttachmentAdd", nil)
                                                      message:nil
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedStringFromTable(@"ok", @"Util_AttachmentAdd", nil)
                                            otherButtonTitles:nil];
      [aAlert show];
    }
  }
  else if (eventType == EHCCameraEvent)
  {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
      picker.delegate = self;
//      picker.allowsEditing = YES;
//      @try {
//
//        picker.showsCameraControls = YES;
//      }
//      @catch (NSException *exception) {
//
//      }
      picker.sourceType = UIImagePickerControllerSourceTypeCamera;
      
      
      //调用相机在plus和6上，黑屏的特殊处理。
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.iSuperViewController presentViewController:picker animated:YES completion:nil];
        
      });
    }
    else
    {
      UIAlertView *aAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"cantPhoto", @"Util_AttachmentAdd", nil)
                                                      message:nil
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedStringFromTable(@"ok", @"Util_AttachmentAdd", nil)
                                            otherButtonTitles:nil];
      [aAlert show];
    }
  }
  else
  {
    
  }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  NSURL *aUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
  if (aUrl)
  {
    //from photo
    ALAssetsLibrary *aAsset = [[ALAssetsLibrary alloc]init];
    [aAsset assetForURL:aUrl
            resultBlock:
     ^(ALAsset *asset)
     {
       self.iPicker = picker;
       
       if (iDelegate && [iDelegate respondsToSelector:@selector(imagePickerDidDismiss)])
       {
         [iDelegate imagePickerDidDismiss];
       }
       
       CHCAttachmentVO *aVO = [[CHCAttachmentVO alloc]init];
       
       UIImage *preview = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
       aVO.userInfo = preview?@{HC_AttachAdd_UserInfo_PreviewPic:preview}:nil;
       
       NSString *fileName = [[asset defaultRepresentation] filename];
       NSArray *aAry = [fileName componentsSeparatedByString:@"."];
       if ([aAry count]>1)
       {
         aVO.iFileName = [aAry objectAtIndex:0]?[aAry objectAtIndex:0]:@"";
         aVO.iFileType = [aAry lastObject]?[aAry lastObject]:@"";
       }
       else if( [aAry count]>0 )
       {
         aVO.iFileName = [aAry objectAtIndex:0]?[aAry objectAtIndex:0]:@"";
         aVO.iFileType = @"JPG";
       }
       else
       {
         aVO.iFileName = @"";
         aVO.iFileType = @"JPG";
       }
       aVO.iFileName = [NSString stringWithFormat:@"%ld",(long)[NSDate date].timeIntervalSince1970];
       
       UIImage *aImage = [info objectForKey:UIImagePickerControllerOriginalImage];
       
       if ( self.isCompress )
       {
         aVO.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:aImage,HC_ATTACHUSERINFO_KEY, nil];
         
         [NSThread detachNewThreadSelector:(@selector(compressImage:)) toTarget:self withObject:aVO];
       }
       else
       {
         [self.iPicker dismissViewControllerAnimated:YES completion:^
         {
           self.iPicker = nil;
         }];
         
         NSData *imageData = UIImageJPEGRepresentation(aImage, self.iCompression);
         
         aVO.iFile = imageData;
         
         double aImgSize = [imageData length]/HC_ATTACHADDRATE_KB;
         aVO.iFileSize = [NSString stringWithFormat:@"%.2f",aImgSize];
         
         if (iDelegate && [iDelegate respondsToSelector:@selector(didSelectImage:)])
         {
           [iDelegate didSelectImage:aVO];
         }
       }
     }
           failureBlock:
     ^(NSError *error)
     {
       HCLog(@"%@",error);
       // 获取图片失败
       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"FailToGetPhotos", @"Util_AttachmentAdd", nil)
                                                      message:nil
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedStringFromTable(@"ok",@"Util_AttachmentAdd",nil)
                                            otherButtonTitles:nil];
       [alert show];
     }];
  }
  else
  {
    self.iPicker = picker;
    
    if (iDelegate && [iDelegate respondsToSelector:@selector(imagePickerDidDismiss)])
    {
      [iDelegate imagePickerDidDismiss];
    }
    
    CHCAttachmentVO *aVO = [[CHCAttachmentVO alloc]init];
    aVO.userInfo = nil;
    
    aVO.iFileType = @"JPG";
    
//    UIImage *aImage = nil;
//    if (self.iInitVO.iIsEditImage)
//    {
//      aImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    }
//    else
//    {
//      aImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    }
    
    UIImage *aImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    if (isCompress)
    {
      aVO.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:aImage,HC_ATTACHUSERINFO_KEY, nil];
      
      [NSThread detachNewThreadSelector:(@selector(compressImage:)) toTarget:self withObject:aVO];
    }
    else
    {
      
      //fram camera
      [self.iPicker dismissViewControllerAnimated:YES completion:^{
        self.iPicker = nil;
      }];
      
      NSData *imageData = UIImageJPEGRepresentation(aImage, self.iCompression);
      
      aVO.iFile = imageData;
      
      double aFileSize = [imageData length]/HC_ATTACHADDRATE_KB;
      aVO.iFileSize = [NSString stringWithFormat:@"%.2f",aFileSize];
      
      if (iDelegate && [iDelegate respondsToSelector:@selector(didSelectImage:)])
      {
        [iDelegate didSelectImage:aVO];
      }
    }
    
  }
}


-(void)compressImage:(CHCAttachmentVO *)aVO
{
  UIImage *aImage = (UIImage *)[aVO.userInfo objectForKey:HC_ATTACHUSERINFO_KEY];
  
  NSData *imageData = [CHCImgCompressUtil compressImageHCStyle:aImage];
  
  //照片增加水印
  if (iDelegate && [iDelegate respondsToSelector:@selector(didTransFormImageData:)])
  {
    
    imageData = [iDelegate performSelector:@selector(didTransFormImageData:) withObject:imageData];
    
    if ((float)[imageData length]/HC_ATTACHADDRATE_KB > 200.0f)
    {
      
      UIImage *image = [UIImage imageWithData:imageData];
      
      imageData = [CHCImgCompressUtil compressImageHCStyle:image];
      
    }
    
  }
  
  
  aVO.iFile = imageData;
  aVO.iFileSize = [NSString stringWithFormat:@"%.2f",(float)[imageData length]/HC_ATTACHADDRATE_KB];
  
  if (iDelegate && [iDelegate respondsToSelector:@selector(didSelectImage:)])
  {
    if (self.iInitVO.iIsEditImage)
    {
      if (self.iDelegate && [iDelegate respondsToSelector:@selector(willClipImage)])
      {
        [((NSObject *)self.iDelegate) performSelectorOnMainThread:@selector(willClipImage) withObject:nil waitUntilDone:YES];
      }
      
      CHCImageClipingViewController *aVC = [[CHCImageClipingViewController alloc]initWithCompletionBlock:
                                            ^(UIImage *editedImage, BOOL canceled)
                                            {
                                              if (!canceled)
                                              {
                                                aVO.iFile = UIImageJPEGRepresentation(editedImage, self.iCompression);;
                                                [(NSObject *)iDelegate performSelectorOnMainThread:(@selector(didSelectImage:))
                                                                                        withObject:aVO
                                                                                     waitUntilDone:YES];
                                              }
                                              [self.iSuperViewController.navigationController popViewControllerAnimated:YES];
                                            }];
      
      aVC.sourceImage = aImage;
      aVC.previewImage = aVO.userInfo[HC_AttachAdd_UserInfo_PreviewPic];
      [aVC reset:NO];
      [aVC setHidesBottomBarWhenPushed:YES];
      [self.iSuperViewController.navigationController pushViewController:aVC animated:YES];
      
    }
    else
    {
      [(NSObject *)iDelegate performSelectorOnMainThread:(@selector(didSelectImage:)) withObject:aVO waitUntilDone:YES];
//    [iDelegate didSelectImage:aVO];
    }
  }
  
  //fram camera
  [self.iPicker dismissViewControllerAnimated:YES completion:^
   {
     self.iPicker = nil;
   }];
  
}

@end
