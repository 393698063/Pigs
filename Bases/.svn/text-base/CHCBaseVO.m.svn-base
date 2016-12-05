//
//  CHCBaseVO.m
//  NewHopeForAgency
//
//  Created by HEcom-PC on 15/7/10.
//  Copyright (c) 2015年 Hecom. All rights reserved.
//

#import "CHCBaseVO.h"
#include <objc/message.h>
#import <objc/runtime.h>

static NSString *const HC_BaseVO_Prefix__Default = @"_";

static NSString *const HC_BaseVO_IVarType_NSString = @"@\"NSString\"";

@implementation CHCBaseVO
@synthesize voDictionary;

#pragma initWithDic
-(instancetype)init
{
  self = [super init];
  if (self)
  {
    [self putValueFromDic:nil];
  }
  return self;
}

-(NSDictionary *)voDictionary
{
  [self fillVoDictionary];
  
  return voDictionary;
}
- (instancetype)initWithDic:(NSDictionary *)aDataDic
{
  self = [self init];
  if (self)
  {
    [self putValueFromDic:aDataDic];
  }
  return self;
}

- (void)putValueFromDic:(NSDictionary *)aDataDic
{
  [self enumIvarArrayWithBlock:
   ^(Ivar aIvar, NSInteger idx, BOOL *stop)
   {
     const char *ivarName = ivar_getName(aIvar);
     NSString *ivarNameStr = [NSString stringWithUTF8String:ivarName];
     NSString *ivarKeyFromName = [self makeKeyFromIVarName:ivarNameStr];
     
     const char *type = ivar_getTypeEncoding(aIvar);
     switch (type[0])
     {
         // 如果是结构体的话，将其转化为NSData，然后encode.
         // 其实cocoa会自动将CGRect等四种结构转化为NSValue，能够直接用value encode.
         // 但其他结构体就不可以，所以还是需要我们手动转一下.
       case _C_STRUCT_B:
         //如果是其他数据结构，也与处理结构体类似，未实现。
       case _C_CHR:
         
         break;
         
         //其他事NSobject类型的
       default:
       {
         NSObject *aValue = [aDataDic objectForKey:ivarKeyFromName];
         
         if ( aValue && ![aValue isKindOfClass:[NSNull class]] && [aValue isKindOfClass:[NSObject class]] )
         {
           [self setValue:aValue forKey:ivarNameStr];
         }
         else
         {
           NSString *typeObjStr = [NSString stringWithUTF8String:type];
           if ([HC_BaseVO_IVarType_NSString isEqualToString:typeObjStr])
           {
             [self setValue:@"" forKey:ivarNameStr];
           }
         }
         break;
       }
     }
   }];
}

#pragma fillVoDictionary
-(NSDictionary *)fillVoDictionary
{
  NSDictionary *aVoDictionary = [[NSMutableDictionary alloc]initWithCapacity:1];
  [self enumIvarArrayWithBlock:
   ^(Ivar aIvar, NSInteger idx, BOOL *stop)
   {
     const char *ivarName = ivar_getName(aIvar);
     NSString *ivarNameStr = [NSString stringWithUTF8String:ivarName];
     NSString *ivarKeyFromName = [self makeKeyFromIVarName:ivarNameStr];
     
     const char *type = ivar_getTypeEncoding(aIvar);
     switch (type[0])
     {
         // 如果是结构体的话，将其转化为NSData，然后encode.
         // 其实cocoa会自动将CGRect等四种结构转化为NSValue，能够直接用value encode.
         // 但其他结构体就不可以，所以还是需要我们手动转一下.
       case _C_STRUCT_B:
         //如果是其他数据结构，也与处理结构体类似，未实现。
       case _C_CHR:
         
         break;
         
         //其他事NSobject类型的
       default:
       {
         NSObject *ivarValue = [self valueForKey:ivarNameStr];
         if (ivarValue == nil)
         {
           //nil，变成nsnull
           ivarValue = [NSNull null];
         }
         else if ([ivarValue isKindOfClass:[CHCBaseVO class]])
         {
           //vo，fillVODictionary
           ivarValue = [(CHCBaseVO *)ivarValue fillVoDictionary];
         }
         else if ([ivarValue isKindOfClass:[NSArray class]])
         {
           //ary。便利ary中的VO
           NSMutableArray *newVarAry = [NSMutableArray arrayWithCapacity:1];
           
           [(NSArray *)ivarValue enumerateObjectsUsingBlock:
            ^(id obj, NSUInteger idx, BOOL *stop)
            {
              if ([obj isKindOfClass:[CHCBaseVO class]])
              {
                CHCBaseVO *voHandler = obj;
                [voHandler fillVoDictionary];
                [newVarAry addObject:voHandler.voDictionary];
              }
              else if(obj != nil)
              {
                [newVarAry addObject:obj];
              }
              else
              {
                [newVarAry addObject:[NSNull null]];
              }
            }];
           
           ivarValue = newVarAry;
         }
         else if ([ivarValue isKindOfClass:[NSDictionary class]])
         {
           //dic，遍历所有key
           NSMutableDictionary *newVarDic = [NSMutableDictionary dictionaryWithCapacity:1];
           
           NSArray *keys = [(NSDictionary *)ivarValue allKeys];
           [keys enumerateObjectsUsingBlock:
            ^(id obj, NSUInteger idx, BOOL *stop)
            {
              NSObject *value = [(NSDictionary *)ivarValue objectForKey:obj];
              if ([value isKindOfClass:[CHCBaseVO class]])
              {
                [(CHCBaseVO *)value fillVoDictionary];
                NSDictionary *valueVODic = ((CHCBaseVO *)value).voDictionary;
                [newVarDic setObject:valueVODic forKey:obj];
              }
              else if (value != nil)
              {
                [newVarDic setObject:value forKey:obj];
              }
              else
              {
                //value = nil
                [newVarDic setObject:[NSNull null] forKey:obj];
              }
            }];
           
           ivarValue = newVarDic;
         }
         
         [aVoDictionary setValue:ivarValue forKey:ivarKeyFromName];
         break;
       }
     }
   }];
  voDictionary = aVoDictionary;
  
  return voDictionary;
}

- (NSString *)makeKeyFromIVarName:(NSString *)aIVarName
{
  NSString *rtnValue = nil;
  
  if (  (aIVarName.length > (HC_BaseVO_Prefix_iHC.length+HC_BaseVO_Prefix__Default.length))
      && [aIVarName hasPrefix:[NSString stringWithFormat:@"%@%@",HC_BaseVO_Prefix__Default,HC_BaseVO_Prefix_iHC]] )
  {
    //必须在第一个，否则先匹配"_"
    //hava prefic "_iHC" ,because simple property have no ivar
    NSUInteger aLoc = HC_BaseVO_Prefix_iHC.length+HC_BaseVO_Prefix__Default.length;
    rtnValue = [aIVarName substringWithRange:NSMakeRange(aLoc, aIVarName.length-aLoc)];
  }
  else if ( (aIVarName.length > HC_BaseVO_Prefix__Default.length)
           && [aIVarName hasPrefix:HC_BaseVO_Prefix__Default] )
  {
    //建议在iHC前面，因为可能性更大
    //have prefix "_" ,because have no ivar
    NSUInteger aLoc = HC_BaseVO_Prefix__Default.length;
    rtnValue = [aIVarName substringWithRange:NSMakeRange(HC_BaseVO_Prefix__Default.length, aIVarName.length-aLoc)];
  }
  else if ( (aIVarName.length > HC_BaseVO_Prefix_iHC.length)
         && [aIVarName hasPrefix:HC_BaseVO_Prefix_iHC] )
  {
    //出现情况最少
    //have prefix "iCH" ,because of req Key value is to simple like "id".
    NSUInteger aLoc = HC_BaseVO_Prefix_iHC.length;
    rtnValue = [aIVarName substringWithRange:NSMakeRange(HC_BaseVO_Prefix_iHC.length, aIVarName.length-aLoc)];
  }
  else
  {
    rtnValue = aIVarName;
  }
  
  return rtnValue;
}

#pragma encode & decode
-(void)encodeWithCoder:(NSCoder *)aCoder
{
  [self enumIvarArrayWithBlock:^(Ivar aIvar, NSInteger idx, BOOL *stop)
   {
     const char *ivarName = ivar_getName(aIvar);
     NSString *ivarNameStr = [NSString stringWithUTF8String:ivarName];
     
     const char *type = ivar_getTypeEncoding(aIvar);
     
     switch (type[0])
     {
         // 如果是结构体的话，将其转化为NSData，然后encode.
         // 其实cocoa会自动将CGRect等四种结构转化为NSValue，能够直接用value encode.
         // 但其他结构体就不可以，所以还是需要我们手动转一下.
       case _C_STRUCT_B:
       {
         NSUInteger ivarSize = 0;
         NSUInteger ivarAlignment = 0;
         // 取得变量的大小
         NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
         // ((const char *)self + ivar_getOffset(ivar))指向结构体变量
         NSData *data = [NSData dataWithBytes:(__bridge const void *)self + ivar_getOffset(aIvar)
                                       length:ivarSize];
         [aCoder encodeObject:data forKey:ivarNameStr];
         break;
       }
         
         //如果是其他数据结构，也与处理结构体类似，未实现。
       case _C_CHR:
       {
         break;
       }
         
       default:
         [aCoder encodeObject:[self valueForKey:ivarNameStr]
                       forKey:ivarNameStr];
         break;
     }
   }];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  [self enumIvarArrayWithBlock:^(Ivar aIvar, NSInteger idx, BOOL *stop)
   {
     const char *ivarName = ivar_getName(aIvar);
     NSString *ivarNameStr = [NSString stringWithUTF8String:ivarName];
     
     id value = [aDecoder decodeObjectForKey:ivarNameStr];
     if (value)
     {
       const char *type = ivar_getTypeEncoding(aIvar);
       
       switch (type[0])
       {
         case _C_STRUCT_B:
         {
           NSUInteger ivarSize = 0;
           NSUInteger ivarAlignment = 0;
           NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
           NSData *data = [aDecoder decodeObjectForKey:ivarNameStr];
           object_setIvar(self, aIvar, data);
           void *sourceIvarLocation = (__bridge void*)self+ ivar_getOffset(aIvar);
           [data getBytes:sourceIvarLocation length:ivarSize];
           //memcpy((char *)self + ivar_getOffset(ivar), sourceIvarLocation, ivarSize);
           break;
         }
           
         default:
           [self setValue:[aDecoder decodeObjectForKey:ivarNameStr]
                   forKey:ivarNameStr];
           break;
       }
     }
   }];
  return self;
}


- (void)enumIvarArrayWithBlock:( void (^)(Ivar aIvar, NSInteger idx, BOOL *stop) )aBlock
{
  Class aClass = [self class];
  NSString *classStr = NSStringFromClass(aClass);
  
  int aCount=0;
  while (![classStr isEqualToString:@"CHCBaseVO"])//只编辑basevo（不包含basevo）以下的类
  {
    unsigned int outCount = 0;
    Ivar *aIvarAry = class_copyIvarList(aClass, &outCount);
    
    for (int i=0; i<outCount; i++)
    {
      aCount++;
      Ivar aIvar = aIvarAry[i];
      
      if (aBlock)
      {
        BOOL isStop = NO;
        aBlock(aIvar, aCount, &isStop);
      }
    }
    
    free(aIvarAry);
    
    aClass = [aClass superclass];
    classStr = NSStringFromClass(aClass);
  }
}

- (void)enumPropertyArrayWithBlock:(void (^)(objc_property_t aProperty, NSInteger idx, BOOL *stop))aBlock
{
  Class aClass = [self class];
  NSString *classStr = NSStringFromClass(aClass);
  
  int aCount=0;
  while (![classStr isEqualToString:@"CHCBaseVO"])
  {
    unsigned int outCount = 0;
    objc_property_t *aPropertyAry = class_copyPropertyList(aClass, &outCount);
    
    for (int i=0; i<outCount; i++)
    {
      aCount++;
      objc_property_t aProperty = aPropertyAry[i];
      
      if (aBlock)
      {
        BOOL isStop = NO;
        aBlock(aProperty, aCount, &isStop);
      }
    }
    
    free(aPropertyAry);
    
    aClass = [aClass superclass];
    classStr = NSStringFromClass(aClass);
  }
}

@end
