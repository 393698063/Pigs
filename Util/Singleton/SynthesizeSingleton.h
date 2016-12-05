//
//  SynthesizeSingleton.h
//  Sosgpsfmcg
//
//  Created by tianxuejun on 14-4-6.
//  Copyright (c) 2014年 Sosgps. All rights reserved.
//

#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
    static className *shared##className = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        shared##className = [[self alloc] init]; \
    }); \
    return shared##className; \
}
