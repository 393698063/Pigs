//
//  SingletonManagerProtocol.h
//  Sosgpsfmcg
//
//  Created by tianxuejun on 14-4-6.
//  Copyright (c) 2014年 Sosgps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SingletonManagerProtocol <NSObject>

- (void)addObject:(id)object;
- (void)removeObject:(id)object;
- (void)removeAllObject;
- (NSArray *)getAllObjects;
- (void)save;

@end
