//
//  CHCPGCountPromotionView.h
//  Pigs
//
//  Created by HEcom on 16/7/25.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol promotionViewDelegate <NSObject>

@optional
- (void)promotionViewDidSelectIndex:(NSInteger )index;

@end

@interface CHCPGCountPromotionView : UIView
@property (nonatomic, strong) NSArray * iDataAry;
@property (nonatomic, weak) id<promotionViewDelegate>delegate;
+ (CHCPGCountPromotionView *)countPromotionViewWithFrame:(CGRect)frame
                                           promotionData:(NSArray *)datas;

@end
