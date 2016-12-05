/*!
 @header CHCImgCompressUtil.h
 @abstract 图片压缩工具
 @author Lemon
 @copyright Hecom
 @version 1.00 2013/07/11 Creation
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//文件压缩的最大大小
#define HC_IMGCOMPRESS_MAXFILEKB 200
//image的宽度
#define HC_IMGCOMPRESS_IMGWIDTH 640
//是否可伸缩
#define HC_IMGCOMPRESS_ISSCALE YES
//初始处理大小（最大大小）
#define HC_IMGCOMPRESS_ROUCHWID 1280.0f

/*!
 @class
 @abstract 图片压缩：按照指定要求压缩图片
 */
@interface CHCImgCompressUtil : NSObject

#pragma mark -
#pragma mark - 添加水印

/*!
 @method
 @abstract 在aView的位置添加aView内容的水印。
 @discussion  水印添加位置为aView的frame位置，返回添加水印后的图片
 @param aView 将要添加的水印
 @param aIamge 将要添加水印的图片
 @result 返回结果不需要释放
 */
+ (UIImage *)addWatermark:(UIView *)aView
                  toImage:(UIImage *)aImage;

#pragma mark -
#pragma mark - 位图压缩

/*!
 @method
 @abstract 将图片按照指定清晰度压缩到指定大小
 @discussion  返回压缩处理后的图片
 @param aImage 将要被压缩的图片
 @param aSize 压缩目标大小
 @param aRate 清晰度比率，越大越清晰。最大有效值为1.0，最小有效值为0
 @result 返回结果不需要释放
 */
+ (UIImage *)compressImageSize:(UIImage *)aImage
                      toCGSize:(CGSize)aSize
                      withRate:(float)aRate;

/*!
 @method
 @abstract 将图片按照指定清晰度截取原图片指定位置的图片
 @discussion  返回截取处理后的图片
 @param aImage 将要被截取的图片
 @param aFrame 目标截取位置和大小,
               aFrame.origin表示截取区域的左上角，
               aFrame.size表示截取区域的尺寸
 @param aRate 清晰度比率，越大越清晰。最大有效值为1.0，最小有效值为0
 @result 返回结果不需要释放
 */
+ (UIImage *)clippingImageSize:(UIImage *)aImage
                     withFrame:(CGRect)aFrame
                      withRate:(float)aRate;

#pragma mark -
#pragma mark - 数据压缩

/*!
 @method
 @abstract 压缩图片存储空间大小，并返回NSData
 @discussion  返回值类型为NSData
 @param aImage 图片数据
 @param aQuality 压缩参数，参数越小，返回的NSData越小。有效范围为0.0～1.0
 @result 返回结果不需要释放
 */
+ (NSData *)compressImageToData:(UIImage *)aImage
                    withQuality:(float)aQuality;

#pragma mark -
#pragma mark - HC-规格压缩

/*!
 @method
 @abstract 以HC的通用标准和方法压缩图片尺寸和存储空间，此压缩为有损压缩
 @discussion  返回压缩后的NSData，
              此NSData为UIImage的单向压缩，如果将此NSData还原为UIImage格式，
              不能由还原出的UIImage得到与返回的NSData同样大小的NSData。
 @param aImage 需要被压缩的图片
 @result 返回结果不需要释放
 */
+ (NSData *)compressImageHCStyle:(UIImage *)aImage;

/*!
 @method
 @abstract	添加水印的方法
 @discussion	该方法只添加多个字符串，返回添加水印后的NSData
 @param 	aImageData  压缩后的图片NSData
 @param 	aTextList   水印的文字
 @param 	aFont   字体
 @param 	aColor   颜色
 @result
 */
+ (NSData *)addWaterMarkToImage:(NSData *)aImageData
                   withTextList:(NSArray *)aTextList
                   withFontList:(NSArray *)aFontList
                      withColor:(UIColor *)aColor;

@end
