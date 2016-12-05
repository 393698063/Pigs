//
//  CHCPGPriceTrendPlot.m
//  Pigs
//
//  Created by HEcom on 16/6/3.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGPriceTrendPlot.h"
#import "DateFomatterTool.h"
#import "CHCPGPriceTrendDataSource.h"

//static const NSUInteger kNumPoints = 10;
static const NSTimeInterval oneDay = 24 * 60 * 60;

@interface CHCPGPriceTrendPlot ()<CPTPlotSpaceDelegate>
@property (nonatomic, assign) id<CPTPlotAreaDelegate, CPTPlotSpaceDelegate, CPTScatterPlotDelegate> delegate;
@property (nonatomic, assign) CHCPGPriceTrendDataSource <CPTPlotDataSource> * dataSource;
@end

@implementation CHCPGPriceTrendPlot
- (instancetype)initWithdelegate:(id<CPTPlotAreaDelegate,CPTPlotSpaceDelegate,CPTScatterPlotDelegate>)delegate
                      dataSource:(id<CPTPlotDataSource>)dataSource
{
  if (self = [super init]) {
    _delegate = delegate;
    _dataSource = dataSource;
    self.title   = @" ";
    self.section = kLinePlots;
  }
  return self;
}


- (void)renderInGraphHostingView:(CPTGraphHostingView *)hostingView
                       withTheme:(CPTTheme *)theme
                        animated:(BOOL)animated
{
  CGRect frame = hostingView.frame;
//  frame.size.height += 15.0f;
  hostingView.frame = frame;
  
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
  CGRect bounds = hostingView.bounds;
#else
  CGRect bounds = NSRectToCGRect(layerHostingView.bounds);
#endif
  
  hostingView.allowPinchScaling = NO;
  CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:bounds];
  graph.paddingTop = 0;
  graph.paddingLeft = 0;
  graph.paddingBottom = 0;
  graph.paddingRight = 0;
//  graph.backgroundColor = [CPTColor cyanColor].cgColor;
  [self addGraph:graph toHostingView:hostingView];
  [self applyTheme:theme toGraph:graph withDefault:[CPTTheme themeNamed:kCPTSlateTheme]];
  
  //设置graph的间距
  graph.plotAreaFrame.masksToBorder = NO;
  graph.plotAreaFrame.paddingTop = 0.0f;
  graph.plotAreaFrame.paddingLeft = 30.0f;
  graph.plotAreaFrame.paddingRight = 0.0f;
  graph.plotAreaFrame.paddingBottom = 0;
  // Plot area delegate
  graph.plotAreaFrame.plotArea.delegate = self;
  
  // Setup scatter plot space
  CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
  plotSpace.allowsUserInteraction = YES;
//      plotSpace.allowsMomentum        = YES;//y允许冲量滚动，感觉像tableView的bounce属性
  plotSpace.delegate              = self;
  
  CGFloat maxYValue = self.dataSource.iMaxYValue;
  CGFloat minYValue = self.dataSource.iMinYValue;
  
  CGFloat diff = maxYValue - minYValue;
  if (diff == 0)
  {
    diff = 1;
  }
  CGFloat yRangeScale = 1 / diff;;
  if (yRangeScale <= 0)
  {
    yRangeScale = 1.0f;
  }
  [graph addPlotSpace:plotSpace];
  
  // Grid line styles
  CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
  majorGridLineStyle.lineWidth = 0.25;
  majorGridLineStyle.lineColor = [CPTColor colorWithComponentRed:225/255.0 green:81/255.0 blue:80/255.0 alpha:1.0];
  
  CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
  minorGridLineStyle.lineWidth = 0.25;
  minorGridLineStyle.lineColor = [CPTColor colorWithComponentRed:225/255.0 green:81/255.0 blue:80/255.0 alpha:1.0];
  
  // Axes
  // Label x axis with a fixed interval policy
  CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
  CPTXYAxis *x          = axisSet.xAxis;
  x.majorGridLineStyle = nil;
  x.majorIntervalLength         = [self.dataSource getXMjorIntervalLength];
  x.minorTicksPerInterval       = 0;
  x.delegate = _delegate;
//  x.axisConstraints       = [CPTConstraints constraintWithRelativeOffset:0];
  x.orthogonalPosition = @(minYValue);
  x.axisLineStyle = [self.dataSource getXAxisLineStyle];
  x.majorTickLineStyle = nil;
  x.minorTickLineStyle = nil;
  x.labelOffset        = -5.0;
  CPTMutableTextStyle *xLabelTextStyle = [CPTMutableTextStyle textStyle];
  xLabelTextStyle.color = [CPTColor colorWithComponentRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
//  xLabelTextStyle.fontSize = 30;
  x.labelTextStyle = xLabelTextStyle;
  x.alternatingBandFills  = @[[CPTColor colorWithComponentRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0],
                              [CPTColor colorWithComponentRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
  NSDateFormatter *dateFormatter = nil;
  if (DELEGATE_CAN_PERFORM_SELECTOR(_dataSource, @selector(getXlabelDateFormatter)))
  {
    dateFormatter = [_dataSource getXlabelDateFormatter];
  }
  if (!dateFormatter)
  {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM.dd"];
  }
  CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
  timeFormatter.referenceDate = [self.dataSource getReferenceDate];
  x.labelFormatter        = timeFormatter;
  
  NSUInteger plotCount = [self.dataSource getPlotCount];
  x.visibleRange   = [CPTPlotRange plotRangeWithLocation:@(-0.5f) length:[self.dataSource getXRangeLength]];
  
  x.title         = @" ";
  x.titleOffset   = 30.0;
  x.plotSpace = plotSpace;
  x.labelExclusionRanges = [self.dataSource getExclusionRanges];
  
  // Label y with an automatic label policy.
  CPTXYAxis *y = axisSet.yAxis;
  CGFloat yMajorIntervalScale = 0.1;
  if (DELEGATE_CAN_PERFORM_SELECTOR(_dataSource, @selector(getYMajorIntervalScale))) {
    yMajorIntervalScale = [_dataSource getYMajorIntervalScale];
  }
  y.majorIntervalLength         = @(yMajorIntervalScale / yRangeScale);
  y.minorTicksPerInterval       = 0;
  y.orthogonalPosition = @(0);
  
//  y.majorGridLineStyle          = majorGridLineStyle;
//  y.minorGridLineStyle          = minorGridLineStyle;
  y.axisLineStyle               = [self.dataSource getXAxisLineStyle];
  y.majorTickLineStyle          = nil;
  y.minorTickLineStyle          = nil;
  y.labelOffset                 = 0.0;
  y.labelRotation               = 0;
  y.labelFormatter              = [self.dataSource getYLabelFormatter];
//  y.axisConstraints             = [CPTConstraints constraintWithRelativeOffset:0];//设置y轴相对画布的位置
    if (DELEGATE_CAN_PERFORM_SELECTOR(_dataSource, @selector(getYLabelTextStyle))) {
      y.labelTextStyle = [_dataSource getYLabelTextStyle];
    }
//  y.visibleRange   = [CPTPlotRange plotRangeWithLocation:@(minYValue) length:@(diff + 0.1/yRangeScale)];
  y.visibleRange = [CPTPlotRange plotRangeWithLocation:@(minYValue == 0 ?  - 0.04 / yRangeScale : (minYValue - 0.13 / yRangeScale))
                                              length:@(diff + y.majorIntervalLength.doubleValue + 0.13 / yRangeScale)];
  CGFloat xStartValue = -0.5 * oneDay;
    if (DELEGATE_CAN_PERFORM_SELECTOR(_dataSource, @selector(getXStartValue))) {
      xStartValue = [_dataSource getXStartValue];
    }
//  y.gridLinesRange = [CPTPlotRange plotRangeWithLocation:@(xStartValue) length:@((plotCount + 0.25f) * oneDay * 3)];
  
  y.title       = @" ";
  y.titleOffset = 40.0;
  y.titleLocation = @(0 / yRangeScale);
  y.plotSpace = plotSpace; 
  
  // Set axes
  graph.axisSet.axes = @[x, y];
  
  NSMutableArray *linePlotArray = [[NSMutableArray alloc] init];
  NSMutableArray *plotsArray = [[NSMutableArray alloc] init];
  NSInteger numberOfLineInPlot = [self.dataSource getNumberOfLineInPlot];
  for (NSInteger index = 0; index < numberOfLineInPlot; index++)
  {
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    [plotsArray addObject:dataSourceLinePlot];
    [linePlotArray addObject:dataSourceLinePlot];
    dataSourceLinePlot.identifier = [self.dataSource getIdentifyWithIndex:index];
    dataSourceLinePlot.dataSource    = self.dataSource;
    
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 1.0;
    lineStyle.lineJoin               = kCGLineJoinRound;
    lineStyle.lineColor = [self.dataSource getLineColorWithIndex:index];
    
    dataSourceLinePlot.dataLineStyle = lineStyle;
    [graph addPlot:dataSourceLinePlot];
    
    // Add plot symbols
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill               = [CPTFill fillWithColor:[CPTColor whiteColor]];
    plotSymbol.lineStyle          = lineStyle;
    plotSymbol.size               = CGSizeMake(6.0, 6.0);
    dataSourceLinePlot.plotSymbol = plotSymbol;
    
    // Set plot delegate, to know when symbols have been touched
    // We will display an annotation when a symbol is touched
    dataSourceLinePlot.delegate                        = self;
    dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0;
  }
  
  // Auto scale the plot space to fit the plot data
  // Extend the ranges by 30% for neatness
  
//    [plotSpace scaleToFitPlots:plotsArray];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:@(minYValue == 0 ?  - 0.04 / yRangeScale : (minYValue - 0.13 / yRangeScale))
                                                    length:@(diff + y.majorIntervalLength.doubleValue + 0.13 / yRangeScale)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:@((plotCount - 0.5f - 10) * oneDay)
                                                    length:[self.dataSource getXRangeLength]];

    // Restrict y range to a global range
    CPTPlotRange *globalXRange = [CPTPlotRange plotRangeWithLocation:@(xStartValue)
                                                              length:[self.dataSource getXRangeLength]];
    plotSpace.globalXRange = globalXRange;
    plotSpace.globalYRange = plotSpace.yRange;
  
//  / Adjust visible ranges so plot symbols along the edges are not clipped
//  CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
  CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
//
  x.orthogonalPosition = yRange.location;
  
//    // Add legend
//    graph.legend = [CPTLegend legendWithPlots:linePlotArray];
//    graph.legend.numberOfRows    = 1;
//    graph.legend.textStyle       = x.titleTextStyle;
//    graph.legend.fill            = [CPTFill fillWithColor:[CPTColor cyanColor]];
//    graph.legend.borderLineStyle = nil;
//    graph.legend.cornerRadius    = 5.0;
//    graph.legend.swatchSize      = CGSizeMake(15.0, 15.0);
//    graph.legend.rowMargin       = 5.0;
//    graph.legend.paddingLeft     = 5.0;
//    graph.legend.paddingTop      = 1.0;
//    graph.legend.paddingRight    = 5.0;
//    graph.legend.paddingBottom   = 1.0;
//    graph.legendAnchor           = CPTRectAnchorBottom;
//    graph.legendDisplacement     = CGPointMake(0.0f, -20.0f);
}

@end
