//
//  CHCPGPriceTrendDataSource.m
//  Pigs
//
//  Created by HEcom on 16/6/7.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGPriceTrendDataSource.h"
#import "DateFomatterTool.h"
#import "HCLog.h"

static const NSTimeInterval oneDay = 24 * 60 * 60;

@interface CHCPGPriceTrendDataSource ()

@end

@implementation CHCPGPriceTrendDataSource

- (instancetype)init
{
  if (self = [super init]) {
    self.iDataSource = [NSArray array];
    self.iIdentifyArray = @[@"globalIdentify",@"cityIdentify"];
    self.iLineColorArray = @[[CPTColor colorWithComponentRed:136/255.0 green:191/255.0 blue:66/255.0 alpha:1.0],
                             [CPTColor colorWithComponentRed:225/255.0 green:81/255.0 blue:80/255.0 alpha:1.0]];
  }
  return self;
}
- (void)setDataSourceWithDataArray:(NSArray *)dataArray type:(EHCPreciTrendType)type
{
  self.iTrendType = type;
  [self generateMaxAndMinYValueWithDataArray:dataArray];
  self.iRefrenceDate = [self generateRefrenceDataWithDataArray:dataArray];
  self.iDataSource = [self generateDataWithDataArray:dataArray];
}
- (NSDate *)generateRefrenceDataWithDataArray:(NSArray *)dataArray
{
  NSDictionary * dict = [dataArray firstObject];
  NSArray * dates = [dict objectForKey:@"dates"];
  NSString * dateStr = [dates lastObject];
  if (self.iTrendType == EHCPreciTrendYear) {
    dateStr = [dates firstObject];
  }
  NSString * df = @"MM.dd";
  if (self.iTrendType == EHCPreciTrendYear) {
    df = @"MM月";
  }
  return [DateFomatterTool getDatefromDateString:dateStr dateFormatter:df];
}
- (void)generateMaxAndMinYValueWithDataArray:(NSArray *)dataArray
{
  NSMutableArray * plots = [NSMutableArray arrayWithCapacity:1];
  [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
   {
     NSDictionary * dict = (NSDictionary *)obj;
     NSArray * values = [dict objectForKey:@"values"];
     [plots addObjectsFromArray:values];
  }];
  [plots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
   {
     if ([obj isKindOfClass:[NSNull class]]) {
       [plots replaceObjectAtIndex:idx withObject:@(0)];
     }
  }];
  self.iMaxYValue = [[plots firstObject] doubleValue];
  self.iMinYValue = [[plots firstObject] doubleValue];
  for (NSNumber * value in plots) {
    if (self.iMaxYValue < [value doubleValue]) {
      self.iMaxYValue = [value doubleValue];
    }
    if (self.iMinYValue > [value doubleValue]) {
      self.iMinYValue = [value doubleValue];
    }
  }
}
- (NSArray *)generateDataWithDataArray:(NSArray *)dataArray
{
  NSMutableArray * plots = [NSMutableArray arrayWithCapacity:1];

  [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
  {
    NSMutableArray * dataSourceArray = [NSMutableArray arrayWithCapacity:1];
    NSDictionary * dict = (NSDictionary *)obj;
    NSArray * dates = [dict objectForKey:@"dates"];
    NSMutableArray * values = [NSMutableArray arrayWithArray:[dict objectForKey:@"values"]];
    [values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([obj isKindOfClass:[NSNull class]]) {
        [values replaceObjectAtIndex:idx withObject:@(0)];
      }
    }];
    NSMutableArray * newDates = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray * newValues = [NSMutableArray arrayWithCapacity:1];
    if (self.iTrendType == EHCPreciTrendMonth)
    {
      [dates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
       {
         [newDates insertObject:obj atIndex:0];
       }];
      [values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
       {
         [newValues insertObject:obj atIndex:0];
       }];
    }
    else
    {
      [newDates addObjectsFromArray:dates];
      [newValues addObjectsFromArray:values];
    }
    NSString * df = @"MM.dd";
    if (self.iTrendType == EHCPreciTrendYear) {
      df = @"MM月";
    }
    NSTimeInterval refrence = 0;
    for (int i = 0; i < newDates.count; i ++)
    {
      NSString * dateStr = [newDates objectAtIndex:i];
      
      NSTimeInterval xVal = [[DateFomatterTool getTimeStampWithDateStr:dateStr dateFormat:df] longLongValue]/1000;
      if (i == 0)
      {
        refrence = xVal;
      }
      NSNumber * value = [newValues objectAtIndex:i];
      double yVal = value.doubleValue;
      [dataSourceArray addObject:
       @{ @"x": @(xVal - refrence),
          @"y": @(yVal) }
       ];
    }
    [plots addObject:dataSourceArray];
  }];
  
  return plots;
}
/**
 *  获取x轴刻度
 *
 *  @return 刻度
 */
- (NSNumber *)getXMjorIntervalLength
{
  NSNumber * mjorInterval = @(oneDay * 3);
  if (self.iTrendType == EHCPreciTrendYear) {
    mjorInterval = @(oneDay * 31);
  }
  return mjorInterval;
}
/**
 *  获取X轴VisibleLength
 *
 *  @return visibleLength
 */
- (NSNumber *)getXVisibleLength
{
  NSInteger plotCount = [self getPlotCount];
  NSNumber * visibleLength = @((plotCount - 1) * oneDay * 3);
  if (self.iTrendType == EHCPreciTrendYear) {
    visibleLength = @(oneDay * 366);
  }
  return visibleLength;
}
- (NSNumber *)getXRangeLength
{
  NSInteger plotCount = [self getPlotCount];
  NSNumber * rangeLength = @((plotCount - 1)  * oneDay * 3 + oneDay);
  if (self.iTrendType == EHCPreciTrendYear) {
    rangeLength = @(oneDay * 365);
  }
  return rangeLength ;
}
/**
 *  获取X轴线型
 *
 *  @return 线型
 */
- (CPTMutableLineStyle *)getXAxisLineStyle
{
  CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
  majorGridLineStyle.lineWidth = 1;
  majorGridLineStyle.lineColor = [CPTColor colorWithComponentRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
  return majorGridLineStyle;
}
/**
 *  获取X轴时间戳
 *
 *  @return NSDateFormatter
 */
- (NSDateFormatter *)getXlabelDateFormatter
{
  NSDateFormatter * df = [[NSDateFormatter alloc] init];
  df.dateFormat = @"MM.dd";
  if (self.iTrendType == EHCPreciTrendYear) {
    df.dateFormat = @"MM月";
  }
  return df;
}
/**
 *  获取基准时间
 *
 *  @return NSDate
 */
- (NSDate *)getReferenceDate
{
  return self.iRefrenceDate;
}
/**
 *  获取曲线点数
 *
 *  @return count
 */
- (NSInteger)getPlotCount
{
  NSArray * ary = [self.iDataSource firstObject];
  __block NSInteger count = ary.count;
  [self.iDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if (count < [obj count]) {
      count = [obj count];
    }
  }];
  return count;
}
/**
 *  获取要隐藏的刻度
 *
 *  @return 刻度数组
 */
- (NSArray *)getExclusionRanges
{
  NSMutableArray * exclusionRanges = [NSMutableArray arrayWithCapacity:1];
  NSNumber * interval = @(0);
  [self.iDataSource.firstObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if (idx % 2 != 0)
    {
      if (self.iTrendType == EHCPreciTrendMonth)
      {
        NSDictionary * dict = (NSDictionary *)obj;
        [exclusionRanges addObject:[CPTPlotRange plotRangeWithLocation:[dict objectForKey:@"x"] length:@(1)]];
      }
      else
      {
        NSNumber * location = @(interval.doubleValue + oneDay * 31 * idx);
        [exclusionRanges addObject:[CPTPlotRange plotRangeWithLocation:location length:@(1)]];
      }
    }
  }];
  return exclusionRanges;
}
/**
 *  获取坐标周的缩放比例
 *
 *  @return 比例
 */
-(CGFloat)getYMajorIntervalScale
{
  return 0.3;
}
/**
 *  获取y周数据格式
 *
 *  @return 获取y周数据格式
 */
- (NSFormatter *)getYLabelFormatter
{
  NSNumberFormatter *newFormatter = [[NSNumberFormatter alloc] init];
//  newFormatter.numberStyle = NSNumberFormatterDecimalStyle;
  [newFormatter setPositiveFormat:@"0.0"];
  return newFormatter;
}
/**
 *  Y轴字型
 *
 *  @return CPTMutableLineStyle
 */
- (CPTTextStyle *)getYLabelTextStyle
{
  CPTMutableTextStyle * labelTextStyle = [CPTMutableTextStyle textStyle];
  labelTextStyle.color = [CPTColor colorWithComponentRed:0xcc / 255.0f green:0xcc / 255.0f blue:0xcc / 255.0f alpha:1.0f];
  return labelTextStyle;
}
/**
 *  获取x轴起始值
 *
 *  @return NSTimeInterval
 */
- (NSTimeInterval)getXStartValue
{
  return -0.5 * oneDay;
}
/**
 *  获取曲线的数量
 *
 *  @return count
 */
- (NSInteger)getNumberOfLineInPlot
{
  return self.iDataSource.count;
}
/**
 *  获取曲线的唯一标示符
 *
 *  @param index 曲线序号
 *
 *  @return 标示符
 */
- (NSString *)getIdentifyWithIndex:(NSInteger)index
{
  return [self.iIdentifyArray objectAtIndex:index];
}
/**
 *  获取线条颜色
 *
 *  @param index 序号
 *
 *  @return 颜色
 */
- (CPTColor *)getLineColorWithIndex:(NSInteger)index
{
  return [self.iLineColorArray objectAtIndex:index];
}
#pragma mark -
#pragma mark Plot Data Source Methods

//-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
//{
//  NSArray *array = nil;
//  NSString *identifier = (NSString *)[plot identifier];
//  //  if (identifier.length > 0) {
//  //    NSInteger equalIndex = -1;
//  //    for (NSInteger i = 0; i < _identifierArray.count; i++) {
//  //      if ([identifier isEqualToString:_identifierArray[i]]) {
//  //        equalIndex = i;
//  //        break;
//  //      }
//  //    }
//  //
//  //    array = _dataSourceArray[equalIndex];
//  //    if (equalIndex == 2 || equalIndex == 3) {
//  //      NSNumber *num = array[index][@"x"];
//  //      NSInteger integerNum = [num integerValue];
//  //      if ((integerNum % oneDay) != 0) {
//  //        return (id)[NSNull null];
//  //      }
//  //    }
//  //  }
//  
//  static CPTMutableTextStyle *textStyle = nil;
//  
//  if ( !textStyle ) {
//    textStyle       = [[CPTMutableTextStyle alloc] init];
//    textStyle.color = [CPTColor blackColor];
//  }
//  
//  NSNumber *num = array[index][@"y"];
//  NSInteger integerNum = [num integerValue];
//  NSString *whiteStr = @"";
//  if (index == 0) {
//    whiteStr = @"     ";
//    if (ABS(integerNum) > 100) {
//      whiteStr = [whiteStr stringByAppendingString:@"     "];
//    }
//  }
//  CPTTextLayer *newLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@%d", whiteStr, integerNum]
//                                                        style:textStyle];
//  return newLayer;
//}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
  return [self getPlotCount];
}

-(id)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
  NSString *identifier = (NSString *)[plot identifier];
  NSInteger plotIndex = [self.iIdentifyArray indexOfObject:identifier];
  NSArray * array = [self.iDataSource objectAtIndex:plotIndex];;
  NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
  NSNumber *num = array[index][key];
  //  if ( fieldEnum == CPTScatterPlotFieldY ) {
  //    num = @([num doubleValue]);
  //  }
  HCLog(@"identifier = %@, fieldEnum = %lu, index = %d, num = %f", identifier, (unsigned long)fieldEnum, index, [num floatValue]);
  
  return num;
}

@end
