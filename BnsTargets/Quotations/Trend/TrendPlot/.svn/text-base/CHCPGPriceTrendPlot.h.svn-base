//
//  CHCPGPriceTrendPlot.h
//  Pigs
//
//  Created by HEcom on 16/6/3.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define DELEGATE_CAN_PERFORM_SELECTOR(delegate, selector) (delegate && selector && [delegate respondsToSelector:selector])

#import "PlotItem.h"

@interface CHCPGPriceTrendPlot : PlotItem
- (instancetype)initWithdelegate:(id<CPTPlotAreaDelegate,CPTPlotSpaceDelegate,CPTScatterPlotDelegate>)delegate
                      dataSource:(id<CPTPlotDataSource>)dataSource;
@end
