//
//  CHCAttachmentBtn.h
//  CollaborationTask
//
//  Created by Lemon on 13-4-3.
//  Copyright (c) 2013年 yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CHCAttachmentAddDef.h"
#import "CHCAttachmentVO.h"
#import "CHCAttachInitVO.h"
#import "CHCImgCompressUtil.h"
#import "HCLog.h"

static NSString *const HC_AttachAdd_UserInfo_PreviewPic = @"HC_AttachAdd_UserInfo_PreviewPic";

/*!
 @protocol
 @abstract 图片选择
 @discussion
 */
@protocol MHCPhotoSelectDelegate <UIImagePickerControllerDelegate>

@required

/*!
 @method
 @abstract imagepicker消失了之后。
 @discussion
 */
- (void)imagePickerDidDismiss;
@optional

/*!
 @method
 @abstract 选择图片后
 @discussion
 @param aVO 选择了图片的相关的VO
 */
- (void)didSelectImage:(CHCAttachmentVO *)aVO;

/*!
 @method
 @abstract 选择图片后
 @discussion
 @param aVO 将要剪切图片
 */
- (void)willClipImage;

/*!
 	@method
 	@abstract	对拍照获取的照片进行加工处理，比如增加水印
 	@discussion
 	@param 	aData
 	@result
 */
- (NSData *)didTransFormImageData:(NSData *)aData;

@end

@interface CHCAttachmentAdd : NSObject<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
  __weak id<MHCPhotoSelectDelegate> iDelegate;
  __weak UIViewController *iSuperViewController;
  NSString *iFilePath;
  float iCompression;
  CHCAttachInitVO *iInitVO;
  BOOL isCompress;
}

/*!
 @property
 @abstract iSuperViewController 上级界面VO
 */
@property (weak, nonatomic) UIViewController *iSuperViewController;

/*!
 @property
 @abstract iDelegate 图片选择的delegate
 */
@property (weak, nonatomic) id<MHCPhotoSelectDelegate> iDelegate;

/*!
 @property
 @abstract iFilePath 文件选择的Path
 */
@property (copy  , nonatomic) NSString *iFilePath;

/*!
 @property
 @abstract iCompression 压缩率
 */
@property (assign, nonatomic) float iCompression;

/*!
 @property
 @abstract iInitVO 初始化VO，标志开启的功能
 */
@property (retain, nonatomic) CHCAttachInitVO *iInitVO;

/*!
 @property
 @abstract isCompress 是否压缩
 */
@property (assign, nonatomic) BOOL isCompress;

/*!
 @method
 @abstract 保存图片到本地
 @discussion
 @param aImage 将要保存的Block
 @param aCompletion 返回的Block
 @result
 */
#pragma mark 一定要用iVar的实例调用改方法，否则可能会崩溃。
- (void)saveImageToAlbum:(UIImage *)aImage
           completeBlock:(void (^)(NSError *aError))aCompletion;

/*!
 @method
 @abstract 初始化方法，只从相册选择
 @discussion
 @param aSuperViewController 弹出相册的VC
 @result 附件选择controller。需要额外设置delegate属性
 */
- (id)initWithSuperViewController:(UIViewController *)aSuperViewController;

/*!
 @method
 @abstract 初始化方法，只从相册选择
 @discussion
 @param aSuperViewController 弹出相册的VC
 @param aInitVO 初始化功能设置VO
 @param aFilePath 选取文件的路径，不开启选取文件功能不用传该值。
 @result 附件选择controller。需要额外设置delegate属性
 */
- (id)initWithSuperViewController:(UIViewController *)aSuperViewController
                       withInitVO:(CHCAttachInitVO *)aInitVO
                     withFilePath:(NSString *)aFilePath;

/*!
 @method
 @abstract 触发选择附件的功能
 @discussion
 @param sender nil
 */
- (void)triggerAttachAddEvent:(id)sender;

/*!
 @method
 @abstract 初始化方法，只从相册选择
 @discussion
 @param actionSheet 弹出相册的VC
 @param buttonIndex 初始化功能设置VO
 */
- (void) actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex;

/*!
 @method
 @abstract 快捷设置由aBtn触发的选择相册的方法
 @discussion
 @param aBtn 触发的button
 @param aDelegate 选择的delegate
 @param aSuperView 展示相册的VC
 @result BOOL 是否成功
 */
+ (BOOL)   setBtnAction:(UIButton *)aBtn
           withDelegate:(id<MHCPhotoSelectDelegate>)aDelegate
withSuperViewController:(UIViewController *)aSuperView;

/*!
 @meth
 @abstract 压缩图片
 @discussion 
 */
-(void)compressImage:(UIImage *)aImage;
@end
