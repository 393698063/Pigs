/*!
 @header CHCBaseVO.h VO基类
 @abstract 基类Base MVC，以及Base MVC使用的Util
 @author Created by HEcom-PC on 15/7/10.
 @version Copyright (c) 2015年 Hecom. All rights reserved.
 */

#import <Foundation/Foundation.h>

static NSString *const HC_BaseVO_Prefix_iHC = @"iHC";

/*!
 @class VOViewController的基类
 */
@interface CHCBaseVO : NSObject
{
  NSDictionary *voDictionary;
}

#pragma mark property list
/*!
 @property
 @abstract vo对应的dictionary
 */
@property (nonatomic, strong) NSDictionary *voDictionary;

#pragma mark method list
/*!
 @method
 @abstract 将VO转化为dictionary
 @discussion
 @result
 */
-(NSDictionary *)fillVoDictionary;

/*!
 @method
 @abstract 初始化方法
 @discussion
 @param aDataDic 初始化的数据
 @result
 */
- (instancetype)initWithDic:(NSDictionary *)aDataDic;

/*!
 @method
 @abstract 赋值方法，不推荐反复调用
 @discussion
 @param aDataDic 赋值的方法
 @result
 */
- (void)putValueFromDic:(NSDictionary *)aDataDic;

@end
