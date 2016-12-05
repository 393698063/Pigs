//
//  CHCPGNoNetWorkView.h
//  Pigs
//
//  Created by HEcom on 16/6/24.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHCNoNetWorkView : UIView
+ (id)noNetWorkViewWithCallback:(void((^)()))callBackBlock;
@end
