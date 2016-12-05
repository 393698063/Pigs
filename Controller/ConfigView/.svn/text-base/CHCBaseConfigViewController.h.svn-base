//
//  CHCBaseConfigViewController.h
//  Eggs
//
//  Created by HEcom_wzy on 16/3/14.
//  Copyright © 2016年 Hecom. All rights reserved.
//

#import "CHCBaseViewController.h"
#import "CHCMEConfigBaseCell.h"
typedef enum
{
  EHCHouseKeeperConfigTypeDefault = 0,
  EHCHouseKeeperConfigTypeBasicInfo = EHCHouseKeeperConfigTypeDefault,// 基本信息
  EHCHouseKeeperConfigTypeProduceRecord,// 生产记录
  EHCHouseKeeperConfigTypeCostExpenditure,// 成本支出
  EHCHouseKeeperConfigTypeSalesIncome,// 销售收入
  EHCHouseKeeperConfigTypeExpenses,// 费用
  EHCHouseKeeperConfigTypeInventoryCheck// 盘点
}EHCHouseKeeperConfigType;
typedef enum
{
  EHCMESelectTypeDefult = 0, //单选
  EHCMESelectTypeMutiSelect // 多选
} EHCMESelectType;
typedef enum
{
  EHCMEInputTypeDefult = 0, // 默认键盘
  EHCMEInputTypeNumberPad,  //数字键盘
  EHCMEInputTypePhonePad, // 电话键盘
  EHCMEInputTypeDecimalPad, // 可输入小数点的数字键盘
} EHCMEInputType;

@interface CHCBaseConfigViewController : CHCBaseViewController
-(void)reloadCellData;
@property (nonatomic, assign) BOOL needAlertWhilePopVc;
@end

@class CHCBaseConfigVO;
@interface CHCBaseConfigController : CHCBaseController
@property (nonatomic, strong) NSMutableArray * iConfigArray;
@property (nonatomic, strong) NSMutableDictionary *iInputValueDict;
-(void)getCellsCorrespondConfigVOFromConfigWithConfigType:(EHCHouseKeeperConfigType)aConfigType
                                          configPlistName:(NSString *)aConfigPlistName;
- (void)dealWithInputValueDictInfo;
-(void)putBaseConfigVOValueArrayWith:(CHCBaseConfigVO *)aBaseConfigVO;
-(NSString *)judgeInputInfoRightAndValidity;
-(NSMutableDictionary *)getUploadParameters;
+(NSMutableArray * )getDictionaryItemsWithItemCorrespondType:(NSString *)aItemCorrespondType;
-(NSString *)getConfigTableTypeStringWith:(EHCHouseKeeperConfigType)aConfigType;
-(void)refreshCellDisplayInfoWithCellRowIndex:(NSInteger)aCellIndex;
-(void)refreshRelatedDataWithBaseConfigVO:(CHCBaseConfigVO *)aConfigVO;
-(void)refreshRelatedDataCanChangedInfoWithBaseConfigVO:(CHCBaseConfigVO *)aConfigVO;
@end

@interface CHCBaseConfigVO : CHCBaseVO
// 当前VO对应的cell的行
@property (nonatomic, strong) NSNumber *rowIndex;
// VC
@property (nonatomic, weak)CHCBaseConfigViewController *iVC;
// 界面显示的名称
@property (nonatomic, copy) NSString * keyShowName;
// 当前显示值对应的key
@property (nonatomic, copy) NSString * valueKey;
// 针对可选的选项，当前字典项的code对应的可以
@property (nonatomic, copy) NSString * codeKey;
// 多选时分隔符
@property (nonatomic, copy) NSString * mutableSelectSeparator;
// 值对应的数组
@property (nonatomic, strong) NSArray * valueArray;
// 值Id对应的数组
@property (nonatomic, strong) NSArray * valueIdArray;
// 当前筛选type，表明当前这个cell需要显示的下拉选项对应的内容，字典项对应的Type
@property (nonatomic, copy) NSString * itemCorrespondType;
// 选择类型，确定单选还是多选
@property (nonatomic, assign) EHCMESelectType selectType;
// 输入类型，确定输入键盘类型
@property (nonatomic, assign) EHCMEInputType inputType;
// 最大输入字符数
@property (nonatomic, strong) NSNumber * maxInputNum;
// 是否必填，默认不必填
@property (nonatomic, strong) NSNumber * needCheckFilled;
// 对应显示的cell的名称，可以通过loadNibName获取该cell
@property (nonatomic, copy) NSString * correspondCellName;
// 当前是否可用，是否可编辑
@property (nonatomic, strong) NSNumber * enableEdit;
// 文本当前的显示占位符
@property (nonatomic, copy) NSString * placeHolder;
// 输入文本是否能够根据其他文本变化而变化
@property (nonatomic, assign) BOOL enableChangeByOtherChange;
// 控件为DatePickCell的时候需要使用的startDate和endDate
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end