/*!
 (BOOL)compareCString:(char*)aCstr1 Cstr2:(char*)aCstr2;
 (BOOL)compareStringIfOrderedSame:(NSString *)aStr1 Str2:(NSString *)aStr2;
 (BOOL)compareStringIfOrderedAscending:(NSString *)aStr1 Str2:(NSString *)aStr2;
 (BOOL)compareStringIfOrderedSameCaseInsensitive:(NSString *)aStr1 Str2:(NSString *)aStr2;
 (NSString*)uppercaseString:(NSString *)aStr;
 (NSString*)lowercaseString:(NSString *)aStr;
 (NSString*)capitalizedString:(NSString *)aStr;
 (NSString *)calculateStringAndCutoutString :(NSString *)aTextString ;
 (NSUInteger )calculateStringLength :(NSString *)aTextString;
 (float)calculateStringFloatLength :(NSString *)aTextString;
 (NSString *)calculateStringAndCutoutString :(NSString *)aTextString 
 (NSString*)getStringToIndex:(NSInteger)aIndex fromString:(NSString *)aFromString;
 (NSString*)urlEncodedString:(NSString *)string;
 (NSString*)getStringFromIndex:(NSInteger)aIndex fromString:(NSString *)aFromString;
 (NSString*)getStringFromIndex:(NSInteger)aIndex1 Index2:(NSInteger)aIndex2 fromString:(NSString *)aFromString;
 (NSString*)insertString:(NSInteger)aIndex  digString:(NSString *)aDigstring 
 (NSString *)md5ToString:(NSString *)aFromString;
 (NSString *)dateToString:(NSData *)aData;
 (NSData *)stringToData:(NSString *)aFromString;
 (Byte *)dataToByte:(NSData *)aData;
 (NSMutableArray *)removeObjectAtIndex:(unsigned) aIndex fromString:(NSArray *)aFromString;
 (BOOL) validateURL:(NSString *)aURl;
 (CGFloat) getWidthOfString:(NSString *)aString withFont:(UIFont *)aFont;
 (NSString *)getSubStringOfString:(NSString *)aString  
(NSMutableString *)filteNumber:(NSString *) number;
(NSMutableArray*)divideString:(NSString*)aString 
(NSString *)addThousandSeparator:(NSString *)inputString digit:(NSUInteger)digit;
(NSString *)delThousandSeparator:(NSString *)inputString digit:(NSUInteger)digit;
 (NSString *)timeStringWithDate:(NSString *)aDateString;
 (BOOL)stringContainsEmoji:(NSString *)string;