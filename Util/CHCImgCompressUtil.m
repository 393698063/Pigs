//
//  CHCImgCompressUtil.m
//  ImgCompressTest
//
//  Created by Lemon on 13-7-1.
//  Copyright (c) 2013年 yonyou. All rights reserved.
//

#import "CHCImgCompressUtil.h"

//static int const HC_IMGCOMPRESS_DISTACNE = 8;

@implementation CHCImgCompressUtil

#pragma mark -
#pragma mark - 添加水印

+ (UIImage *)addWatermark:(UIView *)aView
                  toImage:(UIImage *)aImage
{
  CGSize aSize = aImage.size;
  //屏蔽!，不处理屏幕拉伸，因为最后显示的还是数值大小。
  CGFloat scale = [[UIScreen mainScreen] scale];
  if ( scale<1 || YES )
  {
    scale = 1;
  }
  CGFloat aRate = 1.0f;
  
  UIGraphicsBeginImageContextWithOptions( aSize, NO, scale*aRate );
  // Tell the old image to draw in this new context, with the desired
  [aImage drawInRect:CGRectMake( 0, 0, aSize.width, aSize.height )];
  
  //add wartermark
  if (aView)
  {
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, aSize.width, aSize.height)];
    [baseView addSubview:aView];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [baseView.layer renderInContext:context];
  }
  
  // Get the new image from the context
  UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  
  // End the context
  UIGraphicsEndImageContext();
  // Return the new image.
  newImage = [UIImage imageWithCGImage:newImage.CGImage
                                 scale:scale*aRate
                           orientation:aImage.imageOrientation];
  
  return newImage;
}

#pragma mark -
#pragma mark - 位图压缩

+ (UIImage *)compressImageSize:(UIImage *)aImage
                      toCGSize:(CGSize)aSize
                      withRate:(float)aRate
{
  //屏蔽!
  CGFloat scale = [[UIScreen mainScreen] scale];
  if ( scale<1 || YES )
  {
    scale = 1;
  }
  
  //1. 调整图片方向
  aImage = [CHCImgCompressUtil scaleAndRotateImage:aImage];
  
  //2. 画图
  // Create a graphics image context
  UIGraphicsBeginImageContextWithOptions( aSize, NO, scale*aRate );
  // Tell the old image to draw in this new context, with the desired
  [aImage drawInRect:CGRectMake( 0, 0, aSize.width, aSize.height )];
  // Get the new image from the context
  UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  // End the context
  UIGraphicsEndImageContext();
  // Return the new image.
  newImage = [UIImage imageWithCGImage:newImage.CGImage
                                 scale:scale*aRate
                           orientation:aImage.imageOrientation];
  
  if ( scale*aRate != 1 )
  {
    //3. 重画，改变大小
    UIGraphicsBeginImageContextWithOptions( aSize, NO, 1 );
    [newImage drawInRect:CGRectMake( 0, 0, aSize.width, aSize.height )];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  }
  
  // newImage set
  return newImage;
}

//+ (UIImage *)compressImageSize:(UIImage *)aImage
//                        toSize:(float)aSize
//                      withStep:(CGFloat)aStep
//{
//  return nil;
//}

//转换图片的imageOrientation!
+ (UIImage *)scaleAndRotateImage:(UIImage *)aImage
{
  CGFloat width = aImage.size.width;
  CGFloat height = aImage.size.height;
  CGSize size = aImage.size;
  
  CGRect imageRect;
  
  if( aImage.imageOrientation == UIImageOrientationUp
     || aImage.imageOrientation == UIImageOrientationDown )
  {
    imageRect = CGRectMake( 0, 0, width, height );
  }
  else
  {
    imageRect = CGRectMake( 0, 0, height, width );
  }
  
  if (HC_IMGCOMPRESS_ISSCALE)
  {
    if (width>HC_IMGCOMPRESS_ROUCHWID)
    {
      CGFloat aWidth = HC_IMGCOMPRESS_ROUCHWID;
      CGFloat aHeight = (imageRect.size.height*HC_IMGCOMPRESS_ROUCHWID)/imageRect.size.width;
      
      width = (width*HC_IMGCOMPRESS_ROUCHWID)/imageRect.size.width;
      height= (height*HC_IMGCOMPRESS_ROUCHWID)/imageRect.size.width;
      size = CGSizeMake(width, height);
      
      imageRect = CGRectMake(0, 0, aWidth, aHeight);
    }
  }
  
  UIGraphicsBeginImageContext( size );
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState( context );
  CGContextTranslateCTM( context, 0, height );
  CGContextScaleCTM( context, 1.0, -1.0 );
  
  if( aImage.imageOrientation == UIImageOrientationLeft )
  {
    CGContextRotateCTM( context, M_PI/2 );
    CGContextTranslateCTM( context, 0, -width );
  }
  else if( aImage.imageOrientation == UIImageOrientationRight )
  {
    CGContextRotateCTM( context, - M_PI/2 );
    CGContextTranslateCTM( context, -height, 0 );
  }
  else if( aImage.imageOrientation == UIImageOrientationUp )
  {
    //DO NOTHING
  }
  else if( aImage.imageOrientation == UIImageOrientationDown )
  {
    CGContextTranslateCTM( context, width, height );
    CGContextRotateCTM( context, M_PI );
  }
  
  CGContextDrawImage( context, imageRect, aImage.CGImage );
  CGContextRestoreGState( context );
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img;
}

+ (UIImage *)clippingImageSize:(UIImage *)aImage
                     withFrame:(CGRect)aFrame
                      withRate:(float)aRate
{  
  //屏蔽!
  CGFloat scale = [[UIScreen mainScreen] scale];
  if ( scale<1 || YES )
  {
    scale = 1;
  }
  
  //1. 调整图片方向
  aImage = [CHCImgCompressUtil scaleAndRotateImage:aImage];
  
  //2. 从原图截取图片
  if (aFrame.origin.x<0)
  {
    aFrame = CGRectMake( 0, aFrame.origin.y, aFrame.size.width+aFrame.origin.x, aFrame.size.height );
  }
  if (aFrame.origin.y<0)
  {
    aFrame = CGRectMake( aFrame.origin.x, 0, aFrame.size.width, aFrame.size.height+aFrame.origin.y );
  }
  CGSize aSize = aFrame.size;
  CGPoint aOrigin = aFrame.origin;
  //设置上下文环境
  UIGraphicsBeginImageContextWithOptions( aSize, NO, scale*aRate );
  //从原图上面截下需要的画面
  CGRect subFrame = CGRectMake( aOrigin.x*scale,
                                aOrigin.y*scale,
                                aSize.width*scale,
                                aSize.height*scale );
  CGImageRef subImageRef = CGImageCreateWithImageInRect( aImage.CGImage, subFrame );
  
  //3. 调整图片方向
  //在context条件下，将subImageRef画满smallBounds
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGRect smallBounds = CGRectMake( 0, 0, aSize.width, aSize.height );
  CGContextRotateCTM( context, M_PI ); //先旋转180度，是按照原先顺时针方向旋转的。这个时候会发现位置偏移了
  CGContextScaleCTM( context, -1, 1 ); //再水平旋转一下
  CGContextTranslateCTM( context,0, -aSize.height );
  
  //4, 按照rate重画取出的图片
  CGContextDrawImage( context, smallBounds, subImageRef );
  UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
  CGImageRelease( subImageRef );
  UIGraphicsEndImageContext();
  //对取出的Img处理
  UIImage* smallImage = [UIImage imageWithCGImage:newImg.CGImage
                                            scale:scale*aRate
                                      orientation:newImg.imageOrientation];
  
  if ( scale*aRate != 1 )
  {
    //5. 重画取出的图片
    UIGraphicsBeginImageContextWithOptions( aSize, NO, 1 );
    [smallImage drawInRect:CGRectMake( 0, 0, aSize.width, aSize.height )];
    smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  }
  
  return smallImage;
}

#pragma mark -
#pragma mark - 数据压缩

+ (NSData *)compressImageToData:(UIImage *)aImage
                     withQuality:(float)aQuality
{
  NSData *imageData = UIImageJPEGRepresentation(aImage, aQuality);
  return imageData;
}

#pragma mark -
#pragma mark - HC-规格压缩

+ (NSData *)compressImageHCStyle:(UIImage *)aImage
{
  
  int maxFileSize = HC_IMGCOMPRESS_MAXFILEKB*1024;
  
  float compressQuality = 1.0f;
  NSData *returnData = UIImageJPEGRepresentation( aImage, compressQuality );
  UIImage *returnImg = [UIImage imageWithData:returnData];
  
  //1. 判断是否需要压缩
  if ( [returnData length] > maxFileSize )
  {
    //2. 判断是否需要压缩到640宽度
    CGSize imgSize = returnImg.size;
    if ( imgSize.width > HC_IMGCOMPRESS_IMGWIDTH )
    {
      //计算等比压缩后的大小
      CGFloat aHeight = ( HC_IMGCOMPRESS_IMGWIDTH*imgSize.height )/imgSize.width;
      CGSize newSize = CGSizeMake( HC_IMGCOMPRESS_IMGWIDTH, aHeight );
      //等比压缩
      returnImg = [CHCImgCompressUtil compressImageSize:returnImg
                                               toCGSize:newSize
                                               withRate:1.0];
      returnData = UIImageJPEGRepresentation( returnImg, compressQuality );
    }
    //3. 判断是否需要压缩到0.1质量
    if ( [returnData length] > maxFileSize )
    {
      //循环压缩returnData
      compressQuality = 0.9f;
      returnData = UIImageJPEGRepresentation( returnImg, compressQuality );
      while ( [returnData length] > maxFileSize
             && compressQuality > 0.1f )
      {
        compressQuality -= 0.1f;
        returnData = UIImageJPEGRepresentation( returnImg, compressQuality );
      }
      //取出returnImg
      returnImg = [UIImage imageWithData:returnData];
    }
    
    //4. 判断是否需要压缩到100宽度
    if ( [returnData length] > maxFileSize )
    {
      if ( returnImg.size.width > 100 )
      {
        //向下取整百，计算首次压缩大小
        CGFloat aWidth = ( ((int)returnImg.size.width) / 100 ) * 100.0f;
        CGFloat aHeight = ( returnImg.size.height * aWidth ) / returnImg.size.width;
        CGSize newSize = CGSizeMake( aWidth, aHeight );
        //首次向下取整百压缩
        UIImage *tempImage = [CHCImgCompressUtil compressImageSize:returnImg
                                                          toCGSize:newSize
                                                          withRate:1.0];
        returnData = UIImageJPEGRepresentation( tempImage, compressQuality );
        
        //循环－100压缩
        while ( [returnData length] > maxFileSize
               && newSize.width > 100 )
        {
          aWidth = newSize.width - 100;
          aHeight = ( newSize.height * aWidth ) / newSize.width;
          newSize = CGSizeMake( aWidth, aHeight );
          //取出每次－100压缩的returnImg和returnData
          tempImage = [CHCImgCompressUtil compressImageSize:returnImg
                                                   toCGSize:newSize
                                                   withRate:1.0];
          returnData = UIImageJPEGRepresentation( tempImage, compressQuality );
        }//结束－100循环压缩
        
        //returnImg = tempImage;
        
      }
    }//结束向下取整百压缩
  }//结束全部压缩
  
  /*
   此时的returnData为最终NSData,
   此时的compressQuality为最终压缩比.
  */
  
  return returnData;
}


/*!
 	@method
 	@abstract	添加水印的方法
 	@discussion	该方法只添加多个字符串
 	@param 	aImageData
 	@param 	aTextList
 	@param 	aFont
 	@param 	aColor
 	@result
 */
+ (NSData *)addWaterMarkToImage:(NSData *)aImageData
                   withTextList:(NSArray *)aTextList
                       withFontList:(NSArray *)aFontList
                      withColor:(UIColor *)aColor{

  
  
  UIImage *aImage = [UIImage imageWithData:aImageData];

  
  CGSize imageSize = aImage.size;
  UIGraphicsBeginImageContext(imageSize);
  
  [aImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
  
  CGFloat calculatedHeight = 0.0;
  //计算文字的宽高
  for (int i = 0; i < [aTextList count]; i++) {
    
    NSString *aText = [aTextList objectAtIndex:i];
    UIFont *aFont = [aFontList objectAtIndex:i];
    
    CGSize textSize = [aText sizeWithAttributes:@{NSFontAttributeName:aFont}];
    
    //字体的宽和高
    CGFloat textWide = textSize.width;
    CGFloat textHeight = textSize.height;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:aFont,NSFontAttributeName, aColor,NSForegroundColorAttributeName,nil];
  
    calculatedHeight += textHeight+8;
    
    
    CGRect rect = CGRectMake(imageSize.width - textWide -8, imageSize.height- calculatedHeight , textWide, textHeight);
    [[aTextList objectAtIndex:i] drawInRect:rect withAttributes:dic];
    
  }
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
  
  
  return imageData;
}


@end
