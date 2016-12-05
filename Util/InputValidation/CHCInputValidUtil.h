

#import <Foundation/Foundation.h>

/*!
 	@header	CHCInputValidationUtil.h
 	@abstract	输入校验
 	@discussion	校验是否是整数、日期、日期时间、金额、电话、邮件地址等
 	@author	Lemon
 	@copyright	Hecom
 	@version	1.0 2013-08-30 16:24:31 Creation
 */
@interface CHCInputValidUtil : NSObject
/*!
 	@method
 	@abstract	校验输入的是否为整数
 	@discussion	整数：YES 非整数：NO
 	@param 	aInputStr 	字符串
 	@result	bool
 */
+(BOOL)checkInteger:(NSString *)aInputStr;
/*!
 	@method
 	@abstract	数值校验
 	@discussion	数值：YES 非数值：NO
 	@param 	aInputStr 	字符串
 	@result	bool
 */
+(BOOL)checkNumericalvalue:(NSString *)aInputStr;
/*!
 	@method
 	@abstract	年份校验
 	@discussion	年份:YES 非年份:NO
 	@param 	aInputStr 	字符串
 	@result	bool
 */
+(BOOL)checkYear:(NSString *)aInputStr;

/*!
 @method
 @abstract	11为手机号
 @discussion	11位数字:YES 非:NO
 @param 	aInputStr 	字符串
 @result	bool
 */
+(BOOL)checkMobileNumber:(NSString *)aInputStr;

/*!
 @method
 @abstract	无特殊字符校验
 @discussion	有特殊:NO 无特殊:YES
 @param 	aInputStr 	字符串
 @result	bool
 */
+ (BOOL)checkNormalString:(NSString *)aInputStr;
+ (BOOL)checkNormalStringWithSpace:(NSString *)aInputStr;
/*!
 	@method
 	@abstract	月份校验
 	@discussion	月份:YES 非月份:NO
 	@param 	aInputStr 	字符串
 	@result	bool
 */
+(BOOL)checkMonth:(NSString *)aInputStr;

/*!
 	@method
 	@abstract	年月校验
 	@discussion	年月:YES 非年月:NO
 	@param 	aInputStr 	字符串
 	@result	bool
 */
+(BOOL)checkYearAndMonth:(NSString *)aInputStr;

/*!
 	@method
 	@abstract	邮件地址校验
 	@discussion	邮件地址
 	@param 	aInputStr 	字符串
 	@result	bool
 */
+(BOOL)checkEmail:(NSString *)aInputStr;

/*!
 	@method
 	@abstract	电话号码校验
 	@discussion	电话号码:YES  非电话号码:NO
 	@param 	aInputStr 	字符串
 	@result	bool
 */
+(BOOL)checkPhoneNum:(NSString *)aInputStr;
+(BOOL)checkCellPhoneNum:(NSString *)aInputStr;
+ (BOOL)validateMobile:(NSString *)mobileNum;


/*!
 @method
 @abstract	检查字符串长度短于length
 @discussion	lengthYES，length以外NO
 @param 	aInputStr 	字符串
 @result	bool
 */
+(BOOL)checkLength:(NSString *)aInputStr length:(NSInteger)length;

/*!
 @method
 @abstract	检查字符串长度短于length
 @discussion	lengthYES，length以外NO
 @param 	aInputStr 	字符串
 @result	bool
 */
+(BOOL)checkLetterCharacterNumber:(NSString *)aInputStr;

/*!
 @method
 @abstract	汉字校验
 @param 	aInputStr 	字符串
 @result	bool
 */
+(BOOL)checkLetterCharacter:(NSString *)aInputStr;

@end
