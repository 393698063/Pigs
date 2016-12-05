//
//  CHCPGCustomCountAnnotationView.h
//  Pigs
//
//  Created by HEcom on 16/7/21.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@protocol CustomCountedAnnotationDelegate <NSObject>

- (void)callOutViewTapAtion;

@end

@class CHCPGCustomCountedCallOutView;
@interface CHCPGCustomCountAnnotationView : MAPinAnnotationView
@property (nonatomic, readonly) CHCPGCustomCountedCallOutView * calloutView;
@property (nonatomic, weak) id<CustomCountedAnnotationDelegate> iDelegate;
@end
