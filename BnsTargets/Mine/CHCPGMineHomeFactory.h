//
//  CHCPGMineHomeFactory.h
//  Pigs
//
//  Created by HEcom on 16/6/27.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCPGMineHomeBaseCell.h"



@interface CHCPGMineHomeFactory : NSObject
+ (CHCPGMineHomeBaseCell *)cellFactofyWithTableView:(UITableView *)tableView
                                        data:(NSDictionary *)dict;
@end
