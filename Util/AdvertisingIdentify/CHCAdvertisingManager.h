//
//  CHCAdvertisingManager.h
//  Pigs
//
//  Created by HEcom on 16/4/14.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface CHCAdvertisingManager : NSObject
//DEFINE_SINGLETON_FOR_HEADER(CHCAdvertisingManager)
+ (NSString *)getDeviceId;
@end
