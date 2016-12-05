//
//  CHCPGCustomAnnotationView.h
//  Pigs
//
//  Created by HEcom on 16/7/15.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@protocol CustomAnnotationDelegate <NSObject>

@optional
- (void)submitFatPig:(NSString *)fatNum sow:(NSString *)sowNum;

@end

@class CHCPGCustomCalloutView;
@class CHCPGCountsHomeViewController;
@interface CHCPGCustomAnnotationView : MAPinAnnotationView
@property (nonatomic, readonly) CHCPGCustomCalloutView * calloutView;
@property (nonatomic, weak) id<CustomAnnotationDelegate> iDelegate;
@end
