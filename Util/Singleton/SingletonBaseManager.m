//
//  SingletonBaseManager.m
//  Sosgpsfmcg
//
//  Created by tianxuejun on 14-4-9.
//  Copyright (c) 2014年 Sosgps. All rights reserved.
//

#import "SingletonBaseManager.h"
#import "SingletonBaseManagerForSubClass.h"

@implementation SingletonBaseManager

- (id)init
{
    self = [super init];
    if (self) {
        [self initializeDefaultDataList];
    }
    return self;
}

- (void)initializeDefaultDataList
{
    [self setDataPath];
    NSData *encodedOrderListData = [NSData dataWithContentsOfFile:_objectDataPath];
    _objectArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedOrderListData];
    if (!_objectArray) {
        _objectArray = [[NSMutableArray alloc] init];
    }
}

- (void)setDataPath
{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (NSArray *)getAllObjects
{
    return _objectArray;
}

- (void)addObject:(id)object
{
    if (object) {
        [_objectArray insertObject:object atIndex:0];
        
        //save data
        [self save];
    }
}

- (void)removeObject:(id)object
{
    if (object && [_objectArray containsObject:object]) {
        [_objectArray removeObject:object];
        [self save];
    }
}

- (void)removeAllObject
{
    [_objectArray removeAllObjects];
    [self save];
}

- (void)save
{
    NSData *encodedOrderListData = [NSKeyedArchiver archivedDataWithRootObject:_objectArray];
    [encodedOrderListData writeToFile:_objectDataPath atomically:YES];
}

@end
