//
//  CHCPGMineHomeActionView.h
//  Pigs
//
//  Created by HEcom on 16/6/27.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MineHomeActionProtocol <NSObject>

- (void)homeListTapActionWithType:(NSInteger)type;

@end

@interface CHCPGMineHomeActionView : UIView
@property (nonatomic, weak) id<MineHomeActionProtocol>delegate;
+(id)mineHomeActionView;
- (void)loadDataWithDict:(NSDictionary *)dict;
@end
