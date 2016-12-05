//
//  CHCPGCHooseAddressViewController.h
//  Pigs
//
//  Created by HEcom on 16/4/21.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCBaseViewController.h"

@interface CHCPGCHooseAddressViewController : CHCBaseViewController
- (instancetype)initWithAddressBlock:(void(^)(NSMutableArray * addressAry))AddressBlock;
@end
