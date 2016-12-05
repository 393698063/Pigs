//
//  CHCHttpMultipartVO.h
//  FoodYou
//
//  Created by Lemon-HEcom on 15/9/24.
//  Copyright (c) 2015年 AZLP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCBaseVO.h"
@class CHCHttpMultiPartVO;
@interface CHCHttpMultiConstructor : NSObject
{
  NSMutableArray *iParts;
}

- (void)addParts:(CHCHttpMultiPartVO *)aVO;
- (NSMutableData *)doOutput;
- (NSString *)contentType;

@property (nonatomic, strong) NSMutableArray *iParts;
@end

@interface CHCHttpMultiPartVO : CHCBaseVO
{
  NSString *iKey;
  NSString *iContentType;
}
@property (nonatomic, strong, readonly) NSString *iKey;
@property (nonatomic, strong) NSString *iContentType;
- (NSString *)otherDisposition;
- (NSInteger)doOutputContent:(NSMutableData *)aOS;
@end


@interface CHCHttpFilePartVO : CHCHttpMultiPartVO
{
  Byte *iData;
  NSString *iFileName;
  NSString *iFilePath;
}
@property (nonatomic, assign, readonly) Byte *iData;
@property (nonatomic, strong, readonly) NSString *iFileName;
@property (nonatomic, strong, readonly) NSString *iFilePath;

- (instancetype)initWithFileName:(NSString *)aFileName filePath:(NSString *)aFilePath;
- (instancetype)initWithKey:(NSString *)aKey fileName:(NSString *)aFileName filePath:(NSString *)aFilePath;
- (instancetype)initWithKey:(NSString *)aKey fileName:(NSString *)aFileName;
- (instancetype)initWithKey:(NSString *)aKey fileName:(NSString *)aFileName datas:(Byte *)aData;
@end


@interface CHCHttpStringPartVO : CHCHttpMultiPartVO
{
  NSString *iValue;
}
@property (nonatomic, strong, readonly) NSString *iValue;

- (instancetype)initWithKey:(NSString *)aKey withValue:(NSString *)aValue;
- (instancetype)initWithValue:(NSString *)aValue;
@end