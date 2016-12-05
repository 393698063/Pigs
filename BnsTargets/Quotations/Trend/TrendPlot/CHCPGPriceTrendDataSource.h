//
//  CHCPGPriceTrendDataSource.h
//  Pigs
//
//  Created by HEcom on 16/6/7.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "PlotItem.h"

typedef NS_ENUM(NSInteger, EHCPreciTrendType)
{
  EHCPreciTrendMonth,
  EHCPreciTrendYear
};

@interface CHCPGPriceTrendDataSource : PlotItem<CPTPlotDataSource>
@property (nonatomic, strong) NSArray * iIdentifyArray;
@property (nonatomic, strong) NSArray * iDataSource;
@property (nonatomic, strong) NSDate * iRefrenceDate;
@property (nonatomic, assign) double iMaxYValue;
@property (nonatomic, assign) double  iMinYValue;
@property (nonatomic, strong) NSArray * iLineColorArray;
@property (nonatomic, assign) EHCPreciTrendType iTrendType;
/**
 *  设置数据源
 *
 *  @param dataArray @[@{},@{}]
 */
- (void)setDataSourceWithDataArray:(NSArray *)dataArray type:(EHCPreciTrendType)type;
/**
 *  获取x轴刻度
 *
 *  @return 刻度
 */
- (NSNumber *)getXMjorIntervalLength;
/**
 *  获取X轴VisibleLength
 *
 *  @return visibleLength
 */
- (NSNumber *)getXVisibleLength;
/**
 *  获取x轴RangeLength
 *
 *  @return XRangeLength
 */
- (NSNumber *)getXRangeLength;
/**
 *  获取X轴线型
 *
 *  @return 线型
 */
- (CPTMutableLineStyle *)getXAxisLineStyle;
/**
 *  获取X周时间戳
 *
 *  @return NSDateFormatter
 */
- (NSDateFormatter *)getXlabelDateFormatter;
/**
 *  获取基准时间
 *
 *  @return NSDate
 */
- (NSDate *)getReferenceDate;
/**
 *  获取曲线点数
 *
 *  @return count
 */
- (NSInteger)getPlotCount;
/**
 *  获取要隐藏的刻度
 *
 *  @return 刻度数组
 */
- (NSArray *)getExclusionRanges;
/**
 *  获取坐标周的缩放比例
 *
 *  @return 比例
 */
-(CGFloat)getYMajorIntervalScale;
/**
 *  获取y周数据格式
 *
 *  @return 获取y周数据格式
 */
- (NSFormatter *)getYLabelFormatter;
/**
 *  Y轴文字类型
 *
 *  @return CPTMutableLineStyle
 */
- (CPTTextStyle *)getYLabelTextStyle;
/**
 *  获取x轴起始值
 *
 *  @return NSTimeInterval
 */
- (NSTimeInterval)getXStartValue;
/**
 *  获取曲线的数量
 *
 *  @return count
 */
- (NSInteger)getNumberOfLineInPlot;
/**
 *  获取曲线的唯一标示符
 *
 *  @param index 曲线序号
 *
 *  @return 标示符
 */
- (NSString *)getIdentifyWithIndex:(NSInteger)index;
/**
 *  获取线条颜色
 *
 *  @param index 序号
 *
 *  @return 颜色
 */
- (CPTColor *)getLineColorWithIndex:(NSInteger)index;
@end
