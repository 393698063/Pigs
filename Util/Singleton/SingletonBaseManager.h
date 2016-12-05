//
//  SingletonBaseManager.h
//  Sosgpsfmcg
//
//  Created by tianxuejun on 14-4-9.
//  Copyright (c) 2014年 Sosgps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonManagerProtocol.h"

@interface SingletonBaseManager : NSObject <SingletonManagerProtocol> {
    NSMutableArray *_objectArray;
    NSString *_objectDataPath;
}

@end
